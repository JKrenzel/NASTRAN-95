      SUBROUTINE PLA4
C*****
C THIS FUNCTIONAL MODULE IS THE LAST OF FOUR FUNCTIONAL MODULES UNIQUE
C TO THE PIECE-WISE LINEAR ANALYSIS (DISPLACEMENT METHOD) RIGID FORMAT.
C*****
C DMAP CALL...
C
C PLA4   CSTM,MPT,ECPTNL,GPCT,DIT,DELTAUGV/KGGNL,ECPTNL1/V,N,PLACOUNT/V,
C        N,PLSETNO/V,N,PLFACT/ $
C
C THE OUTPUT DATA BLOCKS AND PARAMETERS ARE DEFINED AS FOLLOWS...
C
C KGGNL IS THE STIFFNESS MATRIX OF NON-LINEAR (STRESS DEPENDENT)
C       ELEMENTS.
C ECPTNL1 IS THE UP-TO-DATE VERSION OF THE INPUT DATA BLOCK, ECPTNL.
C         THAT IS, THE ECPTNL1 DATA BLOCK CONTAINS THE SAME INFORMATION
C         AS ECPTNL EXCEPT THE STRESS INFORMATION IS UPDATED.
C
C PARAMETER NAMES BELOW ARE FORTRAN RATHER THAN DMAP NAMES
C
C PLACNT IS PIECE-WISE LINEAR ANALYSIS RIGID FORMAT DMAP LOOP COUNTER.
C PLSETN IS THE PLFACT CARD SET NUMBER CHOSEN BY THE USER IN HIS CASE
C        CONTROL PACKAGE.
C PLFACT IS THE FACTOR BY WHICH THE LOAD VECTOR WILL MULTIPLIED THE NEXT
C        TIME THROUGH THE PLA DMAP LOOP
C*****
C THIS ROUTINE IS THE MODULE DRIVER.  PLA41 APPENDS DISPLACEMENT INFOR-
C MATION TO THE ECPTNL DATA BLOCK AND A SCRATCH DATA BLOCK, ECPTS, OF
C THIS MERGED INFORMATION IS CREATED.  SUBROUTINE PLA42 USES THE DATA
C BLOCK ECPTS TO CREATE THE KGGNL MATRIX.  ALSO THE UPDATED ECPT INFOR-
C MATION IS OUTPUT AS DATA BLOCK ECPTNL1 BY PLA42.
C*****
      CALL PLA41
      CALL PLA42
      RETURN
      END
