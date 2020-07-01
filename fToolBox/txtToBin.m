% laser_Path = 'F:\Year_1_上\Calibration\dataset\2018_03_21_data\2018_03_21_data2\pair_data\velo';
% laser_Path = 'F:\Year_1_上\Calibration\dataset\2018_03_21_data\2018_03_21_data2\velo';
laser_Path = 'F:\Year_1_上\Calibration\dataset\2018_03_21_data\2018_03_21_biaoding\laser';
laserDir = dir(sprintf('%s/*.txt', laser_Path));
a=linspace(1,225024,225024)';a=a(:)-1;itx=mod(floor(a(:)/64),2); % 去除对偶模式
% save_f='F:\Year_1_上\Calibration\dataset\2018_03_21_data\2018_03_21_data2\pair_data\velo1';
% save_f='F:\Year_1_上\Calibration\dataset\2018_03_21_data\2018_03_21_data2\velo1';
save_f='F:\Year_1_上\Calibration\dataset\2018_03_21_data\2018_03_21_biaoding\velo';

for i=1:1:length(laserDir)
    str = laserDir(i).name;
    velo1 = load(sprintf('%s/%s',laser_Path,str));
%     velo1 = load(sprintf('%s/velo_%06d.txt',laser_Path,i));
    velo=velo1(itx==0,:);% 去除对偶模式
    
    str_velo=sprintf('%s/velo_%06d.bin',save_f,i);
%     str1=[str(1:23) '.bin'];
%     str_velo=sprintf('%s/%s',save_f,str1);
    fileID = fopen(str_velo,'wb');
    fwrite(fileID,velo,'double');
    fclose(fileID);
    i
end
