      SUBROUTINE EXFOWR                                                         
     &  ( IUN, IPREC, FORM, InDATA, NWDS )                                      
C********************************************************************           
C    EXPECTED TYPES OF FORMAT CODES ARE AS FOLLOWS                              
C        NH------       NENN.N       NDNN.N         NX                          
C        NFNN.N         NINN         NGNN.N         NAN                         
C        NPENN.N        NPFNN.N      NPN(----)                                  
C        SPECIAL CHARACTERS:  /(),                                              
C     ICHAR = CURRENT CHARACTER NUMBER BEING PROCESSED IN "FORM"                
C     ICOL  = CURRENT CHARACTER COLUMN POSITION WITHIN THE LINE                 
C     NCNT  = NUMBER OF VALUES OF IDATA AND DATA THAT HAVE BEEN PROCESSE        
C********************************************************************           
      CHARACTER*1     FORM(1000)                                                
      CHARACTER*1     SLASH , BLANK                                             
      CHARACTER*1     LPAREN, RPAREN, PERIOD, COMMA, NUMBER(10)                 
      CHARACTER*1     H, E, D, X, F, I, G, A, P                                 
      CHARACTER*2     PFACT                                                     
      CHARACTER*4     CDATA(200)                                                
      CHARACTER*132   LINE                                                      
      CHARACTER*132   TFORM                                                     
      INTEGER*4       IDATA(200)                                                
      REAL*4          DATA(200)                                                 
      REAL*8          DDATA(100)                                                
      integer*4       indata(200)                                               
      COMMON /SYSTEM/ ISYSBF, IWR                                               
      equivalence     ( idata, data, ddata, cdata )                             
      DATA            H/'H'/, E/'E'/, D/'D'/, X/'X'/, F/'F'/                    
      DATA            I/'I'/, G/'G'/, A/'A'/, P/'P'/                            
      DATA            LPAREN /'('/, RPAREN/')'/, PERIOD/'.'/                    
      DATA            COMMA  /','/, SLASH /'/'/, BLANK /' '/                    
      DATA            NUMBER /'0','1','2','3','4','5','6','7','8','9'/          
      if ( nwds .le. 200 ) go to 2                                              
      print *,' word limit exceeded in exfowr, limit=200'                       
      return                                                                    
2     do 3 kb = 1, nwds                                                         
      idata( kb ) = indata( kb )                                                
3     continue                                                                  
      ILOOP = 0                                                                 
      ICHAR = 1                                                                 
      NCNT  = 1                                                                 
      ICOL  = 1                                                                 
      LINE  = BLANK                                                             
      PFACT = BLANK                                                             
      ICYCLE= 0                                                                 
5     IF ( FORM(ICHAR) .EQ. LPAREN ) GO TO 75                                   
      ICHAR = ICHAR + 1                                                         
      IF ( ICHAR .LE. 1000 ) GO TO 5                                            
      GO TO 7702                                                                
70    IF ( ICHAR .GT. 1000 ) GO TO 7702                                         
      IF ( NCNT  .GT. NWDS ) GO TO 1200                                         
      IF ( FORM(ICHAR) .EQ. BLANK ) GO TO 75                                    
      IF ( FORM(ICHAR) .EQ. SLASH ) GO TO 100                                   
      IF ( FORM(ICHAR) .GE. NUMBER(1) .AND.                                     
     &     FORM(ICHAR) .LE. NUMBER(10) ) GO TO 200                              
      IF ( FORM(ICHAR) .EQ. A ) GO TO 300                                       
      IF ( FORM(ICHAR) .EQ. I ) GO TO 400                                       
      IF ( FORM(ICHAR) .EQ. H ) GO TO 500                                       
      IF ( FORM(ICHAR) .EQ. X ) GO TO 600                                       
      IF ( FORM(ICHAR) .EQ. P ) GO TO 700                                       
      IF ( FORM(ICHAR) .EQ. F ) GO TO 800                                       
      IF ( FORM(ICHAR) .EQ. G ) GO TO 800                                       
      IF ( FORM(ICHAR) .EQ. D ) GO TO 800                                       
      IF ( FORM(ICHAR) .EQ. E ) GO TO 800                                       
      IF ( FORM(ICHAR) .EQ. LPAREN ) GO TO 1000                                 
      IF ( FORM(ICHAR) .EQ. RPAREN ) GO TO 1100                                 
      IF ( FORM(ICHAR) .NE. COMMA  ) GO TO 7702                                 
      IF ( ICYCLE .EQ. 0 ) PFACT = BLANK                                        
75    ICHAR = ICHAR + 1                                                         
      GO TO 70                                                                  
C PROCESS SLASH                                                                 
100   CONTINUE                                                                  
      IF ( LINE .NE. BLANK ) WRITE ( IWR,900 ) LINE                             
900   FORMAT(A132)                                                              
      IF ( LINE .EQ. BLANK ) WRITE ( IWR,901 )                                  
901   FORMAT(/)                                                                 
      LINE   = BLANK                                                            
      IF ( ICYCLE .EQ. 0 ) PFACT = BLANK                                        
      ICOL = 1                                                                  
      GO TO 75                                                                  
C GET MULTIPLIER FOR FIELD CONVERSION                                           
200   CALL FORNUM ( FORM, ICHAR, IMULT )                                        
      GO TO 70                                                                  
C PROCESS ALPHA FIELD--FORMAT(NNANNN) (NN=IMULT,NNN=IFIELD)                     
300   ICHAR = ICHAR + 1                                                         
      IF ( NCNT .GT. NWDS ) GO TO 1200                                          
      CALL FORNUM ( FORM, ICHAR, IFIELD )                                       
      IF ( IMULT .EQ. 0 ) IMULT = 1                                             
      WRITE ( TFORM, 902 ) IMULT, IFIELD                                        
902   FORMAT('(',I2,'A',I2,')')                                                 
      I1 = ICOL                                                                 
      LENGTH = IMULT*IFIELD                                                     
      NEND   = NCNT + IMULT - 1                                                 
      IF ( NEND .GT. NWDS ) NEND = NWDS                                         
      LAST   = ICOL + LENGTH - 1                                                
      WRITE( LINE(ICOL:LAST), TFORM ) (CDATA(KK),KK=NCNT,NEND)                  
      ICOL   = ICOL + LENGTH                                                    
      NCNT   = NCNT + IMULT                                                     
      IMULT = 1                                                                 
      GO TO 70                                                                  
C PROCESS INTEGER FIELD -- FORMAT(NNINNN) (NN=IMULT,NNN=IFIELD)                 
400   ICHAR = ICHAR + 1                                                         
      IF ( NCNT .GT. NWDS ) GO TO 1200                                          
      CALL FORNUM ( FORM, ICHAR, IFIELD )                                       
      IF ( IMULT .EQ. 0 ) IMULT = 1                                             
      WRITE ( TFORM, 903 ) IMULT, IFIELD                                        
903   FORMAT('(',I2,'I',I2,')')                                                 
      I1 = ICOL                                                                 
      LENGTH = IMULT*IFIELD                                                     
      NEND   = NCNT + IMULT - 1                                                 
      LAST   = ICOL + LENGTH - 1                                                
      IF ( NEND .GT. NWDS ) NEND = NWDS                                         
      WRITE( LINE(ICOL:LAST), TFORM ) (IDATA(KK),KK=NCNT,NEND)                  
      ICOL   = ICOL + LENGTH                                                    
      NCNT   = NCNT + IMULT                                                     
      IMULT  = 1                                                                
      GO TO 70                                                                  
C PROCESS HOLERITH FIELD -- FORMAT(NNH----) (NN=IMULT)                          
500   LAST   = ICOL  + IMULT - 1                                                
      ICHAR  = ICHAR + 1                                                        
      LCHAR  = ICHAR + IMULT - 1                                                
      WRITE ( LINE(ICOL:LAST), 904 ) (FORM(KK),KK=ICHAR,LCHAR)                  
904   FORMAT(133A1)                                                             
      ICOL   = ICOL  + IMULT                                                    
      ICHAR  = LCHAR                                                            
      IMULT  = 1                                                                
      GO TO 75                                                                  
C PROCESS X FIELD -- FORMAT(NNX) (NN=IMULT)                                     
600   WRITE ( TFORM, 905 ) IMULT                                                
905   FORMAT('(',I2,'X',')')                                                    
      LAST   = ICOL + IMULT - 1                                                 
      WRITE( LINE(ICOL:LAST), TFORM )                                           
      ICOL   = ICOL + IMULT                                                     
      IMULT  = 1                                                                
      GO TO 75                                                                  
C PROCESS P FACTOR FOR FLOATING FORMAT                                          
700   WRITE ( PFACT,904 ) FORM(ICHAR-1), FORM(ICHAR)                            
      IF ( NCNT .GT. NWDS ) GO TO 1200                                          
      GO TO 75                                                                  
C PROCESS FLOATING FIELD -- FORMAT(NPNNXNNN.NNNN)  WHERE                        
C          (NP = PFACT, NN=IMULT, NNN=IFIELD, NNNN=IDEC)                        
800   ITYPE = ICHAR                                                             
      IF ( NCNT .GT. NWDS ) GO TO 1200                                          
      ICHAR = ICHAR + 1                                                         
      CALL FORNUM ( FORM, ICHAR, IFIELD )                                       
810   IF ( FORM( ICHAR ) .EQ. PERIOD ) GO TO 820                                
      ICHAR = ICHAR + 1                                                         
      GO TO 810                                                                 
820   ICHAR = ICHAR + 1                                                         
      CALL FORNUM ( FORM, ICHAR, IDEC )                                         
      IF ( IMULT .EQ. 0 ) IMULT = 1                                             
      WRITE ( TFORM, 906 ) PFACT, IMULT, FORM(ITYPE),IFIELD, IDEC               
906   FORMAT('(',A2,I2,A1,I2,'.',I2,')')                                        
      I1 = ICOL                                                                 
      LENGTH = IMULT*IFIELD                                                     
      NEND   = NCNT + IMULT - 1                                                 
      LAST   = ICOL + LENGTH - 1                                                
      IF ( NEND .GT. NWDS ) NEND = NWDS                                         
      IF ( IPREC .EQ. 2 )                                                       
     &  WRITE( LINE(ICOL:LAST), TFORM ) (DDATA(KK),KK=NCNT,NEND)                
      IF ( IPREC .NE. 2 )                                                       
     &  WRITE( LINE(ICOL:LAST), TFORM ) (DATA(KK),KK=NCNT,NEND)                 
      ICOL   = ICOL + LENGTH                                                    
      NCNT   = NCNT + IMULT                                                     
      IMULT  = 1                                                                
      GO TO 70                                                                  
C PROCESS LEFT PAREN (NOT THE FIRST LEFT PAREN BUT ONE FOR A GROUP)             
C IMULT HAS THE MULTIPLIER TO BE APPLIED TO THE GROUP                           
1000  ICYCLE = IMULT-1                                                          
      ICSAVE = ICHAR+1                                                          
      ILOOP  = 1                                                                
      IMULT  = 1                                                                
      GO TO 75                                                                  
C PROCESS RIGHT PAREN ( CHECK IF IT IS THE LAST OF THE FORMAT)                  
C IF IT IS PART OF A GROUP, THEN ICYCLE WILL BE NON-ZERO                        
1100  IF ( ICYCLE .GT. 0 ) GO TO 1110                                           
      IF ( ILOOP  .NE. 0 ) GO TO 1120                                           
      IF ( NCNT .GT. NWDS ) GO TO 1200                                          
C NO GROUP, THEREFORE MUST RE CYCLE THROUGH FORMAT                              
C UNTIL LIST IS SATISFIED                                                       
      WRITE ( IUN,900 ) LINE                                                    
      ICHAR  = 2                                                                
      LINE   = BLANK                                                            
      PFACT  = BLANK                                                            
      ICOL   = 1                                                                
      GO TO 70                                                                  
C GROUP BEING PROCESSED, DECREMENT COUNT AND RESET ICHAR TO BEGINNING           
C OF THE GROUP                                                                  
1110  ICYCLE = ICYCLE - 1                                                       
      ICHAR  = ICSAVE                                                           
      GO TO 70                                                                  
C FINISHED WITH LOOP, CONTINUE WITH FORMAT                                      
1120  ILOOP  = 0                                                                
      ICYCLE = 0                                                                
      GO TO 75                                                                  
1200  WRITE ( IUN,900 ) LINE                                                    
      IF ( NCNT .GT. NWDS ) GO TO 7000                                          
      LINE = BLANK                                                              
      GO TO 70                                                                  
7000  CONTINUE                                                                  
      RETURN                                                                    
7702  WRITE( IWR, 9901 ) ICHAR, FORM                                            
9901  FORMAT(///' SUBROUTINE EXFOWR UNABLE TO DECIPHER THE FOLLOWING'           
     & ,' FORMAT AT CHARACTER ',I4,/,' FORMAT GIVEN WAS THE FOLLOWING:'         
     & ,/,(1X,131A1))                                                           
      END                                                                       
