      INTEGER FUNCTION FORFIL (NAME)
C
C     FORFIL RETURNS THE LOGICAL UNIT TO WHICH NAME IS ASSIGNED.
C
      EXTERNAL        ANDF
      INTEGER         ANDF    ,EXFIAT,FIAT  ,FIST  ,SYSOUT
      CHARACTER       UFM*23  ,UWM*25,UIM*29,SFM*25
      COMMON /XMSSG / UFM     ,UWM   ,UIM   ,SFM
      COMMON /SYSTEM/ SYSBUF  ,SYSOUT
      COMMON /XXFIAT/ EXFIAT(1)
      COMMON /XFIAT / FIAT(1)
      COMMON /XFIST / MFIST   ,NFIST ,FIST(1)
C
C     SEARCH FIST FOR NAME. ERROR IF NOT FOUND.
C
      NN = 2*NFIST - 1
      DO 2001 I = 1,NN,2
      IF (FIST(I) .EQ. NAME) GO TO 2010
 2001 CONTINUE
      WRITE  (SYSOUT,2002) SFM,NAME,NAME
 2002 FORMAT (A25,' 2179, ERROR DETECTED IN FUNCTION FORFIL',A4,I4,
     1       ' NOT IN FIST.')
      CALL MESAGE (-61,0,0)
      FORFIL = 0
      RETURN
C
C     PICK UP UNIT FROM /XXFIAT/ OR /XFIAT/ AND RETURN.
C
 2010 J = FIST(I+1)
      IF (J) 2013,2014,2015
 2013 J = -J
 2014 FORFIL = ANDF(EXFIAT(J+1),32767)
      RETURN
 2015 FORFIL = ANDF(FIAT(J+1),32767)
      RETURN
      END
