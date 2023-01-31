
all: gpu_cache

gpu_cache: gpu_cache.cu
	nvcc -arch=sm_86 -o $@ $^ -lineinfo

run:gpu_cache
	 ncu --cache-control none --metrics lts__t_request_hit_rate.pct ./gpu_cache

clean:
	rm gpu_cache
