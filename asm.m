%%%%%%%% ACTIVE SHAPE MODEL %%%%%%%%%%%%%%
clear all; clc; close all;

options = struct;
options.filePath = 'datampie';
%options.filePath = 'datamuct\jpg';
%options.filePath = 'data2\';
%options.filePath = 'datack\';

options.training = true;
%options.training = false;

options.drawBoundingBox = true;
%options.drawBoundingBox = false;

%options.numOfLandmark = 76;
options.numOfLandmark = 79;
%options.numOfLandmark = 68;

options.numOfTrnImgs = -1;
options.listFile = -1;


options.lmExtension = 'flp';
options.imgExtension = 'bmp';
%options.lmExtension = '';
%options.imgExtension = 'jpg';

options.numOfSamplePixel = 15;
options.numOfTestPixel = 31;

%% STEP 1: Obtain landmark coordinates from each shape in training set
% Input:
%	filePath : Path to dtataset directory
%	numOfLandmark: num of Landmark Points
% Output: 
%	'unaligned training set shape coordinates' matrix Xu with rows = 2 * numOfLandmark, cols = numOfTrnImgs
% 	numOfLandmarkPoints = number of Landmark Points
%	numOfTrnImgs = number of Traing Set Images


TrainingData = struct;
if (options.training == true)
    options.filePath = [ options.filePath '\'];
    options.listFile = dir( fullfile(options.filePath, ['*.' options.imgExtension])  );
    
    if options.numOfTrnImgs == -1
        options.numOfTrnImgs = size(options.listFile, 1);
    end
   
    %%%[ TrainingData.Xu TrainingData.fullData] = loadTrainingData( options.numOfLandmark, numColumnData, options.numOfTrnImgs, options.filePath, options.listFile);
    %%%[ TrainingData.Xu TrainingData.fullData] = loadTrainingDataCK( options.numOfLandmark, numColumnData, options.numOfTrnImgs, options.filePath, options.listFile);
   
    % TrainingData.Xu = loadTrainingDataMUCT( options.numOfLandmark, options.numOfTrnImgs, options.filePath, options.listFile );
    TrainingData.Xu = loadTrainingDataMPIE( options.numOfLandmark, options.numOfTrnImgs, options.filePath, options.listFile, options.lmExtension );
    
    disp('Done step 1');

%% STEP 2: Align The Training Shape
% Input: 'unaligned training set shape coordinates' matrix Xu
% Output:  'aligned training set shape coordinates' matrix Xa with rows = 2
% * numLandmarkPoints, cols = numTrnSetImgs    
    TrainingData.Xa = alignTrainingData( TrainingData.Xu );

    disp('Done step 2');
%% STEP 3: Shape Model

    ShapeData = makeShapeModel( TrainingData.Xa, options);

    disp('Done step 3');

%% STEP 4: Local Appearance Model

    %AppearanceData = makeAppearanceModel( TrainingData.Xu, options);
    AppearanceData = make2DAppearanceModel( TrainingData.Xu, options);

    disp('Done step 4');
    
    save 'options.mat' options
    save 'TrainingData.mat' TrainingData;
    save 'ShapeData.mat' ShapeData;
    save 'AppearanceData.mat' AppearanceData;
    
else
    load 'options.mat';
    load 'TrainingData.mat';
    load 'ShapeData.mat';
    load 'AppearanceData.mat';
end % end if training == true

%% TESTING

disp('Testing steps:');
disp('+ Use mouse to draw a bounding box for face');
disp('+ Double click mouse to continue testing');

iImg = 10;

%curImgName = [options.listFile(iImg).name];
curImgName = '001_01_01_051_07.bmp';

%curImg = im2double(imread([options.filePath curImgName])) ; % read grayscale

curImg = rgb2gray( im2double(imread([options.filePath curImgName])) ) ; % read grayscale
%curImg = histeq(rgb2gray( im2double(imread([options.filePath curImgName])) ) ); % read grayscale

%% STEP 1: Get the bounding box
if (options.drawBoundingBox == 1 || 1)
    hf = figure;
    imshow(curImg);
    h = imrect;
    position = wait(h);
    posRect = getPosition(h); % pos = x1 x2 width height    
    save 'posRect.mat' posRect;
    close (hf) ;
else
    load 'posRect.mat';
end
pos = [posRect(1) posRect(2) posRect(1)+posRect(3) posRect(2)+posRect(4)];
% pos = x1 x2, x3 x4 where x1,x2 is top left, x3 x4 is bottom right

    %% Plot the bounding box 
    %%%Plot the bounding box
    figure;
    axis([0,600,0,600]);
    imagesc(curImg);
    colormap(gray);
    hold on;

    plot([pos(1) pos(3)],[pos(2) pos(2)],'r');
    plot([pos(3) pos(3)],[pos(2) pos(4)],'r');
    plot([pos(3) pos(1)],[pos(4) pos(4)],'r');
    plot([pos(1) pos(1)],[pos(4) pos(2)],'r');

%% STEP 2: Align the meanshape over bounding box
%%%Transform the mean shape
cur = reshape( ShapeData.meanShape, options.numOfLandmark , 2);
centerOfRect = [posRect(1)+posRect(3)/2  posRect(2)+posRect(4)/2 ];

curLandMark = cur( 3 , :)' ; % 3rd
nextLandMark = cur(  13, :)';% 13th
scale = posRect(3) / dist(curLandMark(1), nextLandMark(1) );

cur = cur * scale;
cur(:,1) = cur(:,1) + centerOfRect(1);
cur(:,2) = cur(:,2) + centerOfRect(2);

plot ( cur(:,1) , cur(:,2),'b*'); 
oldStuff = cur;
lastCur = zeros(size(cur,1),size(cur,2));

isConverged = false;
iter = 0;
while isConverged == false && iter < 100
%% STEP 3: Update the shape using local appearance
    %cur = chooseBestCandidate(curImg, cur, AppearanceData, options);
    cur = chooseBest2DCandidate(curImg, cur, AppearanceData, options);
    save 'cur.mat' cur;
    %% Find shape coefficient for the current shape
    cur = findShapeCoefficient(cur, ShapeData, options);

    %% Check which ones is converged
    converged = zeros(size(cur,1) , 1);
    
    for iPoint = 1:size(cur,1)
        errors = cur(iPoint,:) - lastCur(iPoint,:);
        MSE = mean(mean(errors.^2));
        if MSE < 0.5
            converged( iPoint) = 1;
        end
    end
    
    if (sum(converged) >= size(cur,1) - 20 || 1)
    %% Plot stuffs
        imagesc(curImg);
        plot ( oldStuff(:,1) , oldStuff(:,2),'b*'); 
        for iLandMark = 1 : options.numOfLandmark
            color = 'm*';
            if converged(iLandMark) == 1
                color = 'y*';
            end
            plot( cur(iLandMark, 1), cur(iLandMark, 2) , color);
            pause(0.0001);
        end
        %if (sum(converged) == size(cur,1)) isConverged = true; end
    end
    lastCur = cur;
%         
%         pause(5);
    iter = iter + 1
    sum(converged)
end
if ( isConverged == false)
%% Plot stuffs
    imagesc(curImg);
    plot ( oldStuff(:,1) , oldStuff(:,2),'b*'); 
    for iLandMark = 1 : options.numOfLandmark
        color = 'm*';
        if converged(iLandMark) == 1
            color = 'y*';
        end
        plot( cur(iLandMark, 1), cur(iLandMark, 2) , color);
        pause(0.05);
    end

end
