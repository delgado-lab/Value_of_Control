function task_wrapper_fmri_2(subjectnum)

%COMP/Varied which side  RLRL
currentdir = pwd;

TaskA_walkthroughGuessing_2(subjectnum);

fprintf('Please get the Experimenter. \n')
quitwrapper = stop_wrapper;
if quitwrapper
    return
end

TaskBRand_CS_2_1(subjectnum);   %C/R S/L  

fprintf('Please get the Experimenter. \n')
quitwrapper = stop_wrapper;
if quitwrapper
    return
end

TaskBRand_CCSS_1_1(subjectnum);   %V/L F/R

fprintf('Please get the Experimenter. \n')
quitwrapper = stop_wrapper;
if quitwrapper
    return
end

TaskBRand_CS_1_2(subjectnum);   %C/L S/R

fprintf('Please get the Experimenter. \n')
quitwrapper = stop_wrapper;
if quitwrapper
    return
end

TaskBRand_CCSS_2_2(subjectnum);   %V/R F/L

fprintf('The experiment has ended.\nYou have earned 260 points out of 460 points.\nPlease get the Experimenter. \n');
quitwrapper = stop_wrapper;
if quitwrapper
    return
end

cd(currentdir)

function quitwrapper = stop_wrapper()
keep_waiting = 1;
while keep_waiting
    yes_no = input('yes/no: ', 's');
    if strcmp(yes_no, 'yes')
        keep_waiting = 0;
        quitwrapper = 0;
    elseif strcmp(yes_no, 'no')
        quitwrapper = 1;
        return;
    else
        fprintf('Please respond with either ''yes'' or ''no''.\n')
    end
end


