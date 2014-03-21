%% Z-Stack Image Analysis
%% Description : Show RGB image
%% Author : Pham Thai Hoa - thaihoabo@gmail.com
%% Created date: 21/03/2014
function [imageData] = showRGB(imageRedPath, imageGreenPath, imageBluePath)
    % Read binary image data
    arrRedData = imread(imageRedPath);
    arrGreenData = imread(imageGreenPath);
    arrBlueData = imread(imageBluePath);
    
    % Create matric MxNx3
    imageData(:,:,1) = arrRedData; 
    imageData(:,:,2) = arrGreenData;
    imageData(:,:,3) = arrBlueData;
    
    % Convert from binary data to RGB matric
    imageData = double(imageData);
    
    % Loop step dimension array 
    for iLoop = 1:3; 
        imageData(:,:,iLoop) = imageData(:,:,iLoop)./max(max(imageData(:,:,iLoop))); 
    end
end