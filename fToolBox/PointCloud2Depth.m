% function Depth = PointCloud2Depth(velo, C)
% LiDAR to depth
data_dir = 'F:\Year_1\Calibration\dataset\siyuan_20180101\pair_data';
velo1 = load(sprintf('%s/velo/velo_%06d.txt',data_dir,17));
img = imread(sprintf('%s/img_resize/img_%06d.jpg',data_dir,17));
a=linspace(1,225024,225024)';a=a(:)-1;itx=mod(floor(a(:)/64),2);
velo=velo1(itx==0,:);
vePSec = veloPolarSector(velo,80); vePSec(:,5)=vePSec(:,5)+1;
vePSec(:,6)=sqrt(power(vePSec(:,1),2)+power(vePSec(:,2),2)+power(vePSec(:,3),2));
vePSec = PC_filter(vePSec, 0.5, 64);

kin=[1017.48,   0,    961.94,   0;
         0,  1035.35, 659.18-200,   0;
         0,     0,      1,      0]; % toolbox
t = [ -0.129769 ; -0.254210 ; -0.499214 ];
R = [ 0.031323  -0.994847  0.096427 ;...
-0.135709  -0.099814  -0.985708 ;...
0.990253  0.017790  -0.138136 ];
kout = eye(4); kout(1:3,1:3)=R;kout(1:3,4)=t;
P_velo_to_img = kin*kout;

velo_img = project(vePSec(:,1:3),P_velo_to_img);
velo_img(:,3)=vePSec(:,1); % xΪ�Ҷ�ֵ
% velo_img(:,3)=sqrt(power(vePSec(:,1),2)+power(vePSec(:,2),2)+power(vePSec(:,3),2));

col=round(velo_img(:,1)); row=round(velo_img(:,2));
ith1=find(col<1|col>1920|row<1|row>650);
velo_img(ith1,:)=[];

% ���ͼ
depth = zeros(650,1920);
% imgd(col,row)=y(:,3);
for i=1:size(velo_img,1)
    depth(round(velo_img(i,2)),round(velo_img(i,1)))=velo_img(i,3);
end

% depth(round(velo_img(:,2)),round(velo_img(:,1)))=velo_img(:,3);

