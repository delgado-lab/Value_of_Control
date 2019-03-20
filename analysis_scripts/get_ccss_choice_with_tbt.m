function get_ccss_choice_with_tbt

subj_list = [202 203 204];
maindir = pwd;

allcc_choices = zeros(length(subj_list), 23);  %subjnum, compmag (0 to 20) isself, count of total times for each compmag
allss_choices = zeros(length(subj_list), 23); 

for s = 1:length(subj_list)
    subj = subj_list(s);
    
    if ~ischar(subj)
        subj = num2str(subj);
    end  
    
    allcc_choices(s,1) = str2num(subj); 
    allss_choices(s,1) = str2num(subj);
    
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
    
    run1_choices = run1data(end).choicetracker;
    run2_choices = run2data(end).choicetracker;
    allrun_choices = [run1_choices;run2_choices];
    
    allrun_choices_tbt = sortrows(allrun_choices,3);
    allrun_choices_tbt(:,3) = allrun_choices_tbt(:,3)-10;
    allrun_choices_tbt(:,1) = str2num(subj); 
    
    cc_choices = allrun_choices(allrun_choices(:,1)==1,:);
    ss_choices = allrun_choices(allrun_choices(:,1)==2,:);
    
    cc_choices_tbt = sortrows(cc_choices,3);
    cc_choices_tbt(:,3) = cc_choices_tbt(:,3)-10;
    cc_choices_tbt(:,1) = str2num(subj); 
    
    ss_choices_tbt = sortrows(ss_choices,3);
    ss_choices_tbt(:,3) = ss_choices_tbt(:,3)-10;
    ss_choices_tbt(:,1) = str2num(subj); 
    
    if s == 1
        all_subj_allrun_choices_tbt = allrun_choices_tbt;
        all_subj_choices_cc_tbt = cc_choices_tbt;
        all_subj_choices_ss_tbt = ss_choices_tbt;
    else
        all_subj_allrun_choices_tbt = [all_subj_allrun_choices_tbt;allrun_choices_tbt];
        all_subj_choices_cc_tbt = [all_subj_choices_cc_tbt;cc_choices_tbt];
        all_subj_choices_ss_tbt = [all_subj_choices_ss_tbt;ss_choices_tbt];
    end
    
    
    allcc_choices(s,2) = sum(cc_choices(cc_choices(:,3)==0,4));
    allcc_choices(s,3) = allcc_choices(s,2)/2;
    allcc_choices(s,4) = sum(cc_choices(cc_choices(:,3)==2,4));
    allcc_choices(s,5) = allcc_choices(s,4)/2;
    allcc_choices(s,6) = sum(cc_choices(cc_choices(:,3)==4,4));
    allcc_choices(s,7) = allcc_choices(s,6)/2;
    allcc_choices(s,8) = sum(cc_choices(cc_choices(:,3)==6,4));
    allcc_choices(s,9) = allcc_choices(s,8)/2;
    allcc_choices(s,10) = sum(cc_choices(cc_choices(:,3)==8,4));
    allcc_choices(s,11) = allcc_choices(s,10)/2;
    allcc_choices(s,12) = sum(cc_choices(cc_choices(:,3)==10,4));
    allcc_choices(s,13) = allcc_choices(s,12)/2;
    allcc_choices(s,14) = sum(cc_choices(cc_choices(:,3)==12,4));
    allcc_choices(s,15) = allcc_choices(s,14)/2;
    allcc_choices(s,16) = sum(cc_choices(cc_choices(:,3)==14,4));
    allcc_choices(s,17) = allcc_choices(s,16)/2;
    allcc_choices(s,18) = sum(cc_choices(cc_choices(:,3)==16,4));
    allcc_choices(s,19) = allcc_choices(s,18)/2;
    allcc_choices(s,20) = sum(cc_choices(cc_choices(:,3)==18,4));
    allcc_choices(s,21) = allcc_choices(s,20)/2;
    allcc_choices(s,22) = sum(cc_choices(cc_choices(:,3)==20,4));
    allcc_choices(s,23) = allcc_choices(s,22)/2;
    
    allss_choices(s,2) = sum(ss_choices(ss_choices(:,3)==0,4));
    allss_choices(s,3) = allss_choices(s,2)/2;
    allss_choices(s,4) = sum(ss_choices(ss_choices(:,3)==2,4));
    allss_choices(s,5) = allss_choices(s,4)/2;
    allss_choices(s,6) = sum(ss_choices(ss_choices(:,3)==4,4));
    allss_choices(s,7) = allss_choices(s,6)/2;
    allss_choices(s,8) = sum(ss_choices(ss_choices(:,3)==6,4));
    allss_choices(s,9) = allss_choices(s,8)/2;
    allss_choices(s,10) = sum(ss_choices(ss_choices(:,3)==8,4));
    allss_choices(s,11) = allss_choices(s,10)/2;
    allss_choices(s,12) = sum(ss_choices(ss_choices(:,3)==10,4));
    allss_choices(s,13) = allss_choices(s,12)/2;
    allss_choices(s,14) = sum(ss_choices(ss_choices(:,3)==12,4));
    allss_choices(s,15) = allss_choices(s,14)/2;
    allss_choices(s,16) = sum(ss_choices(ss_choices(:,3)==14,4));
    allss_choices(s,17) = allss_choices(s,16)/2;
    allss_choices(s,18) = sum(ss_choices(ss_choices(:,3)==16,4));
    allss_choices(s,19) = allss_choices(s,18)/2;
    allss_choices(s,20) = sum(ss_choices(ss_choices(:,3)==18,4));
    allss_choices(s,21) = allss_choices(s,20)/2;
    allss_choices(s,22) = sum(ss_choices(ss_choices(:,3)==20,4));
    allss_choices(s,23) = allss_choices(s,22)/2;
    
    header = {'Subj', '0', 'prop', '2','prop', '4','prop', '6','prop', '8','prop', '10','prop', '12','prop', '14','prop', '16','prop', '18','prop', '20','prop',};
    header2 = {'Subj', 'selfmag', 'EVdiffV-F', 'varied0fixed1'};

    

end


%xlswrite('allsubj_ccchoice', allcc_choices);
%xlswrite('allsubj_sschoice', allss_choices);
csvwrite_with_headers('allsubj_ccchoice.csv',allcc_choices,header);
csvwrite_with_headers('allsubj_sschoice.csv',allss_choices,header);
csvwrite_with_headers('allsubj_ccss_tbt.csv',all_subj_allrun_choices_tbt,header2);
csvwrite_with_headers('allsubj_cc_tbt.csv',all_subj_choices_cc_tbt,header2);
csvwrite_with_headers('allsubj_ss_tbt.csv',all_subj_choices_ss_tbt,header2);


% This function functions like the build in MATLAB function csvwrite but
% allows a row of headers to be easily inserted
%
% known limitations
% 	The same limitation that apply to the data structure that exist with 
%   csvwrite apply in this function, notably:
%       m must not be a cell array
%
% Inputs
%   
%   filename    - Output filename
%   m           - array of data
%   headers     - a cell array of strings containing the column headers. 
%                 The length must be the same as the number of columns in m.
%   r           - row offset of the data (optional parameter)
%   c           - column offset of the data (optional parameter)
%
%
% Outputs
%   None
function csvwrite_with_headers(filename,m,headers,r,c)

%% initial checks on the inputs
if ~ischar(filename)
    error('FILENAME must be a string');
end

% the r and c inputs are optional and need to be filled in if they are
% missing
if nargin < 4
    r = 0;
end
if nargin < 5
    c = 0;
end

if ~iscellstr(headers)
    error('Header must be cell array of strings')
end

 
if length(headers) ~= size(m,2)
    error('number of header entries must match the number of columns in the data')
end

%% write the header string to the file

%turn the headers into a single comma seperated string if it is a cell
%array, 
header_string = headers{1};
for i = 2:length(headers)
    header_string = [header_string,',',headers{i}];
end
%if the data has an offset shifting it right then blank commas must
%be inserted to match
if r>0
    for i=1:r
        header_string = [',',header_string];
    end
end

%write the string to a file
fid = fopen(filename,'w');
fprintf(fid,'%s\r\n',header_string);
fclose(fid);

%% write the append the data to the file

%
% Call dlmwrite with a comma as the delimiter
%
dlmwrite(filename, m,'-append','delimiter',',','roffset', r,'coffset',c);





    
    
    
    
    