clear;clc;
CoarseCalib_dir = 'F:\code\calib_camlaser\Calibration\Coarse_calib\img_laser_data';
fineCalib_dir = 'F:\code\calib_camlaser\Calibration\fine_search\Data';
% 初始化相关参数
alpha = 1/3;
gamma1 = 0.98; % 得到D图的参数
gamma2 = 0.5; % 得到点云特征值X的参数
beam_num = 64; % 激光器数
n = 22; % 总的标定数据帧数
w = 9; % w=1,9... :window size

%% 加载粗标定矩阵
% 内参(自带cameraCalibrator得到的内参cameraParams)   
a=load([CoarseCalib_dir,'\cameraParams.mat']); 
K_int1=a.cameraParams.IntrinsicMatrix';
K_int1(:,4)=0;
% K_int1 = [1003.423,     0,         969.217,   0; 
%              0,      1015.877,     652.405,   0; 
%              0,         0,            1,      0]; 

% 内参(calib工具箱标定结果) 
b=load([CoarseCalib_dir,'\Calib_Results.mat']); 
K_int_tool = [b.fc(1),     0,      b.cc(1),    0;
                0,      b.fc(2),   b.cc(2),    0;
                0,         0,         1,       0]; 
% 外参
c1=load([CoarseCalib_dir,'\laser_filter\C1.mat']); 
C1 = c1.C;
c2=load([CoarseCalib_dir,'\laser_filter\C2.mat']); 
C2 = c2.C;


%% 可视化未优化的标定矩阵下的结果
frame=10;
img = imread(sprintf('%s/img_target%d.jpg',CoarseCalib_dir,frame));
% velo1 = load(sprintf('%s/laser_filter/my_laser%d.txt',file_dir,frame));
velo1 = load(sprintf('%s/laser_target%d.xyz',CoarseCalib_dir,frame));
project_show(velo1(:,1:3), img, C1, K_int1)
%% 加载数据,并对数据进行预处理
% i=1;
% for f =1:1:9
%     % 图像预处理
%     f
%     img = imread(sprintf('%s/my_pic%d.jpg',test_file,f));
%     img = rgb2gray(img);
% %     img = img(350:end,1:end);
% %     Data(i).img = img;
%     D = Inverse_DT(img,alpha,gamma1); % 得到D图像
%     Data(i).D = D;
%     % 点云预处理
% %     velo = load(sprintf('%s/laser_filter/my_laser%d.txt',test_file,f));
%     velo = load(sprintf('%s/my_laser%d.txt',test_file,f));
%     itx = velo(:,1)<5 | velo(:,2)<-40;
%     velo(itx,:)=[];
%     velo(:,6)=sqrt(power(velo(:,1),2)+power(velo(:,2),2)+power(velo(:,3),2));
% %     Data(i).velo = velo;
%     X = PC_filter(velo, gamma2, beam_num); % X=[x,y,z,Xpi]' ；得到X点云
%     % pcshow(X(:,1:3),'MarkerSize' ,20)
%     Data(i).X =  X;
%     i = i+1;
% end
% load('matlab.mat');
%% 搜索算法
% 搜索空间
delta_t = 0.1; % cm,平移向量的偏移量
delta_R = 0.1/180.*pi; % 角度偏移量
C_max = C;
C_optm0 = [0, 0, 0, 0, 0, 0];
max_iter = 100;
iter_count = 1;
img = imread(sprintf('%s/my_pic%d.jpg',file_dir,1));
img = rgb2gray(img);
% img = img(350:end,1:end);
[img_h ,img_w] =size(img);

while(Is_True(C_max,C_optm0)==0)
%     if (iter_count > max_iter)
%         break;
%     end
    C_optm0 = C_max;
    CC = C_729(C_optm0, delta_t, delta_R);
    JC=zeros(729,1);
    disp('开始计算JC')
    for CC_num=1:1:729
        JC_f = 0;
        C_f = CC(CC_num,:);
        for f = 1:1:9
            % 图像预处理,得到D图像
            D = Data(f).D;
            % 加载点云,得到X点云,X=[x,y,z,Xpi]' ；
            X = Data(f).X;
            uv = xyz2uv(X, C_f, K_int); % uv=[u,v,Xpi]
            % 检验-考虑落到图像平面的像素点     
            ithx = find(uv(:,1)<img_w & uv(:,1)>0 & uv(:,2)<img_h & uv(:,2)>0);
%             ithx = find(uv(:,1)<img_h-50 & uv(:,1)>50 & uv(:,2)<img_w-50 & uv(:,2)>50);
            uv_f = uv(ithx,:);
            % 计算第f帧点云投影的JC
            JC0 = obj_func(uv_f,D);
            JC_f = JC_f+JC0;
        end
        JC(CC_num,1) = JC_f;
        % fprintf('计算完第%d个C\n',CC_num)
    end
    [~,I] = max(JC(:,1));
    C_max = CC(I,:);
    fprintf('完成第%d次搜索\n',iter_count)
    iter_count = iter_count+1;
end

C_optm0 = C_max;
% 可视化优化后的标定矩阵下的结果
frame=1;
img = imread(sprintf('%s/my_pic%d.jpg',test_file,frame));
velo1 = load(sprintf('%s/my_laser%d.txt',test_file,frame));
% img = imread(sprintf('%s/my_pic%d.jpg',test_file,frame));
% velo1 = load(sprintf('%s/laser_filter/my_laser%d.txt',test_file,frame));
project_show(velo1(:,1:3), img, C_optm0, K_int)
% hold on
% project_show(velo1(:,1:3), img, C, K_int)
%% 计算JC
% JC=[];
% disp('开始计算JC')
% for CC_num=1:1:729
%     JC1 = 0;
%     for n=w:w:18
%         for f = (n-w+1):1:n
%             % 图像预处理
%             img = Data(f).img;
%             D = Inverse_DT(img,alpha,gamma1); % 得到D图像
%             % 加载点云（process过的点云）
%             velo = Data(f).velo;
%             X = PC_filter(velo, gamma2, beam_num); % X=[x,y,z,Xpi]' ；得到X点云
%             uv = xyz2uv(X, CC(CC_num,:), K_int);
%             % 检验-考虑落到图像平面的像素点
%             [a, b]=size(img);
%             ithx = find(uv(:,1)<a & uv(:,1)>0 & uv(:,2)<b & uv(:,2)>0);
%             uv_f = uv(ithx,:);
%             % 计算第f帧点云投影的JC
%             JC0 = obj_func(uv_f,D);
%             JC1 = JC1+JC0;
%         end
%     end
%     JC = [JC;JC1];
%     CC_num
% end

% [M,I] = max(JC(:,1));
% C_max = CC(I,:);


%% 可视化优化后的标定矩阵下的结果
% frame=20;
% img = imread(sprintf('%s/my_pic%d.jpg',test_file,frame));
% % velo1 = load(sprintf('%s/laser_filter/my_laser%d.txt',file_dir,frame));
% velo1 = load(sprintf('%s/my_laser%d.txt',test_file,frame));
% project_show(velo1(:,1:3), img, C_max, K_int)

