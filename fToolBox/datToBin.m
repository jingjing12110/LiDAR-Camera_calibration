% laser_Path = 'F:\Year_1_上\Calibration\dataset\2018_03_21_data\2018_03_21_data3\lidar\';
% save_Path = 'F:\Year_1_上\Calibration\dataset\2018_03_21_data\2018_03_21_data3\velo';
laser_Path = 'F:\20184092\lidar\';
save_Path = 'F:\20184092\velo';
laserDir = dir(sprintf('%s/*.dat', laser_Path));
% numFrame = length(laserDir)/4;
numFrame = length(laserDir);
a=linspace(1,225024,225024)';a=a(:)-1;itx=mod(floor(a(:)/64),2);

for i=2:1:numFrame
    Str = laserDir(i).name;
    velox=[laser_Path, Str];
    fileID = fopen(velox,'r');
    velo1 = fread(fileID,[4,112512],'double')';
    fclose(fileID);
    
%     Str = laserDir(4*i-2).name;
%     veloy=[laser_Path, Str];
%     fileID = fopen(veloy,'rb');
%     y=fread(fileID,[1 inf],'single')';
%     fclose(fileID);
%     
%     Str = laserDir(4*i-1).name;
%     veloz=[laser_Path, Str];
%     fileID = fopen(veloz,'rb');
%     z=fread(fileID,[1 inf],'single')';
%     fclose(fileID);
%     
%     Str = laserDir(4*i).name;
%     velor=[laser_Path, Str];
%     fileID = fopen(velor,'rb');
%     r=fread(fileID,[1 inf],'int32')';
%     fclose(fileID);
%     
%     velo1=[x,y,z,r];
    % 去对偶模式
    velo=velo1(itx==0,:);
    
    % 保存
    veloName = [Str(6:28) '.bin'];
    str_velo=sprintf('%s/%s',save_Path,veloName);
    fileID = fopen(str_velo,'wb');
    fwrite(fileID,velo,'double');
    fclose(fileID);
%     save(str_velo,'velo','-ascii');

%     fid = fopen(str_velo,'rb');
%     data = fread(fid,[112512,4],'double');
%     fclose(fid);
    
    i

end
