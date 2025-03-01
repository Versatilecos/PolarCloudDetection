function cloud = FinalCloudDetection(Fmask,CDBTexture,type,closeSize)
% This function is used for combining cloud detection results in polar regions 
% The inputs are the Fmask cloud detection results and the CloudDetectionBasedonTexture results.
% Type=1 or Type=2. If type=1, only clouds are detected; if type=2, clouds, snow, water, and cloud shadows are detected.
% If type is not provided, the default value is 1. 
% closeSize is the size of the closing grid, taking 2*blocksize or 3*blocksize, depending on the actual size of the holes.
if nargin < 3
    type = 1;
end
[n, m] = size(Fmask);

cloud = zeros(n,m);

cloud(Fmask == 4 & CDBTexture == 1) = 1;

se = strel('square', closeSize);
cloud_close=imclose(CDBTexture,se);


if type==2

    [n, m] = size(Fmask);


    cloud = Fmask;

    cloud(Fmask == 4 & cloud_close == 1) = 4;

    cloud(Fmask == 4 & cloud_close ~= 1) = 3;
end
if type==1
    cloud=zeros(n,m);
    cloud(Fmask == 4 & cloud_close == 1) = 1;
end

end