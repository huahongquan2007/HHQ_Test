function [ AppearanceData ] = make2DAppearanceModel( Xu , options )
%MAKEAPPEARANCEMODEL Summary of this function goes here
%   Detailed explanation goes here

AppearanceData = struct;

intensityMatrix = zeros( options.numOfLandmark, options.numOfSamplePixel * options.numOfSamplePixel , options.numOfTrnImgs ); % 79 Landmarks -> 79x15^2x46 matrix of gray-value intensities

for iImg = 1 : options.numOfTrnImgs
    %curImgName = [options.listFile(iImg).name(1 : size(options.listFile(iImg).name , 2) - 6) '.bmp'];
    %curImgName = [options.listFile(iImg).name(1 : size(options.listFile(iImg).name , 2) - 6) ['.' options.imgExtension]];
    %curImgName = [options.listFile(iImg).name(1 : size(options.listFile(iImg).name , 2) - 14) ['.' options.imgExtension]];
    
    curImgName = options.listFile(iImg).name;
    
    %curImg = histeq(rgb2gray( im2double(imread([options.filePath curImgName])) )) ; % read grayscale
    
    curImg = rgb2gray( im2double(imread([options.filePath curImgName])) ) ; % read grayscale
    %curImg = im2double(imread([options.filePath curImgName])) ; % read grayscale
    
    %%%% Gradient value
    [dx dy] = gradient( curImg );
    graImg = sqrt(dx.*dx + dy.*dy);
    
    curImgLandmarks = reshape( Xu(:, iImg), options.numOfLandmark, 2);
    %curImgLandmarks = fullData(:, 3:4, iImg); %79 x 2 matrix
    %curImgLandmarks = fullData(:, 1:2, iImg); %79 x 2 matrix

    %curImgLandmarks(:,1) = curImgLandmarks(:,1) * 408;
    %curImgLandmarks(:,2) = curImgLandmarks(:,2) * 528;
    
    %figure;
    %imagesc(curImg);
    %hold all;
    for iLandmark = 1 : options.numOfLandmark
        curLandmark = curImgLandmarks( iLandmark , :)' ;
        
        [grayValue] = get2DGrayValue( curImg, graImg, curLandmark, options.numOfSamplePixel);
        
        %plot(sample(:,1), sample(:,2), 'r*');
        
        gradientValue = grayValue;
        %% Normalization
        sumGradient = sum(gradientValue);
        gradientValue = gradientValue / sumGradient;
        
        intensityMatrix(iLandmark, : , iImg) = gradientValue;
    end
    %disp( sprintf('%s %d', 'Done ', iImg) );
end

for iLandmark = 1 : options.numOfLandmark
    intensityMatrixPerLandmark = zeros(options.numOfSamplePixel * options.numOfSamplePixel, options.numOfTrnImgs );
    for j = 1:options.numOfTrnImgs
        intensityMatrixPerLandmark(:,j) = intensityMatrix( iLandmark , : , j)';
    end
    AppearanceData(iLandmark).cov = intensityMatrixPerLandmark * intensityMatrixPerLandmark' / (options.numOfSamplePixel - 1);
    AppearanceData(iLandmark).mean = mean(intensityMatrixPerLandmark , 2);
    
end

end

