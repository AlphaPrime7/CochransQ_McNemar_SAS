* author: Tingwei Adeck
* date: 2022-11-13
* purpose: Cochran's Q analysis in SAS (Effect of BLS classes on the pass/fail rate for the BLS test)-SPSS is the better tool
* license: public domain
* Input: coch.sav
* Output: CochransQ_BLS_SAS.pdf
* Description: Cochran's Q on 3 independent variables (pre,post and 9-month post) vs a dichotomous pass/fail dependent variable
* Results: Reject the Null of all 3 distributions being same and significance in difference between post & 9mo-post compared to pre
*CochQ results are right but the McNemar test suffers here and it is the equivalent of writing a macro for multiple chi-square tests
A project for later;


%let path=/home/u40967678/sasuser.v94;

	
filename coch
	"&path/biostats/cochranq/coch.sav";
	
libname cochranq
	"&path/biostats/cochranq";	
	
ods pdf file=
    "&path/sas_umkc/output/CochransQ_BLS_SAS.pdf";

options papersize=(8in 11in) nonumber nodate;

	

data cochranq.coch;
proc import file= coch
    out=cochranq.coch
    dbms=SAV
    replace;
run;

proc format; /*if else formatting can be used here*/
   value pfformat
     Passed = 1
     Failed = 0;
run;

data cochranq.coch_recode;
    set cochranq.coch;
    Pre_test_bin = put(Pre_test, pfformat.);
    Post_test_bin = put(Post_test, pfformat.);
   	Nine_month_post_test_bin = put(Nine_month_post_test, pfformat.);
   	Response_sum = Pre_test_bin + Post_test_bin + Nine_month_post_test_bin;
   	Response_char = put(Response_sum, 10.);
   	
   	if Response_sum GT 0 and Response_sum LT 3 then Response_char = 'Discordant';
    else if Response_sum EQ 0 or Response_sum EQ 3 then Response_char = 'Cordant';
run;

title 'Summary of data first 15 obs';   	
proc print data=cochranq.coch_recode (obs=15);
run;

title 'Effect of BLS class on test outcomes using non-binary data';
proc freq data=cochranq.coch_recode;
   tables  Pre_test Post_test Nine_month_post_test / nocum;
   tables Pre_test*Post_test*Nine_month_post_test / agree expected norow nocol nopercent;
run;

title 'Effect of BLS class on test outcomes using binary(1,0) data';
proc freq data=cochranq.coch_recode;
   tables  Pre_test_bin Post_test_bin Nine_month_post_test_bin / nocum;
   tables Pre_test_bin*Post_test_bin*Nine_month_post_test_bin / agree expected norow nocol nopercent;
run;

ods pdf close;
