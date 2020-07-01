base_dir  = 'F:\Year_1_ио\calib_camlaser\2011_09_26_drive_data';

calib_dir = 'F:\Year_1_ио\calib_camlaser\2011_09_26_calib';

cam       = 2; % 0-based index
frame     = 138; % 0-based index

% load calibration
calib = loadCalibrationCamToCam(fullfile(calib_dir,'calib_cam_to_cam.txt'));
Tr_velo_to_cam = loadCalibrationRigid(fullfile(calib_dir,'calib_velo_to_cam.txt'));

% compute projection matrix velodyne->image plane
R_cam_to_rect = eye(4);
R_cam_to_rect(1:3,1:3) = calib.R_rect{1};
P_velo_to_img = calib.P_rect{cam+1}*R_cam_to_rect*Tr_velo_to_cam;

% % load and display image
% img = imread(sprintf('%s/image_%02d/data/%010d.png',base_dir,cam,frame));
% fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
% imshow(img); hold on;

% load velodyne points
fid = fopen(sprintf('%s/velodyne_points/data/%010d.bin',base_dir,frame),'rb');
velo = fread(fid,[4 inf],'single')';
% velo = velo(1:5:end,:); % remove every 5th point for display speed
fclose(fid);

cols = jet;
col_idx = ceil(64*velo(:,4)+0.00001);
temp = cols(col_idx(:),:);
for i=1:1:length(velo(:,1))
    plot3(velo(i,1),velo(i,2),velo(i,3),'.','LineWidth',4,'MarkerSize',2,'Color',temp(i,1:3));
    hold on
end


% plot(velo_img(i,1),velo_img(i,2),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
% plot points
% cols = jet;
% for i=1:size(velo_img,1)
% %   col_idx = round(64*5/velo(i,1));
%   col_idx = ceil(64*velo(i,4)+0.00001);
%   plot(velo_img(i,1),velo_img(i,2),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
% end
