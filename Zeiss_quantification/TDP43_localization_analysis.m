%% Analysis of Zeiss images of TDP43 localization

%Z-stack
addpath('I:/Scripts/Universal_functions','I:\Scripts\Universal_functions\bfmatlab','I:\Scripts\Zeiss\Zstack');
cd('I:\Zeiss_examples\Aaron_iPSC-MN_d10_TARDBP');


mkdir('tifs');
files = glob('*.czi');
colors = 4;

for n=1:numel(files)
    [maxprojection] = zeisszstack(files{n},colors);
    newname = strrep(files{n},'\','_');
    saveastiff(maxprojection,strcat('tifs/',newname(end-6:end-3),'tif'));
end

% analysis of stacked images
addpath('I:/Scripts/Universal_functions','I:\Scripts\Zeiss\fluorescence_quantification');

cd('I:\Zeiss_examples\Aaron_iPSC-MN_d10_TARDBP\tifs');

mkdir('masks');
files = glob('*.tif');
filenumber = numel(files);
datalabels = {'nuclei','ran','tdp43','ran_percentnuclear','tdp43_percentnuclear','neuritearea/nuclei'};
dataout = zeros(filenumber,numel(datalabels));
options.color = true;


nuclearchannel = 1;
nucleusminradius = 12;
cytoplasmchannel = 4;

parfor n=1:filenumber

n
file = files{n};
image = tifread(file);

[nuclearmask,cytomask,dilatedmask,neuritemask,backgroundmask,objectmask,nucleararray] = multichannelmask_v3_1(image,nuclearchannel,nucleusminradius,cytoplasmchannel);

nuclei = double(max(nuclearmask,[],'all'));
neuritearea = sum(neuritemask>0,'all')/nuclei;

%intensity measurements
[avgintensity,rannuclearintensity,objectsize] = intensityfinder_v2(image(:,:,2),nuclearmask);
[avgintensity,rancytointensity,objectsize] = intensityfinder_v2(image(:,:,2),cytomask);
[avgintensity,tdpnuclearintensity,objectsize] = intensityfinder_v2(image(:,:,3),nuclearmask);
[avgintensity,tdpcytointensity,objectsize] = intensityfinder_v2(image(:,:,3),cytomask);

nuclei = double(max(nuclearmask,[],'all'));
neuritearea = sum(neuritemask>0,'all')/nuclei;

%make sure nuclear and cytoplasmic vectors are same length- sometimes not
%due to bug where if last cyto value ==0
tdpnuclearintensity=tdpnuclearintensity(1:numel(tdpcytointensity));
rannuclearintensity=rannuclearintensity(1:numel(rancytointensity));

ran_ratio = rannuclearintensity./(rannuclearintensity+rancytointensity);
tdp_ratio = tdpnuclearintensity./(tdpnuclearintensity+tdpcytointensity);
tdp_ratio(ran_ratio==1)=[]; %delete Ran events where totally nuclear- these are events that slipped through the filters
ran_ratio(ran_ratio==1)=[]; %delete Ran events where totally nuclear- these are events that slipped through the filters

nuclei = double(max(nuclearmask,[],'all'));
neuritearea = sum(neuritemask>0,'all')/nuclei;


dataout(n,:)=[nuclei,mean(rannuclearintensity+rancytointensity),mean(tdpnuclearintensity+tdpcytointensity),mean(ran_ratio),mean(tdp_ratio),neuritearea];
saveastiff(objectmask,strcat('masks\',file(1:end-4),'mask.tif'),options);

end

xlswrite('staininganalysis.xlsx',dataout,'Summary','B2');
xlswrite('staininganalysis.xlsx',datalabels,'Summary','B1');
xlswrite('staininganalysis.xlsx',files,'Summary','A2');

%plotting data
addpath('I:\Scripts\Graphs');

file = 'TDP43_staininganalysis_AH220615.xlsx';
sheet = 'organized';

data = xlsread(file,sheet,'b2:g49');

%Ran intensity
column = 2;
datacolumns = {data(1:8,column),data(9:16,column),data(17:24,column),data(25:32,column),data(33:40,column),data(41:48,column)};
proximity = 20000;
lim = [0 70000000];
points = [0 35000000 70000000];
pointlabels = {'0','50','100'};
xspread = .1;
pointsize = 40;

beeswarmbar4(datacolumns,proximity,lim,points,pointlabels,xspread,pointsize)

%TDP43 intensity
column = 3;
datacolumns = {data(1:8,column),data(9:16,column),data(17:24,column),data(25:32,column),data(33:40,column),data(41:48,column)};
proximity = 20000;
lim = [0 35000000];
points = [0 17500000 35000000];
pointlabels = {'0','50','100'};
xspread = .1;
pointsize = 40;

beeswarmbar4(datacolumns,proximity,lim,points,pointlabels,xspread,pointsize)

%Ran percentnuclear
column = 4;
datacolumns = {data(1:8,column),data(9:16,column),data(17:24,column),data(25:32,column),data(33:40,column),data(41:48,column)};
proximity = .01;
lim = [0 1];
points = [0 0.5 1];
pointlabels = {'0','0.5','1.0'};
xspread = .1;
pointsize = 40;

beeswarmbar4(datacolumns,proximity,lim,points,pointlabels,xspread,pointsize)

%TDP43 percentnuclear
column = 5;
datacolumns = {data(1:8,column),data(9:16,column),data(17:24,column),data(25:32,column),data(33:40,column),data(41:48,column)};
proximity = .01;
lim = [0 1];
points = [0 0.5 1];
pointlabels = {'0','0.5','1.0'};
xspread = .1;
pointsize = 40;

beeswarmbar4(datacolumns,proximity,lim,points,pointlabels,xspread,pointsize)

%neurite area
column = 6;
datacolumns = {data(1:8,column),data(9:16,column),data(17:24,column),data(25:32,column),data(33:40,column),data(41:48,column)};
proximity = .01;
lim = [0 5500];
points = [0 2500 5000];
pointlabels = {'0','2500','5000'};
xspread = .1;
pointsize = 40;

beeswarmbar4(datacolumns,proximity,lim,points,pointlabels,xspread,pointsize)