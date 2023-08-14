function  [x_new,y_new]=findcertaintrace(x,y)
    Shelter_center=[160 230] ;  % center
    Shelter_radius = 40;  % Radius if cricle
    th = linspace(0,2*pi) ;% create circle
    xc = Shelter_center(1)+Shelter_radius*cos(th) ;
    yc = Shelter_center(2)+Shelter_radius*sin(th) ;
    [in,on] = inpolygon(x(:,1),y(:,1),xc,yc);
    inshelter=find(in);
    if isempty(inshelter)==1
        x_new=x
        y_new=y
    else
        x_new=x(1:(inshelter(1)-1),1)
        y_new=y(1:(inshelter(1)-1),1)
    end
    if any(inshelter==1)==1
        x_new=x
        y_new=y
    end
end