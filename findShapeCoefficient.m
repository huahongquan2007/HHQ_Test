function [ x ] = findShapeCoefficient( Y, ShapeData, options )
%FINDSHAPECOEFFICIENT Summary of this function goes here
%   Detailed explanation goes here

%% STEP 1: Initialise the shape parameters, b, to zero
bs = zeros(size(ShapeData.eigVector,2), 1);

Xt = 0;
Yt = 0;
s = 0;
rad = 0;

for i = 1 : 10
%% STEP 2: Generate the model instance 
x = ShapeData.meanShape + ShapeData.eigVector * bs;

%% STEP 3: Find the pose parameters (Xt; Yt, s, rad) which best map x to Y 

    %% Translate Y COG to origin
    m = mean(Y);
    Xt = m(1);
    Yt = m(2);    
    Yc = Y - ones( size(Y,1) ,1) * m;
    
    [Yn s rad ] = alignTwoShape( reshape(Yc, options.numOfLandmark * 2 , 1) , x);
    
%% STEP 4: Invert the pose parameters and use to project Y into the model co-ordinate frame
    radY = rad * -1;
    sY = 1/s;
    A = [cos(radY) -sin(radY) ; sin(radY) cos(radY)];
    Yn = (sY*A*Yc')';
    
%% STEP 5: Project y into the tangent plane to ¹ x by scaling by 1=(y / xmean).
    sTangent = reshape(Yn, options.numOfLandmark * 2, 1)' * ShapeData.meanShape;
    Yn = Yn * sTangent;
%% STEP 6: Update the model parameters to match to y
    bs = ShapeData.eigVector' * (reshape(Yn, options.numOfLandmark * 2, 1) - ShapeData.meanShape);
%% STEP 7: Apply constraints on b(see 4.6,4.7 above)
    for iBs = 1:size(bs,1)
        max = 3 * sqrt(ShapeData.eigValue(iBs));
        if bs(iBs) > max
            bs(iBs) = max;
        end
        if bs(iBs) < -max
            bs(iBs) = -max;
        end
    end

end %% end for
x = reshape(x, options.numOfLandmark , 2);
A = [cos(rad) -sin(rad) ; sin(rad) cos(rad)];
x = (s*A*x')';
x(:,1) = x(:,1) + Xt;
x(:,2) = x(:,2) + Yt;

end

