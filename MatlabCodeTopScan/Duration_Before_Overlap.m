function  [x stdevent meanevent SEMevent Numevents] = Duration_Before_Overlap(loom, Deltaloom, mouse1Ev)
%% ToSeconds in time span Before
    Indices_From_border = find(mouse1Ev.ToSecond >= Deltaloom & mouse1Ev.ToSecond <= loom);%find all ToSeconds within Section-->Lower border
    Indices_To_border = find(mouse1Ev.FromSecond >= Deltaloom & mouse1Ev.FromSecond <= loom);%find all FromSeconds within Section-->Upper border
    % get indices
    Indices_within_border = intersect(Indices_From_border,Indices_To_border);% find all indices within border
    Index_lower_border = find(mouse1Ev.ToSecond >= Deltaloom & mouse1Ev.ToSecond <= loom & mouse1Ev.FromSecond < Deltaloom);% find index at lower border
    Index_upper_border = find(mouse1Ev.FromSecond >= Deltaloom & mouse1Ev.FromSecond <= loom & mouse1Ev.ToSecond > loom);% find index at upper border
    % get values
    Timebins_within_border= mouse1Ev.Length(Indices_within_border);% get values from dataTrack
    Timebin_lower_border= mouse1Ev.ToSecond(Index_lower_border);% get values from mouse1Ev
    Timebin_upper_border = mouse1Ev.FromSecond(Index_upper_border);
    % get durations
    Duration_lower_border = abs(Timebin_lower_border-Deltaloom);
    %caution Deltaloom and loom can be easily swapped in the code at this place
    if height(Index_lower_border)>1
        OverlapTable = mouse1Ev(Index_lower_border,:)
        Timebin_lower_border= max(OverlapTable.ToSecond)
        Duration_lower_border = abs(Timebin_lower_border-Deltaloom);
    end    
    if isempty(Duration_lower_border)==1
        Duration_lower_border=0;
    end
        Duration_upper_border = abs(Timebin_upper_border-loom);
   if height(Index_upper_border)>1
        OverlapTable = mouse1Ev(Index_upper_border,:)
        Timebin_upper_border= max(OverlapTable.FromSecond)
        Duration_upper_border = abs(Timebin_upper_border-loom);
    end  
    if isempty(Duration_upper_border)==1
        Duration_upper_border=0;
    end
    Indices_across_border = find(mouse1Ev.FromSecond < Deltaloom & mouse1Ev.ToSecond > loom);   
    Timebin_across_border = 0; %default    
    if isempty(Indices_across_border)==0 %if acrossborder exists-->whole duration
        Timebin_across_border = loom-Deltaloom;
    end
    adddurations=[Duration_lower_border Duration_upper_border Timebin_across_border];
    Indexadddurations=find(adddurations);
    Total_Durations=[Timebins_within_border;adddurations(Indexadddurations)'];
    if isempty(Indices_across_border)==0
        Total_Durations= Timebin_across_border
    end
    meanevent=mean(Total_Durations);
    Numevents=height(Total_Durations);
    stdevent=std(Total_Durations);
    SEMevent=stdevent/sqrt(Numevents);
    x= sum(Total_Durations);
end