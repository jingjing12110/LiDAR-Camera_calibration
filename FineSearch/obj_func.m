function JC = obj_func(uvr,D)
% 计算单帧点云投影的目标函数
% uvr：点云投影值
% D: Inverse_DT变换后的图像
b = size(uvr,1);
JC = 0;
for p=1:1:b
%     i=round(uvr(p,1));
%     if i<0.4
%         i=1; 
%     end
%     j=round(uvr(p,2));
%     if j<0.4
%         j=1;
%     end
    i = uvr(p,1); % u对应图像矩阵的列，v对应图像矩阵的行
    j = uvr(p,2);
    temp = uvr(p,3)*D(j,i);
    JC = JC+temp;
end

