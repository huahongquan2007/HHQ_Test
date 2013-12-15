function [ x, fullData ] = loadTrainingDataCK(  numOfLandmark, numColumnData, numOfTrnImgs, filePath, listFile  )
%LOADTRAININGDATACK Summary of this function goes here
%   Detailed explanation goes here
    x = zeros( 2 * numOfLandmark, numOfTrnImgs);
    fullData = zeros(numOfLandmark, numColumnData , numOfTrnImgs);
    for iFile = 1: numOfTrnImgs
        c = load( fullfile(filePath, listFile(iFile).name) );
        
        fullData(:,:, iFile) =  [ c(:,1) / 490 , c(:,2) / 640 ];
        x(:, iFile) = reshape( fullData(:,:, iFile) , 2 * numOfLandmark, 1 );
        
%         fid = fopen(  );
%         fid = fopen('data2\001.ASF')
%         count = 1;
%         tline = fgets(fid);
%         while ischar(tline)
%             if count < 16
%                 tline = fgets(fid);
%             end
%             count = count + 1;
%             if count > 16
%                 C = textscan(fid, '%f %f %f %f %f %f %f', 'delimiter' , '\t');
%                 fullData(:,:,iFile) = [C{1} C{2} C{3} C{4} C{5} C{6} C{7}];
%                 x(:, iFile) = [C{3} ; C{4}];
%                 break;
%             end
%         end 

%        fclose(fid);
    end

end

