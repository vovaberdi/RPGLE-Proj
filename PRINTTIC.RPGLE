**free
       dcl-f TICPF  disk keyed usage(*INPUT);
       dcl-f SHOWPF  disk keyed usage(*INPUT);
       dcl-f PRT1 PRINTER;


      dcl-pi printtic;
             param int(10);
             param2 int(10);
      end-pi;

            dsply param;
            dsply param2;

       *inlr = *On;



