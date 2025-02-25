This is a cloud detection method for Landsat 8/9 OLI/TIRS imagery  based on spectral and texture features, aiming to accurately and quickly detect cloud in polar regions without pre-training. 
We categorized the clouds into two types: normal clouds and cirrus clouds, and sequentially extracted them based on their differences in spectral features and texture features compared to snow.

Remember: you need to run Fmask first, obtain the Fmask image, and place it in the corresponding file path before you run this algorithm.
And please change the projection information in "Cloud Mask" if you were to run Greenland imagery.(Antarctic: 3031, Greenland: 32623, code rows: 40 and 41).
