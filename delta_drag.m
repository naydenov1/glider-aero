
% Function that computes the induced drag of each vortex element

function dDind = delta_drag(vortice_mat,control,Gamma,b,Nx,Ny,rho,Uinf)

    w = w_coef(Nx,Ny,vortice_mat,control,Uinf,Gamma);
  
    n = length(Gamma);
    w_new = zeros(Nx,2*Ny);
    Gamma_new = zeros(Nx,2*Ny);
    dDind = zeros(Nx,Ny*n);  
    
    for Nw = 1:ceil(n/2);
        for i = 1:Nx
            
            if Nw == 3 | Nw == 5  %Cas de l'estabilitzador vertical
                for j = 1:Ny
                    w_new(i,j) = w((i-1)*2*Ny + j + 4*Ny*(Nw-1));
                    Gamma_new(i,j) = Gamma((i-1)*2*Ny + j + 4*Ny*(Nw-1));
                end
            else   % Cas ala i estabilitzador horitzontal
                for j = 1:2*Ny
                    w_new(i,j) = w((i-1)*2*Ny + j + 4*Ny*(Nw-1));
                    Gamma_new(i,j) = Gamma((i-1)*2*Ny + j + 4*Ny*(Nw-1)); 
                end
            end
        end
    end
    
    for Nw = Nw = 1:ceil(n/2);      
        for i=1:Nx
            for j=1:Ny*n
                if i == 1
                    dDind(i,j) = rho*Gamma_new(1,j)*w_new(1,j)*deltaY(Nw);
                else
                    dDind(i,j) = rho*(Gamma_new(i,j)- Gamma_new(i-1,j))*w_new(i,j)*deltaY(Nw);
                end
            end
        end
    end
    
end