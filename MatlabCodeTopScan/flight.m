function [Flight,Stimcontrol,Freeze,NoStimcontrol]=flight(loom_table,loom_table_before,maxspeed,speeds)

Shelter_cells=(163<loom_table.CenterX_mm_(:,1)&loom_table.CenterX_mm_(:,1)<289)&(289<loom_table.CenterY_mm_(:,1)&loom_table.CenterY_mm_(:,1)<380)
if sum(Shelter_cells)==0
    shelteryesno=0
else
    shelteryesno=1
end
% Shelter_cells=strfind(loom_table.Center_Areas,';Shelter;');
%     Idx_Shelter_cells= find(~cellfun(@isempty,Shelter_cells));
%     shelteryesno=isempty(Idx_Shelter_cells)
%     shelter_index_height=height(Idx_Shelter_cells)
%     if shelter_index_height>=3
%         shelteryesno=1
%     else
%         shelteryesno=0
%     end
Stimulusbig_cells=loom_table_before.CenterX_mm_(:,1)>567

% Stimulusbig_cells=strfind(loom_table_before.Center_Areas,'Stimuluszonebig');
%     Idx_Stimulusbig_cells= find(~cellfun(@isempty,Stimulusbig_cells));
%     Stimulusbigyesno=~isempty(Idx_Stimulusbig_cells)
latency=find(speeds>=40)
latencyyesno=~isempty(latency)
if sum(Stimulusbig_cells)==0
    Stimulusbigyesno=0
else
    Stimulusbigyesno=1
end
if Stimulusbigyesno==0
    NoStimcontrol=1
else 
    NoStimcontrol=0
end
if  (shelteryesno+Stimulusbigyesno+latencyyesno)==3
    Flight=1
end
if  (shelteryesno+Stimulusbigyesno+latencyyesno)<3
    Flight=0
end
if Stimulusbigyesno==1
    Stimcontrol=1
else
    Stimcontrol=0
end
Wobblingyesno=isempty(find((loom_table.Motion(1:10,1)<0.1)==0))
%speedsarray=speeds{1,1}
if shelteryesno==0 && Stimulusbigyesno==1 && Wobblingyesno==1
    Freeze=1
else
    Freeze=0
end

end