/* From utl-adding-functionality-to-sas-proc-transpose-when-transposing-sets-of-variables.sas */
/* The repo's HAVE table, read verbatim from the inline cards4 block, then printed. */

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

proc print data=have;
run;
