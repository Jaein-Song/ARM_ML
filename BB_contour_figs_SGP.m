clear
site_list{1}='SGP';
site_list{2}='TWP';
site_list{3}='NSA';
site_list{4}='ENA';
for sitei=1:1
    site=site_list{sitei}
datadir=['./DATA/' site '/']
matddir=['./mat/' site '/']
matfdir=['./matfig/' site '/']
if isunix
    flo=dir([datadir '*.nc']);
    fl3o=dir([matddir '*.mat']);
    for i=1:length(flo)
        fl(i,:)=flo(i).name;
        fl3(i,:)=fl3o(i).name;
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

for fi=1:flen
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
    load([matddir afilen],'BB_height')
    load([matddir afilen],'BB')
    BB(BB==0)=12500;
    BB(isnan(BB))=12500;
    BB(BB==1)=NaN;
    scatter(t,BB_height,5,'b')
    scatter(t,BB,10,'xk')
    colorbar
    print('-djpeg',[matfdir ymd '.jpg'])
    clear BB*
    hold off
close all    
end
end
