function get_ccss_choiceRT

subj_list = [101];
maindir = pwd;

Choice_RT = zeros(length(subj_list),9); %subjnum, ccrun1, ccrun2, ccrun1_cardRT, ccrun2_cardRT, ssrun1, ssrun2, ssrun1_cardRT, ssrun2_cardRT

for s = 1:length(subj_list)
    subj = subj_list(s);
    
    if ~ischar(subj)
        subj = num2str(subj);
    end  
    
    Choice_RT(s,1) = str2num(subj); 
    
    run1 = fullfile(maindir, subj,[ subj '_TaskBRand_CCSS_1_1.mat']);
    if exist(run1,'file')
        load(run1);
        run1data = data;
        run2 = fullfile(maindir,subj,[ subj '_TaskBRand_CCSS_2_2.mat']);
        load(run2);
        run2data = data;
    else run1 = fullfile(maindir,subj,[ subj '_TaskBRand_CCSS_2_1.mat']);
        load(run1);
        run1data = data;
        run2 = fullfile(maindir,subj,[ subj '_TaskBRand_CCSS_1_2.mat']);
        load(run2);
        run2data = data;
    end

    %ntrials = 44;
    
    run1_mat = run1data(end).choicetracker;
    run1_mat(:,5) = [run1data.Choice_RT]';
    run1_mat(:,6) = [run1data.Card_RT]';
    run2_mat = run2data(end).choicetracker;
    run2_mat(:,5) = [run2data.Choice_RT]';
    run2_mat(:,6) = [run2data.Card_RT]';
    %allrun_mat = [run1_mat;run2_mat];
    
    cc_run1RT = run1_mat(run1_mat(:,1)==1,5);
    cc_run1RT(cc_run1RT==0) = [];
    cc_run1RT(isnan(cc_run1RT)) = [];
    avg_cc_run1RT = mean(cc_run1RT);
    ss_run1RT = run1_mat(run1_mat(:,1)==2,5);
    ss_run1RT(ss_run1RT==0) = [];
    ss_run1RT(isnan(ss_run1RT)) = [];
    avg_ss_run1RT = mean(ss_run1RT);
    cc_run1cardRT = run1_mat(run1_mat(:,1)==1,6);
    cc_run1cardRT(cc_run1cardRT==0) = [];
    cc_run1cardRT(isnan(cc_run1cardRT)) = [];
    avg_cc_run1cardRT = mean(cc_run1cardRT);
    ss_run1cardRT = run1_mat(run1_mat(:,1)==2,6);
    ss_run1cardRT(ss_run1cardRT==0) = [];
    ss_run1cardRT(isnan(ss_run1cardRT)) = [];
    avg_ss_run1cardRT = mean(ss_run1cardRT);

    cc_run2RT = run2_mat(run2_mat(:,1)==1,5);
    cc_run2RT(cc_run2RT==0) = [];
    cc_run2RT(isnan(cc_run2RT)) = [];    
    avg_cc_run2RT = mean(cc_run2RT);
    ss_run2RT = run2_mat(run2_mat(:,1)==2,5);
    ss_run2RT(ss_run2RT==0) = [];
    ss_run2RT(isnan(ss_run2RT)) = [];    
    avg_ss_run2RT = mean(ss_run2RT);
    cc_run2cardRT = run2_mat(run2_mat(:,1)==1,6);
    cc_run2cardRT(cc_run2cardRT==0) = [];
    cc_run2cardRT(isnan(cc_run2cardRT)) = [];    
    avg_cc_run2cardRT = mean(cc_run2cardRT);
    ss_run2cardRT = run2_mat(run2_mat(:,1)==2,6);
    ss_run2cardRT(ss_run2cardRT==0) = [];
    ss_run2cardRT(isnan(ss_run2cardRT)) = [];    
    avg_ss_run2cardRT = mean(ss_run2cardRT);
    
    Choice_RT(s,2) = avg_cc_run1RT;
    Choice_RT(s,3) = avg_cc_run2RT;
    Choice_RT(s,4) = avg_cc_run1cardRT;
    Choice_RT(s,5) = avg_cc_run2cardRT;
    Choice_RT(s,6) = avg_ss_run1RT;
    Choice_RT(s,7) = avg_ss_run2RT;
    Choice_RT(s,8) = avg_ss_run1cardRT;
    Choice_RT(s,9) = avg_ss_run2cardRT;    

end

xlswrite('allsubj_CCSS_avg_choiceRT', Choice_RT);





    
    
    
    
    