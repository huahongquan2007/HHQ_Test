function [ shapeOutput ] = chooseBestCandidate(curImg, curImgLandmarks , AppearanceData, options )
%CHOOSEBESTCANDIDATE Summary of this function goes here
%   Detailed explanation goes here

numOfCandidate = abs( 2*( floor(options.numOfSamplePixel / 2) - floor(options.numOfTestPixel / 2)) + 1 ); % 17 candidates

shapeOutput = curImgLandmarks;

[dx dy] = gradient( curImg );
graImg = sqrt(dx.*dx + dy.*dy);

% figure;
% imagesc(curImg);
% hold all;

for iLandmark = 1 : options.numOfLandmark
    curLandmark = curImgLandmarks( iLandmark , :)' ;
    
    [grayValue] = get2DGrayValue( curImg, graImg, curLandmark , options.numOfTestPixel);
    
    %plot(sample(:,1), sample(:,2), 'g*');
    
    distance = zeros(numOfCandidate , numOfCandidate , 1);
    Sg = AppearanceData(iLandmark).cov;
    Gm = AppearanceData(iLandmark).mean;
    
    gray2DValue = reshape( grayValue, options.numOfTestPixel, options.numOfTestPixel);
    
    for iCanX = 1 : numOfCandidate
        for iCanY = 1 : numOfCandidate
            curCanGrayValue = gray2DValue(iCanX : iCanX + options.numOfSamplePixel - 1 , iCanY : iCanY + options.numOfSamplePixel - 1);

            %plot(sample(iCan : iCan + options.numOfSamplePixel - 1 ,1), sample(iCan : iCan + options.numOfSamplePixel - 1 ,2), 'b*');

            curCan = reshape( curCanGrayValue, options.numOfSamplePixel * options.numOfSamplePixel, 1) ;
            %% Normalization
            sumGradient = sum(curCan);
            curCan = curCan / sumGradient;

            curDist = (curCan - Gm)' * Sg' * (curCan - Gm);

            distance(iCanX, iCanY) = curDist;
        end
    end
        
    [Y I] = min(distance);
    [Y2 I2] = min(Y);
    
    mRow = I(I2);
    mCol = I2;
    %plot( sample(I,1), sample(I,2), 'g*');
    topLeftRow = curLandmark(2) - floor(options.numOfTestPixel/2) + mRow - 1;
    topLeftCol = curLandmark(1) - floor(options.numOfTestPixel/2) + mCol - 1;
    
    %shapeOutput(iLandmark, :) = sample(I + floor(options.numOfSamplePixel / 2) , :);
    shapeOutput(iLandmark, :) = [ topLeftCol + floor(options.numOfSamplePixel/2) ; topLeftRow + floor(options.numOfSamplePixel/2) ];
    %pause(0.5);
end



end

