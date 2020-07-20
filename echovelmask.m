clear
%site='SGP'
site_list{1}='SGP';
site_list{2}='TWP';
site_list{3}='NSA';
site_list{4}='ENA';
for sitei=1:4
    site=site_list{sitei}
datadir=['./DATA/' site '/']
matddir=['./mat/' site '/']
if isunix
    flo=dir([datadir '*.nc']);
    i=1;
    for i=1:length(flo)
        fl(i,:)=flo(i).name;
    end
    clear flo
else
    fl=ls([datadir '*.nc']);
end
num_hgt=596;
num_tim=21600;
fn=length(fl);
j=0;
ref2mask=zeros(num_hgt,num_tim);
ldrthres=-10.5;
k=1;
nanthres=10;
rainl=0;
rainli=1;
totalnum=zeros(12,num_tim);
cloud_num=zeros(12,num_tim);
BB_num=zeros(12,num_tim);
rain_intsty_bin=zeros(12,num_tim,16);
BB_height_bin=zeros(12,num_tim,50);
for i=1:fn
    fn_length=length(fl(i,:));
    ymd=fl(i,fn_length-17:fn_length-10);
    matfname=strcat(matddir,ymd);
    fname=strcat(datadir,fl(i,:));
    vel=ncread(fname,'mean_doppler_velocity');
    ldr=ncread(fname,'linear_depolarization_ratio');
    z=ncread(fname,'reflectivity_best_estimate');
    iaf=ncread(fname,'instrument_availability_flag');
    height_nc=ncread(fname,'height');
    vel(z<-100)=NaN;
    ldr(z<-100)=NaN;
    z(z<-100)=NaN;
    iaf(iaf<-100)=NaN;
    nanmask=zeros(1,length(iaf));
    nanmask(mod(iaf,2)==1)=11;
    clear rainflag* rain_intsty BB_height BB 
    rainmask=NaN(num_hgt,num_tim);
    rainflag=NaN(1,num_tim);
    rainflag0=NaN(1,num_tim);
    rainflag10=NaN(1,num_tim);
    rain_intsty=NaN(1,num_tim);
    rainmask(~isnan(z))=0;
    BB=zeros(1,num_tim);
    BB_height=NaN(1,num_tim);
    rainflag(nanmask>10)=0;
    fday=str2num(ymd(7:8));
    fyear=str2num(ymd(1:4));
    fmonth=str2num(ymd(5:6));
    k=0;
%% Check Total Number and Cloud amount
    for ti=2:num_tim
        if nanmask(ti)>10   
            totalnum(fmonth,ti)=totalnum(fmonth,ti)+1;
            z_nan=length(z(~isnan(z(:,ti)),ti));
            if z_nan>0
                cloud_num(fmonth,ti)=cloud_num(fmonth,ti)+1;
            end
            clear z_nan
        end
%% Check Rain type/intensity        
        if z(6,ti)>-15&&nanmask(ti)>10
            rainflag(ti)=1;
            rain_intsty(ti)=z(6,ti);
            binno=floor((z(6,ti)+15)/2.5)+1;
            if binno>6
                binno=6;
            end
            rain_intsty_bin(fmonth,ti,binno)=rain_intsty_bin(fmonth,ti,binno)+1;
            if z(6,ti)>0
                rainflag0(ti)=1;
                if z(6,ti)>10
                    rainflag10(ti)=1;
                end
            end
            if length(rainl(rainl==z(6,ti)))<1
                rainl(rainli)=z(6,ti);
                rainls(rainli,1)=str2num(ymd);
                rainls(rainli,2)=ti;
                rainli=rainli+1;             
            end
            rainmask(1:6,ti)=1;
            for hi=6:num_hgt
                if hi>5&&rainmask(hi-1,ti)==1
                    if (z(hi,ti)<-15||vel(hi,ti)>vel(5,ti)*0.6)
                        rainmask(hi,ti)=0;
                    else
                        rainmask(hi,ti)=1;
                    end
                elseif rainmask(hi-1,ti)==0
                    rainmask(hi,ti)=0;
                end
            end
        end
%% Check Melting Layer Presence and Height
        ldr_nan=length(ldr(~isnan(ldr(:,ti)),ti));
        max_z=max(z(7:num_hgt,ti));
        max_ldr=max(ldr(7:num_hgt,ti));
        ldrthres=-20;
%%Cond for BOS
%        if max_z>0&&max_ldr<-20
%            ldrthres=-30;
%        end
%%%
        if ldr_nan>0&&nanmask(ti)>10&&max_z>-10
            BB_flag=0;
            z_diff=diff(z(:,ti));
            vel_diff=diff(vel(:,ti));
            ldr_diff=diff(ldr(:,ti));
            hi=9;
            k=0;
            while hi<num_hgt-4&&~isempty(z(~isnan(z(hi:num_hgt,ti)),ti))
%                 if ldr_diff(hi)<0&&ldr_diff(hi-1)>0&&ldr(hi,ti)>-40
                if (z_diff(hi)<0&&z_diff(hi-1)>0||z_diff(hi)==0)&&max(ldr(hi-4:hi+4,ti))>ldrthres&&z(hi,ti)>-10
                    max_diff=z_diff(hi-4);
                    min_diff=z_diff(hi+4);
                    hi_max=hi-4;
                    hi_min=hi+4;
                    for hhi=hi-4:hi+4
                        if z_diff(hhi)>max_diff
                            max_diff=z_diff(hhi);
                            hi_max=hhi;
                        end
                        if z_diff(hhi)<min_diff
                            min_diff=z_diff(hhi);
                            hi_min=hhi+1;
                        end
                    end
                    clear max_diff min_diff
                    slope_left=(z(hi,ti)-z(hi_max,ti))/(hi-hi_max);
                    slope_right=(z(hi,ti)-z(hi_min,ti))/(hi_min-hi);
                    if hi==hi_max
                        slope_left=0;
                    elseif hi==hi_min
                    end
                    slope_left=slope_left/2;
                    slope_right=slope_right/2;

                    ldr_nan_partial=length(ldr(~isnan(ldr(hi-3:hi+3,ti)),ti));
                    if ldr_nan_partial>0&&slope_left>=0.05&&slope_right>=0.1
                        max_ldr=nanmax(ldr(hi-4:hi+4,ti));
                        if max_ldr~=ldr(hi-4,ti)&&max_ldr~=ldr(hi+4,ti)
                            for hhi=hi-4:hi+4

                                if ldr(hhi,ti)==max_ldr
                                    hi_xldr=hhi;
                                end
                            end
                        max_diff=nanmax(ldr_diff(hi_xldr-4:hi_xldr));
                        min_diff=nanmin(ldr_diff(hi_xldr:hi_xldr+4));
                            for hhi=hi_xldr-4:hi_xldr+4
                                if ldr_diff(hhi)==max_diff
                                    hi_max=hhi;
                                end
                                if ldr_diff(hhi)==min_diff
                                    hi_min=hhi+1; 
                                end
                            end
                           
                            slope_left=(ldr(hi_xldr,ti)-ldr(hi_max,ti))/(hi_xldr-hi_max);
                            slope_right=(ldr(hi_xldr,ti)-ldr(hi_min,ti))/(hi_min-hi_xldr);
                            slope_left=slope_left/2;
                            slope_right=slope_right/2;
%                             if max_ldr<-20
%                                 ldr_slope_thresh=0.3;
%                             elseif max_ldr<-10
                                ldr_slope_thresh=0.2;
%                             else
%                                 ldr_slope_thresh=0.1;
%                             end
%                             if slope_left>=ldr_slope_thresh&&slope_right>ldr_slope_thresh&&max(vel_diff(hi_xldr-2:hi_xldr+2))>0.06
%                             if slope_left>=ldr_slope_thresh&&slope_right>=ldr_slope_thresh&&max(vel_diff(hi_xldr-2:hi_xldr+2))>0.1
                            if slope_left>=ldr_slope_thresh&&slope_right>=ldr_slope_thresh&&(nanmax(vel(hi_xldr:hi_xldr+2,ti))-nanmin(vel(hi_xldr-2:hi_xldr,ti)))>0.6&&nanmax(vel(hi_xldr:hi_xldr+2,ti))<0.5&&nanmin(vel(hi_xldr-2:hi_xldr,ti))<-1.5
                                k=k+1;
                                ldr_val(k)=max_ldr;
                                BB_loc(k)=hi_xldr;
                                ldr_slope(k)=slope_left+slope_right;
                                BB_flag=1;
                                BB_num(fmonth,ti)=BB_num(fmonth,ti)+1;
                                BB_h=height_nc(hi_xldr);
                                BB_height(ti)=BB_h;
%                                BB_bin=floor(BB_h/300)+1;
%                                BB_height_bin(fmonth,ti,BB_bin)=BB_height_bin(fmonth,ti,BB_bin)+1;
                                BB(ti)=1;
                            end
                        end
                    end
%                     end
                end
                hi=hi+1;
            end 
            if k>1
                ldr_val_max=ldr_val(1);
                ldr_slope_max=ldr_slope(1);
                BB_h=height_nc(BB_loc(1));
                BB_height(ti)=BB_h;
                for ki=2:k
                    if ldr_val(ki)>ldr_val_max||(ldr_val(ki)==ldr_val_max&&ldr_slope(ki)>ldr_slope_max)
                        BB_h=height_nc(BB_loc(k)); 
                        BB_height(ti)=BB_h;
                        ldr_val_max=ldr_val(ki);
                        ldr_slope_max=ldr_slope(ki);
                    end
                end
            end
            if BB_flag==1
                BB_bin=floor(BB_h/300)+1;
                BB_height_bin(fmonth,ti,BB_bin)=BB_height_bin(fmonth,ti,BB_bin)+1;
            end
            clear k ldr_val_max ldr_val ldr_slope BB_loc ldr_slope_max BB_h iaf 
        end
    end
    rainmask(isnan(z))=NaN;
    
    save(matfname,'rainmask','rainflag')
    %save(matfname,'rainmask','rainflag','-append')
    save(matfname,'rainmask','rainflag0','-append')
    save(matfname,'rainmask','rainflag10','-append')
    save(matfname,'rainmask','rain_intsty','-append')
    save(matfname,'rainmask','BB_height','-append')
    save(matfname,'rainmask','BB','-append')
    clear rainflag* rain_intsty BB_height BB 

    clear BB BB_height rain_intsty rainflag rainflag0 rainflag10 z ldr vel
end
save([site 'rainlist'],'rainl');
save([site 'Cloud_BB_Rain'],'totalnum','cloud_num','BB_num','rain_intsty_bin','BB_height_bin');
end
% era5comp
%BB_contour_figs
