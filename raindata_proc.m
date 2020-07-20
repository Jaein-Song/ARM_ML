clear
load('raindata.mat');
load('raincell.mat');
rain_1hr(rain_1hr<0)=NaN;
rain_obs(isnan(rain_1hr),:)=NaN;
ymd(isnan(rain_1hr),:)=NaN;
for i=1:length(ymd)
    ymds=sprintf('%0.4i%0.2i%0.2i',ymd(i,1),ymd(i,2),ymd(i,3));
    if length(ls(['cilnc/*',ymds,'*cfradial']))<1
%         i
%         1
%         ymdpos=find(ymd(:,1)=
        rain_pos(i)=NaN;
        rain_obs(i)=NaN;
        rain_1hr(i)=NaN;
        ymd(i,:)=NaN;
    else
        fn=['cilnc/',ls(['cilnc/*',ymds,'*cfradial'])];
        nv=ncread(fn,'nyquist_velocity');
        if min(nv(ymd(i,4)*30+1:ymd(i,4)*30)) <0
            ymd(i,:)=NaN;

            rain_pos(i)=NaN;
            rain_obs(i)=NaN;
            rain_1hr(i)=NaN;            
        end
    end
end
for mi=1:12
    for hi=0:23
        rain_pos_mh(mi,hi+1)=sum(rain_obs((ymd(:,2)==mi&ymd(:,4)==hi),1));
        rain_obs_mh(mi,hi+1)=sum(rain_obs((ymd(:,2)==mi&ymd(:,4)==hi),2));
        rain_1hr_mh(mi,hi+1)=sum(rain_1hr((ymd(:,2)==mi&ymd(:,4)==hi)));
        rain_len_mh(mi,hi+1)=length(ymd(ymd(:,2)==mi&ymd(:,4)==hi));
    end
end
rain_freq_mh=rain_pos_mh./rain_obs_mh;
rain_1hav_mh=rain_1hr_mh./rain_len_mh;
for hi=1:24
    rain_pos_DJF(hi)=sum(rain_pos_mh([12 1 2],hi));
    rain_pos_MAM(hi)=sum(rain_pos_mh([3 4 5],hi));
    rain_pos_JJA(hi)=sum(rain_pos_mh([6 7 8],hi));
    rain_pos_SON(hi)=sum(rain_pos_mh([9 10 11],hi));
    rain_pos_TOT(hi)=sum(rain_pos_mh(:,hi));
    
    rain_obs_DJF(hi)=sum(rain_obs_mh([12 1 2],hi));
    rain_obs_MAM(hi)=sum(rain_obs_mh([3 4 5],hi));
    rain_obs_JJA(hi)=sum(rain_obs_mh([6 7 8],hi));
    rain_obs_SON(hi)=sum(rain_obs_mh([9 10 11],hi));
    rain_obs_TOT(hi)=sum(rain_obs_mh(:,hi));
    
    rain_1hr_DJF(hi)=sum(rain_1hr_mh([12 1 2],hi));
    rain_1hr_MAM(hi)=sum(rain_1hr_mh([3 4 5],hi));
    rain_1hr_JJA(hi)=sum(rain_1hr_mh([6 7 8],hi));
    rain_1hr_SON(hi)=sum(rain_1hr_mh([9 10 11],hi));
    rain_1hr_TOT(hi)=sum(rain_1hr_mh(:,hi));
    
    rain_len_DJF(hi)=sum(rain_len_mh([12 1 2],hi));
    rain_len_MAM(hi)=sum(rain_len_mh([3 4 5],hi));
    rain_len_JJA(hi)=sum(rain_len_mh([6 7 8],hi));
    rain_len_SON(hi)=sum(rain_len_mh([9 10 11],hi));
    rain_len_TOT(hi)=sum(rain_len_mh(:,hi));
end
rain_freq_DJF=rain_pos_DJF./rain_obs_DJF;
rain_1hav_DJF=rain_1hr_DJF./rain_len_DJF;
rain_freq_MAM=rain_pos_MAM./rain_obs_MAM;
rain_1hav_MAM=rain_1hr_MAM./rain_len_MAM;
rain_freq_JJA=rain_pos_JJA./rain_obs_JJA;
rain_1hav_JJA=rain_1hr_JJA./rain_len_JJA;
rain_freq_SON=rain_pos_SON./rain_obs_SON;
rain_1hav_SON=rain_1hr_SON./rain_len_SON;
rain_freq_MAM=rain_pos_MAM./rain_obs_MAM;
rain_1hav_MAM=rain_1hr_MAM./rain_len_MAM;
rain_freq_TOT=rain_pos_TOT./rain_obs_TOT;
rain_1hav_TOT=rain_1hr_TOT./rain_len_TOT;

rain_ints_DJF=rain_1hr_DJF./rain_pos_DJF.*60;
rain_ints_MAM=rain_1hr_MAM./rain_pos_MAM.*60;
rain_ints_JJA=rain_1hr_JJA./rain_pos_JJA.*60;
rain_ints_SON=rain_1hr_SON./rain_pos_SON.*60;
rain_ints_TOT=rain_1hr_TOT./rain_pos_TOT.*60;

rain_freq_DJF(25)=rain_freq_DJF(1);
rain_freq_MAM(25)=rain_freq_MAM(1);
rain_freq_JJA(25)=rain_freq_JJA(1);
rain_freq_SON(25)=rain_freq_SON(1);
rain_freq_TOT(25)=rain_freq_TOT(1);

rain_1hav_DJF(25)=rain_1hav_DJF(1);
rain_1hav_MAM(25)=rain_1hav_MAM(1);
rain_1hav_JJA(25)=rain_1hav_JJA(1);
rain_1hav_SON(25)=rain_1hav_SON(1);
rain_1hav_TOT(25)=rain_1hav_TOT(1);

rain_ints_DJF(25)=rain_ints_DJF(1);
rain_ints_MAM(25)=rain_ints_MAM(1);
rain_ints_JJA(25)=rain_ints_JJA(1);
rain_ints_SON(25)=rain_ints_SON(1);
rain_ints_TOT(25)=rain_ints_TOT(1);

t=[0:1:24];
% save('raindata.mat','rain_freq*','t','-append');
SCS              = get(0,'screensize');
    height           = 1080*0.9;
    width            = 1920*0.3;
    ncol             = 2;
    nrow             = 2;
    figcolor='w';
    MenuBar          = 'figure';
    ToolBar          = 'figure';
    marginl=0.02;
    marginr=0.02;
    margind=0.02;
    marginu=0.02;
    margini=0.01;
    figoh=(1-margind-marginu)/ncol;
    figow=(1-marginr-marginl)/nrow;
    
    cont_fig = figure('color',figcolor,'PaperSize',[height*4 width*4],'units','pixels','position',[0 0 width height],'menubar',MenuBar,'toolbar',ToolBar);

subplot(3,1,1)
plot(t,rain_freq_TOT*100,'displayname','Total','linewidth',2,'color','k','marker','o','markersize',4);hold on
plot(t,rain_freq_MAM*100,'displayname','MAM','linewidth',2,'color','g','marker','o','markersize',4)
plot(t,rain_freq_JJA*100,'displayname','JJA','linewidth',2,'color','r','marker','o','markersize',4)
plot(t,rain_freq_SON*100,'displayname','SON','linewidth',2,'color','y','marker','o','markersize',4)
plot(t,rain_freq_DJF*100,'displayname','DJF','linewidth',2,'color','b','marker','o','markersize',4)
set(gca,'Xlim',[0 24],'XTick',[0:4:24],'YLim',[0 10],'YTick',[0:2:10],'FontName','Times New Roman','FontSize',16,'FontWeight','Bold')
ylabel('Frequency (%)')
% axis square
% legend('show','location','northeastoutside')
% legend('boxoff')
hold off
subplot(3,1,2)
plot(t,rain_1hav_TOT,'displayname','Total','linewidth',2,'color','k','marker','o','markersize',4);hold on
plot(t,rain_1hav_MAM,'displayname','MAM','linewidth',2,'color','g','marker','o','markersize',4);
plot(t,rain_1hav_JJA,'displayname','JJA','linewidth',2,'color','r','marker','o','markersize',4);
plot(t,rain_1hav_SON,'displayname','SON','linewidth',2,'color','y','marker','o','markersize',4);
plot(t,rain_1hav_DJF,'displayname','DJF','linewidth',2,'color','b','marker','o','markersize',4);
set(gca,'Xlim',[0 24],'XTick',[0:4:24],'YLim',[0 0.5],'YTick',[0:0.1:0.5],'FontName','Times New Roman','FontSize',16,'FontWeight','Bold')
ylabel('Rain Amount (mm h^{-1})')
% axis square
% legend('show','location','northeastoutside')
% legend('boxoff')
hold off

subplot(3,1,3)
plot(t,rain_ints_TOT,'displayname','Total','linewidth',2,'color','k','marker','o','markersize',4);hold on
plot(t,rain_ints_MAM,'displayname','MAM','linewidth',2,'color','g','marker','o','markersize',4)
plot(t,rain_ints_JJA,'displayname','JJA','linewidth',2,'color','r','marker','o','markersize',4);
plot(t,rain_ints_SON,'displayname','SON','linewidth',2,'color','y','marker','o','markersize',4);
plot(t,rain_ints_DJF,'displayname','DJF','linewidth',2,'color','b','marker','o','markersize',4);
ylabel(['Rain Intensity (mm h^{-1})' ' '])
xlabel('Hour (KST)')
% axis square
set(gca,'Xlim',[0 24],'XTick',[0:4:24],'YLim',[0 7],'YTick',[0:1:7],'FontName','Times New Roman','FontSize',16,'FontWeight','Bold')
l1=legend('show');
set(l1,'Units','normalized','Position',[0.125 0.00 0.8 0.05],'Orientation','horizontal','box','off')
% legend('boxoff')

hold off
%     print('AWS_precip_stat','-dtiffn','-r100')
%     print('AWS_precip_stat','-depsc','-r100')
 subplot(1,2,1)
 raini=3;
plot(t,refmaskMAMKST_24(raini,1:25)*100,'linewidth',2,'color','g','displayname','MAM','marker','o','markersize',4);ylim([0 0.15]);hold on
plot(t,refmaskJJAKST_24(raini,1:25)*100,'linewidth',2,'color','r','displayname','JJA','marker','o','markersize',4);
plot(t,refmaskSONKST_24(raini,1:25)*100,'linewidth',2,'color','y','displayname','SON','marker','o','markersize',4);
plot(t,refmaskDJFKST_24(raini,1:25)*100,'linewidth',2,'color','b','displayname','DJF','marker','o','markersize',4);hold off;
set(gca,'Xlim',[0 24],'XTick',[0:4:24],'YLim',[0 16],'YTick',[0:4:16],'FontName','Times New Roman','FontSize',16,'FontWeight','Bold')
ylabel('Frequency (%)')
subplot(1,2,2)
plot(t,rain_freq_TOT*100,'displayname','Total','linewidth',2,'color','k','marker','o','markersize',4);hold on
plot(t,rain_freq_MAM*100,'displayname','MAM','linewidth',2,'color','g','marker','o','markersize',4)
plot(t,rain_freq_JJA*100,'displayname','JJA','linewidth',2,'color','r','marker','o','markersize',4)
plot(t,rain_freq_SON*100,'displayname','SON','linewidth',2,'color','y','marker','o','markersize',4)
plot(t,rain_freq_DJF*100,'displayname','DJF','linewidth',2,'color','b','marker','o','markersize',4)
set(gca,'Xlim',[0 24],'XTick',[0:4:24],'YLim',[0 16],'YTick',[0:4:16],'FontName','Times New Roman','FontSize',16,'FontWeight','Bold')


raini=4;
rain_tot_cr(1:24)=refmaskMAMKST_24(raini,1:24)*100;
rain_tot_cr(25:48)=refmaskJJAKST_24(raini,1:24)*100;
rain_tot_cr(49:72)=refmaskSONKST_24(raini,1:24)*100;
rain_tot_cr(73:96)=refmaskDJFKST_24(raini,1:24)*100;

rain_tot_aws(1:24)=rain_freq_MAM(1:24)*100;
rain_tot_aws(25:48)=rain_freq_JJA(1:24)*100;
rain_tot_aws(49:72)=rain_freq_SON(1:24)*100;
rain_tot_aws(73:96)=rain_freq_DJF(1:24)*100;

scatter(rain_tot_aws,rain_tot_cr,'.')
corrcoef(rain_tot_aws,rain_tot_cr)