! Simple fortran hello world
program Mhelloworld_fortran 
  use rsf		 

  implicit none !! . . No implicitly defined variables

  !! . . OpenMP variables
  integer, external :: omp_get_num_threads, omp_get_thread_num
  integer :: nth,ith

  !! . . For OpenMP parallelization
  !$OMP PARALLEL PRIVATE(ith,nth)
  nth = omp_get_num_threads()
  ith = omp_get_thread_num()
  write(0,*) 'Hello from thread number ',ith
  if (ith .eq. 0) write(0,*) 'Total number of threads',nth
  !$OMP END PARALLEL


  call exit()
end program Mhelloworld_fortran
