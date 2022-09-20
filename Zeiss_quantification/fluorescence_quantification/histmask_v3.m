%histmask for zeiss, since background ~= 0

function [mask] = histmask_v3(image,stdevs)

%avg = mean(image(:));
avg = median(image(:)); %the histogram is only one sided and centers around 0 after the image subtraction
stdev = std(double(image(image(:)<10000))); %this takes only values <10000 to prevent artifacts from high fluorescence pixels. The point is to find the stdev of the background
thresh = avg + (stdevs*stdev);
mask = image>thresh;