% function showCalibProject()
%% 加载标定参数
K_int=[1017.48,   0,    961.94,   0;
         0,  1035.35,   459.18,   0;
         0,       0,     1.0,     0];
C = [ -0.1298   -0.2542   -0.4992    2.945   -1.49   -1.3580];
Tr=C2RT(C);

%% 可视化
img_Path ='F:\Year_1_上\Calibration\dataset\siyuan_20180101\pair_data\img_resize\';
velo_Path ='F:\Year_1_上\Calibration\dataset\siyuan_20180101\pair_data\velo\';
imgDir  = dir([img_Path '*.jpg']);
veloDir  = dir([velo_Path '*.bin']);
for j=10:length(imgDir)
    img_file = [img_Path,imgDir(j).name];
    img= imread(img_file);

    velo_file = [velo_Path,veloDir(j).name];
    %     fid = fopen(str_velo,'rb');
%     data = fread(fid,[112512,4],'double');
%     fclose(fid);
    
    fid = open(velo_file,'rb');
    velo = fread(fid,[112512,4],'double');
    fclose(fid);
    
%     velo= load(velo_file);
    project_show(velo(:,1:3), img, C, K_int)

end


