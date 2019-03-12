addpath(genpath('/Users/nikos/Documents/MATLAB/NIfTI'))
path_file='~/NTS'

close all
tstat=strcat(path_file,'/NTS_R_05_cr.nii');
%load data
nii_img=load_untouch_nii(tstat);
vol=nii_img.img;

tstat=strcat(path_file,'/NTS_L_05_cr.nii');
%load data
nii_img2=load_untouch_nii(tstat2);
vol2=nii_img2.img;

vol=vol+vol2;
tstat=strcat(path_file,'/Brainstem_bin05_crop.nii');

%load data
nii_img_lc=load_untouch_nii(strcat(rois_lc));
vol_lc=nii_img_lc.img;

threshold=0.4; 
data=zeros(size(vol));
data(find((vol_lc>0)&(vol<=threshold)))=0.01;
data(find((vol_lc>0)&(vol>threshold)))=vol(find((vol_lc>0)&(vol>threshold)));

%crop volume to only
vol_lc_cropped=zeros(size(vol));
vol_lc_cropped(find(data>0.01))=1;

  
%make surface
surf=isosurface(vol_lc,vol_lc);
figure;
p=patch(surf);
alpha 0.1
p.FaceColor = 'k';
p.EdgeColor = 'none';
%view(150,30) 
daspect([1 1 1])
camlight 
lighting gouraud
axis off
hold on;
surf=isosurface(vol_lc_cropped,data);
p=patch(surf);
%alpha 0.5
p.FaceColor = 'green';
p.FaceColor = [0.324,1,0.578];

p.EdgeColor = 'none';

%set camera angle
% set(gca, 'CameraPosition', [160 165 80]);
%camzoom(1.4)

        
  
