%% This file uses the information provided in the first block to align and stack all cyclic IF images
%change in v3 is squeezing file from 4d to 3d
function [imagestack] = CycIF_stitched_stacker_v3(directories,cyclematrix)


mkdir('Stacked') %directory where stacked images will be written

files = glob(strcat(directories{1},'\*.tif'));
wells = cellfun(@(x) x(end-6:end-4),files,'UniformOutput',false);

options.color = false; %this is used to write tifstack-causes an error when inside parfor loop

[optimizer, metric] = imregconfig('multimodal'); % configures alignment conditions, which should be pretty straightforward
optimizer.InitialRadius = .00001;
optimizer.Epsilon = 1.5e-8;

parfor n=1:numel(files)
    % Call the Dapi files and align them
    imagestack = squeeze(tifread(files{n})); %squeeze gets the image to 3 dimensions
    Cyc1Dapi = imagestack(:,:,cyclematrix(1));
    sizeref = imref2d(size(Cyc1Dapi)); %this is used later to write files out
                
    for nn=2:numel(directories) %writes successive cycles on top of previously written 1st cycle
        cyclefile = tifread(strcat(directories{nn},'\',wells{n},'.tif'));
        cyclefile = squeeze(cyclefile); %gets rid of color dimension
        cycleDapi = cyclefile(:,:,cyclematrix(nn));
        cycleAlignment = imregtform(cycleDapi,Cyc1Dapi,'translation',optimizer,metric); %find alignment
        
        cyclefile = imwarp(cyclefile,cycleAlignment,'OutputView',sizeref);
        
        imagestacksize = size(imagestack);
        if numel(imagestacksize)<3; imagestacksize(3)=1; end %if stack dimension ==1, reads stack dimension as 1
        imagestacksize = imagestacksize(3);
        cyclefilesize = size(cyclefile);
        if numel(cyclefilesize)<3; cyclefilesize(3)=1; end %if stack dimension ==1, reads stack dimension as 1
        cyclefilesize = cyclefilesize(3);
        imagestack(:,:,(imagestacksize+1):(imagestacksize+cyclefilesize))=cyclefile;
        
    end

    
    % write single matrix to TIF file
    saveastiff(imagestack,strcat('Stacked/',wells{n},'.tif'),options)    
end 