      SUBROUTINE ALG19 (LOG1,LOG2,LOG3,LOG5,NLINES,NSPEC,KPTS,RSTA,
     1                  XSTA,R,ZR,B1,B2,TC,PI,C1,NBLADE,CCORD,BLOCK,
     2                  ALPB,EPSLON,IFANGS,IPUNCH,NAERO)
C
      DIMENSION       IDATA(24),RDATA(6),KPTS(1),RSTA(21,10),
     1                XSTA(21,10),R(10,21),ZR(1),B1(1),B2(1),TC(1),
     2                CCORD(1),BLOCK(10,21),ALPB(10,21),EPSLON(10,21),
     3                NR(10),NTERP(10),NMACH(10),NLOSS(10),NL1(10),
     4                NL2(10),NEVAL(10),NCURVE(10),NLITER(10),NDEL(10),
     5                RR(21,10),XLOSS(21,10),RTE(5),DM(11,5),
     6                DVFRAC(11,5),RDTE(21),DELTAD(21),AC(21),F137B(8),
     7                F137S(5),F142TC(7),F161D(8,5),F195M(8,2),F164XB(8)
     8,               F172K(7),NOUT1(10),NOUT2(10),SOL(21),DEV(10,21),
     9                DEVV(10,5),DX(10),X(10),DOO(5),IFANGS(1),
     O                NOUT3(10),NBLAD(10)
      COMMON /UD3PRT/ IPRTC
      DATA    F137B / 0.0,10.0,20.0,30.0,40.0,50.0,60.0,70.0/
      DATA    F137S / 0.4,0.8,1.2,1.6,2.0/
      DATA    F142TC/ 0.0,0.02,0.04,0.06,0.08,0.10,0.12/
      DATA    F161D / 0.0,0.009,0.17,0.29,0.42,0.59,0.79,1.05,0.0,0.12,
     1                0.30,0.51,0.75,1.05,1.47,2.07,0.0,0.16,0.33,0.61,
     2                0.95,1.42,2.12,3.07,0.0,0.17,0.40,0.72,1.11,1.71,
     3                2.62,3.95,0.0,0.2,0.44,0.78,1.21,1.90,3.01,4.75/
      DATA    F195M / 0.17,0.173,0.179,0.189,0.206,0.232,0.269,0.310,
     1                0.25,0.255,0.261,0.268,0.278,0.292,0.312,0.342 /
      DATA    F164XB/ 0.965,0.945,0.921,0.890,0.850,0.782,0.679,0.550/
      DATA    F172K / 0.0,0.160,0.331,0.521,0.74,1.0,1.300/
C
      LMAX   = 60
      CALL FREAD (LOG1,IDATA,6,1)
      NRAD   = IDATA(1)
      NDPTS  = IDATA(2)
      NDATR  = IDATA(3)
      NSWITC = IDATA(4)
      NLE    = IDATA(5)
      NTE    = IDATA(6)
      CALL FREAD (LOG1,RDATA,2,1)
      XKSHPE = RDATA(1)
      SPEED  = RDATA(2)
      CALL FREAD (LOG1,IDATA,3,1)
      NOUT1(NLE) = IDATA(1)
      NOUT2(NLE) = IDATA(2)
      NOUT3(NLE) = IDATA(3)
      IF (IPRTC .EQ. 1) WRITE (LOG2,20) NRAD,NDPTS,NDATR,NSWITC,NLE,NTE,
     1       XKSHPE,SPEED,NLE,NOUT1(NLE),NOUT2(NLE),NOUT3(NLE)
   20 FORMAT (1H1,9X,'DATA INTERFACING ROUTINE - DEVIATION CALCULATIONS'
     1,      ' AND DATA FORMATTING', /10X,69(1H*), /10X,5HINPUT, /10X,
     2       5(1H*), //10X,6HNRAD =,I3,9H  NDPTS =,I3,9H  NDATR =,I3,
     3       11H  NSWITCH =,I2,7H  NLE =,I2,7H  NTE =,I3, //10X,
     4       8HXKSHPE =,F7.4,9H  SPEED =,F9.1, //10X,'AT LEADING EDGE ',
     5       '(STATION,I3,9H) NOUT1 =',I2,9H  NOUT2 =,I2,9H  NOUT3 =,I2)
      LNCT = 10
      K    = NLE + 1
      DO 80 I = K,NTE
      CALL FREAD (LOG1,IDATA,14,1)
      NR(I)     = IDATA(1)
      NTERP(I)  = IDATA(2)
      NMACH(I)  = IDATA(3)
      NLOSS(I)  = IDATA(4)
      NL1(I)    = IDATA(5)
      NL2(I)    = IDATA(6)
      NEVAL(I)  = IDATA(7)
      NCURVE(I) = IDATA(8)
      NLITER(I) = IDATA(9)
      NDEL(I)   = IDATA(10)
      NOUT1(I)  = IDATA(11)
      NOUT2(I)  = IDATA(12)
      NOUT3(I)  = IDATA(13)
      NBLAD(I)  = IDATA(14)
      IF (LNCT+6+NR(I) .LE. LMAX) GO TO 50
      IF (IPRTC .NE. 0) WRITE (LOG2,40)
   40 FORMAT (1H1)
      LNCT = 1
   50 LNCT = LNCT + 6 + NR(I)
      IF (IPRTC .EQ. 1) WRITE (LOG2,60) I,NR(I),NTERP(I),NMACH(I),
     1       NLOSS(I),NL1(I),NL2(I),NEVAL(I),NCURVE(I),NLITER(I),
     2       NDEL(I),NOUT1(I),NOUT2(I),NOUT3(I),NBLAD(I)
   60 FORMAT (/10X,7HSTATION,I3,7H   NR =,I3,9H  NTERP =,I2,9H  NMACH =,
     1       I2,9H  NLOSS =,I2,7H  NL1 =,I3,7H  NL2 =,I3,9H  NEVAL =,I2,
     2       8HNCURVE =,I2,10H  NLITER =,I3,8H  NDEL =,I2, /22X,
     3       7HNOUT1 =,I2,9H  NOUT2 =,I2,9H  NOUT3 =,I2,9H  NBLAD =,I3)
      L1 = NR(I)
      DO 70 J = 1,L1
      CALL FREAD (LOG1,RDATA,2,1)
      RR(J,I)    = RDATA(1)
   70 XLOSS(J,I) = RDATA(2)
   80 IF (IPRTC .EQ. 1) WRITE (LOG2,90) (RR(J,I),XLOSS(J,I),J=1,L1)
   90 FORMAT (/14X,6HRADIUS,6X,15HLOSS DESCRIPTOR,//,(F20.4,F17.6))
      IF (LNCT+7+NDPTS .LE. LMAX) GO TO 100
      IF (IPRTC .NE. 0) WRITE (LOG2,40)
      LNCT = 1
  100 LNCT = LNCT + 2
      IF (IPRTC .EQ. 1) WRITE (LOG2,110) NRAD
  110 FORMAT (/10X,28HDEVIATION FRACTION CURVES AT,I2,6H RADII)
      DO 140 K = 1,NRAD
      IF (LNCT+5+NDPTS .LE. LMAX) GO TO 120
      IF (IPRTC .NE. 0) WRITE (LOG2,40)
      LNCT = 1
  120 LNCT = LNCT + 5 + NDPTS
      CALL FREAD (LOG1,RTE(K),1,1)
      DO 130 J = 1,NDPTS
      CALL FREAD (LOG1,RDATA,2,1)
      DM(J,K)     = RDATA(1)
  130 DVFRAC(J,K) = RDATA(2)
  140 IF (IPRTC .EQ. 1) WRITE (LOG2,150) RTE(K),(DM(J,K),DVFRAC(J,K),
     1       J=1,NDPTS)
  150 FORMAT (/10X,5HRTE =,F8.4, //15X,2HDM,10X,6HDVFRAC, //,
     1       (F20.5,F13.5))
      DO 160 J = 1,NDATR
      CALL FREAD (LOG1,RDATA,3,1)
      RDTE(J)   = RDATA(1)
      DELTAD(J) = RDATA(2)
  160 AC(J)     = RDATA(3)
      IF (LNCT+3+NDATR .LE. LMAX) GO TO 170
      IF (IPRTC .NE. 0) WRITE (LOG2,40)
      LNCT = 1
  170 LNCT = LNCT + 3 + NDATR
      IF (IPRTC .EQ. 1) WRITE (LOG2,180) (RDTE(J),DELTAD(J),AC(J),
     1       J=1,NDATR)
  180 FORMAT (/15X,4HRDTE,6X,6HDELTAD,9X,2HAC,//,(F20.4,F11.3,F13.4))
      IF (LNCT+6+NLINES .LE. LMAX) GO TO 190
      IF (IPRTC .NE. 0) WRITE (LOG2,40)
      LNCT = 1
  190 LNCT = LNCT + 6 + NLINES
      IF (IPRTC .EQ. 1) WRITE (LOG2,200)
  200 FORMAT (/10X,7HRESULTS, /,10X,7(1H*))
      IF (IPRTC .EQ. 1) WRITE (LOG2,210)
  210 FORMAT (/5X,10HSTREAMLINE,5X,5HBETA1,6X,5HBETA2,5X,6HCAMBER,7X,
     1       3HT/C,8X,3HA/C,6X,8HSOLIDITY,4X,11HADDIT. DEVN,4X,
     2       15HTOTAL DEVIATION,/)
      DO 290 J = 1,NLINES
      XJ = J
      CALL ALG15 (ZR,B1,NSPEC,XJ,BETA1,1,0)
      CALL ALG15 (ZR,B2,NSPEC,XJ,BETA2,1,0)
      CALL ALG15 (ZR,TC,NSPEC,XJ,THICK,1,0)
      Q = 1.0
      IF (SPEED .GT. 0.0) Q = -1.0
      CAMBER = (BETA1-BETA2)*Q
      SOLID  = CCORD(J)*FLOAT(NBLADE)/(PI*(R(NLE,J)+R(NTE,J)))
      BETA1  = BETA1*Q
      CALL ALG15 (F137B,F195M(1,NSWITC),8,BETA1,XMS,1,0)
      CALL ALG15 (F137B,F164XB,8,BETA1,XB,1,0)
      CALL ALG15 (F142TC,F172K,7,THICK,XKDT,1,0)
      DO 220 K = 1,5
  220 CALL ALG15 (F137B,F161D(1,K),8,BETA1,DOO(K),1,0)
      CALL ALG15 (F137S,DOO,5,SOLID,DO,1,1)
      CALL ALG15 (RDTE,DELTAD,NDATR,R(NTE,J),DADD,1,0)
      CALL ALG15 (RDTE,AC,NDATR,R(NTE,J),AONC,1,0)
      SOL(J) = SOLID
      DEV(NTE,J) = (DADD+DO*XKSHPE*XKDT+CAMBER*SOLID**(-XB)*
     1             (XMS+0.5*(AONC-0.5)))*Q
      BETA2  = BETA2*Q
      DO 230 I = NLE,NTE
  230 CALL ALG15 (RSTA(1,I),XSTA(1,I),KPTS(I),R(I,J),X(I),1,0)
      DX(NLE) = 0.0
      K = NLE + 1
      DO 240 I = K,NTE
  240 DX(I) = DX(I-1) + SQRT((X(I)-X(I-1))**2+(R(I,J)-R(I-1,J))**2)
      X1 = DX(NTE)
      DO 250 I = K,NTE
  250 DX(I) = DX(I)/X1
      L2 = NTE - NLE - 1
      K  = NLE + 1
      DO 260 L1 = 1,NRAD
  260 CALL ALG15 (DM(1,L1),DVFRAC(1,L1),NDPTS,DX(K),DEVV(K,L1),L2,0)
      KK = NTE - 1
      DO 280 I  = K,KK
      DO 270 L1 = 1,NRAD
  270 DOO(L1) = DEVV(I,L1)
      CALL ALG15 (RTE,DOO,NRAD,R(NTE,J),DEVFR,1,0)
  280 DEV(I,J) = DEV(NTE,J)*DEVFR
  290 IF (IPRTC .EQ. 1) WRITE (LOG2,300) J,BETA1,BETA2,CAMBER,THICK,
     1       AONC,SOLID,DADD,DEV(NTE,J)
  300 FORMAT (I11,F14.3,2F11.3,2F11.4,F12.5,F14.4,F17.4)
      IF (IFANGS(NLE) .EQ. 0) GO TO 340
      IF (NAERO .EQ. 0) GO TO 330
      IDATA(1)  = NLINES
      IDATA(2)  = 0
      IDATA(3)  = 0
      IDATA(4)  = 0
      IDATA(5)  = 0
      IDATA(6)  = 0
      IDATA(7)  = 0
      IDATA(8)  = 0
      IDATA(9)  = 0
      IDATA(10) = 0
      IDATA(11) = 0
      IDATA(12) = 0
      IDATA(13) = NOUT1(NLE)
      IDATA(14) = NOUT2(NLE)
      IDATA(15) = NOUT3(NLE)
      IDATA(16) = 0
      CALL WRITE (LOG5,IDATA,16,1)
      CALL WRITE (LOG5,0.0,1,1)
  310 FORMAT (I3,11(2X,1H0),3I3,3H  0, /,4H 0.0)
      DO 315 J = 1,NLINES
      RDATA(1) = R(NLE,J)
      RDATA(2) = ALPB(NLE,J)
      RDATA(3) = 0.0
      RDATA(4) = EPSLON(NLE,J)
      RDATA(5) = 0.0
      RDATA(6) = 0.0
      CALL WRITE (LOG5,RDATA,6,1)
      RDATA(1) = 0.0
      RDATA(2) = 0.0
      RDATA(3) = 0.0
      RDATA(4) = 0.0
  315 CALL WRITE (LOG5,RDATA,4,1)
  320 FORMAT (2F12.7,12X,F12.7,24X,/,4H 0.0,44X)
      IF (IPUNCH .EQ. 0) GO TO 340
  330 WRITE (LOG3,310) NLINES,NOUT1(NLE),NOUT2(NLE),NOUT3(NLE)
      WRITE (LOG3,320) (R(NLE,J),ALPB(NLE,J),EPSLON(NLE,J),J=1,NLINES)
  340 DO 370 I = K,NTE
      DO 350 J = 1,NLINES
  350 RDTE(J) = R(I,J)
      CALL ALG15 (RR(1,I),XLOSS(1,I),NR(I),RDTE,DELTAD,NLINES,0)
      NX = LOG5
      IF (NAERO .EQ. 0) NX = LOG3
      IF (NX .EQ. LOG3) GO TO 360
      IDATA(1)  = NLINES
      IDATA(2)  = NTERP(I)
      IDATA(3)  = 0
      IDATA(4)  = NMACH(I)
      IDATA(5)  = 6
      IDATA(6)  = NLOSS(I)
      IDATA(7)  = NL1(I)
      IDATA(8)  = NL2(I)
      IDATA(9)  = NEVAL(I)
      IDATA(10) = NCURVE(I)
      IDATA(11) = NLITER(I)
      IDATA(12) = NDEL(I)
      IDATA(13) = NOUT1(I)
      IDATA(14) = NOUT2(I)
      IDATA(15) = NOUT3(I)
      IDATA(16) = NBLAD(I)
      CALL WRITE (LOG5,IDATA,16,1)
      CALL WRITE (LOG5,SPEED,1,1)
      DO 355 J = 1,NLINES
      RDATA(1) = R(I,J)
      RDATA(2) = ALPB(I,J)
      RDATA(3) = DELTAD(J)
      RDATA(4) = EPSLON(I,J)
      RDATA(5) = BLOCK(I,J)
      RDATA(6) = SOL(J)
      CALL WRITE (LOG5,RDATA,6,1)
      RDATA(1) = DEV(I,J)
      RDATA(2) = 0.0
      RDATA(3) = 0.0
      RDATA(4) = 0.0
  355 CALL WRITE (LOG5,RDATA,4,1)
      GO TO 365
  360 WRITE (NX,380) NLINES,NTERP(I),NMACH(I),NLOSS(I),NL1(I),NL2(I),
     1       NEVAL(I),NCURVE(I),NLITER(I),NDEL(I),NOUT1(I),NOUT2(I),
     2       NOUT3(I),NBLAD(I),SPEED,(R(I,J),ALPB(I,J),DELTAD(J),
     3       EPSLON(I,J),BLOCK(I,J),SOL(J),DEV(I,J),J=1,NLINES)
  365 IF (NX .EQ. LOG3) GO TO 370
      NX = LOG3
      IF (NAERO.NE.0 .AND. IPUNCH.NE.0) GO TO 360
  370 CONTINUE
  380 FORMAT (2I3,3H  0,I3,3H  6,11I3, /,F12.3,/,(6F12.7, /,F12.7,36X))
      RETURN
      END
