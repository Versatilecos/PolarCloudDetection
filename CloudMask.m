function [B6_CDBTexture,B6_cloud,B9_CDBTexture,B9_cloud,result1,result2] = CloudMask(path,blockSize,Correlation_threshold,Energy_threshold,B9_threshold,B9_correlation_threshold)
%% 
% Perform cloud detection using spectral and textural features with Fmask, the Mid-Infrared B6 band, and the Cirrus B9 band.
% Recommended threshold settings are: 32, 0.85, 0.3, 0.003, 0.8 respectively. 
% Users need to run Fmask first, obtain the Fmask image, and place it in the corresponding file path before you can run this function.

% Input:
% path: the image path, typically using the Landsat 8/9 B6 band. An example:%path="D:\Landsat8\LC08_L1GT_131108_20230921_20230921_02_RT";
% blocksize: The size of texture calculating block.
% Correlation_threshold: the correlation threshold for normal clouds detecting.
% Energy_threshold: the energy threshold for normal clouds detecting.
% B9_threshold: The reflectance threshold for cirrus detecting.
% B9_Correlation_threshold: the correlation threshold for cirrus detecting.
% Output:
% B6_CDBTexture: normal cloud detection result based on texture
% B6_cloud: normal cloud detection result based on texture and Fmask
% B9_CDBTexture: cirrus detection result based on texture
% B9_cloud: cirrus detection result based on texture and reflectance
% result1: combination cloud detection result of B6_cloud and B9_cloud(cloud: 1, others: 0)
% result2: combination cloud detection result of B6_cloud and B9_cloud(cloud: 4, snow: 3, cloud shadow: 2, clear water: 1, clear land: 0, outside: 255)

% An example:
% path="J:\PHD\grade1\SnowCloudDedection\experiment\Landsat8\LC08_L1GT_094107_20250211_20250211_02_RT";
% blockSize=32;
% Correlation_threshold=0.85;
% Energy_threshold=0.3;
% B9_threshold=0.003;
% B9_correlation_threshold=0.8;
%%

param_suffix = sprintf(...
    '%d_%.2f_%.2f_%.4f_%.2f',...  % 依次对应5个参数的格式
    blockSize,...
    Correlation_threshold,...
    Energy_threshold,...
    B9_threshold,...
    B9_correlation_threshold);

%Define the projection 
project=3031;%Antarctic
%project=32623;%Greenland

tic;
disp("running...")

[~, image_name, ~] = fileparts(path);
pMLT='_MTL.txt';
pB6='_B6.tif';
pB9='_B9.tif';
pfmask='_Fmask4.tif';
MLT_name=strcat(image_name,pMLT);
B6_name=strcat(image_name,pB6);
B9_name=strcat(image_name,pB9);
fmask_name=strcat(image_name,pfmask);
MLT_path=fullfile(path,MLT_name);
B6_path=fullfile(path,B6_name);
B9_path=fullfile(path,B9_name);
fmask_path=fullfile(path,fmask_name);

%automated output path setting
outputfolder_name='CloudDetectionResult';
outputfolder_path=fullfile(path,outputfolder_name);

B6_CDBTexture_name = ['B6CDBTexture_', param_suffix, '.tif'];
B6_cloud_name      = ['B6_cloud_', param_suffix, '.tif'];
B9_CDBTexture_name = ['B9CDBTexture_', param_suffix, '.tif'];
B9_reflectance_name = ['B9reflectance_', param_suffix, '.tif'];
B9_cloud_name      = ['B9_cloud_', param_suffix, '.tif'];
result1_name       = ['CloudMask_', param_suffix, '.tif'];
result2_name       = ['CloudMask2_', param_suffix, '.tif'];
Fmask_name='Fmask.tif';
output_B6_CDBTexture_path=fullfile(outputfolder_path,B6_CDBTexture_name);
output_B6_cloud_path=fullfile(outputfolder_path,B6_cloud_name);
output_B9_CDBTexture_path=fullfile(outputfolder_path,B9_CDBTexture_name);
output_B9_reflectance_path=fullfile(outputfolder_path,B9_reflectance_name);
output_B9_cloud_path=fullfile(outputfolder_path,B9_cloud_name);
output_result1_path=fullfile(outputfolder_path,result1_name);
output_result2_path=fullfile(outputfolder_path,result2_name);
output_Fmask_path=fullfile(outputfolder_path,Fmask_name);
%get B9_mult,B9_add

B9_mult = 0.00002;%default value
B9_add=-0.1;%default value

%%
%read MLT file
fid = fopen(MLT_path, 'rt');
if fid == -1
    fprintf('Failed to open the file %s,default values are used', MLT_path);
else
    while ~feof(fid)
        line = fgetl(fid); 

        if contains(line, 'REFLECTANCE_MULT_BAND_9')
            parts = strsplit(line, '='); 
            if numel(parts) == 2
                B9_mult = strtrim(parts{2});
                B9_mult=str2double(B9_mult);
            end
        end
        if contains(line, 'REFLECTANCE_ADD_BAND_9')

            parts = strsplit(line, '='); 
            if numel(parts) == 2
                B9_add = strtrim(parts{2}); 
                B9_add=str2double(B9_add);
            end
        end
    end

% 关闭文件
fclose(fid);
end




% read B6、B9、fmask files
[B6,R]=readgeoraster(B6_path);
[B9,R]=readgeoraster(B9_path);
[fmask,~]=readgeoraster(fmask_path);
B9=double(B9);

B9_reflectance=B9_mult*B9+B9_add;

%%
B9_cloud1=double(B9_reflectance>B9_threshold);


%%
%the main code of cloud detection
[B6_CDBTexture,B9_CDBTexture]=CloudDetectionBasedonTexture(B6,blockSize,Correlation_threshold,Energy_threshold,B9_correlation_threshold);
B6_cloud=FinalCloudDetection(fmask,B6_CDBTexture,1,2*blockSize);
B6_cloud2=FinalCloudDetection(fmask,B6_CDBTexture,2,2*blockSize);
B9_cloud2=B9_CDBTexture;
B9_cloud=double(B9_cloud2==1 & B9_cloud1==1);
%%
%Merge
[m,n]=size(B6);
result1=zeros(m,n);
result1(B6_cloud==1 | B9_cloud==1)=1;
result2=B6_cloud2;
result2(B6_cloud2==4 | B9_cloud==1)=4;
%%
% output
status = mkdir(outputfolder_path);

% Check if the folder was created successfully.
if status == 1
    disp('Folder created successfully!');
else
    disp('The folder creation failed. It may be because the folder already exists or the path is incorrect.');
end

geotiffwrite(output_B6_CDBTexture_path, B6_CDBTexture, R, "CoordRefSysCode",project);
geotiffwrite(output_B6_cloud_path, B6_cloud, R, "CoordRefSysCode", project);
geotiffwrite(output_B9_CDBTexture_path, B9_CDBTexture, R, "CoordRefSysCode", project);
geotiffwrite(output_B9_reflectance_path, B9_cloud1, R, "CoordRefSysCode", project);
geotiffwrite(output_B9_cloud_path, B9_cloud, R, "CoordRefSysCode", project);
geotiffwrite(output_result1_path, result1, R, "CoordRefSysCode", project);
geotiffwrite(output_result2_path, result2, R, "CoordRefSysCode", project);
geotiffwrite(output_Fmask_path, fmask, R, "CoordRefSysCode", project);
elapsed_time = toc;
disp(['Using time：', num2str(elapsed_time), ' s']);




end