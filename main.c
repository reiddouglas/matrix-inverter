#include <arm_neon.h>
#include <stdlib.h>


#define ROWS 6
#define COLS 6

int matrix[ROWS][COLS] = {
    {1,2,3,4,5,6},
    {1,2,3,4,5,6},
    {1,2,3,4,5,6},
    {1,2,3,4,5,6},
    {1,2,3,4,5,6},
    {1,2,3,4,5,6},
};

/*
 *Optimizations: Loop unrolling
 *
*/
float matrix_norm(){
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

int main(){
    printf("norm: %f", matrix_norm());
}