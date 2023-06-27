**free
       dcl-f SUBPF    disk keyed usage(*UPDATE : *DELETE : *OUTPUT);
       dcl-f TELFIX   disk keyed usage(*INPUT);
       dcl-f SUBL     disk keyed usage(*INPUT) RENAME(SUB:SUBLF);
       dcl-f SUBSFL   workstn sfile(sflr:rrn) sfile(nsflr:rrnp);

       dcl-pr SHOWPGM extpgm('SHOWPGM');
              param int(10) const;
       end-pr;

       dcl-s count Int(10);
       dcl-s rrn   int(3);
       dcl-s rrnp  int(3);
       dcl-s searchKey char(11);
       dcl-s timestampId int(10);
       dcl-s timestampStr char(26);

        *in70=*on;
        *in32=*on;
        *in34=*on;
        rrn=0;
        rrnp=0;

        setll *loval sub;
        read SUB;
        *in99 = %error();
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

            exsr userkey;

          if *in07;
             searchKey = SEU;
             exsr search;
          endif;

          if *in06;
             exsr newc;
          endif;

         enddo;

         *inLR = *ON;


        begsr fillsr;
          write CTLR;
          *in34 = *Off;
          for count = 1 to 6;
            if not *in99;
              rrn = rrn + 1;
            endif;
            if not *in99;
              write SFLR;
            endif;
            read sub;
            *in99 = %error();
            *in99 = %eof();
            *In33 = %eof();
          endfor;
        endsr;


        begsr fillsr1;
          write CTLR;
          *in34 = *Off;
          for count = 1 to 6;
            if not *in99;
            rrn = rrn + 1;
            endif;
            if not *in99;
              write SFLR;
            endif;
            read sub;
            *in99 = %error();
            *in99 = %eof();
            *in33 = %eof();
          endfor;
        endsr;


       begsr search;
        *in34 = *On;
        pos=0;
        rrn=0;
        setll searchKey SUBLF;
        read SUBLF;
        chain subid sub;
        *in99 = %error();
        *in99 = %eof();
        write CTLR;
        for count = 1 to 6;
          if not *in99;
            rrn = rrn + 1;
          endif;
          if not *in99;
            write SFLR;
          endif;
          read SUB;
          *in99 = %error();
          *in99 = %eof();
          *in33 = %eof();
        endfor;
          if rrn>0;
            *in31 = *on;
          endif;
          pos = rrn;
          *in34 = *Off;
          exfmt  ctlr;
       endsr;

       begsr userkey;
        readc SFLR;
        *in99 = %error();
        *in99 = %eof();
        Dow *IN99 = *OFF;
          *in52 = *Off;
          *in54 = *Off;
          *in58 = *Off;
          if OP = '2';
            exsr update;
          endif;
          if OP = '4';
            exsr stschange;
          endif;
          if OP = '5';
            callp SHOWPGM(subid);
          endif;
          readc SFLR;
          *in99 = %error();
          *in99 = %eof();
        enddo;
       endsr;


      begsr stschange;
        setll SUBID SUB;
        read SUB;
        *in99 = not %found();
        *in99 = %error();
        *in99 = %eof();
        if SUBSTS = 'D';
          SUBSTS = 'A';
          else;
            SUBSTS = 'D';
        endif;
        update SUB;
        clear op;
        update SFLR;
        exfmt ctlr;
      endsr;



      begsr update;
        write kot;
        setll SUBID SUB;
        read SUB;
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
          update SUB;
        endif;
        op = *blanks;
        exfmt ALLF;
      endsr;


      begsr newc;
        write kot;
        *in56 = *On;
        clear   SUBID;
        clear   SUBCC4;
        clear   SUBNAME;
        clear   SUBTEL;
        clear   SUBEMAIL;
        exfmt ALLF;
        if *in09 = *On;
          exsr sf2;
          exfmt ALLF;
        endif;

        if *in04 = *on;
          if (SUBCC4 <> 0);
            timestampStr = %char(%date(): *ISO0) + %char(%time(): *ISO0);
            timestampStr = %subst(timestampStr: 5: 14);
            timestampId = %int(timestampStr);
            SUBID = timestampId;
            SUBPAS = 'password';
            SUBSTS = 'Y';
            write SUB;
            else;
          endif;
        endif;
      endsr;




      begsr sf2;
        *in32=*on;
        *in34=*on;
        setll *loval FIX;
        read FIX;
        *in99 = %error();
        *in99 = %eof();
        dow *IN03 = *off;
          clear op;
          write nsflctl;
          *in34 = *Off;
          dow not %eof(TELFIX);
            if not *in99;
              rrnp = rrnp + 1;
            endif;
            if NOT *In99;
              write nsflr;
            endif;
            read FIX;
            *in99 = %error();
            *in99 = %eof();
            *In33 = %eof();
          enddo;
          if rrnp>0;
            *in31 = *on;
          endif;
          pos = 1;
          exfmt  nsflctl;
          readc nsflr;
          if OP = '1';
            SUBTEL = SUBTELF;
          endif;
        enddo;
       endsr;























