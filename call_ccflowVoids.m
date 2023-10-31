
function call_ccflowVoids()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name - ccflowVoids
% Creation Date - 17th January 2021
% Author - C. M. Belanger Nzakimuena
%
% Description - 
%   ccflowVoids gives parameter values corresponding to ETDRS subfieds in 
%   table format. 
%
% Example -
%		call_ccflowVoids()
%
% License - MIT
%
% Change History -
%                   17th January 2021 - Creation by C. M. Belanger Nzakimuena
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath('./subfunctions'))

%% list names of folders inside the patients folder

currentFolder = pwd;
patientsFolder = fullfile(currentFolder, 'processed');
myDir = dir(patientsFolder);
dirFlags = [myDir.isdir] & ~strcmp({myDir.name},'.') & ~strcmp({myDir.name},'..');
nameFolds = myDir(dirFlags);

%% for each 3x3 subfolder, turn segmented data into network graph

% get table row count
rowCount = 0;
for g = 1:numel(nameFolds)
    folder2 = fullfile(patientsFolder, nameFolds(g).name);
    patientDir2 = dir(fullfile(folder2, 'Results'));
    dirFlags2 = [patientDir2.isdir] & ~strcmp({patientDir2.name},'.') & ~strcmp({patientDir2.name},'..');
    subFolders2 = patientDir2(dirFlags2);
    rowCount = rowCount + numel(subFolders2);
end

col = zeros(rowCount,1);
colc = cell(rowCount,1);
ccTable1 = table(colc,col,col,col,col,col,col,...
    'VariableNames',{'id' 'totalArea' 'region1' 'region2' 'region3' 'region4'...
    'region5'});
ccTable2 = table(colc,col,col,col,col,col,col,...
    'VariableNames',{'id' 'totalVolume' 'region1' 'region2' 'region3' 'region4'...
    'region5'});
ccTable3 = table(colc,col,col,col,col,col,col,...
    'VariableNames',{'id' 'totalVolume' 'region1' 'region2' 'region3' 'region4'...
    'region5'});

tableRow = 0;
for i = 1:numel(nameFolds)
    
    % assemble patient folder string
    folder = fullfile(patientsFolder, nameFolds(i).name);
    
    % add line to LOG
    disp(logit(folder, ['Initiating cc_flowVoids; ' nameFolds(i).name ' folder']))
    
    patientDir = dir(fullfile(folder, 'Results'));
    dirFlags = [patientDir.isdir] & ~strcmp({patientDir.name},'.') & ~strcmp({patientDir.name},'..');
    subFolders = patientDir(dirFlags);

    for k = 1:numel(subFolders)
        
        nameFold = subFolders(k).name;
        scanType = nameFold(1:2);
        addpath(genpath('./drusenFunctions'))
        
        if strcmp(scanType, '3m')
            
            load(fullfile(folder,'Results', nameFold,'segmentation.mat'));
            load(fullfile(folder,'Results', nameFold,'scanInfo.mat'));   
            load(fullfile(folder,'Results', nameFold, 'ETDRS_grid','2DregionsETDRS.mat')); 
            load(fullfile(folder,'Results', nameFold, 'ETDRS_grid','3DregionsETDRS.mat')); 
            sizeRed = scanTag{2};
            
            ccMask = cc_Mask(volumeStruc, volumeFlow, lBM);
            numcols2 = round(size(ccMask, 1)*sizeRed);
            numrows2 = round(size(ccMask, 2)*sizeRed);
            ccMask_BW = imresize(ccMask,[numcols2 numrows2]);
            imwrite(ccMask_BW,fullfile([folder,'\Results\', nameFold, '\ccMask_BW' '.png']));
            %figure;imshow(maxMask_BW,[])    
            
            % 2D ETDRS regions setup
            disp('begin cc_Trends')
            [m_Profile, b_Profile, fv10K_Profile] = cc_Trends2(ccMask, regionsETDRS);
            disp('end cc_Trends')
            
            % For left eye, ETDRS regions must be modified from OD nomenclature
            % to OS nomenclature
            if contains(nameFold, '_OS_')
                mRegion3 = m_Profile(6);
                mRegion5 = m_Profile(4);
                m_Profile(4) = mRegion3;
                m_Profile(6) = mRegion5;
                
                bRegion3 = b_Profile(6);
                bRegion5 = b_Profile(4);
                b_Profile(4) = bRegion3;
                b_Profile(6) = bRegion5;

                fv10KRegion3 = fv10K_Profile(6);
                fv10KRegion5 = fv10K_Profile(4);
                fv10K_Profile(4) = fv10KRegion3;
                fv10K_Profile(6) = fv10KRegion5;
                
            end
  
            tableRow = tableRow + 1;
            
            ccTable1{tableRow,'id'} = {nameFold};
            ccTable1{tableRow,'totalArea'} = m_Profile(1);
            ccTable1{tableRow,'region1'}  = m_Profile(2);
            ccTable1{tableRow,'region2'} = m_Profile(3);
            ccTable1{tableRow,'region3'} = m_Profile(4);
            ccTable1{tableRow,'region4'} = m_Profile(5);
            ccTable1{tableRow,'region5'} = m_Profile(6);
           
            ccTable2{tableRow,'id'} = {nameFold};
            ccTable2{tableRow,'totalVolume'} = b_Profile(1);
            ccTable2{tableRow,'region1'}  = b_Profile(2);
            ccTable2{tableRow,'region2'} = b_Profile(3);
            ccTable2{tableRow,'region3'} = b_Profile(4);
            ccTable2{tableRow,'region4'} = b_Profile(5);
            ccTable2{tableRow,'region5'} = b_Profile(6);
           
            ccTable3{tableRow,'id'} = {nameFold};
            ccTable3{tableRow,'totalVolume'} = fv10K_Profile(1);
            ccTable3{tableRow,'region1'}  = fv10K_Profile(2);
            ccTable3{tableRow,'region2'} = fv10K_Profile(3);
            ccTable3{tableRow,'region3'} = fv10K_Profile(4);
            ccTable3{tableRow,'region4'} = fv10K_Profile(5);
            ccTable3{tableRow,'region5'} = fv10K_Profile(6);            

        end
    end
    
end

fileName1 = fullfile(patientsFolder,'ccTable1_m.xls');
fileName2 = fullfile(patientsFolder,'ccTable2_b.xls');
fileName3 = fullfile(patientsFolder,'ccTable3_fv10K.xls');
writetable(ccTable1,fileName1)
writetable(ccTable2,fileName2)
writetable(ccTable3,fileName3)

disp(logit(patientsFolder,'Done cc_flowVoids'))

            
            