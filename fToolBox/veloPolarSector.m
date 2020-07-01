function vePSec = veloPolarSector(velo,angelView)
% velo：xyz格式的点云
% angelView:视角,用度表示
%% 
% x=velo(:,1);
% y=velo(:,2);
% z=velo(:,3);
% R=sqrt(x.*x+y.*y+z.*z);
% alpha = atan2(y,x);
% omega = asin(z./R);
% velo_polar=[R,omega,alpha];
velo_polar = xyzToPolar(velo);
thresh = (angelView./180*pi)./2;
itx = find(velo_polar(:,3)> -thresh & velo_polar(:,3)< thresh);
vePSec = velo(itx,:);
