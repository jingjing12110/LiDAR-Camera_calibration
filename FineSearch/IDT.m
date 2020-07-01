function  [E1,D] = IDT(img,gamma,alpha)
[high,width] = size(img);   % 获得图像的高度和宽度
F2 = double(img);        
U = double(img);       
uSobel = img;
for i = 2:high - 1   %sobel边缘检测
    for j = 2:width - 1
        Gx = (U(i+1,j-1) + 2*U(i+1,j) + F2(i+1,j+1)) - (U(i-1,j-1) + 2*U(i-1,j) + F2(i-1,j+1));
        Gy = (U(i-1,j+1) + 2*U(i,j+1) + F2(i+1,j+1)) - (U(i-1,j-1) + 2*U(i,j-1) + F2(i+1,j-1));
        uSobel(i,j) = sqrt(Gx^2 + Gy^2); 
    end
end 
E1=im2uint8(uSobel);

[m,n] = size(E1);
% E = mapminmax(E,0,1);
% imshow(E/256) % imshow(E,[]);
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
% D = uint8(D);
