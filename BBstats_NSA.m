clear
%site='SGP'
timezone=[-6 -9 -1]
site_list{1}='SGP';
site_list{2}='NSA';
site_list{3}='ENA';
for sitei=2:2
    clear site datadir matddir era5dir fl* lat* lon*
    site=site_list{sitei}
	datadir=['./DATA/' site '/']
	matddir=['./mat/' site '/']
	era5dir=['./ERA5/files_' site '/']
	if isunix
	    flo=dir([matddir '*.mat']);
	    flno=dir([datadir '*.nc']);
	    fleo=dir([era5dir '*.nc']);
	    i=1;
	    for i=1:length(flo)
	        fl(i,:)=flo(i).name;
	        fln(i,:)=flno(i).name;
	        fle(i,:)=fleo(i).name;
	    end
	    clear flo
	else
	    fl=ls([matddir '*.mat']);
	end
	num_hgt=596;
	num_tim=21600;
	fn=length(fl);
	j=0;
    lat_arm=ncread([datadir fln(1,:)],'lat');
    lon_arm=ncread([datadir fln(1,:)],'lon');
    t=ncread([datadir fln(1,:)],'time');
    lat_era=ncread([era5dir fle(1,:)],'latitude');
    lon_era=ncread([era5dir fle(1,:)],'longitude');
    diff_lon=abs(lon_era-lon_arm);
    diff_lat=abs(lat_era-lat_arm);
    lati=find(diff_lat==min(diff_lat));
    loni=find(diff_lon==min(diff_lon));
    clear lon_* lat_* diff_*
    BB_count=zeros(12,24);
    OB_count=zeros(12,24);
    BH_avg=zeros(12,24);
    k=1;
    for i=1:fn
        ymd=fl(i,1:8);
        fday=str2num(ymd(7:8));
        fyear=str2num(ymd(1:4));
        fmonth=str2num(ymd(5:6));
        matfname=strcat(matddir,ymd);
        fname=strcat(datadir,fln(i,:))
        load(matfname,'BB','BB_height');
        eraname=strcat(era5dir,ymd,'.nc');
        iaf=ncread(fname,'instrument_availability_flag');
        qc_flag=mod(iaf,2);
        if min(qc_flag)==1&&max(BB)==0 %all present no ml
            OB_count(fmonth,:)=OB_count(fmonth,:)+1; 
        elseif min(qc_flag)==1&&max(BB)==1 %all present with some ml
            zdl=ncread(eraname,'deg0l');
            for hi=1:24
                hour=hi-1;
                hi_lst=hi+timezone(sitei);
                hi_lst=mod(hi_lst+24,24)+1;
                start_hi=(hi-1)*900+1;
                end_hi=(hi)*900;
                BBc=BB(BB(start_hi:end_hi)==1);
                OB_count(fmonth,hi_lst)=OB_count(fmonth,hi_lst)+1; 
                if length(BBc)>=150
                    BB_count(fmonth,hi_lst)=BB_count(fmonth,hi)+1;
                    BH_avg(fmonth,hi_lst)=BH_avg(fmonth,hi)+nanmean(BB_height(start_hi:end_hi));
                    BB_ERA(k,1)=zdl(loni,lati,hi);
                    BB_ERA(k,2)=nanmean(BB_height(start_hi:end_hi));
                    BB_ERA(k,3)=str2num(ymd);
                    BB_ERA(k,4)=hour;
                    k=k+1;
                end
            end
        elseif min(qc_flag)==0&&max(BB)==1 %some present with some ml
            zdl=ncread(eraname,'deg0l');
            for hi=1:24
                hi_lst=hi+timezone(sitei);
                hi_lst=mod(hi_lst+24,24)+1;
                hour=hi-1;
                start_hi=(hi-1)*900+1;
                end_hi=(hi)*900;
                BBc=BB(BB(start_hi:end_hi)==1);
                qcc=qc_flag(qc_flag(start_hi:end_hi)==1);
                if length(BBc)/length(qcc)>=1/6&&length(qcc)>450
                    OB_count(fmonth,hi_lst)=OB_count(fmonth,hi_lst)+1; 
                    BB_count(fmonth,hi_lst)=BB_count(fmonth,hi)+1;
                    BH_avg(fmonth,hi_lst)=BH_avg(fmonth,hi)+nanmean(BB_height(start_hi:end_hi));
                    BB_ERA(k,1)=zdl(loni,lati,hi);
                    BB_ERA(k,2)=nanmean(BB_height(start_hi:end_hi));
                    BB_ERA(k,3)=str2num(ymd);
                    BB_ERA(k,4)=hour;
                    k=k+1;
                end
            end
        end
        clear BB BB_height zdl iaf qc_flag
    end
    save([site '_BB_stat.mat'], 'BB_count','BH_avg','BB_ERA','OB_count')
end
