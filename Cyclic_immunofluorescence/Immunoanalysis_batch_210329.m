%% 201222 tfMN analysis

addpath('H:/Scripts/Universal_functions','H:/Scripts/Multi_channel_localization');

cd('I:\Cyclic IF\Stacked_210326_FA11_MNid_day10_v2');
mkdir('masks');

files = glob('I:\Cyclic IF\Stacked_210326_FA11_MNid_day10_v2\*.tif');
filenumber = numel(files);
datalabels = {'totalcells','hb9','chat','neun','isl','tuj','tuj-isl','tuj-isl-chat','allpos','bfp2count','chat2'};
dataout = zeros(filenumber,numel(datalabels));
options.color = true;

nuclearchannel = 1;
nucleusminradius = 3;
cytoplasmchannel = 9;

parfor n=1:filenumber

file = files{n};
image = tifread(file);

[nuclearmask,cytomask,dilatedmask,neuritemask,backgroundmask,objectmask] = multichannelmask_v1(image,nuclearchannel,nucleusminradius,cytoplasmchannel);

% positive calls
[hst1call,hst1mask,hst1background] = positive_caller_v3(image(:,:,2),nuclearmask,backgroundmask,2);
[hb9call,hb9mask,hb9background] = positive_caller_v3(image(:,:,3),nuclearmask,backgroundmask,2);
[chatcall,chatmask,chatbackground] = positive_caller_v3(image(:,:,4),dilatedmask,backgroundmask,2);
[neuncall,neunmask,neunbackground] = positive_caller_v3(image(:,:,5),dilatedmask,backgroundmask,2);
[hst2call,hst2mask,hst2background] = positive_caller_v3(image(:,:,6),nuclearmask,backgroundmask,2);
[GFAPcall,GFAPmask,GFAPbackground] = positive_caller_v3(image(:,:,7),dilatedmask,backgroundmask,2);
[Islcall,Islmask,Islbackground] = positive_caller_v3(image(:,:,8),nuclearmask,backgroundmask,2);
[Tujcall,Tujmask,Tujbackground] = positive_caller_v3(image(:,:,9),dilatedmask,backgroundmask,2);

array = [hst1call, hst2call, hb9call, chatcall, neuncall,Islcall, Tujcall,GFAPcall];
bfpcount = numel(array(:,1));
nuclei = array(:,1)==1; %delete nuclei that don't overlap with hoechst channels
array = array(nuclei,:);
nuclei = array(:,2)==1;
array = array(nuclei,:);

totalcells = sum(array(:,1));
hb9pos = sum(array(:,3))/totalcells*100;
chatpos = sum(array(:,4))/totalcells*100;
neunpos = sum(array(:,5))/totalcells*100;
islpos = sum(array(:,6))/totalcells*100;
tujpos = sum(array(:,7))/totalcells*100;
chat2pos = sum(array(:,8))/totalcells*100;

tujislpos = sum(array(:,6)==1 & array(:,7)==1)/totalcells*100;
tujislchatpos = sum(array(:,4)==1 & array(:,6)==1 & array(:,7)==1)/totalcells*100;
fivepos = sum(array(:,3)==1 & array(:,4)==1 & array(:,5)==1 & array(:,6)==1 & array(:,7)==1)/totalcells*100;

dataout(n,:)=[totalcells,hb9pos,chatpos,neunpos,islpos,tujpos,tujislpos,tujislchatpos,fivepos,bfpcount,chat2pos];
saveastiff(objectmask,strcat('masks\',file(end-6:end-4),'_mask.tif'),options);

end

xlswrite('staininganalysis.xlsx',dataout,'Summary','B2');
xlswrite('staininganalysis.xlsx',datalabels,'Summary','B1');
xlswrite('staininganalysis.xlsx',files,'Summary','A2');


%% 210126 NGN2 analysis
addpath('I:/Scripts/Universal_functions','I:/Scripts/Multi_channel_localization');

cd('I:\Cyclic IF\Stacked_210326_FA11_NGN2id_day10_v2');
mkdir('masks');

files = glob('I:\Cyclic IF\Stacked_210326_FA11_NGN2id_day10_v2\*.tif');
filenumber = numel(files);
datalabels = {'bfp2cells','hoechstcells','brn2','foxg1','tuj1','brn2tuj1pos','triplepos','neuritearea/bfp2cells'};
dataout = zeros(filenumber,numel(datalabels));
options.color = true;


nuclearchannel = 1;
nucleusminradius = 3;
cytoplasmchannel = 5;

parfor n=1:filenumber

file = files{n};
image = tifread(file);

[nuclearmask,cytomask,dilatedmask,neuritemask,backgroundmask,objectmask] = multichannelmask_v1(image,nuclearchannel,nucleusminradius,cytoplasmchannel);

% positive calls
[brn2call,brn2mask,brn2background] = positive_caller_v3(image(:,:,3),nuclearmask,backgroundmask,2);
[foxg1call,foxg1mask,foxg1background] = positive_caller_v3(image(:,:,4),dilatedmask,backgroundmask,2);
[tuj1call,tuj1mask,tuj1background] = positive_caller_v3(image(:,:,5),dilatedmask,backgroundmask,2);
[hst2call,hst2mask,hst2background] = positive_caller_v3(image(:,:,2),nuclearmask,backgroundmask,2);

array = [hst2call, brn2call, foxg1call, tuj1call];
nuclei = array(:,1)==1; %delete nuclei that don't overlap with hoechst channels
array = array(nuclei,:);

bfp2cells = max(nuclearmask,[],'all');
totalcells = sum(array(:,1));
brn2pos = sum(array(:,2))/totalcells*100;
foxg1pos = sum(array(:,3))/totalcells*100;
tuj1pos = sum(array(:,4))/totalcells*100;

brn2tuj1pos = sum(array(:,2)==1 & array(:,4)==1)/totalcells*100;
triplepos = sum(array(:,2)==1 & array(:,3)==1 & array(:,4)==1)/totalcells*100;

dataout(n,:)=[bfp2cells,totalcells,brn2pos,foxg1pos,tuj1pos,brn2tuj1pos,triplepos,(sum(neuritemask>0,'all')/bfp2cells)];
saveastiff(objectmask,strcat('masks\',file(end-6:end-4),'_mask.tif'),options);

end

xlswrite('staininganalysis.xlsx',dataout,'Summary','B2');
xlswrite('staininganalysis.xlsx',datalabels,'Summary','B1');
xlswrite('staininganalysis.xlsx',files,'Summary','A2');

%% 210126 SN analysis
addpath('I:/Scripts/Universal_functions','I:/Scripts/Multi_channel_localization');

cd('I:\Cyclic IF\Stacked_210326_FA11_SNid_day10_v2');
mkdir('masks');

files = glob('I:\Cyclic IF\Stacked_210326_FA11_SNid_day7_v2\*.tif');
filenumber = numel(files);
datalabels = {'bfp2cells','hoechstcells','brn3a','isl1','tuj1','brn3atuj1pos','triplepos','neuritearea/bfp2cells'};
dataout = zeros(filenumber,numel(datalabels));
options.color = true;


nuclearchannel = 1;
nucleusminradius = 3;
cytoplasmchannel = 5;

parfor n=1:filenumber

file = files{n};
image = tifread(file);

[nuclearmask,cytomask,dilatedmask,neuritemask,backgroundmask,objectmask] = multichannelmask_v1(image,nuclearchannel,nucleusminradius,cytoplasmchannel);

% positive calls
[brn2call,brn2mask,brn2background] = positive_caller_v3(image(:,:,3),nuclearmask,backgroundmask,2);
[foxg1call,foxg1mask,foxg1background] = positive_caller_v3(image(:,:,4),dilatedmask,backgroundmask,2);
[tuj1call,tuj1mask,tuj1background] = positive_caller_v3(image(:,:,5),dilatedmask,backgroundmask,2);
[hst2call,hst2mask,hst2background] = positive_caller_v3(image(:,:,2),nuclearmask,backgroundmask,2);

array = [hst2call, brn2call, foxg1call, tuj1call];
nuclei = array(:,1)==1; %delete nuclei that don't overlap with hoechst channels
array = array(nuclei,:);

bfp2cells = max(nuclearmask,[],'all');
totalcells = sum(array(:,1));
brn2pos = sum(array(:,2))/totalcells*100;
foxg1pos = sum(array(:,3))/totalcells*100;
tuj1pos = sum(array(:,4))/totalcells*100;

brn2tuj1pos = sum(array(:,2)==1 & array(:,4)==1)/totalcells*100;
triplepos = sum(array(:,2)==1 & array(:,3)==1 & array(:,4)==1)/totalcells*100;

dataout(n,:)=[bfp2cells,totalcells,brn2pos,foxg1pos,tuj1pos,brn2tuj1pos,triplepos,(sum(neuritemask>0,'all')/bfp2cells)];
saveastiff(objectmask,strcat('masks\',file(end-6:end-4),'_mask.tif'),options);

end

xlswrite('staininganalysis.xlsx',dataout,'Summary','B2');
xlswrite('staininganalysis.xlsx',datalabels,'Summary','B1');
xlswrite('staininganalysis.xlsx',files,'Summary','A2');

%% graphs

%MN analysis
addpath('I:/scripts/graphs');

cd('I:\Cyclic IF\Stacked_210326_FA11_MNid_day7_v2');
file = 'staininganalysis.xlsx';
sheet = 'Summary';
data = xlsread(file,sheet,'b2:l9');

hb9 = data(:,2);
chat = data(:,3);
neun = data(:,4);
isl = data(:,5);
tuj = data(:,6);
allpos = data(:,9);

tujisl = data(:,7);
tujislchat = data(:,8);
chat2 = data(:,11);

datacolumns = {hb9,chat,isl,neun,tuj,allpos};
proximity = 2;
lim = [0 100];
points = [0 50 100];
pointlabels = {'0','50','100'};
xspread = .1;
pointsize = 40;

beeswarmbar4(datacolumns,proximity,lim,points,pointlabels,xspread,pointsize)


datacolumns = {tujisl,tujislchat,chat2};
proximity = 2;
lim = [0 100];
points = [0 50 100];
pointlabels = {'0','50','100'};
xspread = .1;
pointsize = 40;

beeswarmbar4(datacolumns,proximity,lim,points,pointlabels,xspread,pointsize)

%NGN2 analysis

cd('I:\Cyclic IF\Stacked_210326_FA11_NGN2id_day7_v2');
file = 'staininganalysis.xlsx';
sheet = 'Summary';
data = xlsread(file,sheet,'b2:i9');

brn2 = data(:,3);
foxg1 = data(:,4);
tuj1 = data(:,5);
triple = data(:,7);


datacolumns = {brn2,foxg1,tuj1,triple};
proximity = 2;
lim = [0 100];
points = [0 50 100];
pointlabels = {'0','50','100'};
xspread = .1;
pointsize = 40;

beeswarmbar4(datacolumns,proximity,lim,points,pointlabels,xspread,pointsize)


%NGN2 analysis

cd('I:\Cyclic IF\Stacked_210326_FA11_NGN2id_day7_v2');
file = 'staininganalysis.xlsx';
sheet = 'Summary';
data = xlsread(file,sheet,'b2:i9');

brn2 = data(:,3);
foxg1 = data(:,4);
tuj1 = data(:,5);
triple = data(:,7);


datacolumns = {brn2,foxg1,tuj1,triple};
proximity = 2;
lim = [0 100];
points = [0 50 100];
pointlabels = {'0','50','100'};
xspread = .1;
pointsize = 40;

beeswarmbar4(datacolumns,proximity,lim,points,pointlabels,xspread,pointsize)

%SN analysis

cd('I:\Cyclic IF\Stacked_210326_FA11_SNid_day7_v2');
file = 'staininganalysis.xlsx';
sheet = 'Summary';
data = xlsread(file,sheet,'b2:i9');

brn3a = data(:,3);
isl1 = data(:,4);
tuj1 = data(:,5);
triple = data(:,7);


datacolumns = {brn3a,isl1,tuj1,triple};
proximity = 2;
lim = [0 100];
points = [0 50 100];
pointlabels = {'0','50','100'};
xspread = .1;
pointsize = 40;

beeswarmbar4(datacolumns,proximity,lim,points,pointlabels,xspread,pointsize)