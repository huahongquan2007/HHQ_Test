function [ grayValue ] = get2DGrayValue( curImg, graImg, curLandmark, numOfSamplePixel)
%GETGRAYVALUE Summary of this function goes here
%   Detailed explanation goes here

grayValue = zeros(numOfSamplePixel * numOfSamplePixel , 1);

pad = floor(numOfSamplePixel / 2);

img2 = zeros( size(curImg,1) + pad * 2 , size(curImg,2) + pad * 2);
img2(pad + 1 : pad + size(curImg , 1) , pad + 1 : pad + size(curImg,2) ) = graImg;

ix = floor( curLandmark(2) );
iy = floor ( curLandmark(1) );
% lay quanh ix iy hinh vuong num x num
ix2 = ix + pad;
iy2 = iy + pad;

result = img2( ix2 - pad : ix2 + pad ,  iy2 - pad : iy2 + pad);

grayValue = reshape(result , numOfSamplePixel * numOfSamplePixel , 1);
end