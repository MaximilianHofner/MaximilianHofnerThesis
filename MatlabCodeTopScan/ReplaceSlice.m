function [Allanimaltables_write,start_frame,end_frame]=ReplaceSlice(Allanimaltables_write,animal_table_before_name,animaltable_replace,start_frame, end_frame)
    %get replacing slice from table
    ReplacedSlice = SliceTraceReplace(animaltable_replace,start_frame, end_frame);
    [rowstart ~]=find((start_frame == animaltable_replace.FrameNum));
    [rowend ~]=find((end_frame == animaltable_replace.FrameNum));
    Allanimaltables_write.(animal_table_before_name)(rowstart:rowend,:)=ReplacedSlice
end