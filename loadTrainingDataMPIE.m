function [ x ] = loadTrainingDataMPIE( numOfLandmark, numOfTrnImgs, filePath, listFile , lmExtension)
%LOADTRAININGDATAMUCT Summary of this function goes here
%   Detailed explanation goes here

x = zeros( 2 * numOfLandmark, numOfTrnImgs);

for iFile = 1: numOfTrnImgs
    fname = listFile(iFile).name;
    fNameNoExt = fname(1:size(fname,2) - 4);
    
    lmFname = [fNameNoExt , '.' , lmExtension];
    
    fid = fopen( fullfile(filePath, lmFname ) );
    %fid = fopen('data2\001.LFP')
    
    count = 1;
    tline = fgets(fid);
    while ischar(tline)
        if count < 16
            tline = fgets(fid);
        end
        count = count + 1;
        if count > 16
            C = textscan(fid, '%f %f %f', 'delimiter' , '\t');
            x(:, iFile) = [C{2} ; C{3}];
            break;
        end
    end 

    fclose(fid);
end


end

