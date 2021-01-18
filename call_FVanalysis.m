
function [m, b, fv10K] = call_FVanalysis()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name - call_FVanalysis()
% Creation Date - 31th May 2020
% Author - Charles Belanger Nzakimuena
% Website - https://www.ibis-space.com/
%
% Description - Choriocapillaris flow voids analysis
%
% Parameters -
%	Input
%               Choriocapillaris maximum projection image,
%               size 1536 px by 1527 px
%	Output
%               Bar and log-log plots of number of flow voids 
%                    against area size
%               Log-log plot best fit line parameters (intercept, slope)
%               Fraction of flow voids exceeding 10,000 square micron 
%                   (FV10000)          
%
% Example -
%		[m, b, fv10K] = call_FVanalysis()
%
% License - MIT
%
% Change History -
%                   31th May 2020 - Creation by Charles Belanger Nzakimuena
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% *add folders containing the libraries used*
addpath(genpath('./subfunctions'))

%% *load choriocapillaris maximum projection image*
choroidIm = imread('norm.tif');
newIm = im2double(choroidIm);

%% *uncomment below for image resizing option*

% inputIm = imresize(inputIm, [304 304]);
% BW = phansalkar(inputIm, [15 15]); 

%% *Phansalkar binarization*

% automated window size adjustment based on input image size
windowSize = round(size(newIm ,1)/(304/15));
BW = phansalkar(newIm, [windowSize windowSize]);
BW2 = imcomplement(BW);

%% *Choriocapillaris flow voids analysis*

[m, b, fv10K] = cc_Trends(BW2);

end