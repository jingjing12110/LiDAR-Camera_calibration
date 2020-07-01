function project_show(velo, img, C, K_int)
%% 标定矩阵
x=C(1,1);y=C(1,2);z=C(1,3);
Roll = C(1,4); Pitch = C(1,5);Yaw = C(1,6);
t=[x,y,z]';
Rx=[1,0,0; 
    0, cos(Roll), -sin(Roll);
    0, sin(Roll), cos(Roll)];
Ry=[cos(Pitch), 0, sin(Pitch);
    0, 1, 0;
    -sin(Pitch), 0, cos(Pitch)];
Rz=[cos(Yaw), -sin(Yaw), 0;
    sin(Yaw),  cos(Yaw), 0;
    0, 0, 1];
R=Rz*Ry*Rx;
K_ext=eye(4,4);
K_ext(1:3,1:3)=R;
K_ext(1:3,4)=t;

K_matrix=K_int*K_ext;

dim_norm = size(K_matrix,1);
dim_proj = size(K_matrix,2);

%% 计算uv
% 除去非图像平面点
velod =velo(1:2:end,:);
velo = veloPolarSector(velod,84);

idx = velo(:,1)<5 | velo(:,1)>50;
velo(idx,:) = [];
% idx = velo(:,2)<12 & velo(:,2)>-10;
% velo=velo(idx,:);
% plot3(velo(:,1),velo(:,2),velo(:,3),'.','LineWidth',4,'MarkerSize',2);
% pcshow(velo)
% 减采样
% velo = velo(1:2:end,:);
p2_in = velo;
if size(p2_in,2)<dim_proj
  p2_in(:,dim_proj) = 1;
end
p2_out = (K_matrix*p2_in')';

p_out = p2_out(:,1:dim_norm-1)./(p2_out(:,dim_norm)*ones(1,dim_norm-1));

% p_out = project(velo(:,1:3),K_matrix);

%% plot points
fig = figure('Position',[0 0 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
imshow(img); hold on;
% for i=1:size(p_out,1)
%     plot(p_out(i,1),p_out(i,2),'o');
% end
cols = jet;
for i=1:1:size(p_out,1)
  col_idx = round(64*5/velo(i,1));
  plot(p_out(i,1),p_out(i,2),'o','LineWidth',3,'MarkerSize',1,'Color',cols(col_idx,:));
end

