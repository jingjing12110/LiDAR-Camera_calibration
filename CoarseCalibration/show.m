
%% calibration parameters
kin_last_time=[1052.89986,   0,    978.2096,   0;
         0,  1052.79659, 602.76635,   0;
         0,     0,      1,      0]; % toolbox
     
 kin=[1073.502956,   0,   975.31449,   0;
         0,  1072.78376, 593.57353,   0;
         0,     0,      1,      0]; % toolbox    
     
 kin40=[1072.958,   0,   974.515787,   0;
         0,  1073.241386, 594.6579469,   0;
         0,     0,      1,      0]; % toolbox    

kin1=[1073.00343318955,0,976.689388046069,0;
    0,1072.67674127265,593.120543183964,0;
    0,0,1,0];

% kout=C2RT(C);

% t = [ -0.129769 ; -0.254210 ; -0.499214 ];
% R = [ 0.031323  -0.994847  0.096427 ;...
%   -0.135709  -0.099814  -0.985708 ;...
%   0.990253  0.017790  -0.138136 ];
% kout = eye(4); kout(1:3,1:3)=R;kout(1:3,4)=t;
% 
% kout2=eye(4); % I optimal
% t2 = [ 0.027946 ; -0.216214 ; -0.606374 ];
% R2 =[ -0.015067  -0.999521  0.027043 ;
%   -0.075554  -0.025830  -0.996807 ;
%   0.997028  -0.017062  -0.075129 ];
% kout2(1:3,1:3)=R2;kout2(1:3,4)=t2;

kout=zeros(4,4);kout(4,4)=1;
T1=[   -0.0014   -0.9967    0.0817    0.0174
         -0.0506   -0.0815   -0.9954   -0.1056
          0.9987   -0.0055   -0.0503   -0.4871];
      
T2=[   -0.0076   -0.9995    0.0301    0.0328
       -0.0788   -0.0295   -0.9965   -0.1340
        0.9969   -0.0099   -0.0786   -0.4994]; %best
    
T22=[   -0.0087   -0.9995    0.0318    0.0391
        -0.0743   -0.0311   -0.9968   -0.1644
         0.9972   -0.0111   -0.0740   -0.4919];  
     
T21=[   -0.0080   -1.0000   -0.0032    0.0412
         0.0071    0.0031   -1.0000   -0.4716
         0.9999   -0.0080    0.0071   -0.4675];
     
T32=[   -0.0103   -0.9999   -0.0070    0.0453
        -0.1040    0.0081   -0.9945   -0.0239
        0.9945   -0.0095   -0.1040   -0.4936]; 
    
% xin
TT1=[ -0.006870  -0.999838    0.016651  0.011366
           -0.021865  -0.016497  -0.999625  -0.412449
            0.999737  -0.007232  -0.021748  -0.406370];

TT2=[-0.010108  -0.999888  0.011037  0.011800 
    -0.029162  -0.010738  -0.999517  -0.332884
     0.999524  -0.010425  -0.029050  -0.406642];
 
 TT22=[ -0.0111   -0.9997    0.0237    0.0147
              -0.0145   -0.0235   -0.9996   -0.3310
               0.9998   -0.0114   -0.0142   -0.4047];
           

kout(1:3,:)=T2; 
kout_S=[   -0.0110   -0.9996    0.0247    0.0127
   -0.0145   -0.0246   -0.9996   -0.3330
    0.9998   -0.0114   -0.0142   -0.4047
         0         0         0    1.0000];
     
C0 = [ 0.0118   -0.3329   -0.4066   -2.7970   -1.5399   -1.9045];

C_last=[0.0328   -0.1340   -0.4994   -3.0163   -1.4915   -1.6669];
C = [ 0.0328   -0.1340   -0.4994   -2.7970   -1.535    -1.9045];
kout_s=C2RT(C);

P_velo_to_img = kin*kout;

% P_velo_to_img=[    0.9656   -1.0728   -0.0308   -0.4190
%     0.5400   -0.0274   -1.0930   -0.5203
%     0.0010   -0.0000   -0.0001   -0.0005];
%% 可视化
frame = 5;%352;%116;%45
base_dir = '/media/jing/DATA/20180502/search/data3/dataSet/';
% base_dir = '/media/jing/DATA/20184092/dataSet/';
%veloDir = dir(sprintf('%s/velo/*.bin', base_dir));
velox = sprintf('%s/velo/velo_%06d.bin', base_dir,frame);
fileID = fopen(velox,'r');
velo1 = fread(fileID,[112512,4],'double');
fclose(fileID); %read

velo = veloPolarSector(velo1,82);
itx = velo(:,4)==0;
velo(itx,:)=[];
idx1 = velo(:,1)<5;
velo(idx1,:) = [];
velo_img = project(velo(:,1:3),P_velo_to_img);

img = imread(sprintf('%s/img/img_%06d.jpg',base_dir, frame));
fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
imshow(img); hold on;

%velo_img = project(velo(:,1:3),P_velo_to_img);

cols = jet;
for i=1:size(velo_img,1)
  col_idx = round(64*5/velo(i,1));
  plot(velo_img(i,1),velo_img(i,2),'o','LineWidth',2,'MarkerSize',1,'Color',cols(col_idx,:));
end


%% data
% base_dir = '/media/jing/DATA/20180502/search/data4/';
% % base_dir = 'H:\Year_1_��\Calibration\CoarseCalibration\';
% veloDir = dir(sprintf('%s/velo/*.bin', base_dir));
% imgDir = dir(sprintf('%s/img/*.jpg', base_dir));
% save_dir = 'C:\Users\kaka\Desktop\img';
% a=160;
% for i=1:1:length(veloDir)
%     Str1 = veloDir(i).name;
%     velox=[veloDir(i).folder,'\', Str1];
%     fileID = fopen(velox,'r');
%     velo1 = fread(fileID,[112512,4],'double');
%     fclose(fileID); %read
%     
%     velo = veloPolarSector(velo1,82);
%     itx = velo(:,4)==0;
%     velo(itx,:)=[];
%     idx1 = velo(:,1)<5;
%     velo(idx1,:) = [];
%    % velo = velo(1:3:end,:);
%     velo_img = project(velo(:,1:3),P_velo_to_img);
%     
%     Str2 = imgDir(i).name;
%     imgF=[imgDir(i).folder,'\', Str2];
%     img = imread(imgF); %read
%     img=img(200:900,:,:);
%     
%     fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
%     imshow(img); hold on;
%     
%     cols = jet;
%     for j=1:size(velo_img,1)
%       col_idx = round(64*5/velo(j,1));
%       plot(velo_img(j,1),velo_img(j,2),'o','LineWidth',2,'MarkerSize',2,'Color',cols(col_idx,:));
% %       plot(velo_img(j,1),velo_img(j,2),'o','markerfacecolor',cols(col_idx,:));
%     end
% 
%     str=sprintf('%s/%d.jpg', save_dir,a);
%     saveas(gcf,str,'jpg');
%     close all
%     a=a+1;
% end
% 
% frame = 10;
% velo = load(sprintf('%s/velo/velo_%06d.txt',base_dir,frame));
% % x=velo(:,2); y=-velo(:,1);
% % velo1=velo(:,1:3); velo1(:,1)=x; velo1(:,2)=y;
% % idx = velo1(:,1)<5 | velo1(:,1)>25 | velo1(:,2)<-9 | velo1(:,2)>9;
% % velo1(idx,:) = [];
% itx1=velo(:,1)<5;
% velo(itx1,:)=[];
% velo = velo(1:2:end,:);
% 
% img = imread(sprintf('%s/img_resize/img_%06d.jpg',base_dir, frame));
% fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
% imshow(img); hold on;
% 
% velo_img = project(velo(:,1:3),P_velo_to_img);
% 
% cols = jet;
% for i=1:size(velo_img,1)
%   col_idx = round(64*5/velo(i,1));
%   plot(velo_img(i,1),velo_img(i,2),'o','LineWidth',2,'MarkerSize',1,'Color',cols(col_idx,:));
% end
% 


