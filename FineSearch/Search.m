
%%
% file_dir = 'F:\Year_1\Calibration\dataset\siyuan_20180101\pair_data';
% test_file = 'F:\Year_1\Calibration\dataset\siyuan_20180101\pair_data';
load('Data1.mat');

K_int=[1072.958,   0,   974.515787,   0;
         0,  1073.241386, 594.6579469,   0;
         0,       0,     1.0,     0];
% C=C_max;
% C = [ -0.1298   -0.2542   -0.4992    2.945   -1.49   -1.3580];
%C = [ -0.1298   -0.2542   -0.4992    3.0135   -1.4311   -1.3440];
C = [ 0.0147   -0.3310   -0.4047   -2.4656   -1.5526   -2.2232];

%% �����㷨
% �����ռ�
delta_t = 0.003;  delta_R = 0.001; % 
img_h=400;img_w=1920;

C_max = C;  C_optm0 = [0, 0, 0, 0, 0, 0];
max_iter = 100; iter_count = 1;
while(Is_True(C_max,C_optm0)==0)

    C_optm0 = C_max;
    CC = C_729(C_optm0, delta_t, delta_R);
    JC=zeros(729,1);
    disp('start')
    for CC_num=1:1:729
        JC_f = 0;
        C_f = CC(CC_num,:);
        for f = 3
            % ͼ��Ԥ����,�õ�Dͼ��
            D = double(Data(f).D);
            % ���ص���,�õ�X����,X=[x,y,z,Xpi]';
            X = Data(f).X;
            uv = xyz2uv(X, C_f, K_int); % uv=[u,v,Xpi]
            % ����-�����䵽ͼ��ƽ������ص�     
            ithx = find(uv(:,1)<img_w & uv(:,1)>150 & uv(:,2)<img_h & uv(:,2)>1);
            uv_f = uv(ithx,:);
            % �����f֡����ͶӰ��JC
            JC0 = obj_func(uv_f,D);
            JC_f = JC_f+JC0;
        end
        JC(CC_num,1) = JC_f;
        % fprintf('�������%d��C\n',CC_num)
    end
    [maxJC,I] = max(JC(:,1));
    C_max = CC(I,:);
%     dataTab(iter_count).maxJC = maxJC;
%     dataTab(iter_count).C_max = C_max;
    iter_count
    iter_count = iter_count+1;
    
end
% save('dataTab.mat','dataTab');
C_optm0 = C_max;
% 
Tr=C2RT(C_optm0);

img = imread(sprintf('%s/img/img_%06d.jpg',test_file,frame));
velo1 = load(sprintf('%s/velo/velo_%06d.txt',test_file,frame));
% img = imread(sprintf('%s/my_pic%d.jpg',test_file,frame));
% velo1 = load(sprintf('%s/laser_filter/my_laser%d.txt',test_file,frame));
project_show(velo1(:,1:3), img, C_optm0, K_int)
% hold on
% project_show(velo1(:,1:3), img, C, K_int)

