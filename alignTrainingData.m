function [ Xa ] = alignTrainingData( Xu )
%ALIGNTRAININGDATA Summary of this function goes here
%   Input: Xu  [2xnumOfLandmark , numOfTrnImgs] ( 158 , 46 );

    n = size(Xu,1) / 2 ; % Number of points in 1 shape
    k = size(Xu,2) ; % Number of shapes

    %%%PLOT THE UNALIGNED DATA POINTS
    %plotTrainingData(Xu);
    
    
    %% app_models.pdf page 15/125
    %% STEP 1: Translate each example so that its centre of gravity is at the origin.
    Xc = [];
    for iter = 1:k
        cur = reshape( Xu(:, iter) , n , 2);
        
        Xt = cur - ones( size(cur,1) ,1) * mean(cur);
        Xc = [Xc , reshape(Xt, n * 2, 1)];
    end
    %% STEP 2: Choose one example as an initial estimate of the mean shape and scale so that |x| = 1.
    meanShape = Xc(:, 1);
    %%%Normalize
    length = sqrt(sum(sum(meanShape.^2)));
    meanShape = meanShape / length;
    
    %% STEP 3: Record the first estimate as x0 to define the default reference frame
    Xo = meanShape;
    
    for i = 1: 50
        %% STEP 4: Align all the shapes with the current estimate of the mean shape
        for iShape = 1:k
            curShape = Xc(:, iShape);
            Xc(:, iShape) = alignTwoShape( meanShape, curShape);
        end

        %% STEP 5: Re-estimate mean from aligned shapes
        meanShape = mean(Xc, 2);

        %% STEP 6: Apply constraints on the current estimate of the mean by aligning it with x0 and scaling so that |x| = 1
        meanShape = alignTwoShape(Xo, meanShape);
        %%%Normalize
        length = sqrt(sum(sum(meanShape.^2)));
        meanShape = meanShape / length;

        %% STEP 7: if not converged, return to 4
    end
    Xa = Xc;

    %% Plot
    figure();
    %%%PLOT
    for iter = 1:k
        cur = reshape(Xc(:, iter), n , 2);
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
    cur = reshape(meanShape, n , 2);
    plotShape(cur,'k.');
    
end

