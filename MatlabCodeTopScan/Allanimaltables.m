function [Allanimal,AllFilePaths]=Allanimaltables(root)
%Get all animal tables
for i= 1:3%3%numVideos% get all videos
    if i>=2
        i=i+1
    end
    video_name= sprintf("Video%d",i);
    root = '%%%'%write your root path
    file_name_video=sprintf('SORTRealignedVersion3Video%d',i)%%d',i);
        for k= 1:4 % get all 4 animal traces
                    file_name_animal = sprintf('_Trace_table1_Trace_AnimalID %d.csv',k);
                    file_name= file_name_video + "" + file_name_animal;
                    file_path = root + "\" + file_name;
                    animal_table = readtable(file_path);
                    animalname=video_name+sprintf('animal_table%d',k);
                    Allanimal.(animalname)=animal_table;
                    AllFilePaths.(animalname)=file_path;
        end
end
