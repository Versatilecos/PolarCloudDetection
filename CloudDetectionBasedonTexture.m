function [cloudB6,cloudB9] = CloudDetectionBasedonTexture(image,blockSize,Correlation_threshold,Energy_threshold,B9_Correlation_threshold)
%% The function performs cloud detection based on GLCM
% Input:
% image: the input image, typically using the Landsat 8/9 B6 band 
% Correlation_threshold: the correlation threshold for detecting normal clouds 
% Energy_threshold: the energy threshold for detecting normal clouds 
% B9_Correlation_threshold: the correlation threshold for detecting Cirrus clouds
% Output:
% cloudB6: normal cloud detection result based on texture
% cloudb9: cirrus detection result based on texture

[Contrast,Correlation,Energy,Homogeneity,indices] = TextureFeatureExtraction(image,blockSize);
[rows,cols]=size(image);
[m,n]=size(Contrast);
cloudB6=zeros(rows,cols);
cloudB9=zeros(rows,cols);

% Iterate over each block.
for i = 1:m
    for j = 1:n
        if (Correlation(i,j) > Correlation_threshold && Energy(i,j) < Energy_threshold)
            % Find the indices of all pixels in this block.
            blockIndices = find(indices(:,:,1) == i & indices(:,:,2) == j);
            % Mark these pixels as 1 in the cloud matrix.
            cloudB6(blockIndices) = 1;
        end
    end
end

for i = 1:m
    for j = 1:n
        if ~isnan(Correlation(i,j))
            if abs(Correlation(i,j)) > B9_Correlation_threshold
                % Find the indices of all pixels in this block.
                blockIndices = find(indices(:,:,1) == i & indices(:,:,2) == j);
                % Mark these pixels as 1 in the cloud matrix.
                cloudB9(blockIndices) = 1;
            end
        end
    end
end


end
