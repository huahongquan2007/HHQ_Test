function [ x ] = loadTrainingDataMUCT( numOfLandmark, numOfTrnImgs, filePath, listFile )
%LOADTRAININGDATAMUCT Summary of this function goes here
%   Detailed explanation goes here

%fid = fopen('datamuct\muct76.csv');
fid = fopen('datamuct\muct76-opencv.csv');

C = textscan(fid, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 'delimiter',',');

%name image i : C{1}(i + 1)
%tag image  i : C{2}{i + 1}
%x0 image i   : C{3}{i + 1} 

x = zeros( 2 * numOfLandmark, numOfTrnImgs);

t = C{1}(:);
for i = 1 : numOfTrnImgs
    fname = listFile(i).name;
    fNameNoExt = fname(1:size(fname,2) - 4);
    
    IndexC = strfind(t, fNameNoExt);
    Index = find(not(cellfun('isempty', IndexC)));
    
    %%% Now we know that the landmarking data is at C{3 --> 154}( Index )
    for j = 1 : 2 * numOfLandmark
        t2 = C{j + 2}(Index);
        x(j , i) = str2num( t2{1} );
    end
    
end

n = size(x,1) / 2 ; % Number of points in 1 shape
k = size(x,2) ; % Number of shapes
for iter = 1:k
    t2 = reshape(x(:, iter), 2, n);
    x(:, iter) = [t2(1, :)' ; t2(2, :)'];
end

end

