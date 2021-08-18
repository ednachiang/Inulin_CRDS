! A fortran95 program for G95
! By WQY
! program main
!   implicit none
!   integer re_i
!   integer boxish
!   write(*,*) "Hello World!"
!   re_i = system("pause")
! end

program main
    ! This program written by Warren Porter and Fariba Porter on 1/22/2020 for accuracy.
    ! All comments in the program are preceded by an exclamation point.

    ! This program numerically integrates temporal or spatial data using either the Rectangle rule
    ! or the Trapezoid rule (more accurate).
    ! It requires for input a data.txt file that you create using a TEXT
    ! editor, e.g. Notepad or Sublime, NOT Word or similar program that inserts hidden characters.

    ! A sample input data file is included. It needs to be in the same folder that the executable
    ! (*.exe)file resides. The first line of the data.txt file is a number 1 or 2.
    ! 1 = rectangle rule usage, 2 = trapezoidal rule usage.
    ! Each subsequent row of the data.txt file are a pair of the x and y values.
    ! Current upper limit is 1000 rows of x,y data, although this is easily increased, via upping the
    ! dimensions (1000).

    implicit none

  integer :: i,j,rule,n,io
  real,dimension(1000):: time,values
  real :: area, height,width,nr

  open (1,file='D:/A_PORTER/A_PROGRAMS/NumInteg/data.txt',status='old')
  open (2,file='D:/A_PORTER/A_PROGRAMS/NumInteg/output.txt',status='unknown')

  !Initialize data row counter
   n=0

  ! Read input: integrator rule, i.e. 1 = rectangle rule, 2 = trapezoidal rule (more accurate)
    read (1,*)rule
    write (2,*)'rule = ',rule
    write (2,*)'   x values   y values'  ! Putting a label above the input data print in the output text file

  do i=1,1000  ! You can have up to 1000 pairs of x,y data
    read (1,*,IOSTAT=io) time(i),values(i)
    IF (io > 0) THEN
      WRITE(*,*) 'Program done, see output.txt, verify inputs'
      EXIT
     ELSE IF (io < 0) THEN
       ! End of file reached
     ELSE
        ! Do normal stuff
         write (2,*)time(i),values(i)
         n=n+1
    END IF
  END DO
  nr = i-2  !Converting integer to real for division below

  write(2,*)'# of data rows = ',nr


  !Choose integration method
  if(rule .eq. 1) then
    ! Rectangle rule -> height of rectangle = height of left edge of rectangle
    width = (time(n) - time(1))/nr  !Determining uniform distance for width of each rectangle
    area = 0.
    do j=1,n
      height = values(j)  !Using leading edge of interval height to get rectangle height
      area = area + width*height
      write (2,*)'area, width,height = ',area,width,height
    enddo
    write (2,*)'Rect. rule area = ',area
  endif

  if(rule .eq. 2) then
    !Trapezoidal rule
    nr = n
    width = (time(n) - time(1))/nr   !Using midpoint height to estimate size of rectangle height
    write (2,*)'time(1),time(n),n,width =',time(1),time(n),n,width
    area = 0.

    do j=2,n
      height = (values(j)+ values(j-1))/2.
      area = area + width*height
      write (2,*)'area, width,height = ',area,width,height
    enddo
    write (2,*)'Trapez. rule area = ',area
  end if
end program
