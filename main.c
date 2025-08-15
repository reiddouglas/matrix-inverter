#include <arm_neon.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <stdint.h>
#include <math.h>


#define ROWS 8
#define COLS 8
#define FRAC 11
#define INT 21

// matrix holds 11-bit integers
int32_t matrix[ROWS * COLS] __attribute__((aligned(16)))= {
    10,  2,  3,  4,  5,  6,  7,  8,
    1, 11,  2,  3,  4,  5,  6,  7,
    1,  1, 12,  2,  3,  4,  5,  6,
    1,  1,  1, 13,  2,  3,  4,  5,
    1,  1,  1,  1, 14,  2,  3,  4,
    1,  1,  1,  1,  1, 15,  2,  3,
    1,  1,  1,  1,  1,  1, 16,  2,
    1,  1,  1,  1,  1,  1,  1, 17
};

// identity matrix that will become our answer
int32_t identity[ROWS * COLS] __attribute__((aligned(16))) = {
    1,0,0,0,0,0,0,0,
    0,1,0,0,0,0,0,0,
    0,0,1,0,0,0,0,0,
    0,0,0,1,0,0,0,0,
    0,0,0,0,1,0,0,0,
    0,0,0,0,0,1,0,0,
    0,0,0,0,0,0,1,0,
    0,0,0,0,0,0,0,1,
};

/**
 * @brief returns the maximum row-wise absolute sum of matrix
 * 
 * @return int64_t 
 */
static inline int64_t matrix_norm(int32_t *matrix){
    register int64_t max = 0;
    register int64_t sum;
    for(int row = 0; row < ROWS; row++){

        // matrix row pointer
        int32_t *mptr = &matrix[row * COLS];

        // load row into neon register
        int32x4_t m_bot = vld1q_s32(mptr);
        int32x4_t m_top = vld1q_s32(mptr + 4);

        // get absolute values of the row
        int32x4_t abs_bot = vabsq_s32(m_bot);
        int32x4_t abs_top = vabsq_s32(m_top);

        // use neon row sum operations
        int64x2_t sum_bot = vpaddlq_s32(abs_bot);
        int64x2_t sum_top = vpaddlq_s32(abs_top);
        int64x2_t sum_full = vaddq_s64(sum_bot, sum_top);

        // get the sum
        sum = vgetq_lane_s64(sum_full,0) + vgetq_lane_s64(sum_full,1);

        if(sum > max){
            max = sum;
        } else {
            // nothing
        }
    }
    return max;
}

static inline void shift_matrix_left(int32_t *matrix){
    for(int row = 0; row < ROWS; row++){
        // matrix row pointer
        int32_t *mptr = &matrix[row * COLS];

        // load row into neon register
        int32x4_t m_bot = vld1q_s32(mptr);
        int32x4_t m_top = vld1q_s32(mptr + 4);

        // store shifted vectors
        vst1q_s32(mptr, vshlq_n_s32(m_bot, FRAC));
        vst1q_s32(mptr + 4, vshlq_n_s32(m_top, FRAC));
    }
}


static inline void mult_row(int32_t *matrix, int32_t multiplier, int row){
    int32_t *mptr = &matrix[row * COLS];

    // load both halves of the row at once for fast memoryo access! WOOOO, I LOVE MEMORY!
    int32x4_t half1 = vld1q_s32(mptr);
    int32x4_t half2 = vld1q_s32(mptr + 4);

    // multiply and expand to 64-bit to prevent overflow
    int64x2_t bot_mult1 = vmull_n_s32(vget_low_s32(half1), multiplier);
    int64x2_t top_mult1 = vmull_n_s32(vget_high_s32(half1), multiplier);
    int64x2_t bot_mult2 = vmull_n_s32(vget_low_s32(half2), multiplier);
    int64x2_t top_mult2 = vmull_n_s32(vget_high_s32(half2), multiplier);

    // narrow back to 32-bit with rounding
    int32x2_t bot1 = vmovn_s64(vrshrq_n_s64(bot_mult1, FRAC));
    int32x2_t top1 = vmovn_s64(vrshrq_n_s64(top_mult1, FRAC));
    int32x2_t bot2 = vmovn_s64(vrshrq_n_s64(bot_mult2, FRAC));
    int32x2_t top2 = vmovn_s64(vrshrq_n_s64(top_mult2, FRAC));

    // recombine vector quarters
    half1 = vcombine_s32(bot1, top1);
    half2 = vcombine_s32(bot2, top2);

    // store both halves back
    vst1q_s32(mptr, half1);
    vst1q_s32(mptr + 4, half2);
}


/**
 * @brief Subtracts row1 * multiplier from row2
 * 
 * @param matrix 
 * @param row1 
 * @param row2 
 */
void subtract_row(int32_t *matrix, int32_t multiplier, int row1, int row2){
    // matrix pointers
    int32_t *mptr1 = &matrix[row1 * COLS];
    int32_t *mptr2 = &matrix[row2 * COLS];

    // load matrix rows into neon registers (avoid page faults by loading one row after another)
    int32x4_t half1_bot = vld1q_s32(mptr1);
    int32x4_t half1_top = vld1q_s32(mptr1 + 4);
    int32x4_t half2_bot = vld1q_s32(mptr2);
    int32x4_t half2_top = vld1q_s32(mptr2 + 4);

    // multiply and expand the register size to accomodate (2N-1) bit result
    int64x2_t bot_mult = vmull_n_s32(vget_low_s32(half1_bot), multiplier);
    int64x2_t top_mult = vmull_n_s32(vget_high_s32(half1_bot), multiplier);

    // return to 32 bit format by discarding MSBs
    int32x2_t bot = vmovn_s64(vrshrq_n_s64(bot_mult, FRAC));
    int32x2_t top = vmovn_s64(vrshrq_n_s64(top_mult, FRAC));

    // recombine vector quarters into halves
    half1_bot = vcombine_s32(bot, top);

    // perform saturating subtraction & store
    half2_bot = vqsubq_s32(half2_bot,half1_bot);
    vst1q_s32(mptr2, half2_bot);

    // multiply and expand the register size to accomodate (2N-1) bit result
    bot_mult = vmull_n_s32(vget_low_s32(half1_top), multiplier);
    top_mult = vmull_n_s32(vget_high_s32(half1_top), multiplier);

    // return to 32 bit format by discarding MSBs
    bot = vmovn_s64(vrshrq_n_s64(bot_mult, FRAC));
    top = vmovn_s64(vrshrq_n_s64(top_mult, FRAC));

    // recombine vector quarters into halves
    half1_top = vcombine_s32(bot, top);

    // perform saturating subtraction & store
    half2_top = vqsubq_s32(half2_top,half1_top);
    vst1q_s32(mptr2 + 4, half2_top);
}


/**
 * @brief Swaps two rows inside of a matrix
 * 
 * @param row1 
 * @param row2 
 */
static inline void swap_rows(int32_t *matrix, int row1, int row2) {

    // matrix row pointers
    int32_t *mptr1 = &matrix[row1 * COLS];
    int32_t *mptr2 = &matrix[row2 * COLS];

    // load neon vectors
    int32x4_t m1_bot = vld1q_s32(mptr1);
    int32x4_t m1_top = vld1q_s32(mptr1 + 4);

    int32x4_t m2_bot = vld1q_s32(mptr2);
    int32x4_t m2_top = vld1q_s32(mptr2+4);

    // swap matrix rows
    vst1q_s32(mptr2, m1_bot);
    vst1q_s32(mptr2 + 4, m1_top);

    vst1q_s32(mptr1, m2_bot);
    vst1q_s32(mptr1 + 4, m2_top);
}


static inline int32_t von_neumann_reciprocal(int32_t num){
    // shift numerator by 33 (instead of 22) to increase fractional bits from 11 to 22
    int64_t numerator = (int64_t)1 << 33;
    int64_t reciprocal = (numerator + (1LL << (FRAC - 1))) / num;
    return (int32_t)(reciprocal >> 11);
}

static inline int32_t partial_pivotting(int col){
    int best_row = col;
    int32_t best_val = matrix[col + col * COLS];
    best_val = (best_val == INT32_MIN) ? INT32_MAX : abs(best_val);

    int offset = (ROWS - 1) * COLS + col;

    for (int row = ROWS - 1; row > col; row--, offset -= COLS) {
        int32_t cur_val = matrix[offset];
        cur_val = (cur_val == INT32_MIN) ? INT32_MAX : abs(cur_val);

        // branchless max
        int update = cur_val > best_val;
        best_val = update ? cur_val : best_val;
        best_row = update ? row : best_row;
    }

    if (best_row != col) {
        swap_rows(matrix, best_row, col);
        swap_rows(identity, best_row, col);
    }

    return best_row;
}
/*
 For each pivot row
    Find the pivot element A[i][i]
    If the pivot is zero, swap with another row
    Normalize pivot row by dividing to make pivot = 1
    For every other row in the column, eliminate A[j][i] by subtracting A[j][i] x pivot row from row j.
*/


int inverter(){
    for(int col = 0; col < COLS; col++){

        int best_row = partial_pivotting(col);
        int32_t best_val = matrix[best_row  * COLS + col];

        int32_t reciprocal = von_neumann_reciprocal(best_val);

        mult_row(matrix, reciprocal, col);
        mult_row(identity, reciprocal, col);

        // zero non-pivot columns
        register int32_t factor;
        for(int row = 0; row < ROWS; row++){
            if(row != col) {
                factor = matrix[row * COLS + col];
                subtract_row(matrix, factor, col, row);
                subtract_row(identity, factor, col, row);
            } else {
                // continue
            }
        }
    }
    return 0;
}

void print_matrix(int32_t *matrix) {
    for (int r = 0; r < ROWS; r++) {
        for (int c = 0; c < COLS; c++) {
            printf("%4d ", matrix[r * COLS + c]);
        }
        printf("\n");
    }
}

int main(){

    int64_t norm = matrix_norm(matrix);
    if(norm > (1<<10)){
        printf("Estimated condition number %lld exceeds limit of 2^11", norm);
        exit(0);
    }else {
        // nothing
    }

    shift_matrix_left(matrix);
    shift_matrix_left(identity);
    
    print_matrix(matrix);
    printf("\n");
    print_matrix(identity);

    clock_t start = clock();

    inverter();

    clock_t end = clock();

    double time_spent = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Elapsed time: %f seconds\n", time_spent);

    print_matrix(matrix);
    printf("\n");
    print_matrix(identity);

    exit(0);
}
