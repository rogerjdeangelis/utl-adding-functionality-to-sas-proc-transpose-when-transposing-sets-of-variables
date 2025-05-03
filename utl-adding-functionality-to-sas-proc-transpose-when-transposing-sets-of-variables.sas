%let pgm=utl-adding-functionality-to-sas-proc-transpose-when-transposing-sets-of-variables;

%stop_submission;

Adding functionality to sas proc transpose when transposing sets of variables

Macro by Arthur Tabachneck, Xia Ke Shan, Robert Virgile and Joe Whitehurst

SOAPBOX ON
Fast simple flexible transpose.
A must for any sas toolbox
Note
  1 Is very fast
  2 Eliminates sort
  3 eliminates sorts plus double transpose
  4 eliminates datastep arrays and lloping
SOAPBOX OFF

    CONTENTS

        1 the issue
        2 the solution
        3 related repos

github
https://tinyurl.com/8nn5mabs
https://github.com/rogerjdeangelis/utl-adding-functionality-to-sas-proc-transpose-when-transposing-sets-of-variables

communities.sas
https://tinyurl.com/2snrdktj
https://communities.sas.com/t5/SAS-Programming/Transposing-two-variable-based-on-two-other-variables/m-p/815192#M321759

/**************************************************************************************************************************/
/* INPUT                 |        PROCESS                        |            OUTPUT                                      */
/* =====                 |        =======                        |            ======                                      */
/*                       |                                       |                                                        */
/* ID   CPS  ALLEG FIND  | 1 ISSUE WITH TRANSPOSE                | ID   CPS  _NAME_  COL1 COL2 COL3                       */
/*                       | ======================                |                                                        */
/* 001  001    1     9   |                                       | 001  001  FIND      9    1    .                        */
/* 001  001    3     1   | proc transpose data=have out=havxpo;  | 001  001  ALLEG     1    3    .                        */
/* 001  002    1     1   |   by id cps;                          | 001  002  FIND      1    .    .                        */
/* 002  003    3     2   |   var find alleg;                     | 001  002  ALLEG     1    .    .                        */
/* 002  003    4     1   | run;quit;                             | 002  003  FIND      2    1    9                        */
/* 002  003    5     9   |                                       | 002  003  ALLEG     3    4    5                        */
/* 002  004    1     1   |                                       | 002  004  FIND      1    1    .                        */
/* 002  004    2     1   |                                       | 002  004  ALLEG     1    2    .                        */
/* 002  005    1     1   |                                       | 002  005  FIND      1    .    .                        */
/* 003  006    4     9   |                                       | 002  005  ALLEG     1    .    .                        */
/*                       |                                       | 003  006  FIND      9    .    .                        */
/* data have;            |                                       | 003  006  ALLEG     4    .    .                        */
/* input ID :$3          |                                       |                                                        */
/*   CPS :$3.            |                                       | BUT I WANT                                             */
/*   ALLEG               |                                       | ==========                                             */
/*   FIND;               |                                       | ID  CPS ALLEG1 FIND1    ALLEG2 FIND2    ALLEG3 FIND3   */
/* cards4;               |                                       |                                                        */
/* 001 001 1 9           |                                       | 001 001    1     9         3     1         .     .     */
/* 001 001 3 1           |                                       | 001 002    1     1         .     .         .     .     */
/* 001 002 1 1           |                                       | 002 003    3     2         4     1         5     9     */
/* 002 003 3 2           |                                       | 002 004    1     1         2     1         .     .     */
/* 002 003 4 1           |                                       | 002 005    1     1         .     .         .     .     */
/* 002 003 5 9           |                                       | 003 006    4     9         .     .         .     .     */
/* 002 004 1 1           |------------------------------------------------------------------------------------------------*/
/* 002 004 2 1           | 2 THE SOLUTION                        | ID  CPS ALLEG1 FIND1    ALLEG2 FIND2    ALLEG3 FIND3   */
/* 002 005 1 1           | ==============                        |                                                        */
/* 003 006 4 9           |                                       | 001 001    1     9         3     1         .     .     */
/* ;;;;                  | NOTE THERE ARE MANY MORE              | 001 002    1     1         .     .         .     .     */
/* run;quit;             | OPTIONS, LIKE CHANGING THE            | 002 003    3     2         4     1         5     9     */
/*                       | ORDER OF THE OUTPUT                   | 002 004    1     1         2     1         .     .     */
/*                       |                                       | 002 005    1     1         .     .         .     .     */
/*                       | %utl_transpose(                       | 003 006    4     9         .     .         .     .     */
/*                       |  data=have                            |                                                        */
/*                       |  ,out=want                            |                                                        */
/*                       |  ,by=id cps                           |                                                        */
/*                       |  ,var=alleg find);                    |                                                        */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

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

/**************************************************************************************************************************/
/*  ID    CPS    ALLEG    FIND                                                                                            */
/*                                                                                                                        */
/*  1     001      1        9                                                                                             */
/*  1     001      3        1                                                                                             */
/*  1     002      1        1                                                                                             */
/*  2     003      3        2                                                                                             */
/*  2     003      4        1                                                                                             */
/*  2     003      5        9                                                                                             */
/*  2     004      1        1                                                                                             */
/*  2     004      2        1                                                                                             */
/*  2     005      1        1                                                                                             */
/*  3     006      4        9                                                                                             */
/**************************************************************************************************************************/

/*___    _   _                      _       _   _
|___ \  | |_| |__   ___   ___  ___ | |_   _| |_(_) ___  _ __
  __) | | __| `_ \ / _ \ / __|/ _ \| | | | | __| |/ _ \| `_ \
 / __/  | |_| | | |  __/ \__ \ (_) | | |_| | |_| | (_) | | | |
|_____|  \__|_| |_|\___| |___/\___/|_|\__,_|\__|_|\___/|_| |_|

*/

%utl_transpose(
 data=have
 ,out=want
 ,by=id cps
 ,var=alleg find);

/**************************************************************************************************************************/
/*   ID    CPS    ALLEG1    FIND1    ALLEG2    FIND2    ALLEG3    FIND3                                                   */
/*                                                                                                                        */
/*   1     001       1        9         3        1         .        .                                                     */
/*   1     002       1        1         .        .         .        .                                                     */
/*   2     003       3        2         4        1         5        9                                                     */
/*   2     004       1        1         2        1         .        .                                                     */
/*   2     005       1        1         .        .         .        .                                                     */
/*   3     006       4        9         .        .         .        .                                                     */
/**************************************************************************************************************************/

/*____            _       _           _
|___ /   _ __ ___| | __ _| |_ ___  __| |  _ __ ___ _ __   ___  ___
  |_ \  | `__/ _ \ |/ _` | __/ _ \/ _` | | `__/ _ \ `_ \ / _ \/ __|
 ___) | | | |  __/ | (_| | ||  __/ (_| | | | |  __/ |_) | (_) \__ \
|____/  |_|  \___|_|\__,_|\__\___|\__,_| |_|  \___| .__/ \___/|___/
                                                  |_|
*/

REPO
--------------------------------------------------------------------------------------------------------------------------------------------
https://github.com/rogerjdeangelis/utl-transpose-more-than-one-variable
https://github.com/rogerjdeangelis/utl-transpose-multiple-rows-into-one-row-do_over-dosubl-and-varlist-macros
https://github.com/rogerjdeangelis/utl-transpose-mutiple-sets-of-variable-fast-macro-transpose
https://github.com/rogerjdeangelis/utl-transpose-mutiple-variables-with-complete-missing-levels-and-missing-values
https://github.com/rogerjdeangelis/utl-transpose-pairs-of-dates-by-groups-or-transposing-mutiple-variables
https://github.com/rogerjdeangelis/utl-transpose-pivot-skinny-to-fat-multiple-sets-of-variables-in-wps-and-sas
https://github.com/rogerjdeangelis/utl-transpose-pivot-summmarize-in-sql-select-using-r-tidyverse-language-and-sql-sas-r-and-python
https://github.com/rogerjdeangelis/utl-transpose-pivot-wide-to-long-using-sql-arrays-in-sas-r-and-python
https://github.com/rogerjdeangelis/utl-transpose-pivot-wide-using-sql-partitioning-in-wps-r-python
https://github.com/rogerjdeangelis/utl-transpose-sets-of-variables-using-Art-Tabachneck-et-all-very-fast-macro
https://github.com/rogerjdeangelis/utl-transpose-sets-of-variables-with-a-compound-identification-Arts-macro
https://github.com/rogerjdeangelis/utl-transpose-table-creating-column-names-from-input-table-rownames-sas-sql-r-pyhon-multi-language
https://github.com/rogerjdeangelis/utl-transpose-table-with-duplicate-values
https://github.com/rogerjdeangelis/utl-transposing-a-complex-data-set-in-sas-arts-transpose-macro
https://github.com/rogerjdeangelis/utl-transposing-and-pivoting-when-id-values-have-duplicates
https://github.com/rogerjdeangelis/utl-transposing-multiple-variables-using-transpose-macro-sql-arrays-proc-report
https://github.com/rogerjdeangelis/utl-transposing-normalizing-a-table-using-four-techniques-arrays-untranspose-transpose-and-gather
https://github.com/rogerjdeangelis/utl-transposing-pivoting-minimums-using-sql-arrays
https://github.com/rogerjdeangelis/utl-transposing-two-variable-to-columns-using-transpose-macro
https://github.com/rogerjdeangelis/utl-untranspose-mutiple-arrays-fat-to-skinny-or-normalize
https://github.com/rogerjdeangelis/utl-using-arts-transpose-macro-with-two-unsorted-tables
https://github.com/rogerjdeangelis/utl-using-r-to-generate-sql-code-to-pivot-transpose-long-like-sas-array-and-do_over-macros
https://github.com/rogerjdeangelis/utl-using-sas-gather-macro-to-untranspose-a-fat-dataset-into-one-obsevation
https://github.com/rogerjdeangelis/utl-very-complex-transpose-with-character-numeric-variables-and-counts-percents
https://github.com/rogerjdeangelis/utl_an_unsusual_transpose_based_on__groups_of_variable_names
https://github.com/rogerjdeangelis/utl_classic_transpose_in_r_and_sas
https://github.com/rogerjdeangelis/utl_diagonal_transpose_while_keeping_all_original_rows
https://github.com/rogerjdeangelis/utl_excel_Import_and_transpose_range_A9-Y97_using_only_one_procedure
https://github.com/rogerjdeangelis/utl_flexible_complex_multi-dimensional_transpose_using_one_proc_report
https://github.com/rogerjdeangelis/utl_simple_three_dimensional_transpose_in_r_and_sas
https://github.com/rogerjdeangelis/utl_sophisticated_transpose_with_proc_summary_idgroup
https://github.com/rogerjdeangelis/utl_sort_summarize_and_transpose_multiple_variable_and_create_output_dataset
https://github.com/rogerjdeangelis/utl_sort_summarize_transpose_and_format_in_1_datastep
https://github.com/rogerjdeangelis/utl_sort_transpose_and_summarize_a_dataset_using_just_one_proc_report
https://github.com/rogerjdeangelis/utl_sort_transpose_and_summarize_in_one_proc_v2
https://github.com/rogerjdeangelis/utl_sort_transpose_summarize
https://github.com/rogerjdeangelis/utl_sql_version_of_proc_transpose_with_major_advantage_of_summarization
https://github.com/rogerjdeangelis/utl_techniques_to_transpose_and_stack_multiple_variables
https://github.com/rogerjdeangelis/utl_transpose_and_concatenate_observations_by_id_in_one_datastep
https://github.com/rogerjdeangelis/utl_transpose_long_to_wide_with_sequential_matching_pairs
https://github.com/rogerjdeangelis/utl_transpose_multiple_variables_and_split_variables_into_multiple_variables
https://github.com/rogerjdeangelis/utl_transpose_rows_to_column_identifying_type_of_data
https://github.com/rogerjdeangelis/utl_transpose_table_by_two_variables_not_supported_by_proc_transpose
https://github.com/rogerjdeangelis/utl_transpose_with_multiple_id_values_per_group
https://github.com/rogerjdeangelis/utl_transpose_with_proc_report
https://github.com/rogerjdeangelis/utl_transpose_with_proc_sql
https://github.com/rogerjdeangelis/utl_transposing_multiple_variables_with_different_ids_a_single_transpose_cannot_do_this
https://github.com/rogerjdeangelis/utl_two_families_itinerary_through_italy_transpose
https://github.com/rogerjdeangelis/utl_using_a_hash_to_transpose_and_reorder_a_table
https://github.com/rogerjdeangelis/wps-pivot-longer-transpose--using-r-and-wps-loops
/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
