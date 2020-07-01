% img_Path = 'F:\Year_1\Calibration\dataset\2018_03_21_data\2018_03_21_data3\img-cal\';
img_Path = '/media/jing/DATA/20180503/calibration/img-cal/';
%img_Path ='/media/jing/DATA/20180502/img-cal/';
imgDir = dir(sprintf('%s/*.jpg', img_Path)); % imgDir  = dir([img_Path '*.jpg']);
img_time=[];
for imgID = 1:1:length(imgDir)
    Str = imgDir(imgID).name;
    imgName(imgID).fullName=Str;
    hour = str2double(Str(12:13));
    minute = str2double(Str(15:16));
    second = str2double(Str(18:19));
    millisecond = str2double(Str(21:23));
    imgTime = millisecond +1000*second + minute*60*1000+hour*60*60*1000; % ��λ����
    img_time = [img_time; imgTime];
    imgName(imgID).imgTime=imgTime;
end

laser_Path = '/media/jing/DATA/20180503/calibration/lidar/';
% laser_Path = 'F:\Year_1\Calibration\dataset\2018_03_21_data\2018_03_21_data3\velo\';
% laser_Path = 'F:\Year_1\Calibration\dataset\siyuan_20180101\0005\0005HDL\';
laserDir = dir(sprintf('%s/*.dat', laser_Path));
laser_time = [];
for laserID = 1:1:length(laserDir) 
    Str = laserDir(laserID).name;
    laserName(laserID).fullName=Str;
    hour = str2double(Str(12:13));
    minute = str2double(Str(15:16));
    second = str2double(Str(18:19));
    millisecond = str2double(Str(21:23));
    laserTime = millisecond +1000*second + minute*60*1000+hour*60*60*1000;
    laser_time = [laser_time;laserTime];
    laserName(laserID).laserTime=laserTime;
end

%% laser��imgID
for i=1:1:length(laserName)
    time_sub = abs(img_time-laserName(i).laserTime);
    [temp,Near_img_ID] = min(time_sub);
    laserName(i).match_imgName = imgName(Near_img_ID).fullName;
    laserName(i).timeSub = temp;
end

% ��ʱ���̫���֡
frame_timeSub=[];
for i=1:length(laserName)
    frame_timeSub=[frame_timeSub; laserName(i).timeSub];
end
%itx = find(frame_timeSub>25); % �������20Hz
itx = find(frame_timeSub>25); 
laserName(itx)=[];

%% lidar-cam 
% save_f='F:\Year_1\Calibration\dataset\siyuan_20180101\pair_data\';
% save_f='F:\Year_1\Calibration\dataset\2018_03_21_data\2018_03_21_data3\pair_data\';
save_f='/media/jing/DATA/20180503/calibration/dataSet/';
R_coor = [0 1 0;-1 0 0;0 0 1];
num_velo = length(laserName);
a=linspace(1,225024,225024)';a=a(:)-1;itx=mod(floor(a(:)/64),2);

j=1;
for i=5:1:num_velo-1
    veloName=laserName(i).fullName;
    velod=[laser_Path, veloName];
    fileID = fopen(velod,'rb');
    velo1 = fread(fileID,[4,225024],'double')';
    fclose(fileID);
    lidar=velo1(itx==0,:);
%     fid = fopen(velod,'rb');
%     lidar = fread(fid,[112512,4],'double');
%     fclose(fid);
    
%     lidar=load(velod);
    y = - lidar(:,2); lidar(:,2) = y; % ���ݲɼ�ʱԭʼ����
    
    velo=(R_coor*lidar(:,1:3)')';
    velo(:,4)=lidar(:,4);
    
    str_velo=sprintf('%s/velo/velo_%06d.bin',save_f,j);
    fileID = fopen(str_velo,'wb');
    fwrite(fileID,velo,'double');
    fclose(fileID);
%     save(str_velo,'velo','-ascii');
    
    imgname=laserName(i).match_imgName;
    imgd=[img_Path,imgname];
    img= imread(imgd);
    str_img=sprintf('%s/img/img_%06d.jpg',save_f,j);
    imwrite(img,str_img)

    j=j+1
end

%% �����Ӧ��ͼ����ƶ�
% save_file = 'F:\code\calib_camlaser\Calibration\�Ĵ�_����\20180101\0004\coarse_calibration';
% for i=1:1:length(imgName)
%     img_file = [img_Path,imgName(i).fullName];
%     img = imread(img_file);
%     imwrite(img,sprintf('%s/img_target%d.jpg',save_file,i));
%     
%     laser_file=[laser_Path,imgName(i).match_laserName];
%     lidar=load(laser_file);
%     y = - lidar(:,2);
%     lidar(:,2) = y;
%     str_name = sprintf('%s/laser_target%d.xyz',save_file,i);
%     % �ֱ궨�������ݣ���ʽnx3(ֻ��xyz����)
%     lidar1=lidar(:,1:3);
%     save(str_name,'lidar1','-ascii');
% end


