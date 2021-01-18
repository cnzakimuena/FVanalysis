
function [vol1, vol2] = cc_volROI(Volume1, Volume2, l_lim)

    vol1 = zeros(size(Volume1));
    vol2 = zeros(size(Volume1));
%     vol3 = zeros(size(Volume1));
    
    for vv = 1:size(Volume1, 3) % for all B-scans    
        im1 = Volume1(:,:,vv); % current B-scan
        im2 = Volume2(:,:,vv); % current B-scan
%         im3 = Volume3(:,:,vv);
        
        % create a mask with ones in the area of interest
        cropMask = zeros(size(im1));
%         wt = 16; % 31 um below BM, i.e., 31um/(1.953um/px) = ~16px
%         wb = 22; % 10 um thick, i.e., 10um/(1.953um/px) = ~6px

%         wt = 18; % 34 um below BM, i.e., 34um/(1.953um/px) = ~18px
%         wb = 24; % 10 um thick, i.e., 10um/(1.953um/px) = ~6px

        % slab sampled as follows provides best results
        wt = 4; % 8 um below BM, i.e., 8um/(1.953um/px) = ~4px 
        wb = 10; % 10 um thick, i.e., 10um/(1.953um/px) = ~6px 
         
        % for the current B-scan, iterate through each A-scan column
        for rr = 1:size(cropMask, 2)
            % assign 1 at given A-scan slab location
            cropMask(l_lim(vv,rr)+wt:l_lim(vv,rr)+wb,rr) = 1;
        end
        
        im1 = cropMask.*im1;
        im2 = cropMask.*im2; 
%         im3 = cropMask.*im3; 
        vol1(:,:,vv) = im1; % assign cropped image to new volume
        vol2(:,:,vv) = im2; % assign cropped image to new volume
%         vol3(:,:,vv) = im3;
    end 
    
    vol_t = min(min(l_lim))+wt; % whole volume depth cropping top location
    vol_b = max(max(l_lim))+wb; % whole volume depth cropping bottom location

%     vol1 = uint8(mat2gray(vol1(vol_t:vol_b,:,:))*255);
%     vol2 = uint8(mat2gray(vol2(vol_t:vol_b,:,:))*255);
%     vol3 = uint8(mat2gray(vol3(vol_t:vol_b,:,:))*255);
    
    vol1 = vol1(vol_t:vol_b,:,:);
    vol2 = vol2(vol_t:vol_b,:,:);
%     vol3 = vol3(vol_t:vol_b,:,:);
    
    
end 