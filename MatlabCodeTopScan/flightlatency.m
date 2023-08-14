function flight_latency=flightlatency(loom_table,speeds,start_frame,fps)
%this function computes the flight latency
if speeds==-1
    flight_latency=-1
else
    latency=find(speeds>=40)
    time_latency=loom_table.FrameNum(latency(:,1),1)
    if isempty(time_latency)==1
        flight_latency=0%"NaN"
    else
        flight_latency=(time_latency(1,1)-start_frame)/fps
    end
end
end