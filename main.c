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
static int32_t matrix[ROWS * COLS] __attribute__((aligned(16)))= {
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
static int32_t identity[ROWS * COLS] __attribute__((aligned(16))) = {
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
static inline int64_t matrix_norm(int32_t * restrict matrix){
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

static inline void shift_matrix_left(int32_t * restrict matrix){
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

/**
 * @brief multiplies a matrix and identity row by a given multiplier
 * 
 * @param matrix 
 * @param multiplier 
 * @param row 
 */
static inline void mult_row(int32_t * restrict matrix, int32_t * restrict identity, int32_t multiplier, int row){
    // matrix pointer
    int32_t *mptr = &matrix[row * COLS];
    int32_t *iptr = &identity[row * COLS];

    // load both halves of the row at once for fast memory access
    int32x4_t mhalf1 = vld1q_s32(mptr);
    int32x4_t mhalf2 = vld1q_s32(mptr + 4);
    int32x4_t ihalf1 = vld1q_s32(iptr);
    int32x4_t ihalf2 = vld1q_s32(iptr + 4);

    // multiply and expand to 64-bit to prevent overflow
    int64x2_t mbot_mult1 = vmull_n_s32(vget_low_s32(mhalf1), multiplier);
    int64x2_t ibot_mult1 = vmull_n_s32(vget_low_s32(ihalf1), multiplier);
    int64x2_t mbot_mult2 = vmull_n_s32(vget_low_s32(mhalf2), multiplier);
    int64x2_t ibot_mult2 = vmull_n_s32(vget_low_s32(ihalf2), multiplier);
    int64x2_t mtop_mult1 = vmull_n_s32(vget_high_s32(mhalf1), multiplier);
    int64x2_t itop_mult1 = vmull_n_s32(vget_high_s32(ihalf1), multiplier);
    int64x2_t mtop_mult2 = vmull_n_s32(vget_high_s32(mhalf2), multiplier);
    int64x2_t itop_mult2 = vmull_n_s32(vget_high_s32(ihalf2), multiplier);

    // narrow back to 32-bit with rounding and recombine vector quarters
    mhalf1 = vcombine_s32(vqrshrn_n_s64(mbot_mult1, FRAC), vqrshrn_n_s64(mtop_mult1, FRAC));
    mhalf2 = vcombine_s32(vqrshrn_n_s64(mbot_mult2, FRAC), vqrshrn_n_s64(mtop_mult2, FRAC));
    ihalf1 = vcombine_s32(vqrshrn_n_s64(ibot_mult1, FRAC), vqrshrn_n_s64(itop_mult1, FRAC));
    ihalf2 = vcombine_s32(vqrshrn_n_s64(ibot_mult2, FRAC), vqrshrn_n_s64(itop_mult2, FRAC));

    // store both halves back
    vst1q_s32(mptr, mhalf1);
    vst1q_s32(mptr + 4, mhalf2);
    vst1q_s32(iptr, ihalf1);
    vst1q_s32(iptr + 4, ihalf2);
}


/**
 * @brief Subtracts row1 * multiplier from row2
 * 
 * @param matrix 
 * @param row1 
 * @param row2 
 */
static inline void subtract_row(int32_t * restrict matrix, int32_t * restrict identity, int32_t multiplier, int row1, int row2){
    // matrix pointers
    int32_t *mptr1 = &matrix[row1 * COLS];
    int32_t *mptr2 = &matrix[row2 * COLS];
    int32_t *iptr1 = &identity[row1 * COLS];
    int32_t *iptr2 = &identity[row2 * COLS];

    // load halves of row 1
    int32x4_t mhalf1 = vld1q_s32(mptr1);
    int32x4_t mhalf1_top = vld1q_s32(mptr1 + 4);
    int32x4_t ihalf1 = vld1q_s32(iptr1);
    int32x4_t ihalf1_top = vld1q_s32(iptr1 + 4);

    // load halves of row 2
    int32x4_t mhalf2 = vld1q_s32(mptr2);
    int32x4_t mhalf2_top = vld1q_s32(mptr2 + 4);
    int32x4_t ihalf2 = vld1q_s32(iptr2);
    int32x4_t ihalf2_top = vld1q_s32(iptr2 + 4);

    // multiply and expand row 1 halves
    int64x2_t mbot = vmull_n_s32(vget_low_s32(mhalf1), multiplier);
    int64x2_t ibot = vmull_n_s32(vget_low_s32(ihalf1), multiplier);
    int64x2_t mtop = vmull_n_s32(vget_high_s32(mhalf1), multiplier);
    int64x2_t itop = vmull_n_s32(vget_high_s32(ihalf1), multiplier);

    // multiply and expand row 2 halves
    int64x2_t mbot_top = vmull_n_s32(vget_low_s32(mhalf1_top), multiplier);
    int64x2_t ibot_top = vmull_n_s32(vget_low_s32(ihalf1_top), multiplier);
    int64x2_t mtop_top = vmull_n_s32(vget_high_s32(mhalf1_top), multiplier);
    int64x2_t itop_top = vmull_n_s32(vget_high_s32(ihalf1_top), multiplier);

    // narrow back to 32-bit with rounding and combine vector quarters
    mhalf1 = vcombine_s32(vqrshrn_n_s64(mbot, FRAC), vqrshrn_n_s64(mtop, FRAC));
    ihalf1 = vcombine_s32(vqrshrn_n_s64(ibot, FRAC), vqrshrn_n_s64(itop, FRAC));
    mhalf1_top = vcombine_s32(vqrshrn_n_s64(mbot_top, FRAC), vqrshrn_n_s64(mtop_top, FRAC));
    ihalf1_top = vcombine_s32(vqrshrn_n_s64(ibot_top, FRAC), vqrshrn_n_s64(itop_top, FRAC));

    // perform saturating subtraction
    mhalf2 = vqsubq_s32(mhalf2, mhalf1);
    ihalf2 = vqsubq_s32(ihalf2, ihalf1);
    mhalf2_top = vqsubq_s32(mhalf2_top, mhalf1_top);
    ihalf2_top = vqsubq_s32(ihalf2_top, ihalf1_top);

    // stor halves back
    vst1q_s32(mptr2, mhalf2);
    vst1q_s32(iptr2, ihalf2);
    vst1q_s32(mptr2 + 4, mhalf2_top);
    vst1q_s32(iptr2 + 4, ihalf2_top);
}



/**
 * @brief Swaps two rows inside of a matrix
 * 
 * @param row1 
 * @param row2 
 */
static inline void swap_rows(int32_t * restrict matrix, int row1, int row2) {

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

static inline void partial_pivotting(int32_t * restrict matrix, int32_t * restrict identity, int col){
    int best_row = col;
    int32_t best_val = matrix[col * COLS + col];
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
}
/*
 For each pivot row
    Find the pivot element A[i][i]
    If the pivot is zero, swap with another row
    Normalize pivot row by dividing to make pivot = 1
    For every other row in the column, eliminate A[j][i] by subtracting A[j][i] x pivot row from row j.
*/
static inline int inverter(int32_t * restrict matrix, int32_t *restrict identity){
    for(int col = 0; col < COLS; col++){

        partial_pivotting(matrix, identity, col);
        int32_t pivot = matrix[col  * COLS + col];

        if(pivot == 0){
            printf("Matrix is ill-conditioned (det 0) - Exiting\n");
            exit(0);
        }

        register int32_t reciprocal = von_neumann_reciprocal(pivot);

        mult_row(matrix, identity, reciprocal, col);

        // zero non-pivot columns
        register int32_t factor;
        for(int row = 0; row < ROWS; row++){
            if(row != col) {
                factor = matrix[row * COLS + col];
                subtract_row(matrix, identity, factor, col, row);
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

    clock_t start = clock();

    int64_t norm = matrix_norm(matrix);
    if(norm > (1<<10)){
        exit(0);
    }else {
        // nothing
    }

    shift_matrix_left(matrix);
    shift_matrix_left(identity);

    inverter(matrix, identity);

    clock_t stop = clock();

    float elapsed = (float)(stop-start) * 1000.0 / CLOCKS_PER_SEC;
    printf("Time elapse in ms: %f\n", elapsed);

    print_matrix(matrix);
    printf("\n");
    print_matrix(identity);

    exit(0);
}
