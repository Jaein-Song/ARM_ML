t=[0:1:24];
load('raindata.mat');
load('raincol.mat');

SCS              = get(0,'screensize');
    height           = 1080*0.6;
    width            = 1920*0.6;
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

subplot(2,2,1)
plot(t,rain_freq_TOT*100,'displayname','Total','linewidth',2,'color','k','marker','o','markersize',4);hold on
plot(t,rain_freq_MAM*100,'displayname','MAM','linewidth',2,'color','g','marker','o','markersize',4)
plot(t,rain_freq_JJA*100,'displayname','JJA','linewidth',2,'color','r','marker','o','markersize',4)
plot(t,rain_freq_SON*100,'displayname','SON','linewidth',2,'color','y','marker','o','markersize',4)
plot(t,rain_freq_DJF*100,'displayname','DJF','linewidth',2,'color','b','marker','o','markersize',4)
set(gca,'Xlim',[0 24],'XTick',[0:4:24],'YLim',[0 15],'YTick',[0:3:15],'FontName','Times New Roman','FontSize',16,'FontWeight','Bold')
ylabel('Frequency (%)')
% axis square
% legend('show','location','northeastoutside')
% legend('boxoff')
hold off
subplot(2,2,2)
plot(t,refmaskTOTKST_24(2,1:25)*100,'displayname','Total','linewidth',2,'color','k','marker','o','markersize',4);hold on
plot(t,refmaskMAMKST_24(2,1:25)*100,'displayname','MAM','linewidth',2,'color','g','marker','o','markersize',4)
plot(t,refmaskJJAKST_24(2,1:25)*100,'displayname','JJA','linewidth',2,'color','r','marker','o','markersize',4)
plot(t,refmaskSONKST_24(2,1:25)*100,'displayname','SON','linewidth',2,'color','y','marker','o','markersize',4)
plot(t,refmaskDJFKST_24(2,1:25)*100,'displayname','DJF','linewidth',2,'color','b','marker','o','markersize',4)
set(gca,'Xlim',[0 24],'XTick',[0:4:24],'YLim',[0 15],'YTick',[0:3:15],'FontName','Times New Roman','FontSize',16,'FontWeight','Bold')
ylabel('Frequency (%)')
subplot(2,2,3)
plot(t,rain_freq_TOT./mean(rain_freq_TOT),'displayname','Total','linewidth',2,'color','k','marker','o','markersize',4);
hold on
plot(t,rain_freq_MAM./mean(rain_freq_MAM),'displayname','MAM','linewidth',2,'color','g','marker','o','markersize',4)
plot(t,rain_freq_JJA./mean(rain_freq_JJA),'displayname','JJA','linewidth',2,'color','r','marker','o','markersize',4)
plot(t,rain_freq_SON./mean(rain_freq_SON),'displayname','SON','linewidth',2,'color','y','marker','o','markersize',4)
plot(t,rain_freq_DJF./mean(rain_freq_DJF),'displayname','DJF','linewidth',2,'color','b','marker','o','markersize',4)
plot([0 24],[1 1],'color',[0.5 0.5 0.5],'linewidth',2,'linestyle','--')
set(gca,'Xlim',[0 24],'XTick',[0:4:24],'YLim',[0 2],'YTick',[0:0.4:2],'FontName','Times New Roman','FontSize',16,'FontWeight','Bold')
ylabel('Frequency (%)')
% axis square
% legend('show','location','northeastoutside')
% legend('boxoff')
hold off
subplot(2,2,4)
plot(t,refmaskTOTKST_24(2,1:25)./mean(refmaskTOTKST_24(2,1:25)),'displayname','Total','linewidth',2,'color','k','marker','o','markersize',4);
hold on
plot(t,refmaskMAMKST_24(2,1:25)./mean(refmaskMAMKST_24(2,1:25)),'displayname','MAM','linewidth',2,'color','g','marker','o','markersize',4)
plot(t,refmaskJJAKST_24(2,1:25)./mean(refmaskJJAKST_24(2,1:25)),'displayname','JJA','linewidth',2,'color','r','marker','o','markersize',4)
plot(t,refmaskSONKST_24(2,1:25)./mean(refmaskSONKST_24(2,1:25)),'displayname','SON','linewidth',2,'color','y','marker','o','markersize',4)
plot(t,refmaskDJFKST_24(2,1:25)./mean(refmaskDJFKST_24(2,1:25)),'displayname','DJF','linewidth',2,'color','b','marker','o','markersize',4)
plot([0 24],[1 1],'color',[0.5 0.5 0.5],'linewidth',2,'linestyle','--')
set(gca,'Xlim',[0 24],'XTick',[0:4:24],'YLim',[0 2],'YTick',[0:0.4:2],'FontName','Times New Roman','FontSize',16,'FontWeight','Bold')
ylabel('Frequency (%)')

    norm_fig = figure('color',figcolor,'PaperSize',[height*2 width*2],'units','pixels','position',[0 0 width/2 height/2],'menubar',MenuBar,'toolbar',ToolBar);
plot(t,(refmaskTOTKST_24(2,1:25)-rain_freq_TOT)*100,'displayname','Total','linewidth',2,'color','k','marker','o','markersize',4);
hold on
plot(t,(refmaskMAMKST_24(2,1:25)-rain_freq_MAM)*100,'displayname','MAM','linewidth',2,'color','g','marker','o','markersize',4)
plot(t,(refmaskJJAKST_24(2,1:25)-rain_freq_JJA)*100,'displayname','JJA','linewidth',2,'color','r','marker','o','markersize',4)
plot(t,(refmaskSONKST_24(2,1:25)-rain_freq_SON)*100,'displayname','SON','linewidth',2,'color','y','marker','o','markersize',4)
plot(t,(refmaskDJFKST_24(2,1:25)-rain_freq_DJF)*100,'displayname','DJF','linewidth',2,'color','b','marker','o','markersize',4)
plot([0 24],[0 0],'color',[0.5 0.5 0.5],'linewidth',2,'linestyle','--')
set(gca,'Xlim',[0 24],'XTick',[0:4:24],'YLim',[-5 10],'YTick',[-1:1:10],'FontName','Times New Roman','FontSize',16,'FontWeight','Bold')
ylabel('Frequency (%)')
% plot(t,refmaskTOTKST_24(2,1:25)./mean(refmaskTOTKST_24(2,1:25))-rain_freq_TOT./mean(rain_freq_TOT),'displayname','Total','linewidth',2,'color','k','marker','o','markersize',4);
% hold on
% plot(t,refmaskMAMKST_24(2,1:25)./(refmaskTOTKST_24(2,1:25))-rain_freq_MAM./(rain_freq_TOT),'displayname','MAM','linewidth',2,'color','g','marker','o','markersize',4)
% plot(t,refmaskJJAKST_24(2,1:25)./(refmaskTOTKST_24(2,1:25))-rain_freq_JJA./(rain_freq_TOT),'displayname','JJA','linewidth',2,'color','r','marker','o','markersize',4)
% plot(t,refmaskSONKST_24(2,1:25)./(refmaskTOTKST_24(2,1:25))-rain_freq_SON./(rain_freq_TOT),'displayname','SON','linewidth',2,'color','y','marker','o','markersize',4)
% plot(t,refmaskDJFKST_24(2,1:25)./(refmaskTOTKST_24(2,1:25))-rain_freq_DJF./(rain_freq_TOT),'displayname','DJF','linewidth',2,'color','b','marker','o','markersize',4)
% plot([0 24],[0 0],'color',[0.5 0.5 0.5],'linewidth',2,'linestyle','--')
% set(gca,'Xlim',[0 24],'XTick',[0:4:24],'YLim',[-0.3 0.3],'YTick',[-0.3:0.15:0.3],'FontName','Times New Roman','FontSize',16,'FontWeight','Bold')
% ylabel('Frequency (%)')

% plot(t,refmaskTOTKST_24(2,1:25)./mean(refmaskTOTKST_24(2,1:25))-rain_freq_TOT./mean(rain_freq_TOT),'displayname','Total','linewidth',2,'color','k','marker','o','markersize',4);
% hold on
% plot(t,refmaskMAMKST_24(2,1:25)./mean(refmaskMAMKST_24(2,1:25))-rain_freq_MAM./mean(rain_freq_MAM),'displayname','MAM','linewidth',2,'color','g','marker','o','markersize',4)
% plot(t,refmaskJJAKST_24(2,1:25)./mean(refmaskJJAKST_24(2,1:25))-rain_freq_JJA./mean(rain_freq_JJA),'displayname','JJA','linewidth',2,'color','r','marker','o','markersize',4)
% plot(t,refmaskSONKST_24(2,1:25)./mean(refmaskSONKST_24(2,1:25))-rain_freq_SON./mean(rain_freq_SON),'displayname','SON','linewidth',2,'color','y','marker','o','markersize',4)
% plot(t,refmaskDJFKST_24(2,1:25)./mean(refmaskDJFKST_24(2,1:25))-rain_freq_DJF./mean(rain_freq_DJF),'displayname','DJF','linewidth',2,'color','b','marker','o','markersize',4)
% plot([0 24],[0 0],'color',[0.5 0.5 0.5],'linewidth',2,'linestyle','--')
% set(gca,'Xlim',[0 24],'XTick',[0:4:24],'YLim',[-0.3 0.3],'YTick',[-0.3:0.15:0.3],'FontName','Times New Roman','FontSize',16,'FontWeight','Bold')
% ylabel('Frequency (%)')


% subplot(2,2,3)
% % plot(t,rain_freq_TOT*100,'displayname','Total','linewidth',2,'color','k','marker','o','markersize',4);
% hold on
% plot(t,rain_freq_MAM./rain_freq_TOT,'displayname','MAM','linewidth',2,'color','g','marker','o','markersize',4)
% plot(t,rain_freq_JJA./rain_freq_TOT,'displayname','JJA','linewidth',2,'color','r','marker','o','markersize',4)
% plot(t,rain_freq_SON./rain_freq_TOT,'displayname','SON','linewidth',2,'color','y','marker','o','markersize',4)
% plot(t,rain_freq_DJF./rain_freq_TOT,'displayname','DJF','linewidth',2,'color','b','marker','o','markersize',4)
% set(gca,'Xlim',[0 24],'XTick',[0:4:24],'YLim',[0 2],'YTick',[0:0.4:2],'FontName','Times New Roman','FontSize',16,'FontWeight','Bold')
% ylabel('Frequency (%)')
% % axis square
% % legend('show','location','northeastoutside')
% % legend('boxoff')
% hold off
% subplot(2,2,4)
% % plot(t,refmaskTOTKST_24(2,1:25)*100,'displayname','Total','linewidth',2,'color','k','marker','o','markersize',4);
% hold on
% plot(t,refmaskMAMKST_24(2,1:25)./refmaskTOTKST_24(2,1:25),'displayname','MAM','linewidth',2,'color','g','marker','o','markersize',4)
% plot(t,refmaskJJAKST_24(2,1:25)./refmaskTOTKST_24(2,1:25),'displayname','JJA','linewidth',2,'color','r','marker','o','markersize',4)
% plot(t,refmaskSONKST_24(2,1:25)./refmaskTOTKST_24(2,1:25),'displayname','SON','linewidth',2,'color','y','marker','o','markersize',4)
% plot(t,refmaskDJFKST_24(2,1:25)./refmaskTOTKST_24(2,1:25),'displayname','DJF','linewidth',2,'color','b','marker','o','markersize',4)
% set(gca,'Xlim',[0 24],'XTick',[0:4:24],'YLim',[0 2],'YTick',[0:0.4:2],'FontName','Times New Roman','FontSize',16,'FontWeight','Bold')
% ylabel('Frequency (%)')
% plot(refmaskDJFKST_24(2,2:25));hold on;
% plot(refmaskMAMKST_24(2,:));
% plot(refmaskJJAKST_24(2,:));
% plot(refmaskSONKST_24(2,:));
% plot(refmaskTOTKST_24(2,:));hold off