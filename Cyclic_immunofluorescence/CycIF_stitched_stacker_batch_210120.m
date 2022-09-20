%% Batchscript for stitching within well and stacking across cycles
addpath('I:/Scripts/Cyclic_IF','I:/Scripts/Universal_functions')

cd('I:\Cyclic IF')
cyclematrix = [1,1,1]; %each number represents the wavelength to use for alignment in each cycle [wavelength to use cycle 1, wavelength to use cycle 2, etc.]
directories = {'I:\Cyclic IF\AH-MN-cyclicIF-livestain\AH-210111-TARDBP-MN-NGN2-day10\hNIL'; 'I:\Cyclic IF\MN_identity_cycle1\AH-210115-NGN2-MN-Day10\hNIL'; 'I:\Cyclic IF\MN_identity_cycle2\AH-210119-MN-day10\2021-01-19\13972\TimePoint_1\Stitched_Images'}; %directories for cycles, must match cyclematrix
CycIF_stitched_stacker_v3(directories,cyclematrix);
movefile('Stacked','Stacked_tfMN_day10_210120');
