! Simple fortran vector addition example
program Mvectoradd_fortran 
  use rsf		 
  implicit none !! . . No implicitly defined variables
  !! . . Variable definitions
  integer :: nx,ntest,ix
  real    :: ox,dx
  real,allocatable,dimension(:)  :: a,b,c !! Cartesian/ray coordinate images
  type (file) :: Fa, Fb, Fc

  !! . . Initializing RSF routine
  call sf_init()

  !! . . Define file structures
  Fa = rsf_input("in");  Fb = rsf_input("other"); Fc = rsf_output("out")

  !!  . . NODs 
  call from_par(Fa,"n1",nx); call from_par(Fa,"d1",dx);	
  call from_par(Fa,"o1",ox); call from_par(Fb,"n1",ntest)

  !! . . Test to ensure vectors are of same length
  if (ntest .ne. nx) call sf_error("Vectors must be of the same length!")

  !! . . Create output header file associated with "out" tag
  call to_par(Fc,"n1",nx); call to_par(Fc,"o1",ox); call to_par(Fc,"d1",dx)
  call settype(Fc,sf_float)

  !! . . Allocate required arrays
  allocate( a(nx), b(nx), c(nx)  )

  !! . . Read in A and B vectors to multiply
  call rsf_read(Fa,a); call rsf_read(Fb,b)

  !! . . Perform vector addition C = A+B
  do ix=1,nx
!!! SOMETHING IS MISSING HERE !!!
  end do

  !! . . Output vector C
  call rsf_write(Fc,c)
  call exit()
end program Mvectoradd_fortran
