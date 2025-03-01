This is a cloud detection method for Landsat 8/9 OLI/TIRS imagery based on spectral and texture features, aiming to accurately and quickly detect cloud in polar regions without pre-training. 
We categorized the clouds into two types: normal clouds and cirrus clouds, and sequentially extracted them based on their differences in spectral features and texture features compared to snow.

This is an algorithm written in Matlab.

Step 1:
Download Fmask at https://github.com/GERSL/Fmask. Set the path and run 'Automask'. The detailed information can be found at Fmask readme.

Step 2:
Download all of the codes. 'CloudMask' is the main function. 'Test' shows an example of this algorithm. Please change the projection information in "CloudMask" if you were to run Greenland imagery. (Antarctic: 3031, Greenland: 32623, code rows: 40 and 41).

Step 3:
Open the 'Test' and set the path. You can start with a large blockSize (such as 64, 128, 256) to quickly obtain results and then reduce the blockSize for more accurate results. The information of parameters are in function 'CloudMask'. The range of Correlation_threshold and Energy_threshold are [0.7,0.9] and [0.15,0.4]. The most strict parameter setting is 0.9, 0.15 while the most lenient parameter setting is 0.7, 0.4.

Step 4:
All cloud detection results will be placed in the CloudDetectionResult folder. It is recommended to check the B6_cloud, B9_cloud, and CloudMask results for parameter adjustments.

Remember: you need to run Fmask first, obtain the Fmask image, and place it in the corresponding file path before you run this algorithm.
