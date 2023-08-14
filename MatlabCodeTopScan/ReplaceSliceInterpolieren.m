function [Allanimaltables_write]=ReplaceSliceInterpolieren(Allanimaltables_write,animal_table_before_name,start_frame, end_frame)
%if animal is not tracked and is moving-->interpolates x and y: only used
%if no other solution is possible
    %get replacing slice from table
    ReplacedSlice = SliceTraceReplace(Allanimaltables_write.(animal_table_before_name),start_frame, end_frame);
    [rowstart ~]=find((start_frame == Allanimaltables_write.(animal_table_before_name).FrameNum));
    [rowend ~]=find((end_frame == Allanimaltables_write.(animal_table_before_name).FrameNum));
    %define start and end point
    y1=Allanimaltables_write.(animal_table_before_name)((rowstart-1),4);
    y2=Allanimaltables_write.(animal_table_before_name)((rowend+1),4);
    x1=Allanimaltables_write.(animal_table_before_name)((rowstart-1),3);
    x2=Allanimaltables_write.(animal_table_before_name)((rowend+1),3);
    n=height(ReplacedSlice);
    % Define the points at which we want to interpolate
    x = linspace(x1{1,1}, x2{1,1}, n);
    % Interpolate the values of y at the points in x using linear interpolation
    y = interp1([x1{1,1}, x2{1,1}], [y1{1,1}, y2{1,1}], x, 'linear');
    Allanimaltables_write.(animal_table_before_name).CenterX_mm_(rowstart:rowend,3)=x;
    Allanimaltables_write.(animal_table_before_name).CenterX_mm_(rowstart:rowend,4)=y;
end