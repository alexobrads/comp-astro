module utils
  use memory
  implicit none
  real, private :: pi = 4.*atan(1.)

contains

  subroutine setup_wave(blob, n)
    integer, intent(inout) :: n
    real, intent(inout) :: blob(:,:)
    integer :: i
    real :: x, dx


    dx = 0.01

    n = nint((x_max - x_min)/dx)
    do i=1,n
      x = x_min + (i-0.5)*dx
      blob(i, 1) = x
      blob(i, 2) = (1*1e-4)*sin(x*2.*pi)
      blob(i, 3) = dx
      blob(i, 4) = 1.2*dx
      blob(i, 5) = 1.
      blob(i, 6) = 0.
      blob(i, 7) = 1.
      blob(i, 8) = 1.
      blob(i, 9) = 0.
      blob(i, 10) = 0.
    enddo
  end subroutine setup_wave


  subroutine setup_shock_tube(blob, n)
    integer, intent(out) :: n
    real, intent(inout) :: blob(:,:)
    integer :: i, n_l, n_r
    real :: x, rho_l, rho_r, dx_l, dx_r
    real :: middle, xmax, xmin, mass, pr, ss

    rho_l = 1.
    rho_r = 0.1

    pr = 1.
    ss = 1.

    dx_l = 0.001
    dx_r = 0.01
    mass = dx_l

    xmin = -0.5
    xmax = 0.5
    middle = 0

    n_l = nint(abs(xmax)/dx_l)  !500
    n_r = nint(abs(xmin)/dx_r)  !50

    n = 2*n_l + 2*n_r

    x = middle
    do i = 1,n_l
      !for left hand side start at -0.5 and go to 0
      x = xmin + (i-0.5)*dx_l
      blob(i, 1) = x
      blob(i, 2) = 0.
      blob(i, 3) = mass
      blob(i, 4) = 1.2*dx_l
      blob(i, 5) = rho_l
      blob(i, 6) = 0.
      blob(i, 7) = pr
      blob(i, 8) = ss
      blob(i, 9) = 0.
      blob(i, 10) = 0.

    enddo

    x = middle
    do i = n_l+1, n_l+n_r
      !for right hand side start at 0 and go to 0.5
      x = middle + ((i - n_l)-0.5)*dx_r

      blob(i, 1) = x
      blob(i, 2) = 0.
      blob(i, 3) = mass
      blob(i, 4) = 1.2*dx_r
      blob(i, 5) = rho_r
      blob(i, 6) = 0.
      blob(i, 7) = pr
      blob(i, 8) = ss
      blob(i, 9) = 0.
      blob(i, 10) = 0.

    enddo

    !now so we can simplify the ghost part
    !lets reflect what we have done above around -0.5
    do i = n_l+n_r+1, 2*n_l+n_r
      !set the high density part from -0.5 to -1
      x = blob(1, 1) - ((i - (n_l+n_r)))*dx_l
      blob(i, 1) = x
      blob(i, 2) = 0.
      blob(i, 3) = mass
      blob(i, 4) = 1.2*dx_l
      blob(i, 5) = rho_l
      blob(i, 6) = 0.
      blob(i, 7) = pr
      blob(i, 8) = ss
      blob(i, 9) = 0.
      blob(i, 10) = 0.

    enddo

    do i = 2*n_l+n_r+1, 2*n_l+2*n_r
      !set the low density part from -1 to -1.5
      x = blob(2*n_l+n_r, 1) - ((i - (2*n_l+n_r)))*dx_r
      blob(i, 1) = x
      blob(i, 2) = 0.
      blob(i, 3) = mass
      blob(i, 4) = 1.2*dx_r
      blob(i, 5) = rho_r
      blob(i, 6) = 0.
      blob(i, 7) = pr
      blob(i, 8) = ss
      blob(i, 9) = 0.
      blob(i, 10) = 0.

    enddo

    !we now have 1100 points
  end subroutine setup_shock_tube


  subroutine setup_sod_shock_tube(blob, n)
    integer, intent(out) :: n
    real, intent(inout) :: blob(:,:)
    integer :: i, n_l, n_r
    real :: x, rho_l, rho_r, dx_l, dx_r
    real :: middle, xmax, xmin, pr_l, pr_r

    rho_l = 1.
    rho_r = 0.125

    pr_l = 1.
    pr_r = 0.1

    dx_l = 0.001
    dx_r = 0.008

    xmin = -0.5
    xmax = 0.5
    middle = 0

    n_l = nint(abs(xmax)/dx_l)  !500
    n_r = nint(abs(xmin)/dx_r)  !50

    n = 2*n_l + 2*n_r

    x = middle
    do i = 1,n_l
      !for left hand side start at -0.5 and go to 0
      x = xmin + (i-0.5)*dx_l
      blob(i, 1) = x
      blob(i, 2) = 0.
      blob(i, 3) = dx_l
      blob(i, 4) = 1.2*dx_l
      blob(i, 5) = rho_l
      blob(i, 6) = 0.
      blob(i, 7) = pr_l
      blob(i, 8) = 1.
      blob(i, 9) = 0.
      blob(i, 10) = 0.

    enddo

    x = middle
    do i = n_l+1, n_l+n_r
      !for right hand side start at 0 and go to 0.5
      x = middle + ((i - n_l)-0.5)*dx_r

      blob(i, 1) = x
      blob(i, 2) = 0.
      blob(i, 3) = dx_l
      blob(i, 4) = 1.2*dx_r
      blob(i, 5) = rho_r
      blob(i, 6) = 0.
      blob(i, 7) = pr_r
      blob(i, 8) = 1.
      blob(i, 9) = 0.
      blob(i, 10) = 0.

    enddo

    !now so we can simplify the ghost part
    !lets reflect what we have done above around -0.5
    do i = n_l+n_r+1, 2*n_l+n_r
      !set the high density part from -0.5 to -1
      x = blob(1, 1) - ((i - (n_l+n_r)))*dx_l
      blob(i, 1) = x
      blob(i, 2) = 0.
      blob(i, 3) = dx_l
      blob(i, 4) = 1.2*dx_l
      blob(i, 5) = rho_l
      blob(i, 6) = 0.
      blob(i, 7) = pr_l
      blob(i, 8) = 1.
      blob(i, 9) = 0.
      blob(i, 10) = 0.

    enddo

    do i = 2*n_l+n_r+1, 2*n_l+2*n_r
      !set the low density part from -1 to -1.5
      x = blob(2*n_l+n_r, 1) - ((i - (2*n_l+n_r)))*dx_r
      blob(i, 1) = x
      blob(i, 2) = 0.
      blob(i, 3) = dx_l
      blob(i, 4) = 1.2*dx_r
      blob(i, 5) = rho_r
      blob(i, 6) = 0.
      blob(i, 7) = pr_r
      blob(i, 8) = 1.
      blob(i, 9) = 0.
      blob(i, 10) = 0.

    enddo

    !we now have 1100 points
  end subroutine setup_sod_shock_tube



  subroutine output(blob, n, dt)

    implicit none
    !integer, intent(in) :: n_ghosts
    integer, intent(in) :: n
    real, intent(in) :: blob(:,:)
    real, intent(in) :: dt
    character(len=100) :: filename
    integer :: j

    write(filename, "(a,f8.3)") 'snap_',dt

    open(1, file=filename, status='replace')
    write(1,*) '# x, v, m, sl, p, u, P, ss, acc, du_dt'
    write(1,*) dt
    do j=1,n
      write(1,*) blob(j,1), blob(j,2), blob(j,3), blob(j,4), &
                  blob(j,5), blob(j,6), blob(j,7), blob(j,8), &
                  blob(j, 9), blob(j, 10)
    enddo

    close(1)

  end subroutine output


end module utils