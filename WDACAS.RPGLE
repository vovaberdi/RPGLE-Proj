     FTICPF     IF   E           K DISK
     FSHOWPF    IF A E           K DISK
     FSUBPF     IF A E           K DISK
     FHALLPF    IF A E           K DISK
     FMOVIEPF   IF A E           K DISK
     FPRTTEST   O    E             PRINTER

     DDT1              DS
     D Y1                             4
     D M1                             2
     D D1                             2
     DDT2              DS
     D D2                             2
     D T1                             1    inz('/')
     D M2                             2
     D T2                             1    inz('/')
     D Y2                             4

      //free
        dcl-s sid   int(10);
        dcl-s shid  int(10);
        sid = %int(PARM);
        shid = %int(PARM2);
      //end-free

     C     sid           CHAIN     SUB
     C     shid          CHAIN     RSHOW
     C     SHHLID        CHAIN     RHALL
     C     SHMVID        CHAIN     RMOVIE
     C                   IF        %FOUND()
     C                   EXSR      WRKDATE
     C                   WRITE     HEAD
     C                   MOVEL     paramslin     LINE
     C                   MOVEL     paramschair   CHAIR
     C                   WRITE     TICKET
     C                   ENDIF
     C                   SETON                                        LR
     C*----------------------------------------------
     C     *INZSR        BEGSR
     C     paramslin     DSPLY
     C     paramschair   DSPLY
     C     *ENTRY        PLIST
     C                   PARM                    PARM             10
     C                   PARM                    PARM2            10
     C                   PARM                    paramslin         2
     C                   PARM                    paramschair       2
     C                   ENDSR
     C*-------------------------------------------------
     C     WRKDATE       BEGSR
     C                   MOVEL     SHDATE        DT1
     C                   MOVEL     Y1            Y2
     C                   MOVEL     M1            M2
     C                   MOVEL     D1            D2
     C                   MOVEL     DT2           DATE
     C                   ENDSR
