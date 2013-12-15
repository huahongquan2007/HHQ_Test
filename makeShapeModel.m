function [ ShapeData ] = makeShapeModel( Xa, options )
%MAKESHAPEMODEL Summary of this function goes here
%   Detailed explanation goes here
%%Xa = TrainingData.Xa;

ShapeData = struct;

Xmean = mean(Xa, 2);
%Calculate Covariance Matrix
covMatrix = Xa*Xa' / (options.numOfLandmark * 2 - 1);
%Find eigenvector & eigenvalue
[V D] = eig(covMatrix);
eigValue = diag(D);
%Sort
[eigValue,IX] = sort(eigValue,'descend');
eigVector = V(:,IX);

ShapeData.eigVector = eigVector(:,1:10);
ShapeData.eigValue = eigValue(1:10);
ShapeData.meanShape = Xmean;



% %% Reconstruction
% %Deriving new data set using 1 eigenvector
% %newData = (eigReduce' * Xa );
% 
% %reData = (eigReduce * newData);
% %TEst reconstruct 
% %close all; cur = reshape(Xa(:, 1), 79 , 2);plotShape(cur,'c*');
% %figure; cur = reshape(reData(:, 1), 79 , 2);plotShape(cur,'c*');
% 
% %Try to generate new shapes
% close all;
% bs = zeros(options.numOfLandmark * 2,1);
% f = figure;
% mode = 3;
% max = 3*sqrt(eigValue(mode));
% step = max / 5;
% for i = -max: step : max
%     %clf(f);
%     %figure; 
%     hold on;
%     bs(mode) = i;
%     xNew = Xmean + eigVector * bs;
%     cur = reshape( xNew, options.numOfLandmark , 2);plotShape(cur,'c*');
%     pause(0.2);
% end

end

