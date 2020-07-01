function [E1,D] = IDT1(img,gamma,alpha)
[m,n] = size(img);
% E = edge(img,'canny',0.09);
% m = 1200;
% n = 1920;
E1=ones(m,n);
a = zeros(8,1);
for i=2:1:m-1
    for j=2:1:n-1
       a0 = img(i,j);
       a(1) =abs(img(i-1,j-1)-a0);
       a(2) =abs(img(i-1,j)-a0);
       a(3) =abs(img(i-1,j+1)-a0);
       a(4) =abs(img(i,j-1)-a0);
       a(5) =abs(img(i,j+1)-a0);
       a(6) =abs(img(i+1,j-1)-a0);
       a(7) =abs(img(i+1,j)-a0);
       a(8) =abs(img(i+1,j+1)-a0);
       t=max(a(:)); 
       E1(i,j)=t;
    end
end

E = double(E1);
I = double(E1);
for i = 2:m
    for j = 2:n-1
        E(i,j)  = max(max(max(E(i-1:i,j-1:j+1)))*gamma,E(i,j));
    end
end

for i = m-1:-1:1
    for j = n-1:-1:2
        E(i,j) = max(max(max(E(i:i+1,j-1:j+1)))*gamma,E(i,j));
    end
end
D = (1-alpha)*E+alpha*I;
