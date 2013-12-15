function [ output_args ] = plotTrainingData( X )
%PLOTTRAININGDATA Summary of this function goes here
%   Detailed explanation goes here

    n = size(X,1) / 2 ; % Number of points in 1 shape
    k = size(X,2) ; % Number of shapes
    
    figure();
    for iter = 1:k
        cur = reshape(X(:, iter), n , 2);
        switch mod(iter , 4)
            case 1
                plotShape(cur,'c*');
            case 2
                plotShape(cur,'y*');
            case 3
                plotShape(cur,'g*');
            case 0
                plotShape(cur,'m*');
        end

    end

end

