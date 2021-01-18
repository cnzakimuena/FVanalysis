

function  BW2 = cc_Mask(volumeStruc, volumeFlow, lBM)

% addpath(genpath('./chorioFunctions'))

% load 'segmentation.mat' file
% NORMAL EYE
% folder = 'C:\Users\cnzak\OneDrive\Desktop\Audio & Video\Research\temp\...\Results\3mmx3mm_20190131135255_OD';
% AMD EYE
% folder = 'C:\Users\cnzak\OneDrive\Desktop\Audio & Video\Research\temp\AMD\...\Results\3mmx3mm_20190328114737_OS';
% load(fullfile(folder, 'segmentation.mat'))  

% figure;imshow3D(volumeStruc,[])
% % OR, for flow images
% figure;imshow3D(volumeFlow,[])

% % apply PR on whole volumes
% [corr_cube] = PRcorr2(volumeStruc, volumeFlow);

% modify ROI function based on choriocappilaris ROI
[volStruc, volFlow] = cc_volROI(volumeStruc, volumeFlow, lBM);

% figure;imshow3D(volStruc,[])
% figure;imshow3D(volFlow,[])
% figure;imshow3D(corrFlow,[])

% figure; imshow3D(volumeStruc,[],'plot',cat(3,lBM))
% figure; imshow3D(volumeFlow,[],'plot',cat(3,lBM))
% figure; imshow3D(volFlow,[],'plot',cat(3,lBM))

maxStruc = zeros(size(volStruc, 2),size(volStruc, 3));
for i = 1:size(volStruc, 2)
    for ii = 1:size(volStruc, 3)  
    maxStruc(i,ii) = max(volStruc(:,i,ii));
    end
end    

maxFlow = zeros(size(volStruc, 2),size(volStruc, 3));
for i = 1:size(volStruc, 2)
    for ii = 1:size(volStruc, 3)  
    maxFlow(i,ii) = max(volFlow(:,i,ii));
    end
end    

maxStruc = imrotate(imresize(maxStruc,[size(maxStruc, 1) size(maxStruc, 2)*1536/300]),-90);
maxFlow = imrotate(imresize(maxFlow,[size(maxFlow, 1) size(maxFlow, 2)*1536/300]),-90);
% figure;imshow(maxStruc,[])
% figure;imshow(maxFlow,[])

% save('maxIMs.mat','maxStruc','maxFlow')
% imwrite(maxFlow, 'norm.tif')
% imwrite(maxFlow, 'AMD.tif')

%% thresholding

% newIm = imread('norm.tif');
% newIm = imread('AMD.tif');
newIm = im2double(maxFlow);

% inputIm = imresize(inputIm, [304 304]);
% BW = phansalkar(inputIm, [15 15]); 
windowSize = round(size(newIm ,1)/(304/15));
BW = phansalkar(newIm, [windowSize windowSize]);
BW2 = imcomplement(BW);

% figure; imshow([newIm BW2],[])
% imwrite(BW2, 'norm_BW_MATLAB.tif')
% imwrite(BW2, 'AMD_BW_MATLAB.tif')

end