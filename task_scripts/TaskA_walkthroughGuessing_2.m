function TaskA_walkthroughGuessing_2(subjectnum)

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
notchosen_color = gray;
chosen_color = [255 153 51]; 

%% TRIAL INFO
ntrials = 20; %

%General timing (in seconds):
%Decision phase (max, leftover goes to ISI): no limit
%ISI (weighted avg):	1.5
%outcome (fixed):	1
%ITI (weighted avg):	2
%Total trial length: 4.5 + decision phase

ITI_list = repmat(1.0,1,20);
ITI_list = Shuffle(ITI_list)+1;
ISI_list = repmat(0.5,1,20);
ISI_list = Shuffle(ISI_list)+1;

%responsewindow = 2.5; have to respond in each trial to advance
outcomedur = 1;

compoutcomes = [repmat(1,1,5) repmat(2,1,5)];   %1 = gain; 2 = loss
compoutcomes = Shuffle(compoutcomes);
selfoutcomes = [repmat(3,1,5) repmat(4,1,5)];   %3 = gain; 4 = loss
selfoutcomes = Shuffle(selfoutcomes);
trial_order = [repmat(1,1,10) repmat(2,1,10); compoutcomes selfoutcomes];   % 1 = choose comp; 2 = choose self;
trial_order = trial_order(:,randperm(20));


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

%%     %%%Make outputdir if it does not already exist%%%
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
    MiddleRect_little = [(screenRect(3)/2-ML_r/2) (screenRect(4)/2-ML_r/2) (screenRect(3)/2+ML_r/2) (screenRect(4)/2+ML_r/2)];

%% test buttons
    keep_going = 1;
    while keep_going
        
        Screen('TextSize', window, floor((40*scale_res(2))));
        longest_msg = '    Left/Up                     Right/Down'; %You''ll see the outcome of one decision at the end of the task.
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
    
    Screen('TextSize', window, floor((30*scale_res(2))));
    Screen('TextStyle', window, 1);
    Screen('DrawText', window, 'Task A: You are about to practice the Guessing Game!', (centerhoriz-(normBoundsRect(3)/1.2)), (centervert-(240*scale_res(2))), black);
    Screen('TextStyle', window, 0);

     %%%Setting the intro screen%%%
    Screen('TextFont', window, 'Helvetica');
    Screen('TextSize', window, floor((20*scale_res(2))));
    longest_msg = 'On each trial, you will be directed to pick whether the computer (COMP) or yourself (SELF) will be playing the game.';
    [normBoundsRect, notused] = Screen('TextBounds', window, longest_msg);

    Screen('DrawText', window, longest_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(180*scale_res(2))), black);
    Screen('DrawText', window, 'The directed choice is highlighted. To select COMP or SELF, use the LEFT and RIGHT buttons.', (centerhoriz-(normBoundsRect(3)/2)), centervert-150, black);
    Screen('DrawText', window, 'Once you have made your choice, you will see a blue card with a question mark.', (centerhoriz-(normBoundsRect(3)/2)), centervert-120, black);
    Screen('TextStyle', window, 1);
    Screen('DrawText', window, 'The card has a number with a value of 1 to 9, EXCLUDING 5.', (centerhoriz-(normBoundsRect(3)/2)), centervert-90, black);
    Screen('DrawText', window, 'The goal is to guess if the card is above (high) or below (low) the number 5.', (centerhoriz-(normBoundsRect(3)/2)), centervert-60, black);
    Screen('TextStyle', window, 0);
    Screen('DrawText', window, 'On the trials that you are playing yourself (SELF), use the UP (high) and DOWN (low) buttons to make your choice.', (centerhoriz-(normBoundsRect(3)/2)), centervert-30, black);
    Screen('DrawText', window, 'On the trials that the computer is playing for you (COMP), press the LEFT button to advance.', (centerhoriz-(normBoundsRect(3)/2)), centervert, black);
    Screen('DrawText', window, 'If the correct guess was made, you gain TEN points. (GREEN)', (centerhoriz-(normBoundsRect(3)/2)), centervert+30, [0 200 0]);
    Screen('DrawText', window, 'But if the wrong guess was made, you gain NO point. (RED)', (centerhoriz-(normBoundsRect(3)/2)), centervert+60, [200 0 0]);
    Screen('DrawText', window, 'There are 20 trials in total, 10 for COMP and 10 for SELF that are randomly presented.', (centerhoriz-(normBoundsRect(3)/2)), centervert+90, black);
    Screen('DrawText', window, 'Press the SPACEBAR to start the task.', (centerhoriz-(normBoundsRect(3)/2)), centervert+150, black);

    Screen('Flip', window);
        
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
    Screen('Flip', window);

     %%%START TRIAL LOOP%%%

     %%%saving data info%%%
    outputname = fullfile(outputdir, [subjectnum '_TaskA_walkthroughGuessing_2.mat']);
    
    startsecs = GetSecs;      %start time for each run
    for k = 1:ntrials
        abort = 0;
        %lapse = 0;
        iscomp = 0;
        ishigh = 0;
        feedback_onset = 0;
        cardvalue = 0;

        eventsecs = GetSecs; %start event clock for each trial
        if k == 1
            delayt = 2;
            WaitSecs(delayt);
        else
            delayt = 0;
        end

        ITI = ITI_list(k);
        ISI = ISI_list(k);
 
        %%FIRST screen with comp and self choices; COUNTERBALANCE ACROSS SUBJECTS 
        if trial_order(1,k) == 1
            Screen('FillRect', window, chosen_color, RightRect);
            Screen('FrameRect',window, black, RightRect, 7);
            Screen('TextSize', window, floor((40*scale_res(2))));
            msg = 'COMP';
            [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
            Screen('TextStyle', window, 1);
            Screen('DrawText', window, msg, (centerhoriz+(normBoundsRect(3)/1.2)), centervert-220, black);
            Screen('TextStyle', window, 0);

            Screen('FillRect', window, notchosen_color, LeftRect);
            Screen('FrameRect',window, black, LeftRect, 7);
            Screen('TextSize', window, floor((40*scale_res(2))));
            msg = 'SELF';
            [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
            Screen('TextStyle', window, 1);
            Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)*2)), centervert-220, black);
            Screen('TextStyle', window, 0);
        else 
            Screen('FillRect', window, notchosen_color, RightRect);
            Screen('FrameRect',window, black, RightRect, 7);
            Screen('TextSize', window, floor((40*scale_res(2))));
            msg = 'COMP';
            [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
            Screen('TextStyle', window, 1);
            Screen('DrawText', window, msg, (centerhoriz+(normBoundsRect(3)/1.2)), centervert-220, black);
            Screen('TextStyle', window, 0);
            
            Screen('FillRect', window, chosen_color, LeftRect);
            Screen('FrameRect',window, black, LeftRect, 7);
            Screen('TextSize', window, floor((40*scale_res(2))));
            msg = 'SELF';
            [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
            Screen('TextStyle', window, 1);
            Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)*2)), centervert-220, black);
            Screen('TextStyle', window, 0);
        end
        Screen('Flip', window);
        compself_onset = GetSecs - startsecs;

        if trial_order(1,k) == 1  %COMP
            Screen('FillRect', window, chosen_color, RightRect);
            Screen('FrameRect',window, black, RightRect, 7);
            Screen('TextSize', window, floor((40*scale_res(2))));
            msg = 'COMP';
            [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
            Screen('TextStyle', window, 1);
            Screen('DrawText', window, msg, (centerhoriz+(normBoundsRect(3)/1.2)), centervert-220, black);
            Screen('TextStyle', window, 0);

            Screen('FillRect', window, notchosen_color, LeftRect);
            Screen('FrameRect',window, black, LeftRect, 7);
            Screen('TextSize', window, floor((40*scale_res(2))));
            msg = 'SELF';
            [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
            Screen('TextStyle', window, 1);
            Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)*2)), centervert-220, black);
            Screen('TextStyle', window, 0);
        else    %SELF
            Screen('FillRect', window, notchosen_color, RightRect);
            Screen('FrameRect',window, black, RightRect, 7);
            Screen('TextSize', window, floor((40*scale_res(2))));
            msg = 'COMP';
            [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
            Screen('TextStyle', window, 1);
            Screen('DrawText', window, msg, (centerhoriz+(normBoundsRect(3)/1.2)), centervert-220, black);
            Screen('TextStyle', window, 0);
            
            Screen('FillRect', window, chosen_color, LeftRect);
            Screen('FrameRect',window, black, LeftRect, 7);
            Screen('TextSize', window, floor((40*scale_res(2))));
            msg = 'SELF';
            [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
            Screen('TextStyle', window, 1);
            Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)*2)), centervert-220, black);
            Screen('TextStyle', window, 0);
        end
        
         %%%MAKE COMP/SELF CHOICE%%%
        Choice_RT_start = GetSecs; %start RT clock
        press = 0;
        while ~press
            Choice_RT = 0;
            [~, ~, responsecode] = KbCheck; %Keyboard input
            
            if trial_order(1,k) == 1 
                if find(responsecode) == R_arrow %Right COMP
                    Screen('FrameRect',window,white,RightRect,7);
                    Choice_RT = GetSecs - Choice_RT_start;
                    press = 1; 
                    msg = 'COMP';
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg, (centerhoriz+(normBoundsRect(3)/1.2)), centervert-220, black);
                    Screen('TextStyle', window, 0);
                    msg = 'SELF';
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)*2)), centervert-220, black);
                    Screen('TextStyle', window, 0);
                    Screen('Flip', window); 
                    Choice_RT_onset = GetSecs - startsecs;
                    iscomp = 1;
                else
                    Screen('FillRect', window, chosen_color, RightRect);
                    Screen('FrameRect',window, black, RightRect, 7);
                    Screen('TextSize', window, floor((40*scale_res(2))));
                    msg = 'COMP';
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg, (centerhoriz+(normBoundsRect(3)/1.2)), centervert-220, black);
                    Screen('TextStyle', window, 0);
                    Screen('FillRect', window, notchosen_color, LeftRect);
                    Screen('FrameRect',window, black, LeftRect, 7);
                    Screen('TextSize', window, floor((40*scale_res(2))));
                    msg = 'SELF';
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)*2)), centervert-220, black);
                    Screen('TextStyle', window, 0);
                end
            elseif trial_order(1,k) == 2 
                if find(responsecode) == L_arrow %Left SELF
                    Screen('FrameRect',window,white,LeftRect,7);
                    Choice_RT = GetSecs - Choice_RT_start;
                    press = 1;
                    msg = 'COMP';
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg, (centerhoriz+(normBoundsRect(3)/1.2)), centervert-220, black);
                    Screen('TextStyle', window, 0);
                    msg = 'SELF';
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)*2)), centervert-220, black);
                    Screen('TextStyle', window, 0);
                    Screen('Flip', window);
                    Choice_RT_onset = GetSecs - startsecs;
                    iscomp = 0;
                else
                    Screen('FillRect', window, notchosen_color, RightRect);
                    Screen('FrameRect',window, black, RightRect, 7);
                    Screen('TextSize', window, floor((40*scale_res(2))));
                    msg = 'COMP';
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg, (centerhoriz+(normBoundsRect(3)/1.2)), centervert-220, black);
                    Screen('TextStyle', window, 0);
                    Screen('FillRect', window, chosen_color, LeftRect);
                    Screen('FrameRect',window, black, LeftRect, 7);
                    Screen('TextSize', window, floor((40*scale_res(2))));
                    msg = 'SELF';
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)*2)), centervert-220, black);
                    Screen('TextStyle', window, 0);
                end
            elseif find(responsecode) == esc_key
                abort = 1;
            end
        end
        WaitSecs(.750);


        Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
        Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
        Screen('Flip', window);
        WaitSecs(ISI);
        [responded, responsetime, keyCode] = KbCheck; %Keyboard input
        if find(keyCode) == esc_key %escape
            abort = 1;
        end

        
%%SECOND screen with unknown card and introduce guessing game 
        
        %startcardsecs = GetSecs;
        
        cardeventsecs = GetSecs; %start event clock for card part of the trial
        
        %Screen('DrawTexture', windowPointer, texturePointer [,sourceRect] [,destinationRect] [,rotationAngle] [, filterMode] [, globalAlpha] [, modulateColor] [, textureShader] [, specialFlags] [, auxParameters]);
        %Screen('FillRect', windowPtr [,color] [,rect] )
        Screen('FillRect', window, middle_card_color, MiddleRect);
        Screen('FrameRect',window,black,MiddleRect,7);
        Screen('TextSize', window, floor((60*scale_res(2))));
        msg = '?';
        [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
        Screen('TextStyle', window, 0);
        Screen('Flip', window);
        decisionphase_onset = GetSecs - startsecs; 

        msg = '?';
        [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
        Screen('TextStyle', window, 0);
        Screen('FillRect', window, middle_card_color, MiddleRect);
        Screen('FrameRect',window,black,MiddleRect,7);

        
        %%%MAKE CARD GAME CHOICE%%%
        Card_RT_start = GetSecs; %start RT clock
        press = 0;
        while ~press
            Card_RT = 0;
            [~, ~, responsecode] = KbCheck; %Keyboard input
            if trial_order(1,k) == 2 
                if find(responsecode) == U_arrow %SELF / HIGH
                    Screen('FrameRect',window,white,MiddleRect,7);
                    Card_RT = GetSecs - Card_RT_start;
                    press = 1;
                    msg = '?';
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
                    Screen('TextStyle', window, 0);
                    Screen('Flip', window);
                    Card_RT_onset = GetSecs - startsecs;
                    ishigh = 1;
                elseif find(responsecode) == D_arrow %SELF / LOW
                    Screen('FrameRect',window,white,MiddleRect,7);
                    Card_RT = GetSecs - Card_RT_start;
                    press = 1;
                    msg = '?';
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
                    Screen('TextStyle', window, 0);
                    Card_RT_onset = GetSecs - startsecs;
                    Screen('Flip', window);
                    ishigh = 0;
                else
                    Screen('FillRect', window, middle_card_color, MiddleRect);
                    Screen('FrameRect',window,black,MiddleRect,7);
                    Screen('TextSize', window, floor((60*scale_res(2))));
                    msg = '?';
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
                    Screen('TextStyle', window, 0);
                end
            elseif trial_order(1,k) == 1 
                if find(responsecode) == L_arrow %COMP / advance with LEFT button 
                    Screen('FrameRect',window,white,MiddleRect,7);
                    Card_RT = GetSecs - Card_RT_start;
                    press = 1;
                    msg = '?';
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
                    Screen('TextStyle', window, 0);
                    Card_RT_onset = GetSecs - startsecs;
                    Screen('Flip', window);
                else
                    Screen('FillRect', window, middle_card_color, MiddleRect);
                    Screen('FrameRect',window,black,MiddleRect,7);
                    Screen('TextSize', window, floor((60*scale_res(2))));
                    msg = '?';
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
                    Screen('TextStyle', window, 0);
                end
            elseif find(responsecode) == esc_key
                abort = 1;
            end
        end
        WaitSecs(.50);

        Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
        Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
        Screen('Flip', window);
        WaitSecs(ISI) %timing loop
        [responded, responsetime, keyCode] = KbCheck; %Keyboard input
        if find(keyCode) == esc_key %escape
            abort = 1;
        end
        
        if trial_order(2,k) == 1 || trial_order(2,k) == 3 %gain
            if ishigh 
                cardvalue = 5+ceil(rand*4);
            else
                cardvalue = ceil(rand*4);
            end
            o_color = [0 200 0];
        elseif trial_order(2,k) == 2 || trial_order(2,k) == 4 %loss
            if ishigh
                cardvalue = ceil(rand*4);
            else
                cardvalue = 5+ceil(rand*4);
            end
            o_color = [200 0 0];
        end
        Screen('FillRect', window, o_color, MiddleRect_little);
        Screen('FrameRect',window,black,MiddleRect_little,5);
        msg = num2str(cardvalue);
        Screen('TextSize', window, 50);
        [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
        Screen('TextStyle', window, 0);
        Screen('Flip', window);
        feedback_onset = GetSecs - startsecs;
        
        WaitSecs(outcomedur);        

        %%%save data here%%%
        data(k).Choice_RT = Choice_RT;
        data(k).Choice_RT_onset = Choice_RT_onset;
        data(k).Card_RT = Card_RT;
        data(k).Card_RT_onset = Card_RT_onset;
        data(k).iscomp = iscomp;
        data(k).ishigh = ishigh;
        data(k).ITI = ITI;
        data(k).ISI = ISI;
        data(k).compselfonset = compself_onset;
        data(k).decisionphase_onset = decisionphase_onset;
        data(k).feedback_onset = feedback_onset;
        data(k).trial_order_outcome = trial_order(2,k);
        data(k).trial_order_compself = trial_order(1,k);
        data(k).cardvalue = cardvalue;

        %%%ITI PERIOD: DRAW FIXATION CROSS%%%
        Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
        Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
        Screen('Flip', window);
        while GetSecs - (eventsecs+delayt+ISI+outcomedur) < ITI %timing loop
            [keyIsDown, secs, keyCode] = KbCheck; %Keyboard input
            if find(keyCode) == esc_key %escape
                abort = 1;
            end
        end

        if abort
            ListenChar(0);
            Screen('CloseAll');
            end_secs = GetSecs;
            run_time = end_secs - startsecs;
            save(outputname, 'data','run_time');
            return;
        end
    end
    %WaitSecs(5); %wait 5 seconds at the end to let last feedback HRF return to baseline.
    WaitSecs(1); %Behavioral
    
    end_secs = GetSecs;
    run_time = end_secs - startsecs;
    save(outputname, 'data','run_time');

    ListenChar(0);
    Screen('CloseAll');
    
catch ME
    disp(ME.message);
    ListenChar(0);
    Screen('CloseAll');
    keyboard
end

