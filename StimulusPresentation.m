sca;
close all;
clearvars;

%% -----PARAMETERS------%
min_radius_deg = 1;  % diameter 2
max_radius_deg = 10;  % diameter 20
screen_distance_cm = 70;
screen_height_cm = 30;

time_to_expand_sec = 0.25;
time_between_looms_sec = 0.25;

%% -----DERIVED------%
%radius_cm = atan(deg2rad(radius_deg))*screen_distance_cm
min_radius_cm = tan(deg2rad(min_radius_deg)) * screen_distance_cm;
max_radius_cm = tan(deg2rad(max_radius_deg)) * screen_distance_cm;
start = tic;
event_array = {};
% Define colors
white = GrayIndex(0);
black = BlackIndex(0);
% Open a window and set the background to white
Screen('Preference', 'SkipSyncTests', 1);
screenNumber = max(Screen('Screens'));
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('FillRect', window, white);
Screen('Flip', window);
WaitSecs(3);
px_per_cm_ratio = windowRect(4) / screen_height_cm;
min_radius_px = min_radius_cm * px_per_cm_ratio;
max_radius_px = max_radius_cm * px_per_cm_ratio;
expansion_speed_px_per_sec = (max_radius_px - min_radius_px) / time_to_expand_sec;
%radius_at_sec_x = expansion_speed_px_per_sec * x + min_radius_px
circle_center = windowRect(3:4) / 2;
KbWait([], 2);
event_array(height(event_array)+1, :) = {"sync_event" toc(start)};
for i=1:5% modify number of looms
    KbWait([], 2);
    event_array(height(event_array)+1, :) = {"press"+num2str(i) toc(start)};
    for j=1:5% modify expandings
        % Get the start time
        startTime = GetSecs;
        endTime = startTime + time_to_expand_sec;
        timeElapsed = 0;
        event_array(height(event_array)+1, :) = {"start_loom"+num2str(i)+"."+num2str(j) toc(start)};
        %Draw an expanding black circle until it reaches the upper and lower screen borders
        while (startTime + timeElapsed) < endTime
            % Calculate the current circle radius
            timeElapsed = GetSecs - startTime;
            circleRadius = expansion_speed_px_per_sec * timeElapsed + min_radius_px; % initial size in px
            % Draw the circle
            Screen('FillOval', window, black, [circle_center(1)-circleRadius, circle_center(2)-circleRadius, circle_center(1)+circleRadius, circle_center(2)+circleRadius]);
            %Flip the window to display the drawn elements
            Screen('Flip', window);
        end
        event_array(height(event_array)+1, :) = {"end_loom"+num2str(i)+"."+num2str(j) toc(start)};
        Screen('FillRect', window, white);
        Screen('Flip', window);
        WaitSecs(time_between_looms_sec);
    end
end
KbWait([], 2);
%Clear the screen and end the program
sca;
%Write to current directory
event_table = array2table(event_array, "VariableNames", ["Event" "Timestamp"]);
writetable(event_table, "event_table_" + datestr(datetime, "YYYYmmDD_hhMMss") + ".csv");