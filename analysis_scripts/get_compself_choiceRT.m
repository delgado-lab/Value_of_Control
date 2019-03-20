function get_compself_choiceRT

subj_list = [101];
maindir = pwd;

Choice_RT = zeros(length(subj_list),7); %subjnum, run1, run2, run1_cardRT, run2_cardRT

for s = 1:length(subj_list)
    subj = subj_list(s);
    
    if ~ischar(subj)
        subj = num2str(subj);
    end  
    
    Choice_RT(s,1) = str2num(subj); 
    
    run1 = fullfile(maindir,subj,[ subj '_TaskBRand_CS_1_1.mat']);
    if exist(run1,'file')
        load(run1);
        run1data = data;
        run2 = fullfile(maindir,subj,[ subj '_TaskBRand_CS_2_2.mat']);
        load(run2);
        run2data = data;
    else run1 = fullfile(maindir,subj,[ subj '_TaskBRand_CS_2_1.mat']);
        load(run1);
        run1data = data;
        run2 = fullfile(maindir,subj,[ subj '_TaskBRand_CS_1_2.mat']);
        load(run2);
        run2data = data;
    end

    %ntrials = 44;
    
    run1_RT = [run1data.Choice_RT]';
    run1_RT(run1_RT==0) = [];
    run1_RT(isnan(run1_RT)) = [];
    avg_run1RT = mean(run1_RT);
    
    run1_RT = [run1data.Choice_RT]';
    run1_RT = [run1_RT, data(end).comptracker];
    run1_RT_self = run1_RT(run1_RT(:,3)==1);
    run1_RT_comp = run1_RT(run1_RT(:,3)==0); 
    run1_RT_self(run1_RT_self==0) = [];
    run1_RT_comp(run1_RT_comp==0) = [];
    run1_RT_self(isnan(run1_RT_self)) = [];
    run1_RT_comp(isnan(run1_RT_comp)) = [];
    avg_run1RT_self = mean(run1_RT_self);
    avg_run1RT_comp = mean(run1_RT_comp);
    
    run2_RT = [run1data.Choice_RT]';
    run2_RT(run2_RT==0) = [];
    run2_RT(isnan(run2_RT)) = [];
    avg_run2RT = mean(run2_RT);
    
    run2_RT = [run2data.Choice_RT]';
    run2_RT = [run2_RT, data(end).comptracker];
    run2_RT_self = run2_RT(run2_RT(:,3)==1);
    run2_RT_comp = run2_RT(run2_RT(:,3)==0); 
    run2_RT_self(run2_RT_self==0) = [];
    run2_RT_comp(run2_RT_comp==0) = [];
    run2_RT_self(isnan(run2_RT_self)) = [];
    run2_RT_comp(isnan(run2_RT_comp)) = [];
    avg_run2RT_self = mean(run2_RT_self);
    avg_run2RT_comp = mean(run2_RT_comp);

    
    Choice_RT(s,2) = avg_run1RT;
    Choice_RT(s,3) = avg_run2RT;
    Choice_RT(s,4) = avg_run1RT_self;
    Choice_RT(s,5) = avg_run1RT_comp;
    Choice_RT(s,6) = avg_run2RT_self;
    Choice_RT(s,7) = avg_run2RT_comp;


end

xlswrite('allsub_CS_avg_choiceRT_bycompself', Choice_RT);





    
    
    
    
    