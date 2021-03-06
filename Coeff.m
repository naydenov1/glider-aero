% Function that calculates the aerodynamic coefficients of the wing (CLift
% and CDrag)
function [CL, CD, Cm] = Coeff(cr,ct,b,Uinf,rho,L,Dind,CDpar,M)

% Geometry
S = b*(cr+ct)/2;
MGC = S/b;

q = 0.5*rho*norm(Uinf)^2;

% Coefficients
CL = L/(q*S);
CDpar = sum(CDpar);
CD = CDpar + Dind/(q*S);
Cm = M/(q*S*MGC);

end