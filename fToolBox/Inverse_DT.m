function D = Inverse_DT(img,alpha,gamma)
%% 获取图像边缘
[m,n] = size(img);
% E = edge(img,'canny',0.09);
% m = 1200;
% n = 1920;
E=ones(m,n);
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
       E(i,j)=t;
    end
end
% E = mapminmax(E,0,1);
% imshow(E/256) % imshow(E,[]);
%% Inverse distance transform 
% (3)
D=E;
window_size=50;
x_temp=repmat((-window_size:window_size)',1,2*window_size+1);
y_temp=x_temp';
factor_=max(abs(x_temp),abs(y_temp));
gamma_power=power(gamma,factor_);

for i=window_size+1:m-window_size
    for j=window_size+1:n-window_size
        E_temp=E(i-window_size:i+window_size,j-window_size:j+window_size);
        temp1=E_temp.*gamma_power;
        temp_max=max(temp1(:));
        D(i,j) = alpha*E(i,j)+(1-alpha)*temp_max;
    end
end
D = mapminmax(D,0,1); %归一化
% % (2)
% D=ones(m,n);
% for i=1:1:m
%     for j = 1:1:n
%         [x_start, x_end, y_start, y_end] = Is_SEn(i,j,3);
%         temp=zeros(m*n,1);
%         k=1;
%         for x=x_start:1:x_end
%             for y =y_start:1:y_end
%                 temp1 = [i,j;x,y];
%                 d8 = pdist(temp1,'chebychev');
%                 temp(k,1)=E(x,y)*power(gamma,d8);
%                 k = k+1;
%             end
%         end
%         temp_max=max(temp(:,1));
%         D(i,j) = alpha*E(i,j)+(1-alpha)*temp_max;
%     end
% end
% 
% % (1)
% for i=1:1:m
%     for j=1:1:n
%         temp=zeros(m*n,1);
%         k=1;
%         for x=1:1:m
%             for y =1:1:n
%                 temp1 = [i,j;x,y];
%                 d8 = pdist(temp1,'chebychev');
%                 temp(k,1)=E(x,y)*power(gamma,d8);
%                 k = k+1;
%             end
%         end
%         temp_max=max(temp(:,1));
%         D(i,j) = alpha*E(i,j)+(1-alpha)*temp_max;
%     end
% end


