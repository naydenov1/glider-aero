% function dL = delta_lift(Vortex,Gamma,rho,Uinf)
%     deltaY=(Vortex(2,:,2)-Vortex(1,:,2))';
%     deltaZ=(Vortex(2,:,3)-Vortex(1,:,3))';
%     delta=sqrt(deltaY.^2+deltaZ.^2);
%     dL = rho*norm(Uinf)*Gamma.*delta;
% end

function dL = delta_lift(Gamma,b,Nx,Ny,rho,Uinf,cas)
    deltaY = b/(2*Ny);
    dL = zeros(Nx,Ny);
    Gamma_e = zeros(Nx,Ny);
    Gamma_d = zeros(Nx,Ny);  
    switch cas
        case 'ala'
            k = 0;
            % semiala esquerra            
            for i=1:Nx
                for j=1:Ny
                    % change from vector to matrix
                    k = k + 1;
                    Gamma_e(i,j) = Gamma((i-1)*Ny+j);
                end
            end
            % semiala esquerra
            Ny_aux = k+Ny;
            l = 0;
            for i=1:Nx
                for j=k:Ny_aux
                    l = l + 1;
                    % change from vector to matrix
                    Gamma_d(i,l) = Gamma((i-1)*Ny+j);
                end
            end
            Gamma = [Gamma_e Gamma_d];
            for i=1:Nx
                for j=1:Ny
                    if i == 1
                        dL(i,j) = rho*norm(Uinf)*Gamma(1,j)*deltaY;
                    else
                        dL(i,j) = rho*norm(Uinf)*(Gamma(i,j)-Gamma(i-1,j))*deltaY;
                    end
                end
            end
%         case 'ala'
%             Gamma_new = zeros(Nx,2*Ny);
%             for i=1:Nx
%                 for j=1:(Ny*2)
%                     if(j<=Ny)
%                         Gamma_new(i,j) = Gamma((i-1)*Ny+j);
%                     else
%                         Gamma_new(i,j) = Gamma((i-1)*Ny+j);
%                     end
%                         
%                     Gamma_d(i,l) = Gamma((i-1)*Ny+j);
%                     if i == 1
%                         dL(i,j) = rho*norm(Uinf)*Gamma_new(1,j)*deltaY;
%                     else
%                         dL(i,j) = rho*norm(Uinf)*(Gamma_new(i,j)-Gamma_new(i-1,j))*deltaY;
%                     end
%                 end
%             end
        case 'ala+htp'
        case 'ala+htp+vtp'
        case 'ala+htps'
    end
end
    