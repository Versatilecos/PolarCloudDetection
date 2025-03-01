This is a cloud detection method for Landsat 8/9 OLI/TIRS imagery  based on spectral and texture features, aiming to accurately and quickly detect cloud in polar regions without pre-training. 
We categorized the clouds into two types: normal clouds and cirrus clouds, and sequentially extracted them based on their differences in spectral features and texture features compared to snow.

Step 1:
Download Fmask at https://github.com/GERSL/Fmask. Set the path and run 'Automask'. The detailed information can be found at Fmask readme.

Step 2:
Open the 'test' and set the path. You can start with a large blockSize (such as 64, 128, 256) to quickly obtain results and then reduce the blockSize for more accurate results. The information of parameters are in function 'CloudMask'.
All cloud detection results will be placed in the CloudDetectionResult folder. It is recommended to check the B6_cloud, B9_cloud, and CloudMask results for parameter adjustments.

Remember: you need to run Fmask first, obtain the Fmask image, and place it in the corresponding file path before you run this algorithm.
