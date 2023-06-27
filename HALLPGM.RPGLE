     FHALLPF    UF A E           K DISK
     FHALLSFL   CF   E             WORKSTN
     F                                     SFILE(SFLR:RRN)
     C     *LOVAL        SETLL     RHALL                              9898
     C                   READ      RHALL                                9999
     C     *IN99         DOWEQ     *OFF
     C                   WRITE     KOT
     C                   WRITE     BOT
     C                   EXSR      FILLSF
     C                   ENDDO
     C     RRN           IFGT      0
     C                   SETON                                        3133
     C                   Z-ADD     1             POS
     C                   ENDIF
     C                   EXFMT     CTLR
     C   06              EXSR      NEWHALL
     C     *IN03         IFEQ      *ON
     C                   SETON                                        LR
     C                   ENDIF
     C*
     C*
     C                   READC     SFLR                                 9999
     C     *IN99         DOWEQ     *OFF
     C                   SETOFF                                       525458
     C     OP            IFEQ      '2'
     C                   EXSR      UPDATE
     C                   ENDIF
     C*    OP            IFEQ      '4'
     C*                  EXSR      DELETE
     C*                  ENDIF
     C                   READC     SFLR                                 9999
     C                   ENDDO
     C*---------------------------------------------------
     C     NEWHALL       BEGSR
     C     *IN03         DOWEQ     *OFF
     C                   SETON                                        56
     C                   EXFMT     ALLF
     C     HLID          CHAIN     RHALL                              9999
     C     HLID          IFNE      0
     C                   IF        NOT %FOUND()
     C                   MOVE      HLID          HLID
     C                   WRITE     RHALL
     C                   ELSE
     C     'ID EXSIST'   DSPLY
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDSR
     C*--------------------------------------------------
     C     FILLSF        BEGSR
     C                   SETON                                          3234
     C                   WRITE     CTLR
     C                   SETOFF                                         34
     C*
     C                   Z-ADD     0             RRN               4 0
     C     *LOVAL        SETLL     RHALL                              9999
     C                   READ      RHALL                                9999
     C     *IN99         DOWEQ     *OFF
     C                   ADD       1             RRN               4 0
     C                   WRITE     SFLR
     C                   READ      RHALL                                9999
     C                   ENDDO
     C                   ENDSR
     C*-------------------------------------------------
     C*    DELETE        BEGSR
     C*    ITID          CHAIN     RITM                               9999
     C*    ITID          DELETE    RITM
     C*                  ENDSR
     C*-------------------------------------------------
     C     UPDATE        BEGSR
     C     HLID          SETLL     RHALL                              9999
     C                   READ      RHALL                                9999
     C                   SETON                                        52
     C                   EXFMT     ALLF
     C   02              UPDATE    RHALL
     C                   MOVE      *BLANKS       OP
     C                   EXFMT     ALLF
     C                   ENDSR
