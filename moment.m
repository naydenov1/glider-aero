% Function that returns the momement about the origin of coordinates
% of the wing given the lift of each element and its position.
function M = moment(dLw,dLh,dLv,Nx,Ny,Xp,cas)
    Mw = 0;
    Mh = 0;
    Mv = 0;
    switch cas
        case 'ala'
            Xp_w = rearrange_wing(Nx,Ny,Xp,'wing');
            for j=1:Ny
                for i=1:Nx
            %             what to do with: ground effect and with vortex where there is
            %             no other vortex at j+1?
                  Xpm = (Xp_w(i,j)+Xp_w(i,j+1))/2;
                  Mw = Mw + Xpm*dLw(i,j);  
                end
            end
        case 'ala+htp'
            Xp_w = rearrange_wing(Nx,Ny,Xp,'wing');
            Xp_h = rearrange_wing(Nx,Ny,Xp,'htp');
            for j=1:Ny
                for i=1:Nx
                  Xpmw = (Xp_w(i,j)+Xp_w(i,j+1))/2;
                  Mw = Mw + Xpmw*dLw(i,j);
                  Xpmh = (Xp_h(i,j)+Xp_h(i,j+1))/2;
                  Mh = Mh + Xpmh*dLh(i,j);                    
                end
            end            
        case 'ala+htp+vtp'
            Xp_w = rearrange_wing(Nx,Ny,Xp,'wing');
            Xp_h = rearrange_wing(Nx,Ny,Xp,'htp');
            Xp_v = rearrange_wing(Nx,Ny,Xp,'vtp');
            for j=1:Ny
                for i=1:Nx
                  Xpmw = (Xp_w(i,j)+Xp_w(i,j+1))/2;
                  Mw = Mw + Xpmw*dLw(i,j);
                  Xpmh = (Xp_h(i,j)+Xp_h(i,j+1))/2;
                  Mh = Mh + Xpmh*dLh(i,j);
                  Xpmv = (Xp_v(i,j)+Xp_v(i,j+1))/2;
                  Mv = Mv + Xpmv*dLv(i,j);                  
                end
            end            
    end
    M = Mw + Mh + Mv;
    M = -M;
end
