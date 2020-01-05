! Simple fortran vector addition example with parallel OpenMP

! Simple test program to do vector addition C = A + B
! 		Input in=A
!		Input other=B
!		Output out=C
!		No parameters required

!!$  Copyright (C) 2011 University of Western Australia
!!$  
!!$  This program is free software; you can redistribute it and/or modify
!!$  it under the terms of the GNU General Public License as published by
!!$  the Free Software Foundation; either version 2 of the License, or
!!$  (at your option) any later version.
!!$  
!!$  This program is distributed in the hope that it will be useful,
!!$  but WITHOUT ANY WARRANTY; without even the implied warranty of
!!$  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!!$  GNU General Public License for more details.
!!$  
!!$  You should have received a copy of the GNU General Public License
!!$  along with this program; if not, write to the Free Software
!!$  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

program Mvectoradd_fortran_parallel 
  use rsf		 

  implicit none !! . . No implicitly defined variables

  !! . . Variable definitions
  integer :: nx,ntest,ix
  real    :: ox,dx
  real,allocatable,dimension(:)  :: a,b,c !! Cartesian/ray coordinate images
  type (file) :: Fa, Fb, Fc

  !! . . OpenMP variables
  integer, external :: omp_get_num_threads, omp_get_thread_num
  integer :: nth,ith

  !! . . For OpenMP parallelization
  !$OMP PARALLEL
  nth = omp_get_num_threads()
  ith = omp_get_thread_num()
  write(0,*) 'Hello from thread number ',ith
  if (ith .eq. 0) write(0,*) 'Total number of threads',nth
  !$OMP END PARALLEL

  !! . . Initializing RSF routine
  call sf_init()

  !! . . Define file structures
  Fa = rsf_input("in")
  Fb = rsf_input("other")
  Fc = rsf_output("out")

  !!  . . NOD of 1st file (A)
  call from_par(Fa,"n1",nx);
  call from_par(Fa,"o1",ox); 
  call from_par(Fa,"d1",dx)  

  !! . . NOD of 2nd file (B)
  call from_par(Fb,"n1",ntest);

  !! . . Test to ensure vectors are of same length
  if (ntest .ne. nx) call sf_error("Vectors must be of the same length!")

  !! . . Create output header file associated with "out" tag
  call to_par(Fc,"n1",nx)
  call to_par(Fc,"o1",ox) 
  call to_par(Fc,"d1",dx)	
  call settype(Fc,sf_float)

  !! . . Allocate required arrays
  allocate( a(nx), b(nx), c(nx)  )

  !! . . Read in A and B vectors to multiply
  call rsf_read(Fa,a)
  call rsf_read(Fb,b)

  !! . . Perform vector addition C = A+B
  !$OMP PARALLEL DO PRIVATE(ix)
  do ix=1,nx
     c(ix) = a(ix) + b(ix)
  end do
  !$OMP END PARALLEL DO

  !! . . Output vector C
  call rsf_write(Fc,c)

  call exit()
end program Mvectoradd_fortran_parallel


