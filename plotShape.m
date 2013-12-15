function [ output_args ] = plotShape( data , type )
%PLOTSHAPE Summary of this function goes here
%   Detailed explanation goes here

hold on;

%numLandmarkPoints = uint8 (size(data , 1 ) / 2 );
%cur = reshape(data, 79 , 2);
for iPoint = 1 : size(data,1)
    plot( data(iPoint,1) , data(iPoint, 2) , type );
    %plot( data(iPoint), data(iPoint + 79), type );
end

end

