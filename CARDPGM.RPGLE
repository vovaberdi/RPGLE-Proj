
       dcl-f CARDPF    disk keyed usage(*UPDATE : *DELETE : *OUTPUT);
       dcl-f SUBPF     disk keyed usage(*INPUT);
       dcl-f SUBL     disk keyed usage(*INPUT) RENAME(SUB:SUBLF);
       dcl-f CRDL     disk keyed usage(*INPUT) RENAME(RCARD:RCARDL);
       dcl-f CRDSFL   workstn sfile(sflr:rrn) sfile(nsflr:rrnp);

       dcl-s dat   int(10);
       dcl-s Count Int(10);
       dcl-s RRN   int(3);
       dcl-s rrnp  int(3);
       dcl-s searchKey char(11);
       dcl-s timestampId int(10);
       dcl-s timestampStr char(26);

       Dcl-DS DT1;
       Y1             Char(4);
       M1             Char(2);
       D1             Char(2);
        End-DS;
       Dcl-DS DT2;
       Y2             Char(4);
       T1             Char(1)    inz('/');
       M2             Char(2);
       T2             Char(1)    inz('/');
       D2             Char(2);
        End-DS;

       Dcl-DS TT1;
       N1             Char(2);
       T3             Char(1)    inz('-');
       N2             Char(2);
       T4             Char(1)    inz('=');
       TT2            Char(2);
        End-DS;

        dat = (%dec(%date));

        *in70=*on;
        *in32=*on;
        *in34=*on;
        rrn=0;
        rrnp=0;


        setll *loval RCARD;
        read RCARD;
        *in99 = %eof();
        dow *IN03 = *off;
          write KOT;
          write BOT;

          if  *in70;
            exsr fillsr1;
          endif;
          *in70 = *off;

          if  *in71;
            exsr fillsr;
          endif;

          if rrn>0;
            *in31 = *on;
          endif;
          pos = rrn;
          exfmt  ctlr;

          if *in07;
             searchKey = SEU;
             exsr search;
          endif;

          if *in06;
             exsr newc;
          endif;
          exsr userkey;
          op = *blanks;
        enddo;
        *inLR = *ON;


        begsr fillsr;
        write CTLR;
        *in34 = *Off;
        for Count = 1 to 6;
          if not *in99;
            RRN = RRN + 1;
            exsr TOT;
            exsr WRKDATE;
          endif;
          if not *in99;
            chain crdsubid sub;
            write SFLR;
          endif;
          read RCARD;
          *in99 = %eof();
          *in33 = %eof();
        endfor;
        endsr;


        begsr fillsr1;
        *in70 = *off;
        write CTLR;
        *in34 = *Off;
        for Count = 1 to 6;
          if not *in99;
            RRN = RRN + 1;
            exsr TOT;
            exsr WRKDATE;
          endif;
          if not *in99;
            chain crdsubid sub;
            write SFLR;
          endif;
          read RCARD;
          *in99 = %eof();
          *In33 = %eof();
        endfor;
        endsr;


       begsr search;
        dow *IN98 = *off;
          *In34 = *On;
          pos=0;
          rrn=0;
          setll searchKey SUBLF;
          read SUBLF;
          *in98 = not %found();
          setll subid RCARDL;
          reade subid RCARDL;
          *in98 = not %found();
          *in98 = %error();
          *in98 = %eof();
          write CTLR;
          for Count = 1 to 6;
            if NOT *In99;
              RRN = RRN + 1;
            Endif;
            if NOT *In99;
              write SFLR;
            Endif;
            reade subid RCARDL;
            *in99 = %error();
            *in99 = %eof();
            *In33 = %eof();
          endfor;
          if rrn>0;
            *in31 = *on;
          endif;
          pos = rrn;
          *in34 = *Off;
          exfmt  ctlr;
          enddo;
       endsr;


       begsr userkey;
        READC SFLR;
        *in99 = %error();
        *in99 = %eof();
        Dow *IN99 = *OFF;
          *in52 = *Off;
          *in54 = *Off;
          *in58 = *Off;
          if OP = '2';
           exsr update;
          endIF;
          if OP = '4';
           exsr stschange;
          endif;
         READC SFLR ;
         *in99 = %error();
         *in99 = %eof();
        enddo;
       endsr;


       begsr stschange;
        setll CRDID RCARD;
        read RCARD;
        *in99 = not %found();
        *in99 = %error();
        *in99 = %eof();
        if CRDSTS = 'D';
          CRDSTS = 'A';
          else;
            CRDSTS = 'D';
        endif;
        update RCARD;
        clear op;
        update SFLR;
        exfmt ctlr;
       endsr;



       begsr update;
        *in80 = *off;
        write kot;
        setll CRDID RCARD;
        read RCARD;
        *in99 = not %found();
        *in99 = %error();
        *in99 = %eof();
        *In52 = *On;
        exfmt ALLF;
        if *in09 = *On;
          exsr sf2;
          clear op;
          exfmt ALLF;
        endif;
        if *in02;
        update RCARD;
        endif;
        op = *blanks;
        exfmt ALLF;
       endsr;


       begsr newc;
        write kot;
        *in56 = *On;
        clear   CRDSUBID;
        clear   CRDQTY;
        clear   CRDUSED;
        clear   CRDDAT;
        clear   CRDSUM;
        exfmt ALLF;

        if *in09 = *On;
          exsr sf2;
          exfmt ALLF;
        endif;

       if *in04 = *on;
        if (CRDSUBID <> 0);
          timestampStr = %char(%date(): *ISO0) + %char(%time(): *ISO0);
          timestampStr = %subst(timestampStr: 5: 14);
          timestampId = %int(timestampStr);
          CRDID = timestampId;
          CRDSTS = 'Y';
          CRDDAT = dat;
          write RCARD;
       else;
       ENDIF;
       endif;
       endsr;




       begsr sf2;
        *in32=*on;
        *in34=*on;
        setll *loval SUB;
        read SUB;
        *in99 = %error();
        *in99 = %eof();
        dow *IN03 = *off;
        clear op;
         WRITE nsflctl;
        *In34 = *Off;
        dow not %eof(SUBPF);
          If NOT *In99;
            rrnp = rrnp + 1;
          Endif;
          If NOT *In99;
            WRITE nsflr;
          Endif;
          READ SUB;
          *in99 = %error();
          *in99 = %eof();
          *In33 = %eof();
        ENDDO;
         if rrnp>0;
            *in31 = *on;
          endif;
          pos = 1;
          exfmt  nsflctl;
          readc nsflr;
           If OP = '1';
               CRDSUBID = SUBID;
          endif;
        enddo;
       endsr;

       begsr TOT;
             N1 = %trim(%char(CRDQTY));
             N2 = %trim(%char(CRDUSED));
             TT2 = %trim(%char(CRDQTY - CRDUSED));
             TOTAL = N1 + T3 + N2 + T4 + TT2;
       endsr;

     C     WRKDATE       BEGSR
     C                   MOVEL     CRDDAT        DT1
     C                   MOVEL     Y1            Y2
     C                   MOVEL     M1            M2
     C                   MOVEL     D1            D2
     C                   MOVEL     DT2           CRDDATE
     C                   ENDSR


        //   begsr WRKDATE;
        //     DT1 = SHDATE;
        //     Y2 = Y1;
        //     M2 = M1;
        //     D2 = D1;
        //     CRDDATE = DT2;
        // endsr;




















