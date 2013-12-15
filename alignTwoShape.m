function [ Xb , s, rad ] = alignTwoShape( Xa, Xb )
%ALIGNTWOSHAPE Align Xb to Xa
%   Detailed explanation goes here

    tempN = size(Xa,1) / 2;
    X1 = reshape(Xb , tempN , 2);
    X2 = reshape(Xa , tempN , 2);
    
    %%%%%%%%%%%
    n = size(X1, 1);
    
    Xt1 = reshape( X1, 2 * n , 1);
    Xt2 = reshape( X2, 2 * n , 1);

    a = (Xt1' * Xt2) / (Xt1' * Xt1) ;
    b = ( X1(:,1)' * X2(:,2) -  X1(:,2)' * X2(:,1)  ) / (Xt1' * Xt1);

    s = sqrt(a * a + b * b);
    rad = atan(b/a);
    A = [cos(rad) -sin(rad) ; sin(rad) cos(rad)];

    Xb = reshape( (s*A*X1')', tempN * 2, 1);
    
    
end