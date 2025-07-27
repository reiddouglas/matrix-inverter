#include <arm_neon.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <stdint.h>


#define ROWS 8
#define COLS 8

// matrix holds 11-bit integers
int16_t matrix[ROWS][COLS] = {
    {1,2,3,4,5,6,7,8},
    {1,2,3,4,5,6,7,8},
    {1,2,3,4,5,6,7,8},
    {1,2,3,4,5,6,7,8},
    {1,2,3,4,5,6,7,8},
    {1,2,3,4,5,6,7,8},
    {1,2,3,4,5,6,7,8},
    {1,2,3,4,5,6,7,8},
};

// identity matrix that will become our answer
int16_t identity[ROWS][COLS] = {
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
            sum += abs(matrix[row][col]);
        }
        if(sum > max){
            max = sum;
        } else {
            // nothing
        }
    }
    return max;
}

/*
 For each pivot row
    Find the pivot element A[i][i]
    If the pivot is zero, swap with another row
    Normalize pivot row by dividing to make pivot = 1
    For every other row in the column, eliminate A[j][i] by subtracting A[j][i] x pivot row from row j.
*/
int inverter(){
    for(int row = 0; row < ROWS; row++){

    }
}

int main(){
    clock_t start = clock();

    inverter();

    clock_t end = clock();

    double time_spent = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Elapsed time: %f seconds\n", time_spent);

    exit(0);
}
