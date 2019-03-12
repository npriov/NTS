addpath(genpath('/Users/nikos/Documents/MATLAB/NIfTI'))

cd('/Users/nikos/Downloads/nts_stuff/mni_direct/');
aa=dir('/Users/nikos/Downloads/nts_stuff/mni_direct/*-mask_L.nii.gz');
listim={aa.name};


%load up data
dd=load_nii(listim{1});
dd=dd.img;
summed=zeros(size(dd));


%for each slice find max value

for image=1:length(listim)
    
    dd=load_nii(listim{image});
    dd=dd.img;

    for slice=1:size(dd,3)
        if (nnz(dd(:,:,slice))~=0)

           temp=dd(:,:,slice);
           [x,y]=find(temp>0);

          summed(x(1),y(1),slice)=1;
          
            
        end
    end
end


aa=dir('/Users/nikos/Downloads/nts_stuff/mni_direct/*-mask_R.nii.gz');
listim={aa.name};

%load up data
dd=load_nii(listim{1});
dd=dd.img;
summedR=zeros(size(dd));

%for each slice find max value

for image=1:length(listim)
    
    dd=load_nii(listim{image});
    dd=dd.img;

    for slice=1:size(dd,3)
        if (nnz(dd(:,:,slice))~=0)

           temp=dd(:,:,slice);
           [x,y]=find(temp>0);

          summedR(x(1),y(1),slice)=1;
          
            
        end
    end
end


% [x,y,z] = ind2sub(size(summed),find(summed >0));
% scatter3(x,y,z,ones(size(x)))
% 
% [xr,yr,zr] = ind2sub(size(summedR),find(summedR >0));
% scatter3(xr,yr,zr,ones(size(xr)))

sumer=summed+summedR;
[xr,yr,zr] = ind2sub(size(sumer),find(sumer >0));
figure(1)
subplot(1,3,1)
scatter3(xr,yr,zr,20,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[ 0.5843 0.8157 0.9882]);hold on;
zticks(15:10:65)
zticklabels([15:10:65]/2-72.5)
xticks(165:10:205)
xticklabels(([165:10:205]-185)/2)
yticks(152:10:182)
yticklabels(([152:10:182]-252)/2)
xlabel('X (mm): Right to Left')
ylabel('Y (mm): Dorsal to Ventral')
zlabel('Z (mm): Caudal to Rostral')
set(gca,'FontSize',14)

%%now get a histogram
c = squeeze(sum(sum(sumer~=0,1)~=0,2));
zr=1:size(sumer,3);
subplot(1,3,2)
bar(zr(find(c>0)),c(find(c>0))/(max(c)+0.2),'FaceColor',[ 0.5843 0.8157 0.9882],'EdgeColor',[0 0.1 0.1],'LineWidth',1.5); hold on;
zlabel('Z (mm): Caudal to Rostral')
xticks(15:10:75)
xticklabels([15:10:75]/2-72.5)
xlabel('Z (mm): Caudal to Rostral')
set(gca,'FontSize',14)
ylabel('Frequency (ratio)')


%calculate centroid for each slice
centroids_deviation=zeros([3 size(sumer,3)]);
for slice=1:size(sumer,3)
    if (nnz(sumer(:,:,slice))>1)
       temp=sumer(:,:,slice);
       [x,y]=find(temp>0);
       centroids_deviation(:,slice)=[median(x),median(y), mahal([median(x)/2,median(y)/2],[x/2,y/2])];
      
    end
end
centroids_deviation(isnan(centroids_deviation))=0;
indx=find(centroids_deviation(1,:)>0);
temp=1:size(centroids_deviation,2);
temp(indx)
subplot(1,3,3)
bar(temp(indx),centroids_deviation(3,indx),'FaceColor',[ 0.5843 0.8157 0.9882],'EdgeColor',[0 0.1 0.1],'LineWidth',1.5); hold on;
xticks(15:10:65)
xticklabels([15:10:65]/2-72.5)
xlabel('Z (mm): Caudal to Rostral')
ylabel('Mahanobis distance (unitless)')
set(gca,'FontSize',14)



