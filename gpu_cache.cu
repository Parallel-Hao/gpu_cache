#include <stdio.h>
#include <cuda_runtime.h>

__global__ void w(int *data, const int val, const int sz){
  for (int i = threadIdx.x+blockDim.x*blockIdx.x; i< sz; i+=gridDim.x*blockDim.x)
    data[i] = val;
}

__global__ void r(int *data, int *r, const int sz){
  int val;
  for (int i = threadIdx.x+blockDim.x*blockIdx.x; i< sz; i+=gridDim.x*blockDim.x)
    val += data[i];
  if (val == 0) *r = val;
}

int main(){
  const int s = 1024*1024;  // 1M
  const int sz = s*sizeof(int);  // 4MB
  int *d1, *d2, *res;
  cudaMalloc(&d1, sz*10);
  cudaMalloc(&d2, sz*10);
  cudaMalloc(&res, sizeof(int));
  cudaMemset(d1, 1, sz);
  cudaMemset(d2, 1, sz);
  w<<<160,1024>>>(d2, 1, s);
  r<<<160,1024>>>(d1, res, s);
  w<<<160,1024>>>(d1, 1, s);
  r<<<160,1024>>>(d1, res, s);
  cudaDeviceSynchronize();
}
