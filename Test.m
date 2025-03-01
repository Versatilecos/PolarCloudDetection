%This is a test for this cloud detection algorithm.

%All cloud detection results will be placed in the CloudDetectionResult folder.
%It is recommended to check the B6_cloud, B9_cloud, and CloudMask results for parameter adjustments.

%The most strict parameter setting is 32, 0.9, 0.15, 0.003, 0.8.
%The most lenient parameter setting is 32, 0.7, 0.4, 0.003, 0.8. 
%You can start with a larger blockSize (such as 64, 128, 256) to quickly obtain results and then reduce the blockSize for more accurate results.

path="D:\LandSat\LC08_L1GT_131108_20230921_20230921_02_RT";
blockSize=64;% or 32, 128, 256
Correlation_threshold=0.85;
Energy_threshold=0.3;
B9_threshold=0.003;
B9_correlation_threshold=0.8;
[B6_CDBTexture,B6_cloud,B9_CDBTexture,B9_cloud,result1,result2] = CloudMask(path,blockSize,Correlation_threshold,Energy_threshold,B9_threshold,B9_correlation_threshold);
