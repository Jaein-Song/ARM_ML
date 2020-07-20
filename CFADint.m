clear
QCfmax=2;
CFADflag=1;
% if(QC==1)
%     tail='QCed.cdf';
% else
%     tail='noQC.cdf';
% end

zh0=0;
vh0=0;
sh0=0;
zv0=0;
vh0=0;
vv0=0;
sv0=0;
ldr0=0;
zh1=0;
vh1=0;
sh1=0;
zv1=0;
vh1=0;
vv1=0;
sv1=0;
ldr1=0;

for i=1 :12
    tail='cfad_noQC.cdf';
    fn=strcat('./cfads/all/',num2str(i),tail);
    h=ncread(fn,'height');
    zb=ncread(fn,'Reflectivity_Bin');
    vb=ncread(fn,'Velocity_Bin');
    sb=ncread(fn,'SpectralWidth_Bin');
    lb=ncread(fn,'LDR_bin');
    
    n(i)=ncread(fn,'number');
    zh0=zh0+ncread(fn,'Reflectivity_h_CFAD')/(n(i)*720);
    zv0=zv0+ncread(fn,'Reflectivity_v_CFAD')/(n(i)*720);
    vh0=vh0+ncread(fn,'Velocity_h_CFAD')/(n(i)*720);
    vv0=vv0+ncread(fn,'Velocity_v_CFAD')/(n(i)*720);
    sh0=sh0+ncread(fn,'SpectralWidth_h_CFAD')/(n(i)*720);
    sv0=sv0+ncread(fn,'SpectralWidth_v_CFAD')/(n(i)*720);
    ldr0=ldr0+ncread(fn,'LDR_CFAD')/(n(i)*720);
    
    tail='cfad_QCed.cdf';
    fn=strcat('./cfads/all/',num2str(i),tail);
    
    n(i)=ncread(fn,'number');
    zh1=zh1+ncread(fn,'Reflectivity_h_CFAD')/(n(i)*720);
    zv1=zv1+ncread(fn,'Reflectivity_v_CFAD')/(n(i)*720);
    vh1=vh1+ncread(fn,'Velocity_h_CFAD')/(n(i)*720);
    vv1=vv1+ncread(fn,'Velocity_v_CFAD')/(n(i)*720);
    sh1=sh1+ncread(fn,'SpectralWidth_h_CFAD')/(n(i)*720);
    sv1=sv1+ncread(fn,'SpectralWidth_v_CFAD')/(n(i)*720);
    ldr1=ldr1+ncread(fn,'LDR_CFAD')/(n(i)*720);
    
end
out{1,1}.name='Z_{hh} unQCed';
out{1,2}.name='Z_{hv} unQCed';
out{1,3}.name='V_{hh} unQCed';
out{1,4}.name='LDR unQCed';
out{1,1}.var=zh0/12;
out{1,2}.var=zv0/12;
out{1,3}.var=vh0/12;
out{1,4}.var=ldr0/12;
out{1,1}.xlim=[-50 30];
out{1,2}.xlim=[-50 30];
out{1,3}.xlim=[-10 2];
out{1,4}.xlim=[-40 20];
out{1,1}.xax=zb;
out{1,2}.xax=zb;
out{1,3}.xax=vb;
out{1,4}.xax=lb;
out{1,1}.xlb='Reflectivity (dBZ)';
out{1,2}.xlb='Reflectivity (dBZ)';
out{1,3}.xlb='Raidal Velocity (ms^{-1})';
out{1,4}.xlb='Linear Depolarization Ratio (dB)';

out{2,1}.name='Z_{hh} QCed';
out{2,2}.name='Z_{hv} QCed';
out{2,3}.name='V_{hh} QCed';
out{2,4}.name='LDR QCed';
out{2,1}.var=zh1/12;
out{2,2}.var=zv1/12;
out{2,3}.var=vh1/12;
out{2,4}.var=ldr1/12;
out{2,1}.xlim=[-50 30];
out{2,2}.xlim=[-50 30];
out{2,3}.xlim=[-10 2];
out{2,4}.xlim=[-40 20];
out{2,1}.xax=zb;
out{2,2}.xax=zb;
out{2,3}.xax=vb;
out{2,4}.xax=lb;
out{2,1}.xlb='Reflectivity (dBZ)';
out{2,2}.xlb='Reflectivity (dBZ)';
out{2,3}.xlb='Raidal Velocity (ms^{-1})';
out{2,4}.xlb='Linear Depolarization Ratio (dB)';
% figure
% subplot(4,2,1)    
% contourf(zb,h,log10(zh1),'linestyle','none','LevelStep',0.1)
% set(gca,'CLim',[-4 -1])
% ylim([0 15000])
% colorbar
% title('zh')
% 
% subplot(4,2,2)
% contourf(zb,h,log10(zv1),'linestyle','none','LevelStep',0.1)
% set(gca,'CLim',[-4 -1])
% ylim([0 15000])
% colorbar
% title('zv')
% 
% subplot(4,2,3)
% contourf(vb,h,log10(vh1),'linestyle','none','LevelStep',0.1)
% set(gca,'CLim',[-4 -1])
% ylim([0 15000])
% colorbar
% title('vh')
% subplot(4,2,3)
% 
% subplot(4,2,4)
% contourf(vb,h,log10(vv1),'linestyle','none','LevelStep',0.1)
% set(gca,'CLim',[-4 -1])
% ylim([0 15000])
% colorbar
% title('vv')
% 
% subplot(4,2,5)
% contourf(sb,h,log10(sh1),'linestyle','none','LevelStep',0.1)
% set(gca,'CLim',[-4 -1])
% ylim([0 15000])
% colorbar
% title('sh')
% 
% subplot(4,2,6)
% contourf(sb,h,log10(sv1),'linestyle','none','LevelStep',0.1)
% set(gca,'CLim',[-4 -1])
% ylim([0 15000])
% colorbar
% title('sv')
% 
% subplot(4,2,7)
% contourf(lb,h,log10(ldr1),'linestyle','none','LevelStep',0.1)
% set(gca,'CLim',[-4 -1])
% ylim([0 15000])
% colorbar
% title('ldr')
% %%%%%%%%%%%%%
% figure
% subplot(4,2,1)    
% contourf(zb,h,log10(zh0),'linestyle','none','LevelStep',0.1)
% set(gca,'CLim',[-4 -1])
% ylim([0 15000])
% colorbar
% title('zh')
% 
% subplot(4,2,2)
% contourf(zb,h,log10(zv0),'linestyle','none','LevelStep',0.1)
% set(gca,'CLim',[-4 -1])
% ylim([0 15000])
% colorbar
% title('zv')
% 
% subplot(4,2,3)
% contourf(vb,h,log10(vh0),'linestyle','none','LevelStep',0.1)
% set(gca,'CLim',[-4 -1])
% ylim([0 15000])
% colorbar
% title('vh')
% subplot(4,2,3)
% 
% subplot(4,2,4)
% contourf(vb,h,log10(vv0),'linestyle','none','LevelStep',0.1)
% set(gca,'CLim',[-4 -1])
% ylim([0 15000])
% colorbar
% title('vv')
% 
% subplot(4,2,5)
% contourf(sb,h,log10(sh0),'linestyle','none','LevelStep',0.1)
% set(gca,'CLim',[-4 -1])
% ylim([0 15000])
% colorbar
% title('sh')
% 
% subplot(4,2,6)
% contourf(sb,h,log10(sv0),'linestyle','none','LevelStep',0.1)
% set(gca,'CLim',[-4 -1])
% ylim([0 15000])
% colorbar
% title('sv')
% 
% subplot(4,2,7)
% contourf(lb,h,log10(ldr0),'linestyle','none','LevelStep',0.1)
% set(gca,'CLim',[-4 -1])
% ylim([0 15000])
% colorbar
% title('ldr')
