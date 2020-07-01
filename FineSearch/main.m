clear;clc;
CoarseCalib_dir = 'F:\code\calib_camlaser\Calibration\Coarse_calib\img_laser_data';
fineCalib_dir = 'F:\code\calib_camlaser\Calibration\fine_search\Data';
% ��ʼ����ز���
alpha = 1/3;
gamma1 = 0.98; % �õ�Dͼ�Ĳ���
gamma2 = 0.5; % �õ���������ֵX�Ĳ���
beam_num = 64; % ��������
n = 22; % �ܵı궨����֡��
w = 9; % w=1,9... :window size

%% ���شֱ궨����
% �ڲ�(�Դ�cameraCalibrator�õ����ڲ�cameraParams)   
a=load([CoarseCalib_dir,'\cameraParams.mat']); 
K_int1=a.cameraParams.IntrinsicMatrix';
K_int1(:,4)=0;
% K_int1 = [1003.423,     0,         969.217,   0; 
%              0,      1015.877,     652.405,   0; 
%              0,         0,            1,      0]; 

% �ڲ�(calib������궨���) 
b=load([CoarseCalib_dir,'\Calib_Results.mat']); 
K_int_tool = [b.fc(1),     0,      b.cc(1),    0;
                0,      b.fc(2),   b.cc(2),    0;
                0,         0,         1,       0]; 
% ���
c1=load([CoarseCalib_dir,'\laser_filter\C1.mat']); 
C1 = c1.C;
c2=load([CoarseCalib_dir,'\laser_filter\C2.mat']); 
C2 = c2.C;


%% ���ӻ�δ�Ż��ı궨�����µĽ��
frame=10;
img = imread(sprintf('%s/img_target%d.jpg',CoarseCalib_dir,frame));
% velo1 = load(sprintf('%s/laser_filter/my_laser%d.txt',file_dir,frame));
velo1 = load(sprintf('%s/laser_target%d.xyz',CoarseCalib_dir,frame));
project_show(velo1(:,1:3), img, C1, K_int1)
%% ��������,�������ݽ���Ԥ����
% i=1;
% for f =1:1:9
%     % ͼ��Ԥ����
%     f
%     img = imread(sprintf('%s/my_pic%d.jpg',test_file,f));
%     img = rgb2gray(img);
% %     img = img(350:end,1:end);
% %     Data(i).img = img;
%     D = Inverse_DT(img,alpha,gamma1); % �õ�Dͼ��
%     Data(i).D = D;
%     % ����Ԥ����
% %     velo = load(sprintf('%s/laser_filter/my_laser%d.txt',test_file,f));
%     velo = load(sprintf('%s/my_laser%d.txt',test_file,f));
%     itx = velo(:,1)<5 | velo(:,2)<-40;
%     velo(itx,:)=[];
%     velo(:,6)=sqrt(power(velo(:,1),2)+power(velo(:,2),2)+power(velo(:,3),2));
% %     Data(i).velo = velo;
%     X = PC_filter(velo, gamma2, beam_num); % X=[x,y,z,Xpi]' ���õ�X����
%     % pcshow(X(:,1:3),'MarkerSize' ,20)
%     Data(i).X =  X;
%     i = i+1;
% end
% load('matlab.mat');
%% �����㷨
% �����ռ�
delta_t = 0.1; % cm,ƽ��������ƫ����
delta_R = 0.1/180.*pi; % �Ƕ�ƫ����
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
    disp('��ʼ����JC')
    for CC_num=1:1:729
        JC_f = 0;
        C_f = CC(CC_num,:);
        for f = 1:1:9
            % ͼ��Ԥ����,�õ�Dͼ��
            D = Data(f).D;
            % ���ص���,�õ�X����,X=[x,y,z,Xpi]' ��
            X = Data(f).X;
            uv = xyz2uv(X, C_f, K_int); % uv=[u,v,Xpi]
            % ����-�����䵽ͼ��ƽ������ص�     
            ithx = find(uv(:,1)<img_w & uv(:,1)>0 & uv(:,2)<img_h & uv(:,2)>0);
%             ithx = find(uv(:,1)<img_h-50 & uv(:,1)>50 & uv(:,2)<img_w-50 & uv(:,2)>50);
            uv_f = uv(ithx,:);
            % �����f֡����ͶӰ��JC
            JC0 = obj_func(uv_f,D);
            JC_f = JC_f+JC0;
        end
        JC(CC_num,1) = JC_f;
        % fprintf('�������%d��C\n',CC_num)
    end
    [~,I] = max(JC(:,1));
    C_max = CC(I,:);
    fprintf('��ɵ�%d������\n',iter_count)
    iter_count = iter_count+1;
end

C_optm0 = C_max;
% ���ӻ��Ż���ı궨�����µĽ��
frame=1;
img = imread(sprintf('%s/my_pic%d.jpg',test_file,frame));
velo1 = load(sprintf('%s/my_laser%d.txt',test_file,frame));
% img = imread(sprintf('%s/my_pic%d.jpg',test_file,frame));
% velo1 = load(sprintf('%s/laser_filter/my_laser%d.txt',test_file,frame));
project_show(velo1(:,1:3), img, C_optm0, K_int)
% hold on
% project_show(velo1(:,1:3), img, C, K_int)
%% ����JC
% JC=[];
% disp('��ʼ����JC')
% for CC_num=1:1:729
%     JC1 = 0;
%     for n=w:w:18
%         for f = (n-w+1):1:n
%             % ͼ��Ԥ����
%             img = Data(f).img;
%             D = Inverse_DT(img,alpha,gamma1); % �õ�Dͼ��
%             % ���ص��ƣ�process���ĵ��ƣ�
%             velo = Data(f).velo;
%             X = PC_filter(velo, gamma2, beam_num); % X=[x,y,z,Xpi]' ���õ�X����
%             uv = xyz2uv(X, CC(CC_num,:), K_int);
%             % ����-�����䵽ͼ��ƽ������ص�
%             [a, b]=size(img);
%             ithx = find(uv(:,1)<a & uv(:,1)>0 & uv(:,2)<b & uv(:,2)>0);
%             uv_f = uv(ithx,:);
%             % �����f֡����ͶӰ��JC
%             JC0 = obj_func(uv_f,D);
%             JC1 = JC1+JC0;
%         end
%     end
%     JC = [JC;JC1];
%     CC_num
% end

% [M,I] = max(JC(:,1));
% C_max = CC(I,:);


%% ���ӻ��Ż���ı궨�����µĽ��
% frame=20;
% img = imread(sprintf('%s/my_pic%d.jpg',test_file,frame));
% % velo1 = load(sprintf('%s/laser_filter/my_laser%d.txt',file_dir,frame));
% velo1 = load(sprintf('%s/my_laser%d.txt',test_file,frame));
% project_show(velo1(:,1:3), img, C_max, K_int)

