/*
data project.ttest_recode_ifelse;
    set project.ttest;
    if Class_test_taken = 'New Test - Class a' then Class_test_taken = 1;
    else if Class_test_taken = 'New Test - Class b' then Class_test_taken = 2;
run;
*/
    

data cochranq.coch_recode;
    set cochranq.coch;
    if Pre_test = 'Passed' then Pre_test = 1;
    else if Pre_test = 'Failed' then Pre_test = 0;
     else if Post_test = 'Passed' then Post_test = 1;
    else if Post_test = 'Failed' then Post_test = 0;
    else if Nine_month_post_test = 'Passed' then Nine_month_post_test = 1;
    else if Nine_month_post_test = 'Failed' then Nine_month_post_test = 0;
run;