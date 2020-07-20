clear
fl=ls('./nqcnc/*.cfradial');
fn=length(fl);
j=0;
ldrthres=-10.5;
for i=1:fn
    fname=strcat('./nqcnc/',fl(i,:));
    ldr1inst=ncread(fname,'linear_depolarization_ratio');
    ref1inst=ncread(fname,'reflectivity_h');
    vel1inst=ncread(fname,'mean_doppler_velocity_h');
    swh1inst=ncread(fname,'spectral_width_h');
    ldrinst=ldr1inst(1:200,:);
    refinst=ref1inst(1:200,:);
    velinst=vel1inst(1:200,:);
    swhinst=swh1inst(1:200,:);
%     ldr1m=ldrinst(~isnan(ldrinst));
%     swh1m=swhinst(~isnan(ldrinst));
    ldr1m=ldrinst(~isnan(ldrinst)&refinst<-15);
    swh1m=swhinst(~isnan(ldrinst)&refinst<-15);
    ln=length(ldr1m);
    ldrm(j+1:j+ln)=ldr1m;
    swhm(j+1:j+ln)=swh1m;
    j=j+ln;
    clear *inst *1m
end
swll=swhm(ldrm<ldrthres);swhl=swhm(ldrm>=ldrthres);ldll=ldrm(ldrm<ldrthres);ldhl=ldrm(ldrm>=ldrthres);
% histogram(swhl,'normalization','probability','binlimits',[0 0.2])
% hold on
% histogram(swll,'normalization','probability','binlimits',[0 0.2])
% hold off
% histogram(swhl,'binlimits',[0 0.2])
% hold on
% histogram(swll,'binlimits',[0 0.2])
% hold off
hh=histogram2(ldrm,swhm,20,'displaystyle','tile','ybinlimits',[0 0.2],'normalization','probability');
bc=hh.BinCounts./length(ldrm);
xx=hh.XBinEdges
yy=hh.YBinEdges
% pcolor(xx(1:20),yy(1:20),bc)
% pcolor(xx(1:20),yy(1:20),bc')