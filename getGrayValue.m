function [ grayValue , sample] = getGrayValue( curImg, graImg, curLandmark, nextLandmark, numOfSamplePixel)
%GETGRAYVALUE Summary of this function goes here
%   Detailed explanation goes here
sample = getProfilePositions( curLandmark, nextLandmark, numOfSamplePixel);

grayValue = zeros(numOfSamplePixel , 1);

for iSample = 1 : numOfSamplePixel
    x = sample(iSample,2);
    if x > size(curImg,1)
        x = size(curImg,1);
    elseif x < 1
        x = 1;
    end
    y = sample(iSample,1);
    if y > size(curImg,2)
        y = size(curImg,2);
    elseif y < 1
        y = 1;
    end
    
    %grayValue(iSample) = curImg( sample(iSample, 2) , sample(iSample, 1));
    %grayValue(iSample) = curImg( x , y);
    grayValue(iSample) = graImg( x , y);
end

end

