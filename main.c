#include <arm_neon.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <stdint.h>
#include <math.h>


#define ROWS 8
#define COLS 8

// matrix holds 11-bit integers
float matrix[8][8] = {
    {10,  2,  3,  4,  5,  6,  7,  8},
    { 1, 11,  2,  3,  4,  5,  6,  7},
    { 1,  1, 12,  2,  3,  4,  5,  6},
    { 1,  1,  1, 13,  2,  3,  4,  5},
    { 1,  1,  1,  1, 14,  2,  3,  4},
    { 1,  1,  1,  1,  1, 15,  2,  3},
    { 1,  1,  1,  1,  1,  1, 16,  2},
    { 1,  1,  1,  1,  1,  1,  1, 17}
};

// identity matrix that will become our answer
float identity[ROWS][COLS] = {
    {1,0,0,0,0,0,0,0},
    {0,1,0,0,0,0,0,0},
    {0,0,1,0,0,0,0,0},
    {0,0,0,1,0,0,0,0},
    {0,0,0,0,1,0,0,0},
    {0,0,0,0,0,1,0,0},
    {0,0,0,0,0,0,1,0},
    {0,0,0,0,0,0,0,1},
};

/*
 * Possible Optimizations: Loop unrolling, neon intrinsics
 *
*/
int matrix_norm(){
    int max = 0;
    for(int row = 0; row < ROWS; row++){
        int sum = 0;
        for(int col = 0; col < COLS; col++){
            sum += fabsf(matrix[row][col]);
        }
        if(sum > max){
            max = sum;
        } else {
            // nothing
        }
    }
    return max;
}

void mult_row(float multiplier, int row){
    for(int col = 0; col < COLS; col++){
        matrix[row][col] *= multiplier;
        identity[row][col] *= multiplier;
    }
}

void subtract_row(float multiplier, int row1, int row2){
    for(int col = 0; col < COLS; col++){
        matrix[row2][col] -= (matrix[row1][col] * multiplier);
        identity[row2][col] -= (identity[row1][col] * multiplier);
    }
}

void swap_rows(int row1, int row2) {
    for (int col = 0; col < COLS; col++) {
        float temp = matrix[row1][col];
        matrix[row1][col] = matrix[row2][col];
        matrix[row2][col] = temp;

        temp = identity[row1][col];
        identity[row1][col] = identity[row2][col];
        identity[row2][col] = temp;
    }
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
        // partial pivotting
        int best_row = col;
        for (int row = col + 1; row < ROWS; row++) {
            if (fabsf(matrix[row][col]) > fabsf(matrix[best_row][col])) {
                best_row = row;
            }
        }
        if (best_row != col) {
            swap_rows(best_row, col);
        }
        float pivot = matrix[col][col];
        // if largest pivot is 0, matrix is ill-conditioned
        if(pivot == 0){
            return 1;
        }
        float multiplier = 1/pivot;
        mult_row(multiplier, col);
        for(int row = 0; row < ROWS; row++){
            if(row == col) continue; // skip pivot
            float factor = matrix[row][col];
            subtract_row(factor,col,row);
        }
    }
    return 0;
}

void print_matrix(const char* name, float matrix[ROWS][COLS]) {
    printf("%s =\n", name);
    for (int i = 0; i < ROWS; ++i) {
        printf("[ ");
        for (int j = 0; j < COLS; ++j) {
            printf("%5.5f ", matrix[i][j]);
        }
        printf("]\n");
    }
    printf("\n");
}

int main(){
    clock_t start = clock();

    if(inverter()){
        printf("Ill-conditioned matrix (invertible)\n");
        exit(1);
    }

    clock_t end = clock();
    
    print_matrix("Original matrix", matrix);
    print_matrix("Identity", identity);

    double time_spent = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Elapsed time: %f seconds\n", time_spent);

    exit(0);
}
