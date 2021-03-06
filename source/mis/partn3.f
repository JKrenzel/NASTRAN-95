      SUBROUTINE PARTN3 (FILE,SIZE,ONES,IZ,NZ,HERE,BUF,CORE)
CDIR$ INTEGER=64
C
C     CDIR$ IS CRAY COMPILER DIRECTIVE. 64-BIT INTEGER IS USED LOCALLY
C     DO LOOP 10 MAY NOT WORK PROPERLY WITH 48 BIT INTEGER
C
C     PARTN3 CALLED BY PARTN1 AND MERGE1 (VIA PARTN2) BUILDS A BIT
C     STRING AT Z(IZ) THROUGH Z(NZ) AND CONTAINING ONE-BITS ONLY IN
C     THE RESPECTIVE POSITIONS OCCUPIED BY NON-ZERO ELEMENTS IN THE
C     COLUMN VECTOR WHICH IS STORED ON FILE.
C
      IMPLICIT INTEGER (A-Z)
      EXTERNAL        LSHIFT,RSHIFT,ORF
      LOGICAL         HERE,PASS
      DIMENSION       BUF(4),MCB(7),TRL(6),BIT(64),SUBR(2)
      CHARACTER       UFM*23,UWM*25,UIM*29,SFM*25,SWM*27
      COMMON /XMSSG / UFM,UWM,UIM,SFM,SWM
      COMMON /NAMES / RD,RDREW,WRT,WRTREW,CLSREW,CLS
      COMMON /SYSTEM/ SYSBUF,OUTPT,XXX(37),NBPW
      COMMON /ZNTPKX/ ELEM(4),ROW,EOL
      COMMON /ZZZZZZ/ Z(1)
      COMMON /BLANK / SYM,TYPE,FORM(4),CPCOL,RPCOL,IREQCL
      EQUIVALENCE     (TRL(1),MCB(2))
      DATA    SUBR  / 4HPART,4HN3  /
      DATA    PASS  / .FALSE.      /
C
C     SET UP TABLE OF BITS ON FIRST PASS THROUGH THIS ROUTINE.
C
      IF (PASS) GO TO 20
      PASS = .TRUE.
      J = NBPW - 1
      K = LSHIFT(1,J)
      DO 10 I = 1,NBPW
      BIT(I) = K
      K = RSHIFT(K,1)
   10 CONTINUE
C
   20 CALL OPEN (*130,FILE,BUF,RDREW)
      HERE   = .TRUE.
      MCB(1) = FILE
      CALL RDTRL (MCB)
C
C     NUMBER OF WORDS IN COLUMN INCLUDING ZEROS
C
      SIZE = TRL(2)
      IF (IREQCL .EQ. 0) GO TO 37
      IF (IREQCL.GT.0 .AND. IREQCL.LE.TRL(1)) GO TO 38
      IF (TRL(1) .LE. 0) GO TO 37
      WRITE  (OUTPT,30) SWM,FILE,TRL(1),IREQCL
   30 FORMAT (A27,' 2173, PARTITIONING VECTOR FILE',I5,' CONTAINS',I10,
     1       ' COLUMNS.', /5X,' THE FIRST COLUMN WILL BE USED, NOT THE',
     2       ' REQUESTED COLUMN',I10)
   37 IREQCL = 1
   38 CALL SKPREC (FILE,IREQCL)
      IF (TRL(4).EQ.1 .OR. TRL(4).EQ.2) GO TO 60
      WRITE  (OUTPT,50) SWM,FILE
   50 FORMAT (A27,' 2174, PARTITIONING VECTOR ON FILE',I5,
     1       ' IS NOT REAL-SINGLE OR REAL-DOUBLE PRECISION.')
C
C     ZERO THE BIT STRING
C
   60 NZ = IZ + (SIZE-1)/NBPW
      IF (NZ .GT. CORE) CALL MESAGE (-8,0,SUBR)
      DO 70 I = IZ,NZ
      Z(I) = 0
   70 CONTINUE
C
C     SET UP TO UNPACK THE COLUMN
C
      ONES = 0
      EOL  = 0
      CALL INTPK (*120,FILE,0,1,0)
      GO TO 90
C
C     UNPACK THE ELEMENTS AND TURN ON BITS IN THE BIT STRING.  MAINTAIN
C     COUNT OF BITS IN -ONES-.
C
   80 IF (EOL) 90,90,120
   90 CALL ZNTPKI
      IF (ROW .GT. SIZE) GO TO 100
      K     = ROW - 1
      ZWORD = K/NBPW + IZ
      ZBIT  = MOD(K,NBPW) + 1
      Z(ZWORD) = ORF(Z(ZWORD),BIT(ZBIT))
      ONES  = ONES + 1
      GO TO 80
C
C     ELEMENT OF COLUMN LIES OUT OF RANGE INDICATED BY TRAILER
C
  100 WRITE  (OUTPT,110) SFM,FILE
  110 FORMAT (A25,' 2175, THE ROW POSITION OF AN ELEMENT OF A COLUMN ',
     1       'ON FILE',I5, /5X,'IS GREATER THAN NUMBER OF ROWS ',
     2       'SPECIFIED BY TRAILER.')
      GO TO 160
C
C     BIT STRING IS COMPLETE.
C
  120 CALL CLOSE (FILE,CLSREW)
      RETURN
C
C     FILE IS PURGED
C
  130 SIZE = 0
      ONES = 0
      HERE = .FALSE.
      RETURN
C
C     FATAL ERROR
C
  160 CALL CLOSE  (FILE,CLSREW)
      CALL MESAGE (-61,0,SUBR)
      RETURN
      END
