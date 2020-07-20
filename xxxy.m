
close all

ncn='2016030800z.nc';loni=510;lati=222;
lon=ncread(ncn,'longitude');lat=ncread(ncn,'latitude');lvl=ncread(ncn,'level');t=ncread(ncn,'t');
t_obj=t(loni,lati,:);
t_obj=squeeze(t_obj);
h_lvl=(1-(double(lvl)./1013.25).^0.190284)*145366.45*0.3048;t_obj=t_obj-273.15;
day_no=46;
time_no=630;
time_no=270;
figname='2016012812z';
figname='2016030800z';
matdir='./mat';
fl1=ls('./nqcnc/*.cfradial');
fl2=ls('./cilnc/*.cfradial');
fl3=ls('./mat/*.mat');
sonde=sonde_rkjj_2016030800z;
ref=ncread(['cilnc/' fl2(day_no,:)],'reflectivity_h');
ldr=ncread(['cilnc/' fl2(day_no,:)],'linear_depolarization_ratio');
load(['mat/' fl3(day_no,:)],'BB_height')
% plot(sonde(:,3),sonde(:,2))
xmina=-70;xmaxa=10;
xminb=-30;xmaxb=15;
xminc=-30;xmaxc=-10;
height=900;
width=600;
MenuBar          = 'figure';
ToolBar          = 'figure';
figcolor='w';
cont_fig = figure('color',figcolor,'PaperSize',[height*4 width*4],'units','pixels','position',[(1920-width)/2 (1080-height)/5 width height],'menubar',MenuBar,'toolbar',ToolBar);
a=axes('Position',[.15 .24 .7 .7]);
set(a,'Units','normalized','box','on');
a2=axes('Position',[.15 .24 .7 .7]);
a3=axes('Position',[.15 .24 .7 .7]);
a4=axes('Position',[.15 .24 .7 .7]);
b2=axes('Position',[.15 .24 .7 .7]);
c2=axes('Position',[.15 .24 .7 .7]);
set(b2,'Units','normalized');
set(c2,'Units','normalized');
set(a2,'Units','normalized');
set(a3,'Units','normalized');
set(a4,'Units','normalized');
hold on

% set(axes2,'XTick',zeros(1,0),'YTick',zeros(1,0));
b=axes('Position',[.15 .16 .7 1e-12]);
set(b,'Units','normalized');
set(b,'Color','none');
c=axes('Position',[.15 .08 .7 1e-12]);
set(c,'Units','normalized');
set(c,'Color','none');

plot(a,sonde(:,3),sonde(:,2),'k','linewidth',2)
gca=a;
hold on
plot(a2,[0 0],[0 15000],'--','linewidth',2,'color',[0.5 0.5 0.5])
plot(a3,[xmina xmaxa],[BB_height(time_no) BB_height(time_no)],'--','linewidth',2,'color',[0.5 0.5 0.5])
plot(a4,t_obj,h_lvl,'color',[0.7 0.7 0.7],'linewidth',2)

plot(b2,ref(:,time_no),h,'r','linewidth',2)
set(b2,'Color','none','XTick',zeros(1,0),'YTick',zeros(1,0));
plot(c2,ldr(:,time_no),h,'b','linewidth',2)
set(c2,'Color','none','XTick',zeros(1,0),'YTick',zeros(1,0));

set(a,'xlim',[xmina xmaxa]);
set(a,'ylim',[0 15000],'fontname','times new roman','fontsize',12,'fontweight','bold')
set(a2,'xlim',[xmina xmaxa]);
set(a2,'ylim',[0 15000])
set(a2,'Color','none','XTick',zeros(1,0),'YTick',zeros(1,0));

set(a3,'xlim',[xmina xmaxa]);
set(a3,'ylim',[0 15000])
set(a3,'Color','none','XTick',zeros(1,0),'YTick',zeros(1,0));

set(a4,'xlim',[xmina xmaxa]);
set(a4,'ylim',[0 15000])
set(a4,'Color','none','XTick',zeros(1,0),'YTick',zeros(1,0));

set(b2,'xlim',[xminb xmaxb]);
set(b2,'ylim',[0 15000])
set(c2,'xlim',[xminb xmaxc]);
set(c2,'ylim',[0 15000])
set(b,'xlim',[xminb xmaxb],'fontname','times new roman','fontsize',12,'fontweight','bold','XColor',[1 0 0]);
set(c,'xlim',[xminc xmaxc],'fontname','times new roman','fontsize',12,'fontweight','bold','XColor',[0 0 1]);

set(a,'ytick',[0:2500:15000]);
box on
xlabel(a,'Temperature (^\circC)')
xlabel(b,'Reflectivity (dBZ)')
xlabel(c,'LDR (dB)')
ylabel(a,'Height');
title(a,figname,'fontweight','Bold','fontsize',20);
hold off
print('-djpeg',figname)
close all