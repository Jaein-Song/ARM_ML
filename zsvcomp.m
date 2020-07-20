fl=ls('cilnc/*l');
for fi=1:length(fl)
    fn=fl(fi,:);
    fn=strcat('./cilnc/',fn);
    z=ncread(fn,'reflectivity_h');
    v=ncread(fn,'mean_doppler_velocity_h');
    l=ncread(fn,'linear_depolarization_ratio');
    s=ncread(fn,'spectral_width_h');
    for i=1:720
    z1((fi-1)*1000*720+(i-1)*1000+1:(fi-1)*1000*720+i*1000)=z(:,i);
    s1((fi-1)*1000*720+(i-1)*1000+1:(fi-1)*1000*720+i*1000)=s(:,i);
    v1((fi-1)*1000*720+(i-1)*1000+1:(fi-1)*1000*720+i*1000)=v(:,i);
    l1((fi-1)*1000*720+(i-1)*1000+1:(fi-1)*1000*720+i*1000)=l(:,i);
    end
    
end
z1f=z1(~isnan(s1)&s1>0);
s1f=s1(~isnan(s1)&s1>0);
v1f=v1(~isnan(s1)&s1>0);
l1f=l1(~isnan(s1)&s1>0);
z1bb=z1f(l1f>-5);
l1bb=l1f(l1f>-5);
s1bb=s1f(l1f>-5);
v1bb=v1f(l1f>-5);

z1fa=z1f(v1f<-1);
l1fa=l1f(v1f<-1);
s1fa=s1f(v1f<-1);
v1fa=v1f(v1f<-1);