/* From utl-adding-functionality-to-sas-proc-transpose-when-transposing-sets-of-variables.sas */
/* Section "1 ISSUE WITH TRANSPOSE": the repo's HAVE table fed into the baseline    */
/* PROC TRANSPOSE shown in the file's process column, then printed. The listing      */
/* matches the OUTPUT column documented alongside that step in the source.           */

data have;
input ID :$3
  CPS :$3.
  ALLEG
  FIND;
cards4;
001 001 1 9
001 001 3 1
001 002 1 1
002 003 3 2
002 003 4 1
002 003 5 9
002 004 1 1
002 004 2 1
002 005 1 1
003 006 4 9
;;;;
run;quit;

proc transpose data=have out=havxpo;
  by id cps;
  var find alleg;
run;quit;

proc print data=havxpo;
run;
