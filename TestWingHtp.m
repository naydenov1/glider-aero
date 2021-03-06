function tests = TestWingHtp
tests = functiontests(localfunctions);
end
function test(testCase)
    % Wing:NACA 2412 airfoil
    m_W = 0.02;
    p_W = 0.4;
    i_W = 0; %the chord of the center section of the wing has zero incidence angle with respect to the rod

    % HTP NACA 0009
    m_H = 0;
    p_H = 0;
    i_H = 0; % degrees

    % VTP NACA 0009
    m_V = 0;
    p_V = 0;

    St_S = 1/8;
    Sv_S = 2/3;
    lt_cm = 4;

    rho = 1.225; % density [kg/m^3]

    Nx=5; Ny=10;
    % GEOMETRY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    alpha = 0;
    Uinf = [1*cosd(alpha),0,1*sind(alpha)];

    % Wing
    cr_W=1; ct_W=1*cr_W; b_W=10;
    sweep_W=0; dihedral_W=0; twist_W=0; 
    x_offset_W=0; z_offset_W=0;

    [CoordW,VortexW,ControlPW,DragPW,NormalW] = wing_assembly (cr_W,ct_W,b_W,Nx,Ny,m_W,p_W,sweep_W,dihedral_W,twist_W,x_offset_W,z_offset_W);

    %Horizontal tail
    cr_H=0.5*cr_W; ct_H=1*cr_H; b_H=0.25*b_W;
    sweep_H=0; dihedral_H=0; twist_H=0;
    x_offset_H=4+0.25*cr_W-0.25*cr_H; z_offset_H=z_offset_W;

    [CoordH,VortexH,ControlPH,DragPH,NormalH] = wing_assembly (cr_H,ct_H,b_H,Nx,Ny,m_H,p_H,sweep_H,dihedral_H,twist_H,x_offset_H,z_offset_H);

    %Vertical tail
    cr_V=1*cr_H; ct_V=1*cr_V; b_V=2/3*b_H;
    sweep_V=0; dihedral_V=0; twist_V=0; 
    x_offset_V=x_offset_H; z_offset_V=z_offset_W;

    [CoordV,VortexV,ControlPV,DragPV,NormalV] = geometry (cr_V,ct_V,b_V,Nx,Ny,m_V,p_V,sweep_V,dihedral_V,twist_V,x_offset_V,z_offset_V);
    [CoordV,VortexV,ControlPV,DragPV,NormalV] = rotation(CoordV,VortexV,ControlPV,DragPV,NormalV,0,90,cr_V,x_offset_V,z_offset_V);

    %Tail assembly
    [CoordT,VortexT,ControlPT,DragPT,NormalT] = assembly(CoordH,VortexH,ControlPH,DragPH,NormalH,CoordV,VortexV,ControlPV,DragPV,NormalV);

    %Tail incidence
    [CoordT,VortexT,ControlPT,DragPT,NormalT] = rotation(CoordT,VortexT,ControlPT,DragPT,NormalT,i_H,0,cr_H,x_offset_H,z_offset_H);

    %Wing-body assembly
    [Coord,Vortex,ControlP,DragP,Normal] = assembly(CoordW,VortexW,ControlPW,DragPW,NormalW,CoordT,VortexT,ControlPT,DragPT,NormalT);

    % COMPUTATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    deltaY = [b_W/(2*Ny) b_H/(2*Ny) b_V/Ny];

    Gamma = circulation(Uinf,Vortex,ControlP,Normal);
    [dLw,dLh,dLv] = delta_lift(Gamma,deltaY,Nx,Ny,rho,Uinf,'ala+htp+vtp');
    [dDw,dDh,dDv] = delta_drag(Gamma,Vortex,DragP,deltaY,Nx,Ny,rho,Uinf,'ala+htp+vtp');

    L = lift(dLw,dLh,dLv);
    M = moment(dLw,dLh,dLv,Nx,Ny,DragP(:,:,1),'ala+htp+vtp');
    Dind = drag(dDw,dDh,dDv);
    [CL, CD, Cm] = Coeff(cr_W,ct_W,b_W,Uinf,rho,L,Dind,M);
    % Solution
    actSolutionCL = CL;
    actSolutionCD = CD;
    actSolutionCm = Cm;
    % XFLR5 solution for this data
    expSolutionCL = 0.1649;
    expSolutionCD = 0.0009;
    expSolutionCm = -0.0753;
    % verify
    verifyEqual(testCase,actSolutionCL,expSolutionCL,'AbsTol',0.0001)
    verifyEqual(testCase,actSolutionCD,expSolutionCD,'AbsTol',0.0001)
    verifyEqual(testCase,actSolutionCm,expSolutionCm,'AbsTol',0.0001')
end
