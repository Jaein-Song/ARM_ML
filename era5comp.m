clear
lat_i=22;
lon_i=14;
ndir='./ERA5/';
mdir='./mat/';
nflist=ls([ndir '*.nc']);
nfleng=length(nflist);
k=1;
l=1;
for fi=1:nfleng
    nfname=nflist(fi,:);
    ys=nfname(1:4);y=str2num(ys);
    ms=nfname(5:6);m=str2num(ms);
    ds=nfname(7:8);d=str2num(ds);
    hs=nfname(9:10);h=str2num(hs);
    nfname=[ndir nfname];
    temp_4=ncread(nfname,'t');
    temp=squeeze(temp_4(lon_i,lat_i,:,1));
    pres=ncread(nfname,'level');
    pres=double(pres);
    height=0.3048.*145366.45.*(1-(pres./1013.25).^0.190284);
    mflist=ls([mdir '*' ys ms ds '.mat']);
    mfname=[mdir mflist(1,:)];
    load(mfname,'BB_height')
    BB_h=nanmean(BB_height(h*30+1:(h+1)*30));
    if length(BB_height(~isnan(BB_height(h*30+1:(h+1)*30))))>5
        h_i=find(height<=BB_h,1);
        hl=height(h_i);tl=temp(h_i);
        hh=height(h_i-1);th=temp(h_i-1);
        tb=(th-tl)/(hh-hl)*(BB_h-hl)+tl;
        temp_BB(k)=tb;
        t(k,1:6)=[y,m,d,h,BB_h,tb-273];
        k=k+1;
    else
        x(l,1:4)=[y,m,d,h];
        l=l+1;
    end
    clear temp h BB_height mfname mflist tb hl hh
end
ero5=t(find(temp_BB>=278),:);