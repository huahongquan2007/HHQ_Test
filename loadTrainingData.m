function [ x, fullData ] = loadTrainingData( numOfLandmark, numColumnData, numOfTrnImgs, filePath, listFile  )
%LOADTRAININGDATA Summary of this function goes here
%   Detailed explanation goes here

    x = zeros( 2 * numOfLandmark, numOfTrnImgs);
    fullData = zeros(numOfLandmark, numColumnData , numOfTrnImgs);
    for iFile = 1: numOfTrnImgs
        fid = fopen( fullfile(filePath, listFile(iFile).name) );
        %fid = fopen('data2\001.ASF')
        count = 1;
        tline = fgets(fid);
        while ischar(tline)
            if count < 16
                tline = fgets(fid);
            end
            count = count + 1;
            if count > 16
                C = textscan(fid, '%f %f %f %f %f %f %f', 'delimiter' , '\t');
                fullData(:,:,iFile) = [C{1} C{2} C{3} C{4} C{5} C{6} C{7}];
                x(:, iFile) = [C{3} ; C{4}];
                break;
            end
        end 

        fclose(fid);
    end

%     % Visualize fullData of Image 1
%     iImg = 1;
%     curImgName = [listFile(iImg).name(1 : size(listFile(iImg).name , 2) - 6) '.bmp'];
%     curImg = histeq(rgb2gray( im2double( imread([filePath curImgName]))) ) ; % read grayscale
%     close all ;
%     figure;
%     imagesc(curImg);
%     colormap(gray);
%     hold on; 
%     
%     curImgLandmarks = [fullData(:,3, iImg) fullData(:,4, iImg)];
%     
%     for iLandmark=1: 79
%         color = 'r*';
%         type = floor(fullData(iLandmark,2, iImg));
%         switch type
%             case 0
%                 color = 'g*';
%             case 1
%                 color = 'y*';
%             case 2
%                 color = 'b*';
%         end
%         plot ( curImgLandmarks(iLandmark,1) * 408 , curImgLandmarks(iLandmark,2) * 528, color); 
%     end

end

