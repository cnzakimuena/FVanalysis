

function  [mProfile, bProfile, fv10KProfile] = cc_Trends2(chorioMask, rETDRS)

%total drusen area

% 3000um X 2980um gives 8940000um^2, divided by the total number of pixels
% to obtain the conversion factor in um^2/px
convFac = ((size(chorioMask,1)*3000/1536)*(size(chorioMask,2)*3000/1536))/(size(chorioMask,1)*size(chorioMask,2));

% actual number of pixels in the region, returned as a scalar; the input
% must be a logical matrix
statsBW = regionprops(chorioMask,'Area');
% areas in px are multiplied by the conversion factor (um^2/px)
statsMat = cell2mat(struct2cell(statsBW))*convFac;
[total_m, total_b, total_fv10K] = cc_getFeat2(statsMat);

% modify 3D volume aspect ratio
% dimension increased
decNewDimA = size(chorioMask, 1);
decNewDimB = size(chorioMask, 2);
decNewDimV = round(size(rETDRS, 3));
% returns the volume B that has the number of rows, columns, and planes
% specified by the three-element vector [numrows numcols numplanes].
rETDRS_BW = imbinarize(imresize3(rETDRS,[decNewDimA decNewDimB decNewDimV]));
%figure;imshow3D(rETDRS_BW,[])

mGR = zeros(1, size(rETDRS_BW, 3));
bGR = zeros(1, size(rETDRS_BW, 3));
fv10KGR = zeros(1, size(rETDRS_BW, 3));
for k = 1:size(rETDRS_BW, 3)
    
    % actual number of pixels in the region, returned as a scalar; the input
    % must be a logical matrix
    tempMask = chorioMask;
    tempMask(logical(~rETDRS_BW(:,:,k))) = 0;
    curr_statsBW = regionprops(tempMask,'Area');
    % areas in px are multiplied by the conversion factor (um^2/px)
    curr_statsMat = cell2mat(struct2cell(curr_statsBW))*convFac;
    [para_m, para_b, para_fv10K] = cc_getFeat2(curr_statsMat);

    mGR(:, k) = para_m; % at given grid region, um^2
    bGR(:, k) = para_b;
    fv10KGR(:, k) = para_fv10K;
    
end

mProfile = [total_m mGR]; % um^2
bProfile = [total_b bGR]; % um^2
fv10KProfile = [total_fv10K fv10KGR]; % um^2 
% figure;imshow(chorioMask,[])

% sub_maxBW = chorioMask.*logical(regionsETDRS(:,:,1));
% figure;imshow(sub_maxBW,[])
% nnz(sub_maxBW) % sum of non-zeros for region 1 of chroidMap
% sum(sum((logical(regionsETDRS(:,:,1))))) % sum of non-zeros for ETDRS 1


end