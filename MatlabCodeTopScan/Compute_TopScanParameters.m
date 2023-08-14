%This script extracts sociial and nonsocial TopScan parameters stored in a
%MySQL Database
%Sign in to database
%load Mausevent und Info
%Run: Startup
%SQLconnect
%Duration_After_New
%Duration_Before_New
%connect to database
%MausInfo and and CSV file need to be in the current directory
%mandatory functions:   Duration_After_New
%                       Duration_Before_New
%run current file
loomingtimes=xlsread('LoomingzeitenMatlab2.xlsx');
MausEvent=readtable('MausEvent.xlsx');
MausInfo=readtable('MausInfo.xlsx');
% Initialisation and Variables
symmetry = 0 %0 1 oder3
path= cd;
video=3
videoname=sprintf('Video%d_',video);%!!!
timespan='10sBefore_And_AfterL_';%'AfterL_';
filetype= '.xlsx';
FolderName='%%%'%type your folder
mkdir(fullfile(pwd,FolderName));
Durationbeforeafter=10;
Durationloom=2.44
LoomPerVideo=5;
Big_table=table();
%%
Events=unique(MausEvent.EvShort(1:end,1), 'stable')%sorts alphabetically
for i=1:height(Events)
    All_Before=table('RowNames',{'Loom1','Loom2','Loom3','Loom4','Loom5'});
    All_After=table('RowNames',{'Loom1','Loom2','Loom3','Loom4','Loom5'});
    All_During=table('RowNames',{'Loom1','Loom2','Loom3','Loom4','Loom5'});
    name_event= Events(i,1)
    % Get DataAll from Server
    datasource="%%%";
    username= "%%%";
    password="%%%%";
    conn = mysql(datasource,username,password)
    dataAll = fetch(conn,[sprintf('SELECT * FROM L2Video3_fixed_full_trial1 WHERE L2Video3_fixed_full_trial1.EvShort = ''%s'' ',name_event)]); %!!!
    dataAll = sortrows(dataAll,'FromSecond','ascend');
    dataAll = sortrows(dataAll,'TrackNumber','ascend');
    close(conn)
    %find all tracks imported: here 1
    UniTrack=unique(dataAll.TrackNumber);
    dataTrack = find(dataAll.TrackNumber == UniTrack);%find rows with tracknumber
    dataTrack = dataAll(dataTrack,:);
    dataTrack = sortrows(dataTrack,'FromSecond','ascend');
    u = unique(dataTrack.Mouse1);
    u2 = unique(dataTrack.Mouse2);
    u3 = [u;u2];
    u = unique(u3);%find all mouse IDs in mouse 1 and 2
    u = u(u~=0);%check if one mouse is nan--> was not detected
    [NumMice ~] = size(u);%4 mice
    % iterate through all mice
    %what is symmetry
    for i= 1:3%After and Before
        %delta=deltas(1,i)
        for j = 1:NumMice
            mouse1_event = u(j);
            if symmetry == 0
                mouse1EvIndx = dataTrack.Mouse1 == mouse1_event;
                mouse1Ev = dataTrack(mouse1EvIndx,:);
            end
            for k= 1:LoomPerVideo %
                loom= loomingtimes(video,k)
                gender_mouse=MausInfo.sex(j);
                group_mouse=MausInfo.group(j);
                Track_Number=MausInfo.TrackNumber(j);
                RFID_tag=MausInfo.RFIDtag(j);
                ID_mouse=MausInfo.MouseID(j);
                % i indicates if a time span before, during or after the
                % looming event(trial) is computed Duration_Before_Overlap
                % and Duration_After_Overlap slice the tables to the
                % desired size
                if i==1%Before Loom
                    Deltaloom=loom-Durationbeforeafter
                    All_Before.EvShort_1_2_3_4(1,j)=name_event;
                    [x stdevent meanevent SEMevent Numevents] = Duration_Before_Overlap(loom, Deltaloom, mouse1Ev)
                    All_Before.BeforeDurationEvent_Mouse_1_2_3_4(k,j)=x;% x=sum
                    All_Before.Beforeydata_1_2_3_4(k,j)=Numevents;
                    All_Before.BeforeStd_Mouse_1_2_3_4(k,j)=stdevent;
                    All_Before.BeforeMean_Mouse_1_2_3_4(k,j)=meanevent;
                    All_Before.BeforeSEM_Mouse_1_2_3_4(k,j)=SEMevent;
                    All_Before.BeforeMouseID_1_2_3_4(k,j)=ID_mouse;
                    All_Before.BeforeGroup_1_2_3_4(k,j)=group_mouse;
                    All_Before.BeforeTrackNum_1_2_3_4(k,j)=Track_Number;
                    All_Before.BeforeRFID_1_2_3_4(k,j)=string(RFID_tag);
                    All_Before.BeforeGender_1_2_3_4(k,j)=gender_mouse;
                end
                if i==2%After Loom
                    loom=loom+Durationloom
                    Deltaloom=loom+Durationbeforeafter
                    [x stdevent meanevent SEMevent Numevents] = Duration_After_Overlap(loom, Deltaloom, mouse1Ev)
                    All_After.AfterEvShort_1_2_3_4(1,j)=name_event;
                    All_After.AfterDurationEvent_Mouse_1_2_3_4(k,j)=x;
                    All_After.AfterStd_Mouse(k,j)=stdevent;
                    All_After.AfterMean_Mouse_1_2_3_4(k,j)=meanevent;
                    All_After.AfterSEM_Mouse_1_2_3_4(k,j)=SEMevent;
                    All_After.Afterydata_1_2_3_4(k,j)=Numevents;
                    All_After.AfterMouseID_1_2_3_4(k,j)=ID_mouse;
                    All_After.AfterGroup_1_2_3_4(k,j)=group_mouse;
                    All_After.AfterTrackNum_1_2_3_4(k,j)=Track_Number;
                    All_After.AfterRFID_1_2_3_4(k,j)=string(RFID_tag);
                    All_After.AfterGender_1_2_3_4(k,j)=gender_mouse;
                end
                if i==3%After Loom
                    Deltaloom=loom+Durationloom
                    [x stdevent meanevent SEMevent Numevents] = Duration_After_Overlap(loom, Deltaloom, mouse1Ev)
                    All_During.DuringEvShort_1_2_3_4(1,j)=name_event;
                    All_During.DuringDurationEvent_Mouse_1_2_3_4(k,j)=x;
                    All_During.DuringStd_Mouse(k,j)=stdevent;
                    All_During.DuringMean_Mouse_1_2_3_4(k,j)=meanevent;
                    All_During.DuringSEM_Mouse_1_2_3_4(k,j)=SEMevent;
                    All_During.Duringydata_1_2_3_4(k,j)=Numevents;
                    All_During.DuringMouseID_1_2_3_4(k,j)=ID_mouse;
                    All_During.DuringGroup_1_2_3_4(k,j)=group_mouse;
                    All_During.DuringTrackNum_1_2_3_4(k,j)=Track_Number;
                    All_During.DuringRFID_1_2_3_4(k,j)=string(RFID_tag);
                    All_During.DuringGender_1_2_3_4(k,j)=gender_mouse;
                end
                if isempty(x) == 1; %remove Nans
                    x = 0;
                    No = 0;
                else
                    [No, ~] = size(x); % number of events
                end
            end
        end;
        DurationAll=[ All_Before All_After All_During];
    end
    name_event
    name_event=char(name_event);
    filename=string(strcat(name_event,{'_'},videoname,timespan,name_event,filetype));
    %write each Event
    writetable(DurationAll,fullfile(path,FolderName,filename{1}));
    Big_table.(string(name_event))=DurationAll;
    filename_all=strcat(videoname,timespan,filetype);%
    %write all Events
    writetable(DurationAll,fullfile(path,FolderName,filename_all),'WriteVariableNames',true,'WriteRowNames',true,'WriteMode','append')
    clear DurationAll mouse1Ev dataAll dataTrack
end
%% save in another form
Graphpad_table=table();
Dur_before=table();
Duration_after=table();
Duration_during=table();
ydata_before=table();
ydata_after=table();
ydata_during=table();
Before=table('RowNames',{'Maus1','Maus2','Maus3','Maus4'});
After=table('RowNames',{'Maus1','Maus2','Maus3','Maus4'});
During=table('RowNames',{'Maus1','Maus2','Maus3','Maus4'});
Duration=table();
event_col=table();
Duration_vertical_after=table();
Duration_vertical_before=table();
Duration_vertical_during=table();
for i=1:height(Events);
    name_event= Events(i,1);
    if isempty(Big_table.(string(name_event)))==1
        continue
    end
    if height(Big_table.(string(name_event)).BeforeDurationEvent_Mouse_1_2_3_4')<4
        continue
    end
    event_col= table([name_event;name_event;name_event;name_event],'VariableNames',{'Event'});
    Before.Duration_before=Big_table.(string(name_event)).BeforeDurationEvent_Mouse_1_2_3_4';
    After.Duration_after=Big_table.(string(name_event)).AfterDurationEvent_Mouse_1_2_3_4';
    During.Duration_during=Big_table.(string(name_event)).DuringDurationEvent_Mouse_1_2_3_4';
    Before.ydata_before=Big_table.(string(name_event)).Beforeydata_1_2_3_4';
    After.ydata_after=Big_table.(string(name_event)).Afterydata_1_2_3_4';
    During.ydata_during=Big_table.(string(name_event)).Duringydata_1_2_3_4';
    Duration=[event_col Before After During];
    filename_all=strcat('GraphPad',videoname,timespan,filetype)
    Graphpad_table.(string(name_event))=Duration;
    %write all Events only Duration and ydata
    writetable(Duration,fullfile(path,FolderName,filename_all),'WriteVariableNames',true,'WriteRowNames',true,'WriteMode','append')
    Duration_vertical_col=table();
    Duration_vertical_a=[];
    Duration_vertical_b=[];
    Duration_vertical_d=[];
    for k=1:5
        Duration_vertical_col_a=Graphpad_table.(string(name_event)).Duration_after(:,k);
        Duration_vertical_col_b=Graphpad_table.(string(name_event)).Duration_before(:,k);
        Duration_vertical_col_d=Graphpad_table.(string(name_event)).Duration_during(:,k);
        Duration_vertical_a=[Duration_vertical_a;Duration_vertical_col_a];
        Duration_vertical_b=[Duration_vertical_b;Duration_vertical_col_b];
        Duration_vertical_d=[Duration_vertical_d;Duration_vertical_col_d];
    end
    Duration_vertical_after.(string(name_event))= Duration_vertical_a;
    Duration_vertical_before.(string(name_event))= Duration_vertical_b;
    Duration_vertical_during.(string(name_event))= Duration_vertical_d;
end
save (FolderName)


