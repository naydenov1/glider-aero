function Xcm = x_cm(b,Nx,Ny,cr_W,ct_W,b_W,m_W,p_W,sweep_W,dihedral_W,...
    twist_W,z_offset_W,cr_H,ct_H,i_H,b_H,m_H,p_H,sweep_H,dihedral_H,twist_H,cr_V,...
    ct_V,b_V,m_V,p_V,sweep_V,dihedral_V,twist_V,dLw,dLh,dLv,M)

x_offset_W = 0;
k=0.005; s=0;
MGC=0.5*(cr_W+ct_W);
while abs(M)>1e-9
 
% GEOMETRY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wing
[CoordW,VortexW,ControlPW,DragPW,NormalW] =wing_assembly (cr_W,ct_W,b_W,...
    Nx,Ny,m_W,p_W,sweep_W,dihedral_W,twist_W,x_offset_W,z_offset_W);

%Horizontal tail
x_offset_H=x_offset_W+4*MGC+0.25*cr_W-0.25*cr_H; z_offset_H=z_offset_W;
[CoordH,VortexH,ControlPH,DragPH,NormalH] = wing_assembly (cr_H,ct_H,...
    b_H,Nx,Ny,m_H,p_H,sweep_H,dihedral_H,twist_H,x_offset_H,z_offset_H);

%Vertical tail
x_offset_V=x_offset_H; z_offset_V=z_offset_W;

[CoordV,VortexV,ControlPV,DragPV,NormalV] = geometry (cr_V,ct_V,b_V,Nx,...
    Ny,m_V,p_V,sweep_V,dihedral_V,twist_V,x_offset_V,z_offset_V);
[CoordV,VortexV,ControlPV,DragPV,NormalV] = rotation(CoordV,VortexV,...
    ControlPV,DragPV,NormalV,0,90,cr_V,x_offset_V,z_offset_V);

%Tail assembly
[CoordT,VortexT,ControlPT,DragPT,NormalT] = assembly(CoordH,VortexH,...
    ControlPH,DragPH,NormalH,CoordV,VortexV,ControlPV,DragPV,NormalV);

%Tail incidence
[CoordT,VortexT,ControlPT,DragPT,NormalT] = rotation(CoordT,VortexT,...
    ControlPT,DragPT,NormalT,i_H,0,cr_H,x_offset_H,z_offset_H);

%Wing-body assembly
[Coord,Vortex,ControlP,DragP,Normal] = assembly(CoordW,VortexW,...
    ControlPW,DragPW,NormalW,CoordT,VortexT,ControlPT,DragPT,NormalT);

% MOMENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M = moment(dLw,dLh,dLv,Nx,Ny,DragP(:,:,1),'ala+htp+vtp');

c=cr_W-(cr_W-ct_W)*Coord(1,Ny+1,2)/(b/2); %Computation of the wing chord

Xcm = -x_offset_W - c/4;


if M<0
    if s==1
        k=k*0.1;
    end
    x_offset_W = x_offset_W - k; 
    s=0;
else
    if s==0
        k=k*0.1;
    end
    x_offset_W = x_offset_W + k;     
    s=1;    
end
end

end