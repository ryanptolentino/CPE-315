
/* Matrix multiplication: C = A * B.
*/

// includes, system
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

// includes, kernels
#include "matmul.h"

extern "C"

void matmul(int*, const int*, const int*, unsigned int, unsigned int, 
    unsigned int);

void PrintMat(Matrix);

Matrix AllocateMatrix(int height, int width, int init);

////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////
int main(int argc, char** argv) {

  // Matrices for the program
  Matrix  M;
  Matrix  N;
  Matrix  P;
  int size = 0;
  // Number of elements in the solution matrix
  //  Assuming square matrices, so the sizes of M, N and P are equal

  srand(2222);

  // Check command line for input matrix files
  if(argc <= 2) 
  {
    if (argc == 2)
       size = atol(argv[1]);
    if (size <= 0)
       size = MATRIX_SIZE;

    // No inputs provided
    // Allocate and initialize the matrices
    M  = AllocateMatrix(size, size, 1);
    //PrintMat(M);
    N  = AllocateMatrix(size, size, 1);
    //PrintMat(N);
    P  = AllocateMatrix(size, size, 0);
  }
  else
  {
    printf("Usage: matmul [size] > outfile\n");
    return 1;
  }
  
  matmul(P.elements, M.elements, N.elements, size, size, size);

  PrintMat(P);

  // Free matrices
  free(M.elements);
  M.elements = NULL;
  free(N.elements);
  N.elements = NULL;
  free(P.elements);
  P.elements = NULL;
  return 0;
}

// Allocate a matrix of dimensions height*width
//	If init == 0, initialize to all zeroes.  
//	If init == 1, perform random initialization.
Matrix AllocateMatrix(int height, int width, int init)
{
  Matrix M;
  M.width = M.pitch = width;
  M.height = height;
  int size = M.width * M.height;
  M.elements = NULL;

  M.elements = (int*) malloc(size*sizeof(int));

  for(unsigned int i = 0; i < M.height * M.width; i++)
  {
    M.elements[i] = (init == 0) ? (0) : 
	    ((100*(rand()-(RAND_MAX/2))/(RAND_MAX/100)));
  }
  return M;
}	

// Write a matrix to file
void PrintMat(Matrix M)
{
  /*** Print results ***/
  fprintf(stderr,"Printing Result Matrix:\n");
  for (unsigned int i=0; i<M.height; i++)
  {
    for (unsigned int j=0; j<M.width; j++) 
      fprintf(stdout, "%d ", M.elements[i*M.width+j]);
    fprintf(stdout, "\n"); 
  }
  fprintf(stderr,"******************************************************\n");
  fprintf(stderr,"Done.\n");
}
