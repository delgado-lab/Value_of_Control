function TaskBRand_CCSS_1_1(subjectnum)

Screen('Preference', 'SkipSyncTests', 1);

if ~ischar(subjectnum)
    subjectnum = num2str(subjectnum);
end

%%
RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));

gray = [190 190 190];
black = [0 0 0];
white = [255 255 255];
blue = [0 0 200];
middle_card_color = blue;
chosen_color = [255 153 51]; 

%% TRIAL INFO 
ntrials = 22; 

ITI_ISI_list(:,1) = [repmat(1,1,11) repmat(2,1,5) repmat(3,1,3) repmat(4,1,2) repmat(6,1,1)]';  % ITI
ITI_ISI_list(:,2) = [repmat(1,1,11) repmat(2,1,5) repmat(3,1,3) repmat(4,1,2) repmat(6,1,1)]';  % ISI
ITI__ISI_list = Shuffle(ITI_ISI_list,2); 

trial_order(:,1) = [repmat(1,1,11) repmat(2,1,11)]';   %1- CC; 2- SS   
trial_order(1:11,2) = [repmat(0,1,1) repmat(2,1,1) repmat(4,1,1) repmat(6,1,1) repmat(8,1,1) repmat(10,1,1) repmat(12,1,1) repmat(14,1,1) repmat(16,1,1) repmat(18,1,1) repmat(20,1,1)]';
trial_order(12:22,2) = [repmat(0,1,1) repmat(2,1,1) repmat(4,1,1) repmat(6,1,1) repmat(8,1,1) repmat(10,1,1) repmat(12,1,1) repmat(14,1,1) repmat(16,1,1) repmat(18,1,1) repmat(20,1,1)]';
trial_order = Shuffle(trial_order,2);   %col 1 = CC/SS; col 2 = varied magnitude 
trial_order(:,3) = (1:22); % trial number

responsewindow = 4;
guess_responsewindow = 2;
choicetracker_list = zeros();

try
    %%
    %%%MAKE BUTTON CODES PORTABLE. ALL BUTTON CHANGES SHOULD BE HERE%%%
    KbName('UnifyKeyNames'); 
    
    L_arrow = KbName('LeftArrow'); 
    R_arrow = KbName('RightArrow');
    U_arrow = KbName('UpArrow'); 
    D_arrow = KbName('DownArrow');

    esc_key = KbName('ESCAPE');
    space_key = KbName('space');
    go_button = space_key;

    %%%Make outputdir if it does not already exist%%%
    maindir = pwd;
    outputdir = fullfile(maindir,'BehavioralData',subjectnum);
    if ~exist(outputdir,'dir')
        mkdir(outputdir);
    end
    
   %Setting up the screens
    Screen('CloseAll');
    [window,screenRect] = Screen('OpenWindow', 0, gray, []);
    
    HideCursor;
    ListenChar(2);
    WaitSecs(.5);
    
    centerhoriz = screenRect(3)/2;   %gives center point of origin on the screen
    centervert = screenRect(4)/2;
    scale_res = [1 1];

    %Create offscreen window to save displays to
    
    %%%set image and rect sizes%%%
    above_fixation = 0;
    scale_pic_size = 1.2; % 1 keeps original. < 1 makes it smaller. > 1 makes it bigger
    
    xDim_F = (200*scale_res(1))*scale_pic_size; % size of the squares (pixels)
    yDim_F = xDim_F;
    
    xDim_O = (180*scale_res(1))*scale_pic_size; % size of the oval (pixels)
    yDim_O = xDim_O;
    
    ML_r = 150;
    moveleft = -200;
    moveright = 200;
    
    LeftRect = [(screenRect(3)/2-xDim_F/2)+moveleft ((screenRect(4)/2-yDim_F/2)-above_fixation) (screenRect(3)/2+xDim_F/2)+moveleft ((screenRect(4)/2+yDim_F/2)-above_fixation)];
    RightRect = [(screenRect(3)/2-xDim_F/2)+moveright ((screenRect(4)/2-yDim_F/2)-above_fixation) (screenRect(3)/2+xDim_F/2)+moveright ((screenRect(4)/2+yDim_F/2)-above_fixation)];
    MiddleRect = [(screenRect(3)/2-xDim_F/2) (screenRect(4)/2-yDim_F/2)-above_fixation (screenRect(3)/2+xDim_F/2) (screenRect(4)/2+yDim_F/2)-above_fixation];

%% test buttons
    keep_going = 1;
    while keep_going
        
        Screen('TextSize', window, floor((35*scale_res(2))));
        longest_msg = '   Left/Up                         Right/Down'; %You''ll NOT see the outcome of after each trial.
        [normBoundsRect, ~] = Screen('TextBounds', window, longest_msg);
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, longest_msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-220, black);
        Screen('TextStyle', window, 0);
        
        Screen('FillRect', window, chosen_color, LeftRect);
        Screen('FillRect', window, chosen_color, RightRect);
        
        
        Screen('FrameRect',window, black, LeftRect,7);
        Screen('FrameRect',window, black, RightRect,7);
        Screen('Flip',window);
        
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, longest_msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-220, black);
        Screen('TextStyle', window, 0);
        Screen('FillRect', window, chosen_color, LeftRect);
        Screen('FillRect', window, chosen_color, RightRect);
        Screen('FrameRect',window,black,LeftRect,7);
        Screen('FrameRect',window,black,RightRect,7);
        press = 0;
        while ~press
            Choice_RT = 0;
            [~, ~, responsecode] = KbCheck; %Keyboard input
            if find(responsecode) == L_arrow %LEFT
                Screen('FrameRect',window,[0 0 255],LeftRect,7);
                press = 1;
                Screen('Flip', window);
            elseif find(responsecode) == R_arrow %RIGHT 
                Screen('FrameRect',window,[0 0 255],RightRect,7);
                press = 1;
                Screen('Flip', window);
            elseif find(responsecode) == U_arrow %UP 
                Screen('FrameRect',window,[0 0 255],LeftRect,7);
                press = 1;
                Screen('Flip', window);
            elseif find(responsecode) == D_arrow %DOWN
                Screen('FrameRect',window,[0 0 255],RightRect,7);
                press = 1;
                Screen('Flip', window);
            elseif find(responsecode) == esc_key
                press = 1;
                keep_going = 0;
            end
        end
        if press
            WaitSecs(.750);
        end
    end
    
    Screen('Flip', window);
    
    Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
    Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
    Screen('Flip', window);
    WaitSecs(.750);
    
    instruction_msg = sprintf('Task B: You are about to play the Guessing Game!');  

    Screen('TextSize', window, floor((30*scale_res(2))));
    Screen('TextFont', window, 'Helvetica');

    Screen('TextStyle', window, 0);

    %%%Setting the intro screen%%%
    Screen('TextSize', window, floor((20*scale_res(2))));
    longest_msg = instruction_msg;
    [normBoundsRect, notused] = Screen('TextBounds', window, longest_msg);
    Screen('TextStyle', window, 1);
    Screen('TextSize', window, floor((30*scale_res(2))));
    Screen('DrawText', window, instruction_msg, (centerhoriz-(normBoundsRect(3)/0.85)), (centervert-(350*scale_res(2))), black);
    Screen('TextSize', window, floor((20*scale_res(2))));
    Screen('DrawText', window, 'In each trial, you will be asked to pick between either TWO COMP or TWO SELF options.', (centerhoriz-(normBoundsRect(3)/0.85)), (centervert-(250*scale_res(2))), black);
    Screen('DrawText', window, 'The two options will DIFFER in their point values (0-20 points).', (centerhoriz-(normBoundsRect(3)/0.85)), centervert-200, black);
    Screen('TextStyle', window, 0);
    Screen('DrawText', window, 'To select the LEFT or RIGHT option, use the LEFT and RIGHT buttons.', (centerhoriz-(normBoundsRect(3)/0.85)), centervert-150, black);
    Screen('DrawText', window, 'Once you have made your choice, you will see a blue card with a question mark.', (centerhoriz-(normBoundsRect(3)/0.85)), centervert-100, black);
    Screen('DrawText', window, 'The card has a number with a value of 1 to 9, EXCLUDING 5.', (centerhoriz-(normBoundsRect(3)/0.85)), centervert-50, black);
    Screen('DrawText', window, 'The goal is to guess if the card is above (high) or below (low) the number 5.', (centerhoriz-(normBoundsRect(3)/0.85)), centervert, black);
    Screen('DrawText', window, 'On the trials that you are playing yourself (SELF), use the UP (high) and DOWN (low) buttons to make your choice.', (centerhoriz-(normBoundsRect(3)/0.85)), centervert+50, black);
    Screen('DrawText', window, 'On the trials that the computer is playing for you (COMP), press the LEFT button to advance.', (centerhoriz-(normBoundsRect(3)/0.85)), centervert+100, black);
    Screen('DrawText', window, 'Unlike the practice version, you will not be immediately given the outcome of each trial.', (centerhoriz-(normBoundsRect(3)/0.85)), centervert+150, black);
    Screen('DrawText', window, 'The points you earned will be added to your point bank that could translate into monetary bonus at the end of the experiment.', (centerhoriz-(normBoundsRect(3)/0.85)), centervert+200, black);
    Screen('DrawText', window, 'Press the SPACEBAR to start the task.', (centerhoriz-(normBoundsRect(3)/0.85)), centervert+250, black);

    Screen('Flip', window);

    slack = Screen('GetFlipInterval', window);

    %start sequence. Can be changed to receive a scanner pulse

    go = 1;
    while go
        [keyIsDown, notused, keyCode] = KbCheck; %Keyboard input
        keyCode = find(keyCode);
        if keyIsDown == 1
            if keyCode(1) == go_button
                go = 0;
            end
            if keyCode(1) == esc_key %esc to close
                Screen('CloseAll');
                ListenChar(0);
                return;
            end
        end
    end

    Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
    Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
    ready = Screen('Flip', window);

    %%%START TRIAL LOOP%%%

    %%%saving data info%%%
    outputname = fullfile(outputdir, [subjectnum '_TaskBRand_CCSS_1_1.mat']);

    startsecs = GetSecs;

    for k = trial_order(1,3):trial_order(end,3)
        abort = 0;
        lapse = 0;
        card_lapse = 0;
        isfixed = 0;
        ishigh = 0;
        
        %eventsecs = GetSecs; %start event clock for each trial

        if k == 1
            delayt = 2;
            WaitSecs(delayt);
        else
            delayt = 0;
        end

        ITI = ITI_ISI_list(k,1);
        ISI = ITI_ISI_list(k,2);

        if trial_order(k,1) == 1   %CC
            variedmag = trial_order(k,2);
            fixedmag = 10;
            type = 'COMP';
        else   %SS
            variedmag = trial_order(k,2);
            fixedmag = 10; 
            type = 'SELF ';     
        end
        
        if k == 1
            choicetracker = choicetracker_list(k);        %CC/SS, fixed mag, varied, mag, isfixed
        else 
            choicetracker(k,:) = [0,0,0,0];
        end

        Screen('FillRect', window, chosen_color, LeftRect);
        Screen('FrameRect',window, black, LeftRect, 7);
        Screen('TextSize', window, floor((30*scale_res(2)))); 

        msg1 = sprintf('%s=%dpts',type, variedmag);    %varied choice either SELF or COMP
        msg2 = sprintf('%s=%dpts',type, fixedmag);     %fixed choice 

        [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg1);
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, msg1, (centerhoriz-(normBoundsRect(3)*1.665)), centervert-(normBoundsRect(4)/2), black);
        Screen('TextStyle', window, 0);

        Screen('FillRect', window, chosen_color, RightRect);
        Screen('FrameRect',window, black, RightRect, 7);
        Screen('TextSize', window, floor((30*scale_res(2))));

        [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg2);
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, msg2, (centerhoriz+(normBoundsRect(3)/1.6)), centervert-(normBoundsRect(4)/2), black);
        Screen('TextStyle', window, 0);
        compself_onset = Screen('Flip', window);   %onset of COMP/SELF choice screen

         %%%MAKE COMP/SELF CHOICE%%%
        %Choice_RT_start = GetSecs; %start RT clock for comp/self choice
        press = 0;
        while ~press
            Choice_RT = 0;
            [~, ~, responsecode] = KbCheck; %Keyboard input
            if GetSecs - (compself_onset-slack) > responsewindow
                msg = 'Respond faster!';
                Screen('TextSize', window, floor((60*scale_res(2))));
                [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                Screen('TextStyle', window, 0);
                Screen('DrawText', window, msg, centerhoriz-normBoundsRect(3)/2, centervert-100, black);                
                Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                compself_offset = Screen('Flip', window, compself_onset+responsewindow-slack);
                while GetSecs - compself_offset < 8 %timing loop for lapse trials 10 seconds wait until next trial
                    [responded, responsetime, keyCode] = KbCheck; %Keyboard input
                    if find(keyCode) == esc_key %escape
                    abort = 1;
                    end
                end
                trial_endtime = GetSecs;                
                lapse = 1;
                press = 1;
                Choice_RT = 0;
                isfixed = NaN;
                ishigh = NaN;
                choicetracker(k,2) = fixedmag;       %CC/SS, fixed mag, varied, mag, isfixed
                choicetracker(k,1) = trial_order(k,1);
                choicetracker(k,3) = variedmag;
                choicetracker(k,4) = NaN;
                Choice_RT_onset = 0;
            else
                if find(responsecode) == L_arrow %Left varied  (old COMP)
                    Choice_RT = GetSecs - compself_onset;
                    Choice_RT_onset = GetSecs - startsecs;
                    Screen('FillRect', window, chosen_color, LeftRect);
                    Screen('FrameRect',window,white,LeftRect,7);
                    msg1 = sprintf('%s=%dpts',type, variedmag);    %varied choice either SELF or COMP
                    msg2 = sprintf('%s=%dpts',type, fixedmag);     %fixed choice 
                    Screen('FillRect', window, chosen_color, RightRect);
                    Screen('FrameRect',window, black, RightRect, 7);
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg1);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg1, (centerhoriz-(normBoundsRect(3)*1.665)), centervert-(normBoundsRect(4)/2), black);
                    Screen('TextStyle', window, 0);
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg2);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg2, (centerhoriz+(normBoundsRect(3)/1.6)), centervert-(normBoundsRect(4)/2), black);
                    Screen('TextStyle', window, 0);
                    Screen('Flip',window,compself_onset+Choice_RT-slack);  % now visible on screen after choice selection
                    Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                    Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                    compself_offset = Screen('Flip', window, compself_onset+Choice_RT-slack+1);     %after choice made compself screen should end after 1 second. 
                    while GetSecs - compself_offset < ISI %timing loop for Go/NoGo based on ISI
                        [responded, responsetime, keyCode] = KbCheck; %Keyboard input
                        if find(keyCode) == esc_key %escape
                        abort = 1;
                        end
                    end
                    press = 1; 
                    lapse = 0;
                    isfixed = 0;
                    choicetracker(k,2) = fixedmag;       %CC/SS, fixed mag, varied, mag, isfixed
                    choicetracker(k,1) = trial_order(k,1);
                    choicetracker(k,3) = variedmag;
                    choicetracker(k,4) = 0;
                elseif find(responsecode) == R_arrow %Right fixed (old SELF)
                    Choice_RT = GetSecs - compself_onset;
                    Choice_RT_onset = GetSecs - startsecs;                                                          
                    Screen('FillRect', window, chosen_color, RightRect);                    
                    Screen('FrameRect',window,white,RightRect,7);                    
                    msg1 = sprintf('%s=%dpts',type, variedmag);    %varied choice either SELF or COMP
                    msg2 = sprintf('%s=%dpts',type, fixedmag);     %fixed choice 
                    Screen('FillRect', window, chosen_color, LeftRect);
                    Screen('FrameRect',window, black, LeftRect, 7);
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg1);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg1, (centerhoriz-(normBoundsRect(3)*1.665)), centervert-(normBoundsRect(4)/2), black);
                    Screen('TextStyle', window, 0);
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg2);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg2, (centerhoriz+(normBoundsRect(3)/1.6)), centervert-(normBoundsRect(4)/2), black);
                    Screen('TextStyle', window, 0);
                    Screen('Flip',window,compself_onset+Choice_RT-slack);  % now visible on screen
                    Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                    Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                    compself_offset = Screen('Flip', window, compself_onset+Choice_RT-slack+1);     %after choice made compself screen should end after 1 second. 
                    while GetSecs - compself_offset < ISI %timing loop for Go/NoGo based on ISI
                        [responded, responsetime, keyCode] = KbCheck; %Keyboard input
                        if find(keyCode) == esc_key %escape
                        abort = 1;
                        end
                    end
                    press = 1;
                    lapse = 0; 
                    isfixed = 1;
                    choicetracker(k,2) = fixedmag;       %CC/SS, fixed mag, varied, mag, isfixed
                    choicetracker(k,1) = trial_order(k,1);
                    choicetracker(k,3) = variedmag;
                    choicetracker(k,4) = 1;
                elseif find(responsecode) == esc_key
                    abort = 1; 
                end   
            end
        end
        
%%SECOND screen with unknown card and introduce guessing game 

        if lapse == 1
            Card_RT = NaN;
            Card_RT_onset = NaN;
            guessing_phase_onset = NaN;
            guessing_offset = NaN;
        else
            cardeventsecs = GetSecs; %start event clock for card part of the trial

            Screen('FillRect', window, middle_card_color, MiddleRect);
            Screen('FrameRect',window,black,MiddleRect,7);
            Screen('TextSize', window, floor((60*scale_res(2))));
            msg = '?';
            [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
            Screen('TextStyle', window, 1);
            Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
            Screen('TextStyle', window, 0);
            guessing_phase_onset = Screen('Flip', window);

            %%%MAKE CARD GAME CHOICE%%%
            press = 0;
            while ~press
                Card_RT = 0;
                [~, ~, responsecode] = KbCheck; %Keyboard input 
                if GetSecs - (guessing_phase_onset-slack) > guess_responsewindow  %if time is more than responsewindow 
                    msg = 'Respond Faster!';
                    Screen('TextSize', window, floor((60*scale_res(2))));
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 0);
                    Screen('DrawText', window, msg, centerhoriz-normBoundsRect(3)/2, centervert-100, black);
                    Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                    Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                    guessing_offset = Screen('Flip', window, guessing_phase_onset+guess_responsewindow-slack);
                    card_lapse = 1;
                    Card_RT = 0;
                    Card_RT_onset = 0;
                    press = 1;
                    while GetSecs - guessing_offset < ITI %timing loop for Go/NoGo based on ISI
                        [responded, responsetime, keyCode] = KbCheck; %Keyboard input
                        if find(keyCode) == esc_key %escape
                        abort = 1;
                        end
                    end
                else
                    if trial_order(k,1) == 1   %COMP/COMP condition
                        if find(responsecode) == L_arrow   % picked comp in previous screen so can only press LEFT key to advance 
                            Card_RT = GetSecs - guessing_phase_onset;  
                            Card_RT_onset = GetSecs - startsecs;                              
                            press = 1;
                            Screen('FillRect', window, middle_card_color, MiddleRect);
                            Screen('FrameRect',window,white,MiddleRect,7);
                            msg = '?';
                            [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                            Screen('TextStyle', window, 1);
                            Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
                            Screen('TextStyle', window, 0);
                            Screen('Flip',window,guessing_phase_onset+Card_RT-slack);  % now visible on screen
                            Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                            Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                            guessing_offset = Screen('Flip', window, guessing_phase_onset+guess_responsewindow-slack);
                            card_lapse = 0;
                            %GoNoGo_offset = GetSecs;
                            while GetSecs - guessing_offset < ITI %timing loop for Go/NoGo based on ITI
                                [responded, responsetime, keyCode] = KbCheck; %Keyboard input
                                if find(keyCode) == esc_key %escape
                                abort = 1;
                                end
                            end
                        end
                    elseif trial_order(k,1) == 2   %SELF/SELF condition
                        if find(responsecode) == U_arrow % trial order = 2 so SS condition
                            Card_RT = GetSecs - guessing_phase_onset;  
                            Card_RT_onset = GetSecs - startsecs;                              
                            press = 1;
                            Screen('FillRect', window, middle_card_color, MiddleRect);                            
                            Screen('FrameRect',window,white,MiddleRect,7);                            
                            msg = '?';
                            [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                            Screen('TextStyle', window, 1);
                            Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
                            Screen('TextStyle', window, 0);
                            Screen('Flip',window,guessing_phase_onset+Card_RT-slack);  % now visible on screen
                            Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                            Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                            guessing_offset = Screen('Flip', window, guessing_phase_onset+guess_responsewindow-slack);
                            while GetSecs - guessing_offset < ITI %timing loop for Go/NoGo based on ITI
                                [responded, responsetime, keyCode] = KbCheck; %Keyboard input
                                if find(keyCode) == esc_key %escape
                                abort = 1;
                                end
                            end
                            ishigh = 1;
                            card_lapse = 0;                        
                        elseif find(responsecode) == D_arrow % SELF / DOWN
                            Card_RT = GetSecs - guessing_phase_onset;  
                            Card_RT_onset = GetSecs - startsecs;                            
                            press = 1;
                            Screen('FillRect', window, middle_card_color, MiddleRect);
                            Screen('FrameRect',window,white,MiddleRect,7);                            
                            msg = '?';
                            [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                            Screen('TextStyle', window, 1);
                            Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
                            Screen('TextStyle', window, 0);
                            Screen('Flip',window,guessing_phase_onset+Card_RT-slack);  % now visible on screen
                            Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                            Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                            guessing_offset = Screen('Flip', window, guessing_phase_onset+guess_responsewindow-slack);
                            while GetSecs - guessing_offset < ITI %timing loop for Go/NoGo based on ITI
                                [responded, responsetime, keyCode] = KbCheck; %Keyboard input
                                if find(keyCode) == esc_key %escape
                                abort = 1;
                                end
                            end
                            ishigh = 0;
                            card_lapse = 0;
                        elseif find(responsecode) == esc_key
                            abort = 1;
                        end
                    end
                end
            end
            WaitSecs(.50);
        trial_endtime = GetSecs;
        end
         
        %%%save data here%%%
        data(k).Choice_RT = Choice_RT;
        data(k).Choice_RT_onset = Choice_RT_onset;
        data(k).Card_RT = Card_RT;
        data(k).lapse = lapse;
        data(k).card_lapse = card_lapse;
        data(k).choicetracker = choicetracker;
        data(k).Card_RT_onset = Card_RT_onset;
        data(k).ishigh = ishigh;
        data(k).isfixed = isfixed;
        data(k).ITI = ITI;
        data(k).ISI = ISI;
        data(k).compselfonset = compself_onset;
        data(k).compselfoffset = compself_offset;
        data(k).guessing_phase_onset = guessing_phase_onset;    
        data(k).guessing_phase_offset = guessing_offset;
        data(k).trial_endtime = trial_endtime;

        if abort
            ListenChar(0);
            Screen('CloseAll');
            end_secs = GetSecs;
            run_time = end_secs - startsecs;
            save(outputname, 'data','run_time','startsecs' ,'ready','startsecs');
            return;
        end
    end
    WaitSecs(5); %wait 5 seconds at the end to let last feedback HRF return to baseline.

    end_secs = GetSecs;
    run_time = end_secs - startsecs;
    save(outputname, 'data','run_time','ready','startsecs')

    ListenChar(0);
    Screen('CloseAll');
        
catch ME
    disp(ME.message);
    ListenChar(0);
    Screen('CloseAll');
    keyboard
end
    
