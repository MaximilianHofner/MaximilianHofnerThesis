% This MATLAB script computes multiple parameters derived from TopScan
% output in .CSV files
% mis annotations are corrected based on user defined table entries in Excel Spreadsheets
% Interpolation or Replacement of table of TopScan data is carried out with
% multiple functions 
clearvars -except TraceLoomingtimes244
root= "%%%"%write your root path
[Allanimal,AllFilePaths]=Allanimaltables(root);
Allanimaltables_write=Allanimaltables
%% initialise variables
Allflightlatencies=table();
AllFlighttable=table();
AllStimcontroltable=table();
AllFreezetable=table();
AllNoStimcontroltable=table();
Allmaximumspeed=table();
Allmeanspeedtable=table();
LengthTrackAll=table();
AllDurationtrace=table();
%% iterate through all videos
for video= 1:3%3%numVideos% get all videos
    if video>=2
        video=video+1
    end
    video_name= sprintf("Video%d",video);
    NewAnnotationname=sprintf('NewAnnotation%d.xlsx',video);
    NewAnnotation=xlsread(NewAnnotationname);%change per video
    %% Initialise
    Durationtrace=table();
    LengthTrack=table();
    maximumspeed=table();
    meanspeedtable=table();
    flightlatencies=table();
    Stimcontroltable=table();
    NoStimcontroltable=table();
    Flighttable=table();
    Freezetable=table();
    AllSpeeds={};
    AllAllSpeeds={};
    Allorientations={};
    Allmotions={};
    AllAllorientations={};
    AllAllmotions={};
%%
    for i= 1:height(NewAnnotation)
        start_frame=round(NewAnnotation(i,1));
        end_frame=round(NewAnnotation(i,2));
        Mouse1=NewAnnotation(i,3);
        Mouse2=NewAnnotation(i,4);
        Fillmethod=NewAnnotation(i,5)
        % define names
        tablename='animal_table';
        animalname=video_name+tablename;
        %To overwrite
        animal_table_before_name=animalname+Mouse1
        %To write
        animaltable_replace_name=animalname+Mouse2;
        section='done'
        % Replacing mis annotation
        if Fillmethod==0
            animaltable_replace=Allanimal.(animaltable_replace_name);
            Allanimaltables_write=ReplaceSlice(Allanimaltables_write,animal_table_before_name,animaltable_replace,start_frame, end_frame)
            ReplacedSlice = SliceTraceReplace(animaltable_replace,start_frame, end_frame);
            [rowstart ~]=find((start_frame == animaltable_replace.FrameNum));
            [rowend ~]=find((end_frame == animaltable_replace.FrameNum));
            Allanimaltables_write.(animal_table_before_name)(rowstart:rowend,:)=ReplacedSlice
            else
                if Fillmethod==2
                    Allanimaltables_write=ReplaceSliceFill(Allanimaltables_write,animal_table_before_name,start_frame, end_frame)
                else
                    Allanimaltables_write=ReplaceSliceInterpolieren(Allanimaltables_write,animal_table_before_name,start_frame, end_frame)
                end
        end
    end
    %%
    LoomPerVideo=5;
    i=video;
    %j=5             %change
    fps = 30; 
    padding_sec=2.44%2.44%1%7%1%2.44
    padding_sec_before=-0.1%-0.1
    TraceLoomingtimes244=xlsread('TraceLoomingtimes2_44.xlsx');
    %% iterate through all trials
    for j=1:5%LoomPerVideo% get all looms in a video
        loom_name= sprintf('loom%d',j);
        loom_sec= TraceLoomingtimes244(i,j);
        start_frame = (loom_sec - 0) * fps;%padding_sec) * fps; 
        end_frame = (loom_sec + padding_sec) * fps;
        end_frame_before =(loom_sec + padding_sec_before) * fps;
        %% iterate through all mice 
        for k= 1:4 % get all 4 animal traces
            Tablename1=sprintf('Video%d',i);
            Tablename2=sprintf("animal_table%d",k);
            Tablename=Tablename1+Tablename2;
            Table=Allanimaltables_write.(Tablename);
            loom_table =SliceTrace(Table,start_frame, end_frame);
            heig=height(loom_table)
            [rowstart ~]=find((start_frame == loom_table.FrameNum));
            [rowend ~]=find((end_frame == loom_table.FrameNum));
            [x,y,lengths,distances,speeds,meanspeed,maxspeed,orientations,motions] = getTraceInfo2(loom_table,fps);
            loom_table_before=SliceTrace(Table,end_frame_before,start_frame);
            [Flight,Stimcontrol,Freeze,NoStimcontrol]=flight(loom_table,loom_table_before,maxspeed,speeds)
            hold on;
            Colours={'b','g','k','r'};
            [x,y,length,distances,speeds,meanspeed,maxspeed,orientations,motions, durationtrace] = getTraceInfo3(loom_table,x,y,fps)
            %% only plot flight and calculate value for every mouse at every trial 
            if Flight==1
                Loom=plot(x(:,1), -y(:,1),Colours{k},'LineWidth',2)
            end
            Durationtrace.(loom_name)(k,1)=durationtrace
            LengthTrack.(loom_name)(k,1)=lengths;
            maximumspeed.(loom_name)(k,1)=maxspeed;
            meanspeedtable.(loom_name)(k,1)=meanspeed
            flight_latency=flightlatency(loom_table,speeds,start_frame,fps);
            Flighttable.(loom_name)(k,1)=Flight
            flightlatencies.(loom_name)(k,1)=flight_latency;
            Freezetable.(loom_name)(k,1)=Freeze;
            Stimcontroltable.(loom_name)(k,1)=Stimcontrol;
            NoStimcontroltable.(loom_name)(k,1)=NoStimcontrol;
            speeds={speeds}
            orientations={orientations}
            motions={motions}
            AllSpeeds=[AllSpeeds,speeds]
            Allorientations=[Allorientations,orientations]
            Allmotions=[Allmotions,motions]
            distances=diff(x(:,1))
            swaps=find(abs(distances)>100)
            false_rows=loom_table.FrameNum(swaps,:)
        end
        AllAllSpeeds=[AllAllSpeeds,AllSpeeds];
        AllAllorientations=[AllAllorientations,Allorientations];
        AllAllmotions=[AllAllmotions,Allmotions];
    end
    %% draw arena and zones
    f = gcf;
    title('Traces of mice during the trials of a block')%graphics_name(1))
    filename=sprintf('Video_Matlab_correction%d',video)
    hold on;
    % define floor
    Floor= [172, 8; 491, 6 ;680, 16; 957, 42; 969, 177 ;968, 317 ;973, 454; 957, 607 ;704, 633; 439, 638; 167, 638 ;162, 307;172, 8];
    x_Floor=Floor(:,1);
    y_Floor=Floor(:,2);
    plot(x_Floor,-y_Floor)
    %Shelterzone
    Shelter_center=[226, 317];
    Shelter_radius=63.674598;
    th = linspace(0,2*pi) ;% create circle
    xc = Shelter_center(1)+Shelter_radius*cos(th) ;
    yc = Shelter_center(2)+Shelter_radius*sin(th) ;
    %Stimuluscenterbig
    plot(xc,-yc,'m');
    x_Stimuluscenterbig=[567 697 957 968 969 972 956 720 569 567];
    y_Stimuluscenterbig=-[10 16 43 172 345 465 606 631 634 10];
     plot(x_Stimuluscenterbig,y_Stimuluscenterbig)
    xlabel('TopScan x coordinate in mm');
    ylabel('TopScan y coordinate in mm');
    if video==3
        legend('Mouse 1','','Mouse 3','Mouse 4','Location','NorthEastOutside')
        else
        legend('Mouse 1','Mouse 2','Mouse 3','Mouse 4','Location','NorthEastOutside')
    end
    %% save file to folder
    Foldername="Alltraces"
    mkdir(pwd,Foldername)
    path=pwd +"\"+Foldername+"13082023"
    save Foldername LengthTrack
    saveas(f,[path+"\"+filename+'.png']);
    saveas(f,[path+"\"+filename]);
    close(f)
    %% Output variables of interest
    Allflightlatencies.(video_name)=flightlatencies
    AllDurationtrace.(video_name)=Durationtrace
    LengthTrackAll.(video_name)=LengthTrack
    AllFlighttable.(video_name)=Flighttable
    AllStimcontroltable.(video_name)=Stimcontroltable
    AllFreezetable.(video_name)=Freezetable
    AllNoStimcontroltable.(video_name)=NoStimcontroltable
    Allmaximumspeed.(video_name)=maximumspeed
    Allmeanspeedtable.(video_name)=meanspeedtable
end