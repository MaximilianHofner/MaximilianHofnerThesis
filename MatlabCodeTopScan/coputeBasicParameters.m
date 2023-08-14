function [x,y,length,distances,speeds,meanspeed,maxspeed,orientations,motions] = getTraceInfo2(slicetable,fps)
%This function computes parameters based on x and y coordinates of TopScan output
            x = slicetable.CenterX_mm_; 
            y = slicetable.CenterY_mm_;
            orientations=slicetable.Orientation__pi_2ToPi_2_;
            motions=slicetable.Motion;
            distances=sqrt(diff(x(:,1)).^2 + diff(y(:,1)).^2);%from point to point%height-1
            distances=distances(~isnan(distances))
            length = sum(distances)
            speeds=(distances/10)*fps;% in m/s%height-1
            meanspeed= mean(speeds);
            maxspeed=max(speeds);
end

