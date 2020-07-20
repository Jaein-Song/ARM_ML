clear 
load('Cloud_BB_Rain')
%% Change to Local Time and Integerate as hourly data
totalnum_KST=UTC2KST(totalnum,2);
cloud_num_KST=UTC2KST(cloud_num,2);
BB_num_KST=UTC2KST(BB_num,2);
rain_intsty_bin_KST=UTC2KST(rain_intsty_bin,3);
BB_height_bin_KST=UTC2KST(BB_height_bin,3);

totalnum_KST24=min2hourly(totalnum_KST,2,12,720);
cloud_num_KST24=min2hourly(cloud_num_KST,2,12,720);
BB_num_KST24=min2hourly(BB_num_KST,2,12,720);
rain_intsty_bin_KST24=min2hourly(rain_intsty_bin_KST,3,12,720,16);
BB_height_bin_KST24=min2hourly(BB_height_bin_KST,3,12,720,50);

for ti=1:24
    TN(ti)=sum(totalnum_KST24(:,ti));
    CN(ti)=sum(cloud_num_KST24(:,ti));
    BN(ti)=sum(BB_num_KST24(:,ti));
    
    TN_MAM(ti)=sum(totalnum_KST24(3:5,ti)); 
    CN_MAM(ti)=sum(cloud_num_KST24(3:5,ti));
    BN_MAM(ti)=sum(BB_num_KST24(3:5,ti));
    
    TN_JJA(ti)=sum(totalnum_KST24(6:8,ti));
    CN_JJA(ti)=sum(cloud_num_KST24(6:8,ti));
    BN_JJA(ti)=sum(BB_num_KST24(6:8,ti));
    
    TN_JJ(ti)=sum(totalnum_KST24(6:7,ti));
    CN_JJ(ti)=sum(cloud_num_KST24(6:7,ti));
    BN_JJ(ti)=sum(BB_num_KST24(6:7,ti));
    TN_AS(ti)=sum(totalnum_KST24(8:9,ti));
    CN_AS(ti)=sum(cloud_num_KST24(8:9,ti));
    BN_AS(ti)=sum(BB_num_KST24(8:9,ti));

    TN_SON(ti)=sum(totalnum_KST24(9:11,ti));
    CN_SON(ti)=sum(cloud_num_KST24(9:11,ti));
    BN_SON(ti)=sum(BB_num_KST24(9:11,ti));
    
    TN_DJF(ti)=sum(totalnum_KST24(1:2,ti))+sum(totalnum_KST24(12,ti));
    CN_DJF(ti)=sum(cloud_num_KST24(1:2,ti))+sum(cloud_num_KST24(12,ti));
    BN_DJF(ti)=sum(BB_num_KST24(1:2,ti))+sum(BB_num_KST24(12,ti));
    
    for zi=1:16
        RI(ti,zi)=sum(rain_intsty_bin_KST24(:,ti,zi));
        RI_MAM(ti,zi)=sum(rain_intsty_bin_KST24(3:5,ti,zi));
        RI_JJA(ti,zi)=sum(rain_intsty_bin_KST24(6:8,ti,zi));
        RI_JJ(ti,zi)=sum(rain_intsty_bin_KST24(6:7,ti,zi));
        RI_AS(ti,zi)=sum(rain_intsty_bin_KST24(8:9,ti,zi));
        RI_SON(ti,zi)=sum(rain_intsty_bin_KST24(9:11,ti,zi));
        RI_DJF(ti,zi)=sum(rain_intsty_bin_KST24(1:2,ti,zi))+sum(rain_intsty_bin_KST24(12,ti,zi));
    end
    for zi=1:50
        BB(ti,zi)=sum(BB_height_bin_KST24(:,ti,zi));
        BB_MAM(ti,zi)=sum(BB_height_bin_KST24(3:5,ti,zi));
        BB_JJA(ti,zi)=sum(BB_height_bin_KST24(6:8,ti,zi));
        BB_JJ(ti,zi)=sum(BB_height_bin_KST24(6:7,ti,zi));
        BB_AS(ti,zi)=sum(BB_height_bin_KST24(8:9,ti,zi));
        BB_SON(ti,zi)=sum(BB_height_bin_KST24(9:11,ti,zi));
        BB_DJF(ti,zi)=sum(BB_height_bin_KST24(1:2,ti,zi))+sum(BB_height_bin_KST24(12,ti,zi));
    end
end
% for ti=1:24
%     for zi=1:16
%         RIb(ti,zi)=sum(RI(ti,1:zi));
%         RIb_MAM(ti,zi)=sum(RI_MAM(ti,1:zi));
%         RIb_JJA(ti,zi)=sum(RI_JJA(ti,1:zi));
%         RIb_SON(ti,zi)=sum(RI_SON(ti,1:zi));
%         RIb_DJF(ti,zi)=sum(RI_DJF(ti,1:zi));
%     end
%     for zi=1:50
%         BBb(ti,zi)=sum(BB(ti,1:zi));
%         BBb_MAM(ti,zi)=sum(BB_MAM(ti,1:zi));
%         BBb_JJA(ti,zi)=sum(BB_JJA(ti,1:zi));
%         BBb_SON(ti,zi)=sum(BB_SON(ti,1:zi));
%         BBb_DJF(ti,zi)=sum(BB_DJF(ti,1:zi));
%     end
% end
t1=[1:24]-0.5;
% 
% bar(t1*2-1,CN./TN,0.5);
% hold on
% colormap(jet)
% cmap=jet(16);
% bar(t1*2,CN./TN,0.5);
% % bar(t1*2-1,RI./TN,'stacked');
% % bar(t1*2,BB./TN,0.5,'stacked');
% for zi=16:-1:1
%     bar(t1*2-1,RIb(ti,zi)./TN,0.5,'facecolor',cmap(zi,:));
% end
% clear cmap
% cmap=jet(50);
% for zi=50:-1:1
%     bar(t1*2,BBb(ti,zi)./TN,0.5,'facecolor',cmap(zi,:));
% end
% clear cmap
% hold off
% t1=[1:24];
% 
for i=1:16
    TN16(:,i)=TN;
    TN16_MAM(:,i)=TN_MAM;
    TN16_JJA(:,i)=TN_JJA;
    TN16_JJ(:,i)=TN_JJ;
    TN16_AS(:,i)=TN_AS;
    TN16_SON(:,i)=TN_SON;
    TN16_DJF(:,i)=TN_DJF;
end
for i=1:50
    TN50(:,i)=TN;
    TN50_MAM(:,i)=TN_MAM;
    TN50_JJA(:,i)=TN_JJA;
    TN50_JJ(:,i)=TN_JJ;
    TN50_AS(:,i)=TN_AS;
    TN50_SON(:,i)=TN_SON;
    TN50_DJF(:,i)=TN_DJF;
end
% subplot(3,1,1)
bar(t1,CN./TN,1,'facecolor',[0.5 0.5 0.5]);
title('Cloud Occurrence Total')
print('-djpeg','Cloud_Occurrence_Total')
bar(t1,CN_MAM./TN_MAM,1,'facecolor',[0.5 0.5 0.5]);

title('Cloud Occurrence MAM')
print('-djpeg','Cloud_Occurrence_MAM')
bar(t1,CN_JJA./TN_JJA,1,'facecolor',[0.5 0.5 0.5]);
title('Cloud Occurrence JJA')
print('-djpeg','Cloud_Occurrence_JJA')
bar(t1,CN_SON./TN_SON,1,'facecolor',[0.5 0.5 0.5]);
title('Cloud Occurrence SON')
print('-djpeg','Cloud_Occurrence_SON')
bar(t1,CN_DJF./TN_DJF,1,'facecolor',[0.5 0.5 0.5]);
title('Cloud Occurrence DJF')
print('-djpeg','Cloud_Occurrence_DJF')


subplot(2,1,1)
title('Rain Intensity Total')
colormap jet
bar(t1,RI./TN16,1,'stacked','linestyle','none');ylim([0 0.2]);xlim([0 24]);
colorbar('peer',gca,'Ticks',[1 4 7 10 13 16],...
    'TickLabels',{'-15','-7.5','0','7.5','15','22.5'});
hold off
subplot(2,1,2)
title('Bright Band Height Total')
bar(t1,BB./TN50,1,'stacked','linestyle','none');ylim([0 0.1]);xlim([0 24]);
colormap jet
colorbar('peer',gca,'Ticks',[1 10 20 30 40 50],...
    'TickLabels',{'0','3000','6000','9000','12000','15000'});
print('-djpeg', 'RIBB_total')

subplot(2,1,1)
title('Rain Intensity MAM')
colormap jet
bar(t1,RI_MAM./TN16_MAM,1,'stacked','linestyle','none');ylim([0 0.2]);xlim([0 24]);

colorbar('peer',gca,'Ticks',[1 4 7 10 13 16],...
    'TickLabels',{'-15','-7.5','0','7.5','15','22.5'});
hold off
subplot(2,1,2)
title('Bright Band Height MAM')
bar(t1,BB_MAM./TN50_MAM,1,'stacked','linestyle','none');ylim([0 0.1]);xlim([0 24]);
colormap jet
colorbar('peer',gca,'Ticks',[1 10 20 30 40 50],...
    'TickLabels',{'0','3000','6000','9000','12000','15000'});
print('-djpeg', 'RIBB_MAM')

subplot(2,1,1)
title('Rain Intensity JJA')
colormap jet
bar(t1,RI_JJA./TN16_JJA,1,'stacked','linestyle','none');ylim([0 0.2]);xlim([0 24]);
colorbar('peer',gca,'Ticks',[1 4 7 10 13 16],...
    'TickLabels',{'-15','-7.5','0','7.5','15','22.5'});
hold off
subplot(2,1,2)
title('Bright Band Height Total')
bar(t1,BB_JJA./TN50_JJA,1,'stacked','linestyle','none');ylim([0 0.1]);xlim([0 24]);
colormap jet
colorbar('peer',gca,'Ticks',[1 10 20 30 40 50],...
    'TickLabels',{'0','3000','6000','9000','12000','15000'});
print('-djpeg', 'RIBB_JJA')

subplot(2,1,1)
title('Rain Intensity SON')
colormap jet
bar(t1,RI_SON./TN16_SON,1,'stacked','linestyle','none');ylim([0 0.2]);xlim([0 24]);
colorbar('peer',gca,'Ticks',[1 4 7 10 13 16],...
    'TickLabels',{'-15','-7.5','0','7.5','15','22.5'});
hold off
subplot(2,1,2)
title('Bright Band Height SON')
bar(t1,BB_SON./TN50_SON,1,'stacked','linestyle','none');ylim([0 0.1]);xlim([0 24]);
colormap jet
colorbar('peer',gca,'Ticks',[1 10 20 30 40 50],...
    'TickLabels',{'0','3000','6000','9000','12000','15000'});
print('-djpeg', 'RIBB_SON')

subplot(2,1,1)
title('Rain Intensity DJF')
colormap jet
bar(t1,RI_DJF./TN16_DJF,1,'stacked','linestyle','none');ylim([0 0.2]);xlim([0 24]);
colorbar('peer',gca,'Ticks',[1 4 7 10 13 16],...
    'TickLabels',{'-15','-7.5','0','7.5','15','22.5'});
hold off
subplot(2,1,2)
title('Bright Band Height DJF')
bar(t1,BB_DJF./TN50_DJF,1,'stacked','linestyle','none');ylim([0 0.1]);xlim([0 24]);
colormap jet
colorbar('peer',gca,'Ticks',[1 10 20 30 40 50],...
    'TickLabels',{'0','3000','6000','9000','12000','15000'});
print('-djpeg', 'RIBB_DJF')

subplot(2,1,1)
title('Rain Intensity JJ')
colormap jet
bar(t1,RI_JJ./TN16_JJ,1,'stacked','linestyle','none');ylim([0 0.2]);xlim([0 24]);
colorbar('peer',gca,'Ticks',[1 4 7 10 13 16],...
    'TickLabels',{'-15','-7.5','0','7.5','15','22.5'});
hold off
subplot(2,1,2)
title('Bright Band Height JJ')
bar(t1,BB_JJ./TN50_JJ,1,'stacked','linestyle','none');ylim([0 0.1]);xlim([0 24]);
colormap jet
colorbar('peer',gca,'Ticks',[1 10 20 30 40 50],...
    'TickLabels',{'0','3000','6000','9000','12000','15000'});
print('-djpeg', 'RIBB_JJ')

subplot(2,1,1)
title('Rain Intensity AS')
colormap jet
bar(t1,RI_AS./TN16_AS,1,'stacked','linestyle','none');ylim([0 0.2]);xlim([0 24]);
colorbar('peer',gca,'Ticks',[1 4 7 10 13 16],...
    'TickLabels',{'-15','-7.5','0','7.5','15','22.5'});
hold off
subplot(2,1,2)
title('Bright Band Height AS')
bar(t1,BB_AS./TN50_AS,1,'stacked','linestyle','none');ylim([0 0.1]);xlim([0 24]);
colormap jet
colorbar('peer',gca,'Ticks',[1 10 20 30 40 50],...
    'TickLabels',{'0','3000','6000','9000','12000','15000'});
print('-djpeg', 'RIBB_AS')

clear ti zi 
save('Cloud_BB_Rain_PP','*');
