function [x,y,length,distances,speeds,meanspeed,maxspeed,orientations,motions, durationtrace] = getTraceInfo3(slicetable,x,y,fps)
%x and y only from start to shelter
            orientations=slicetable.Orientation__pi_2ToPi_2_;
            motions=slicetable.Motion;
            durationtrace= height(x)/fps;
            distances=sqrt(diff(x(:,1)).^2 + diff(y(:,1)).^2);%from point to point%height-1
            distances=distances(~isnan(distances));
            length = sum(distances);
            speeds=(distances/10)*fps;% in m/s%height-1
            meanspeed= mean(speeds);
            maxspeed=max(speeds);
            if isempty(x+y)==1
                length = -1
                speeds=-1
                meanspeed= -1
                maxspeed=-1
                durationtrace=-1
            end
%             if swap==1
%                 distances=distances(find(distances<70));%<distancefps))%littleswapfilter
%                 length = sum(distances);%height-1
%                 speeds=distances/fps;% in m/s%height-1
%                 meanspeed= mean(speeds);
%                 maxspeed=max(speeds);
%             end
end
