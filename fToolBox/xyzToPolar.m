function velo_polar = xyzToPolar(velo)
x=velo(:,1);
y=velo(:,2);
z=velo(:,3);
R=sqrt(x.*x+y.*y+z.*z);
alpha = atan2(y,x);
omega = asin(z./R);
velo_polar=[R,omega,alpha];


