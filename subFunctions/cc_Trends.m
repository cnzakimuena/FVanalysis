

function  [slope, intercept, fraction10K] = cc_Trends(chorioMask)

% 3000um X 2980um gives 8940000um^2, divided by the total number of pixels
% to obtain the conversion factor in um^2/px
convFac = ((size(chorioMask,1)*3000/1536)* ...
    (size(chorioMask,2)*3000/1536))/(size(chorioMask,1)* ...
    size(chorioMask,2));

% actual number of pixels in the region, returned as a scalar; the input
% must be a logical matrix
statsBW = regionprops(chorioMask,'Area');
% areas in px are multiplied by the conversion factor (um^2/px)
statsMat = cell2mat(struct2cell(statsBW))*convFac;
[slope, intercept, fraction10K] = cc_getFeat(statsMat);

end