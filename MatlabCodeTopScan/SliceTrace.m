function slicetable =SliceTrace(animal_table,start_frame, end_frame, file_path)
%calculate animaltablewith or without swapcorrection:swap 1 oder 0
%gives slice that is between the given from and to borders
%start and endframe are included
slicetable = animal_table((start_frame <= animal_table.FrameNum) & (animal_table.FrameNum <= end_frame), :);
end