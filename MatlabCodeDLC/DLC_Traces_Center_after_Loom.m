%This script computes perameters derived from DLC and creates
%visualizations for events during a trial
% Center after Loom
LengthTrack=table();
maximumspeed=table();
meanspeedtable=table();
Allmaximumspeed=table();
Allmeanspeedtable=table();
LengthTrackAll=table();
fps=30
for video= 1:3%3%numVideos% get all videos
    if video>=2
        video=video+1
    end
    video_name=sprintf("Video%d",video)
    root = "C:\Code25072023\DeepLabCut\"+video_name;
    for i=1:5
        loom_name= sprintf('loom%d',i);
        file_name = sprintf('loom%dDLC_dlcrnetms5_SLEAP_testMay4shuffle1_200000_el.csv',i);
        file_path = root + "\" + file_name;
        safe_path = 'C:\Code25072023\DeepLabCut\Video4'
        animal_table = readtable(file_path);
        loom_table = animal_table(1:end, :);
        loomarray=table2array(loom_table);
        loomarray=loomarray(600:673,:);%slice only trace after the loom at 20s%673
        loomarray(isnan(loomarray))=0;
        counter=0
        for j=11:27:92 %2:3:109
            counter=counter+1
            loom_array_first=loomarray(:,j:j+1);
            rows=find(loomarray(:,j+2));
            ArrayNoNans=loom_array_first(rows,:);
            x=ArrayNoNans(:,1);
            y=ArrayNoNans(:,2);
            [x,y]=findcertaintrace(x,y)
            distances=sqrt(diff(x(:,1)).^2 + diff(y(:,1)).^2);%from point to point%height-1
            indswap=find(distances>30)
            distances(indswap)=[]
            distances=distances(~isnan(distances))
            lengths = sum(distances)
            speeds=(distances/10)*fps;% in m/s%height-1
            meanspeed= mean(speeds);
            maxspeed=max(speeds);
            LengthTrack.(loom_name)(counter,1)=lengths;
            if isempty(maxspeed)==true
                maxspeed=-1
            end
            maximumspeed.(loom_name)(counter,1)=maxspeed;
            meanspeedtable.(loom_name)(counter,1)=meanspeed

            %%
            hold on
            plot(x,-y)
            title('DLC traces of mice during the trials of a block')
            xlabel('x coordinate in mm')
            ylabel('y coordinate in mm')
            axis([50 800 -550 -0])%550
            rectangle('Position',[110 -450 610 450])
            C = [160 230] ;  % center
            R = 40;  % Radius if cricle
            th = linspace(0,2*pi) ;
            % Circle
            xc = C(1)+R*cos(th) ;
            yc = C(2)+R*sin(th) ;
            % plot
            plot(xc,-yc,'r')
        end
        axis([100 800 -500 50])
        legend('Mouse1','Mouse2','Mouse3','Mouse4','Shelter','Arena','Location','NorthEastOutside')
        graphics_name= video_name+".JPEG"%sprintf('loom%d.JPEG',i)
        f = gcf;
        exportgraphics(f,graphics_name)
    end
    close(f)
    Allmaximumspeed.(video_name)=maximumspeed
    Allmeanspeedtable.(video_name)=meanspeedtable
    LengthTrackAll.(video_name)=LengthTrack
end