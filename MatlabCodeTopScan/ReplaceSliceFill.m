function Allanimaltables_write=ReplaceSliceFill(Allanimaltables_write,animal_table_before_name,start_frame, end_frame)
%if animal is not tracked at all and stays at one point--> replaces with
%NaN and overwrites
    %get replacing slice from table
    [rowstart ~]=find((start_frame == Allanimaltables_write.(animal_table_before_name).FrameNum));
    [rowend ~]=find((end_frame == Allanimaltables_write.(animal_table_before_name).FrameNum));
    %delete values by replacing with NaN
    Allanimaltables_write.(animal_table_before_name).CenterX_mm_(rowstart:rowend,1)=NaN;
    Allanimaltables_write.(animal_table_before_name).CenterY_mm_(rowstart:rowend,1)=NaN;
    %Fill alues with fillmissing previous
    FillarrayX=Allanimaltables_write.(animal_table_before_name).CenterX_mm_(rowstart-1:(rowend));
    FillarrayY=Allanimaltables_write.(animal_table_before_name).CenterY_mm_(rowstart-1:(rowend));
    ReplacedSliceX=fillmissing(FillarrayX,'previous');
    ReplacedSliceY=fillmissing(FillarrayY,'previous');
    Allanimaltables_write.(animal_table_before_name).CenterX_mm_(rowstart:rowend)=ReplacedSliceX(2:end);
    Allanimaltables_write.(animal_table_before_name).CenterY_mm_(rowstart:rowend)=ReplacedSliceY(2:end);
end