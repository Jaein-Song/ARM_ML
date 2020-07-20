clear
ymdl{1}='20180327';
sitel{1}='SGP';
figon=1;
time_no=120;
%edir='./files_sfc/';
%eflist=ls([edir '*.nc']);
lat_arm=34.76;
lon_arm=127.21;
%lat_era=ncread([edir eflist(1,:)],'latitude');
%lon_era=ncread([edir eflist(1,:)],'longitude');
%diff_lon=abs(lon_era-lon_arm);
%diff_lat=abs(lat_era-lat_arm);
%lati=find(diff_lat==min(diff_lat));
%loni=find(diff_lon==min(diff_lon));
for casei=1:1
    ymd=ymdl{casei};
    site=sitel{casei};

    if site=='BOS'
        cd E:\CR_work
        ncfile=ls(['./cilnc/*' ymd '*']);
        matfile=ls(['./mat/*' ymd '*']);
        ncfile=['./cilnc/' ncfile];
        matfile=['./mat/' matfile];
        t=ncread(ncfile,'time');
        h=ncread(ncfile,'range');
        z=ncread(ncfile,'reflectivity_h');
        ldr=ncread(ncfile,'linear_depolarization_ratio');
        vel=ncread(ncfile,'mean_doppler_velocity_h');
        load(matfile);
    else
%         cd E:\ARM
        ncfile0=dir(['./DATA/' site '/*' ymd '*']);
        matfile0=dir(['./mat/' site '/*' ymd '*']);
        ncfile=[ncfile0.folder '/' ncfile0.name];
        matfile=[matfile0.folder '/' matfile0.name];
        t=ncread(ncfile,'time');
        h=ncread(ncfile,'height');
        z=ncread(ncfile,'reflectivity_best_estimate');
        ldr=ncread(ncfile,'linear_depolarization_ratio');
        vel=ncread(ncfile,'mean_doppler_velocity');
        z(z<-100)=NaN;
        ldr(ldr<-100)=NaN;
        vel(vel<-100)=NaN;
        load(matfile);
    end
    if figon==1
        SCS              = get(0,'screensize');
        height           = 1080*0.9;
        width            = 1920*0.9;
        ncol             = 2;
        nrow             = 2;
        figcolor='w';
        MenuBar          = 'figure';
        ToolBar          = 'figure';
        marginl=0.01;
        marginr=0.01;
        margind=0.01;
        marginu=0.01;
        margini=0.005;
        ncol=2;
        nrow=1;
        figoh=(1-margind-marginu)/ncol;
        figow=(1-marginr-marginl)/nrow;
        fig = figure('color',figcolor,'PaperSize',[1600 900],'units','pixels','position',[300 300 800 450],'menubar',MenuBar,'toolbar',ToolBar);
        ax = axes('Parent',fig);
        hold(ax,'on');

        contourf(t/3600,h,z,'linestyle','none','levelstep',3);
        set(gca,'clim',[-30 20],'Xlim',[0 24],'Ylim',[0 15000],'box','on','linewidth',1,'fontsize',15,'fontweight','bold');
        set(gca,'XTick',[0:4:24],'YTick',[0000:3000:15000]);

        xlabel('UTC','FontSize',20,'FontWeight','bold');
        ylabel('Height (m AGL)','FontSize',20,'FontWeight','bold');
        colormap jet
        colorbar
        hold on 
        scatter(t/3600,BB_height,5,'filled','b','v','linewidth',0.1);
        scatter(t/3600,BB_bottom,5,'filled','r','^','linewidth',0.1);
        hold off 
            print([site ymd '_case_study_with_bottom'],'-dtiffn','-r100')
        clf
        close all
    elseif figon==2
        hour=t(time_no)/3600;
        hour=floor(hour+0.5);
        eraname=ls([edir '*' ymd num2str(hour,'%0.2i') '*']);
        eraname=[edir eraname];
        zdl=ncread(eraname,'deg0l');

        xmina=-30;xmaxa=20;
        xminb=-8;xmaxb=2;
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
        plot(a,z(:,time_no),h,'k','linewidth',2)

        gca=a;
        hold on
        ylim_xxxy=[0 8000];
%         plot(a2,[0 0],[0 15000],'--','linewidth',2,'color',[0.5 0.5 0.5])
        plot(a2,[xmina xmaxa],[zdl(loni,lati) zdl(loni,lati)],'--','linewidth',2,'color',[0.2 0.2 0.6],'Displayname','ERA5\_MLH')
        plot(a3,[xmina xmaxa],[BB_height(time_no) BB_height(time_no)],'--','linewidth',2,'color',[0.5 0.5 0.5],'Displayname','Estimated\_MLH')
        a23(1)=a2;
        a23(2)=a3;
%         legend(a23)
        l1=legend(a2,'ERA5\_MLH','location','northeast');
        set(l1,'Position',[0.665-0.25 0.885 0.08 0.02],'box','off','fontsize',10.5);
        l2=legend(a3,'Estimated\_MLH');
        set(l2,'Position',[0.697-0.25 0.91 0.06 0.02],'box','off','fontsize',10.5);
%         plot(a4,t_obj,h_lvl,'color',[0.7 0.7 0.7],'linewidth',2)
%         legend(a2)
%         legend(a3)
        plot(b2,vel(:,time_no),h,'r','linewidth',2)
        set(b2,'Color','none','XTick',zeros(1,0),'YTick',zeros(1,0));
        plot(c2,ldr(:,time_no),h,'b','linewidth',2)
        set(c2,'Color','none','XTick',zeros(1,0),'YTick',zeros(1,0));

        set(a,'xlim',[xmina xmaxa]);
        set(a,'ylim',ylim_xxxy,'fontname','times new roman','fontsize',12,'fontweight','bold')
        set(a2,'xlim',[xmina xmaxa]);
        set(a2,'ylim',ylim_xxxy)
        set(a2,'Color','none','XTick',zeros(1,0),'YTick',zeros(1,0));

        set(a3,'xlim',[xmina xmaxa]);
        set(a3,'ylim',ylim_xxxy)
        set(a3,'Color','none','XTick',zeros(1,0),'YTick',zeros(1,0));

        set(a4,'xlim',[xmina xmaxa]);
        set(a4,'ylim',ylim_xxxy)
        set(a4,'Color','none','XTick',zeros(1,0),'YTick',zeros(1,0));

        set(b2,'xlim',[xminb xmaxb]);
        set(b2,'ylim',ylim_xxxy)
        set(c2,'xlim',[xminc xmaxc]);
        set(c2,'ylim',ylim_xxxy)
        set(b,'xlim',[xminb xmaxb],'fontname','times new roman','fontsize',12,'fontweight','bold','XColor',[1 0 0]);
        set(c,'xlim',[xminc xmaxc],'fontname','times new roman','fontsize',12,'fontweight','bold','XColor',[0 0 1]);

        set(a,'ytick',[min(ylim_xxxy):(max(ylim_xxxy)-min(ylim_xxxy))/8:max(ylim_xxxy)]);
        box on
        xlabel(a,'Reflectivity (dBZ)')        
        xlabel(b,'Vertical Velocity (m\cdots^{-1})')
        xlabel(c,'LDR (dB)')
        ylabel(a,'Height');
%         title(a,figname,'fontweight','Bold','fontsize',20);
        hold off
        print('-djpeg',[site '_profile'])
        close all
    end
end
