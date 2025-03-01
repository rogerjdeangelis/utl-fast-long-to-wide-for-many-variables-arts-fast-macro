%let pgm=utl-fast-long-to-wide-for-many-variables-arts-fast-macro;

%stop_submission

Fast long to wide for many variables arts fast macro

Note a single proc transpose cannot do this pivot

   proc transpose  data=have out=havexpo;
     by id;
     id i;
     var X W Z R;
   run;quit;

   ID    _NAME_    _1    _2    _3    _4    _5    _6

    1      X       11    15    19    23    27    31
    1      W       12    16    20    24    28    32
   ...
    2      Z       37    41    45    49    53    57
    2      R       38    42    46    50    54    58

   THREE SOLUTIONS
   ===============

       1 arts transpose macro (very flexible)
       2 common double transpose
         Tom
         https://communities.sas.com/t5/user/viewprofilepage/user-id/159
       3 numary macro
         %put %utl_numary(have,drop=id i); generates this code

         [12,4] (11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,
                 35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58)

Arts macro was designed to be fast and eliminate the double transpose
AUTHORS: Arthur Tabachneck, Xia Ke Shan, Robert Virgile and Joe Whitehurst

github
https://tinyurl.com/5n8z5kck
https://github.com/rogerjdeangelis/utl-fast-long-to-wide-for-many-variables-arts-fast-macro

sas communities
https://tinyurl.com/ycxstf2u
https://communities.sas.com/t5/SAS-Programming/long-to-wide-for-multiple-varaibles/m-p/955070#M372997

macros
https://tinyurl.com/y9nfugth
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories

related repos
https://github.com/rogerjdeangelis/utl-creating-two-dimensional-numeric-array-from-the-rectangular-sas-dataset
https://github.com/rogerjdeangelis/utl-convert-the-numeric-values-in-sas-dataset-to-an-in-memory-two-dimensional-array-multi-language

/**************************************************************************************************************************/
/*                   |                      |                                                                             */
/*     INPUT         |      PROCESS         |                                 OUTPUT                                      */
/*     =====         |      =======         |                                 ======                                      */
/*                   |                      |                                                                             */
/*Data have;         | 1 ARTS TRANSPOSE     |                                                                             */
/*input ID I X W Z R;| ================     |     1st row     2nd row     3rd row     4th row     5th row     6th row     */
/*cards4;            |                      |     ----------- ----------- ----------- ----------- ----------- ----------- */
/*1 1 11 12 13 14    |  %utl_transpose(     |  ID X1 W1 Z1 R1 X2 W2 Z2 R2 X3 W3 Z3 R3 X4 W4 Z4 R4 X5 W5 Z5 R5 X6 W6 Z6 R6 */
/*1 2 15 16 17 18    |    data=have         |     ----------- ----------- ----------- ----------- ----------- ----------- */
/*1 3 19 20 21 22    |   ,out=want          |   1 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 */
/*1 4 23 24 25 26    |   ,by=id             |   2 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 */
/*1 5 27 28 29 30    |   ,var=X W Z R );    |                                                                             */
/*1 6 31 32 33 34    |                      |                                                                             */
/*2 1 35 36 37 38    |                      |                                                                             */
/*2 2 39 40 41 42    |                      |                                                                             */
/*2 3 43 44 45 46    |                      |                                                                             */
/*2 4 47 48 49 50    |                      |                                                                             */
/*2 5 51 52 53 54    |                      |                                                                             */
/*2 6 55 56 57 58    |                      |                                                                             */
/*;;;;               |                      |                                                                             */
/*Run;quit;          |-----------------------                                                                             */
/*                   |                      |                                                                             */
/*                   |                      |                                                                             */
/*                   | 2 DOUBLE TRANSPOSE   |                                                                             */
/*                   | ==================   |                                                                             */
/*                   |                      |                                                                             */
/*                   | proc transpose       |                                                                             */
/*                   |  data=have out=tall; |                                                                             */
/*                   |   by id i;           |                                                                             */
/*                   |   var x -- r ;       |                                                                             */
/*                   | run;                 |                                                                             */
/*                   |                      |                                                                             */
/*                   | proc transpose       |                                                                             */
/*                   |   data=tall          |                                                                             */
/*                   |   out=want(          |                                                                             */
/*                   |     drop=_name_);    |                                                                             */
/*                   |   by id ;            |                                                                             */
/*                   |   id _name_ i;       |                                                                             */
/*                   |   var col1 ;         |                                                                             */
/*                   | run;                 |                                                                             */
/*                   |                      |                                                                             */
/*                   |------------------------------------------                                                          */
/*                   |                                         |                                                          */
/*                   | 3 NUMARY MACRO                          |                                                          */
/*                   | ==============                          |                                                          */
/*                   |                                         |                                                          */
/*                   | data want;                              |                                                          */
/*                   |   length grp 3;                         |                                                          */
/*                   |   array num                             |                                                          */
/*                   |     %utl_numary(have,drop=id i);        |                                                          */
/*                   |   array var[24]                         |                                                          */
/*                   |      %do_over(_vs,Phrase=X? W? Z? R?);  |                                                          */
/*                   |                                         |                                                          */
/*                   |   do grp= 1 to 2;                       |                                                          */
/*                   |    rc=0;                                |                                                          */
/*                   |    select (grp);                        |                                                          */
/*                   |       when(1) do; s=1; e=6;  end;       |                                                          */
/*                   |       when(2) do; s=7; e=12; end;       |                                                          */
/*                   |    end; * otherwise not needed;         |                                                          */
/*                   |    do row=s to e;                       |                                                          */
/*                   |      do col=1 to 4;                     |                                                          */
/*                   |       rc=rc+1;                          |                                                          */
/*                   |       var[rc]=num[row,col];             |                                                          */
/*                   |      end;                               |                                                          */
/*                   |    end;                                 |                                                          */
/*                   |   output;                               |                                                          */
/*                   |   end;                                  |                                                          */
/*                   |   drop rc row col num: s e;             |                                                          */
/*                   | run;quit;                               |                                                          */
/*                   |                                         |                                                          */
/*                   |                                         |                                                          */
/*                   |------------------------------------------                                                          */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

Data have;
input ID I X W Z R;
cards4;
1 1 11 12 13 14
1 2 15 16 17 18
1 3 19 20 21 22
1 4 23 24 25 26
1 5 27 28 29 30
1 6 31 32 33 34
2 1 35 36 37 38
2 2 39 40 41 42
2 3 43 44 45 46
2 4 47 48 49 50
2 5 51 52 53 54
2 6 55 56 57 58
;;;;
Run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  ID    I     X     W     Z     R                                                                                       */
/*                                                                                                                        */
/*   1    1    11    12    13    14                                                                                       */
/*   1    2    15    16    17    18                                                                                       */
/*   1    3    19    20    21    22                                                                                       */
/*   1    4    23    24    25    26                                                                                       */
/*   1    5    27    28    29    30                                                                                       */
/*   1    6    31    32    33    34                                                                                       */
/*                                                                                                                        */
/*   2    1    35    36    37    38                                                                                       */
/*   2    2    39    40    41    42                                                                                       */
/*   2    3    43    44    45    46                                                                                       */
/*   2    4    47    48    49    50                                                                                       */
/*   2    5    51    52    53    54                                                                                       */
/*   2    6    55    56    57    58                                                                                       */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _         _
/ |   __ _ _ __| |_ ___  | |_ _ __ __ _ _ __  ___ _ __   ___  ___  ___  _ __ ___   __ _  ___ _ __ ___
| |  / _` | `__| __/ __| | __| `__/ _` | `_ \/ __| `_ \ / _ \/ __|/ _ \| `_ ` _ \ / _` |/ __| `__/ _ \
| | | (_| | |  | |_\__ \ | |_| | | (_| | | | \__ \ |_) | (_) \__ \  __/| | | | | | (_| | (__| | | (_) |
|_|  \__,_|_|   \__|___/  \__|_|  \__,_|_| |_|___/ .__/ \___/|___/\___||_| |_| |_|\__,_|\___|_|  \___/
                                                 |_|
*/

%utl_transpose(
  data=have
 ,out=want
 ,by=id
 ,var=X W Z R );


/**************************************************************************************************************************/
/*                                                                                                                        */
/*     1st row     2nd row     3rd row     4th row     5th row     6th row                                                */
/*     ----------- ----------- ----------- ----------- ----------- -----------                                            */
/*  ID X1 W1 Z1 R1 X2 W2 Z2 R2 X3 W3 Z3 R3 X4 W4 Z4 R4 X5 W5 Z5 R5 X6 W6 Z6 R6                                            */
/*     ----------- ----------- ----------- ----------- ----------- -----------                                            */
/*   1 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34                                            */
/*   2 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58                                            */
/*                                                                                                                        */
/*                                                                                                                        */
/*  ID X1 W1 Z1 R1 X2 W2 Z2 R2 X3 W3 Z3 R3 X4 W4 Z4 R4 X5 W5 Z5 R5 X6 W6 Z6 R6                                            */
/*                                                                                                                        */
/*   1 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34                                            */
/*   2 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58                                            */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                                                   _             _     _        _
|___ \    ___ ___  _ __ ___  _ __ ___   ___  _ __    __| | ___  _   _| |__ | | ___  | |_ _ __ __ _ _ __  ___ _ __   ___  ___  ___
  __) |  / __/ _ \| `_ ` _ \| `_ ` _ \ / _ \| `_ \  / _` |/ _ \| | | | `_ \| |/ _ \ | __| `__/ _` | `_ \/ __| `_ \ / _ \/ __|/ _ \
 / __/  | (_| (_) | | | | | | | | | | | (_) | | | || (_| | (_) | |_| | |_) | |  __/ | |_| | | (_| | | | \__ \ |_) | (_) \__ \  __/
|_____|  \___\___/|_| |_| |_|_| |_| |_|\___/|_| |_| \__,_|\___/ \__,_|_.__/|_|\___|  \__|_|  \__,_|_| |_|___/ .__/ \___/|___/\___|
                                                                                                            |_|
*/

proc transpose
 data=have out=tall;
  by id i;
  var x -- r ;
run;

proc transpose
  data=tall
  out=want(
    drop=_name_);
  by id ;
  id _name_ i;
  var col1 ;
run;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* ID X1 W1 Z1 R1 X2 W2 Z2 R2 X3 W3 Z3 R3 X4 W4 Z4 R4 X5 W5 Z5 R5 X6 W6 Z6 R6                                             */
/*                                                                                                                        */
/*  1 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34                                             */
/*  2 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58                                             */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*____
|___ /   _ __  _   _ _ __ ___   __ _ _ __ _   _  _ __ ___   __ _  ___ _ __ ___
  |_ \  | `_ \| | | | `_ ` _ \ / _` | `__| | | || `_ ` _ \ / _` |/ __| `__/ _ \
 ___) | | | | | |_| | | | | | | (_| | |  | |_| || | | | | | (_| | (__| | | (_) |
|____/  |_| |_|\__,_|_| |_| |_|\__,_|_|   \__, ||_| |_| |_|\__,_|\___|_|  \___/
                                          |___/
*/

%symdel rowcol reshape / nowarn;
* Note macro arguments are automatically local within the macro;
* however it does not hurt to remove from global scope to minimize confusion;

%array(_vs,values=1-6);

data want;
  length grp 3;
  array num
    %utl_numary(have,drop=id i);
  array var[24]
     %do_over(_vs,Phrase=X? W? Z? R?);
  do grp= 1 to 2;
   rc=0;
   select (grp);
      when(1) do; s=1; e=6;  end;
      when(2) do; s=7; e=12; end;
   end;
   do row=s to e;
     do col=1 to 4;
      rc=rc+1;
      var[rc]=num[row,col];
     end;
   end;
  output;
  end;
  drop rc row col num: s e;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* ID X1 W1 Z1 R1 X2 W2 Z2 R2 X3 W3 Z3 R3 X4 W4 Z4 R4 X5 W5 Z5 R5 X6 W6 Z6 R6                                             */
/*                                                                                                                        */
/*  1 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34                                             */
/*  2 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58                                             */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
