% Batch script for image stitching

addpath('I:/Scripts/Universal_functions','I:/Scripts/Image_Stitching')
folders = glob('I:\AH-220126-FA11-MN\2022-01-26\15131\TimePoint_1');

for n=1:numel(folders)
    cd(folders{n});
    delete('*_thumb*.tif'); %deletes thumb files
    rownumber = 5;
    columnnumber = 5;
    wavelengthnumber = 4;
    stitchwavelength = 1;
    files = glob('*.tif');
    Stitcher_subtract_bgr_v2(files,rownumber,columnnumber,wavelengthnumber,stitchwavelength);
end