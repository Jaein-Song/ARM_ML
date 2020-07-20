clear
site_list{1}='SGP';
site_list{2}='NSA';
site_list{3}='ENA';
site_list{4}='OLI';
site_list{5}='ASI';
site_list{6}='AWR';
for sitei=3:3
    site=site_list{sitei}
datadir=['./DATA/' site '/']
matddir=['./mat/' site '/']
matfdir=['./']
if isunix
%     flo=dir([datadir '*.nc']);
    fl3o=dir([matddir '*20150930*.mat']);
    for i=1:length(fl3o)
%         fl(i,:)=flo(i).name;
        fl3(i,:)=fl3o(i).name;
        ymd=fl3(i,1:8);
        flo=dir([datadir '*' ymd '*']);
        fl(i,:)=flo.name;
    end
    clear flo fl3o
else
    fl=ls([datadir '*.nc']);
end
%matdir='./mat';
%fl1=ls('./nqcnc/*.cfradial');
%fl=ls('./cilnc/*.cfradial');
%fl3=ls('./mat/*.mat');
flen=length(fl);

for fi=1:1%flen
%     flo=dir[datdir]
try
    fname=strcat(datadir,fl(fi,:));
    fn_length=length(fl(i,:));
    ymd=fl(fi,fn_length-17:fn_length-10);
    ref=ncread(fname,'reflectivity_best_estimate');
    ref(ref<-100)=NaN;
    fday=str2num(ymd(7:8));
    fyear=str2num(ymd(1:4));
    fmonth=str2num(ymd(5:6));
    findl=strcat(matddir,ymd,'.mat');
    afilend=dir(findl);
    afilen=afilend.name
    h=ncread(fname,'height');
    t=ncread(fname,'time');
    figure1=figure('visible','off');
    hold off
    colormap(jet)
    contourf(t,h,ref,'linestyle','none','levelstep',1);
    hold on
    set(gca,'Clim',[-40 30])
    load([matddir afilen],'BB_height','BB_bottom')
    load([matddir afilen],'BB')
    BB(BB==0)=12500;
    BB(isnan(BB))=12500;
    BB(BB==1)=NaN;
    scatter(t/3600,BB_height,5,'b')
    scatter(t/3600,BB_bottom,5,'xr')
    %scatter(t,BB,10,'xk')
    colorbar
    print('-djpeg',[matfdir ymd '.jpg'])
    clear BB*
    hold off
close all    
catch
    [fname 'error occurred']
end
end
end
