save_file = '/media/jing/Jing/Year_1/Calibration/CoarseCalibration/laser_filter3';

file_dir = '/media/jing/DATA/20180502/dataSet/velo/';
veloDir = dir(sprintf('%s/*.bin', file_dir));

% img_dir = '/media/jing/Jing/Year_1/Calibration/CoarseCalibration/img/';
img_dir = '/media/jing/Jing/Year_1/Calibration/CoarseCalibration/laser_filter3/img/';
imgDir = dir(sprintf('%s/*.jpg', img_dir));
for i=1:1:length(imgDir)
    Str = imgDir(i).name;
    imgF=[img_dir, Str];
    img = imread(imgF);
    
    str = sprintf('%s/img/img_target%d.jpg',save_file, i);
    imwrite(img,str,'JPG');
    
    % 找对应的点云
    str_same = Str(4:10);
    for j=1:1:length(veloDir)
        StrVelo = veloDir(j).name;
        if (StrVelo(5:11)==str_same)
                velox=[file_dir, StrVelo];
                fileID = fopen(velox,'r');
                velo = fread(fileID,[112512,4],'double');
                fclose(fileID);

                vePSec = veloPolarSector(velo,80);
                itx = vePSec(:,1)<7 & vePSec(:,1)>0 & ...
                         vePSec(:,3)>-1.8 & vePSec(:,3)<0.5;
            %      vePSec(:,2)<y_max & vePSec(:,2)>y_min & ...
                velo1 = vePSec(itx,1:3);

                strvelo1 = sprintf('%s/laser/laser_target%d.xyz',save_file,i);
                save(strvelo1,'velo1','-ascii')
        end
        
    end
    
    
end


for i=1:1:length(veloDir)
    Str = veloDir(i).name;
    velox=[file_dir, Str];
    fileID = fopen(velox,'r');
    velo = fread(fileID,[112512,4],'double');
    fclose(fileID);
    
    vePSec = veloPolarSector(velo,80);
    itx = vePSec(:,1)<7 & vePSec(:,1)>0 & ...
      vePSec(:,3)>-1.8 & vePSec(:,3)<0.5;
%      vePSec(:,2)<y_max & vePSec(:,2)>y_min & ...
    velo1 = vePSec(itx,1:3);
    
    str = sprintf('%s/laser_target%d.xyz',save_file, i);
    save(str,'velo1','-ascii')
    
end



