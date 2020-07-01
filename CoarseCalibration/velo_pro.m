file_dir = 'F:\code\calib_camlaser\2011_09_26_calib\激光图像标定数据\标定板数据';
save_XYZ_dir = 'F:\code\calib_camlaser\2011_09_26_calib\激光图像标定数据\data\laser';
test_file = 'F:\code\calib_camlaser\2011_09_26_calib\激光图像标定数据\场景数据';
x_min=2;x_max=50;
y_min=-15;y_max=15;
z_th=-1.8;
frame=1;
%% 将txt转换成XYZ，调用lasercamcalib得到外参初值
for frame=1:1:22
    velo = load(sprintf('%s/my_laser%d.txt',file_dir,frame));
%     s0=sprintf('%s/laser_target%d.xyz',file_dir,frame);
%     v=velo(:,1:3);
%     save(s0,'v','-ascii')
    % 滤波
    itx=find(velo(:,1)<x_max & velo(:,1)>x_min & ...
             velo(:,2)<y_max & velo(:,2)>y_min & ...
             velo(:,3)>z_th);
    velo_f=velo(itx,:);
%     pcshow(velo_f(:,1:3))
    s1=sprintf('%s/laser_filter/my_laser%d.txt',test_file,frame);
    save(s1,'velo_f','-ascii') %搜索算法时用
%     s2=sprintf('%s/laser_target%d.xyz',save_XYZ_dir,frame);
%     itx2 = find(velo_f(:,1)<15 & velo(:,3)>1.8 & ...
%                 velo_f(:,2)<8 & velo_f(:,2)>-8);
%     velo_ff = velo_f(itx2,:);
%     v=velo_ff(:,1:3);
% %     pcshow(v)
%     save(s2,'v','-ascii')
end

%% 点云处理与滤波
% gamma = 0.5; % 
% beam_num = 64;
% 
% velo = load(sprintf('%s/laser_filter/my_laser%d.txt',file_dir,frame));
% velo(:,6)=sqrt(power(velo(:,1),2)+power(velo(:,2),2)+power(velo(:,3),2));
% num = size(velo,1);
% X=[];
% for i=1:1:beam_num
%     itx = find(velo(:,5)==i);
%     P = velo(itx,:); % 取第i帧点云
%     pc_num = size(P,1);
%     Xi = ones(pc_num,4);
%     Xi(:,1:3)=P(:,1:3);
%     Xi(1,4)=power(P(1,6),gamma);
%     Xi(pc_num,4)=power(P(pc_num,6),gamma);
%     for j=2:1:pc_num-1
%         temp1 = max(P(j-1,6)-P(j,6), P(j+1,6)-P(j,6));
%         temp = max(temp1, 0);
%         Xi(j,4) = power(temp, gamma);
%     end
%     X = [X;Xi];    
% end
% % 滤波
% threshhold = power(0.3,gamma); % 深度不连续阈值30cm
% ithx = find(X(:,4) <= threshhold);
% X(ithx,:)=[];
% X = X(:,1:3);



