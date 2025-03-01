function [Contrast,Correlation,Energy,Homogeneity,indices] = TextureFeatureExtraction(image,blockSize)
%%
% UNTITLED This function provides the feature values calculated from the gray-level co-occurrence matrix for each block after blocking.
%   'blocksize' is the size of each block, 'image' is the input image.
%   'indices' is a double-layer matrix indicating which block the pixels are assigned to, with the first layer representing rows and the second layer representing columns.



% Calculate the size of the horizontal boundary section and the vertical boundary section.
horizontalBorder = size(image, 1) - blockSize * floor(size(image, 1) / blockSize);
verticalBorder = size(image, 2) - blockSize * floor(size(image, 2) / blockSize);
%%
% Initialize the numbering matrix and the feature matrix.
indices = zeros(size(image, 1), size(image, 2), 2);
n=ceil(size(image, 1) / blockSize);
m=ceil(size(image, 2) / blockSize);
Contrast=zeros(n,m);
Correlation=zeros(n,m);
Energy=zeros(n,m);
Homogeneity=zeros(n,m);
%%
% The main part of the block processing.
for i = 1:blockSize:size(image, 1)-horizontalBorder
    for j = 1:blockSize:size(image, 2)-verticalBorder
        block = image(i:i+blockSize-1, j:j+blockSize-1);
        indices(i:i+blockSize-1, j:j+blockSize-1, 1) = ceil(i/blockSize);
        indices(i:i+blockSize-1, j:j+blockSize-1, 2) = ceil(j/blockSize);
        % 处理每个分块
        numlevels=max(block);
        glcm = graycomatrix(block, 'Offset', [0 1], 'NumLevels',256);
        stats = graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
        Contrast(ceil(i/blockSize),ceil(j/blockSize))=stats.Contrast;
        Correlation(ceil(i/blockSize),ceil(j/blockSize))=stats.Correlation;
        Energy(ceil(i/blockSize),ceil(j/blockSize))=stats.Energy;
        Homogeneity(ceil(i/blockSize),ceil(j/blockSize))=stats.Homogeneity;
    end
end
%%
% Process the boundary part by block.
for i = size(image, 1)-horizontalBorder+1:size(image, 1)
    for j = 1:blockSize:size(image, 2)-verticalBorder
        block = image(i:end, j:j+blockSize-1);
        indices(i:end, j:j+blockSize-1, 1) = ceil(i/blockSize);
        indices(i:end, j:j+blockSize-1, 2) = ceil(j/blockSize);

        glcm = graycomatrix(block, 'Offset', [0 1], 'NumLevels',256);
        stats = graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
        Contrast(ceil(i/blockSize),ceil(j/blockSize))=stats.Contrast;
        Correlation(ceil(i/blockSize),ceil(j/blockSize))=stats.Correlation;
        Energy(ceil(i/blockSize),ceil(j/blockSize))=stats.Energy;
        Homogeneity(ceil(i/blockSize),ceil(j/blockSize))=stats.Homogeneity;
    end
end


for i = 1:blockSize:size(image, 1)-horizontalBorder
    for j = size(image, 2)-verticalBorder+1:size(image, 2)
        block = image(i:i+blockSize-1, j:end);
        indices(i:i+blockSize-1, j:end, 1) = ceil(i/blockSize);
        indices(i:i+blockSize-1, j:end, 2) = ceil(j/blockSize);

        glcm = graycomatrix(block, 'Offset', [0 1], 'NumLevels',256);
        stats = graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
        Contrast(ceil(i/blockSize),ceil(j/blockSize))=stats.Contrast;
        Correlation(ceil(i/blockSize),ceil(j/blockSize))=stats.Correlation;
        Energy(ceil(i/blockSize),ceil(j/blockSize))=stats.Energy;
        Homogeneity(ceil(i/blockSize),ceil(j/blockSize))=stats.Homogeneity;
    end
end


lastBlock = image(size(image, 1)-horizontalBorder+1:end, size(image, 2)-verticalBorder+1:end);
indices(size(image, 1)-horizontalBorder+1:end, size(image, 2)-verticalBorder+1:end, 1) = ceil((size(image, 1))/blockSize);
indices(size(image, 1)-horizontalBorder+1:end, size(image, 2)-verticalBorder+1:end, 2) = ceil((size(image, 2))/blockSize);

i=size(image,1);
j=size(image,2);
glcm = graycomatrix(lastBlock, 'Offset', [0 1], 'NumLevels',256);
stats = graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
Contrast(ceil(i/blockSize),ceil(j/blockSize))=stats.Contrast;
Correlation(ceil(i/blockSize),ceil(j/blockSize))=stats.Correlation;
Energy(ceil(i/blockSize),ceil(j/blockSize))=stats.Energy;
Homogeneity(ceil(i/blockSize),ceil(j/blockSize))=stats.Homogeneity;
end