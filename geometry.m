function [x,y,z,xp,yp,zp,xc,yc,zc] = geometry (cr,ct,b,Nx,Ny,m,p,flecha,diedro)

for i=1:Nx+1
    y(i,:)=linspace(0,b/2,Ny+1); %Y Coordinate of the points of the elemnts
    yp(i,:)=linspace(0,b/2,Ny+1); %Y Coordinate of the points of the vortex
end

for j=1:Ny+1
    c=cr-(cr-ct)*y(1,j)/(b/2); %Computation of the chord of the wing segment
    for i=1:Nx+1
        x(i,j)=cr/4-c/4+c*(i-1)/Nx+y(i,j)*tand(flecha); %X Coordinate of the points of the elemnts
        xp(i,j)=cr/4-c/4+c*(i-1)/Nx+c/(4*Nx)+yp(i,j)*tand(flecha); %X Coordinate of the points of the vortex
        xadim=(x(i,j)-x(1,j))/c; %Adimensionalization of the x coordinatie of the points
        z(i,j)=camber(xadim,m,p)+y(i,j)*tand(diedro); %Z Coordinate of the points of the elemnts
        xadimp=(xp(i,j)-x(1,j))/c; %Adimensionalization of the x coordinatie of the vector
        zp(i,j)=camber(xadim,m,p)+yp(i,j)*tand(diedro); %Z Coordinate of the points of the vortex
    end
end

for j=1:Ny
    for i=1:Nx
        yc(i,j)=(y(i,j)+y(i,j+1))/2; %Y Coordinate  of the control points
    end
    c=cr-(cr-ct)*yc(1,j)/(b/2); %Chord of the wing segment
    for i=1:Nx
        xc(i,j)=cr/4-c/4+c*(i-1)/Nx+c*3/(4*Nx)+yc(i,j)*tand(flecha); %X Coordinate  of the control points
        xadimc=(xc(i,j)-((x(1,j)+x(1,j+1))/2))/c; %Adimensionalization  of the x coordinate of the control point
        zc(i,j)=camber(xadimc,m,p)+yc(i,j)*tand(diedro); %Z Coordinate  of the control points
    end
end

end