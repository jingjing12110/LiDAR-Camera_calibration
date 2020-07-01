laser_Path = 'G:\20180417\20180417jiansudai2\dataSet\velo';
laserDir = dir(sprintf('%s/*.bin', laser_Path));

save_f='G:\20180417\20180417jiansudai2\dataSet\velo_txt';

for i=25:1:length(laserDir)
    str = laserDir(i).name;
    str_velo=sprintf('%s/velo_%06d.bin',laser_Path,i);
    fileID = fopen(str_velo,'rb');
    velo=fread(fileID,[112512,4],'double');
    fclose(fileID);
    
    str_velo1=sprintf('%s/velo_%06d.txt',save_f,i);
    save(str_velo1,'velo','-ascii');

    i
end
