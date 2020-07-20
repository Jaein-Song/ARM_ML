    clear
%site='SGP'
site_list{1}='SGP';
site_list{2}='NSA';
site_list{3}='ENA';
%site_list{4}='ASI';
%site_list{5}='AWR';
site_list{4}='OLI';
for sitei=1:4
    site=site_list{sitei}
    clear fl
    datadir=['./DATA/' site '/']
    matddir=['./mat/' site '/']
    metfdir=['./MET/' site '/']
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
    fname=strcat(datadir,fl(1,:));
    height_nc=ncread(fname,'height');
    time_nc=ncread(fname,'time');
    num_hgt=length(height_nc);
    num_tim=length(time_nc);
    t_intv=time_nc(2)-time_nc(1);
    t10=round(600/t_intv);
    t5=round(300/t_intv);
    fn=length(fl);
    j=0;
    ref2mask=zeros(num_hgt,num_tim);
    ldrthres=-10.5;
    k=1;
    nanthres=10;
    totalnum=zeros(12,num_tim);
    cloud_num=zeros(12,num_tim);
    BB_num=zeros(12,num_tim);
    BB_height_bin=zeros(12,num_tim,50);
    Bi=1;
    for i=1:fn
        fn_length=length(fl(i,:));
        ymd=fl(i,fn_length-17:fn_length-10);
        matfname=strcat(matddir,ymd);
        fname=strcat(datadir,fl(i,:))
        skip=0;
        fx=dir(fname);
        if fx.bytes>=10000000
            try
                vel=ncread(fname,'mean_doppler_velocity');
                ldr=ncread(fname,'linear_depolarization_ratio');
                z=ncread(fname,'reflectivity_best_estimate');
                iaf=ncread(fname,'instrument_availability_flag');
                height_nc=ncread(fname,'height');
            catch
                skip=1;
            end
        else
            skip=1;
        end
        
        metf=dir([metfdir '*' ymd '*']);
        if ~isempty(metf)&&length(metf)==1&&metf.bytes>=10000
            try
                metname=[metfdir metf.name];
                time_met=ncread(metname,'time');
                try
                    temp=ncread(metname,'temperature_ambient');
                catch
                    try
                        temp=ncread(metname,'T_Ambient');
                    catch
                        try
                            temp=ncread(metname,'temp_mean');
                        catch
                            skip=1
                        end
                    end
                end
                try
                    RH=ncread(metname,'RH_Ambient');
                catch
                    try
                        RH=ncread(metname,'rh_ambient');
                    catch
                        try
                            RH=ncread(metname,'rh_mean');
                        catch
                            skip=1
                        end
                    end
                end

            catch
                skip=1;
            end
        else
            skip=1;
        end
        if ~skip
            vel(vel<-100)=NaN;
            ldr(ldr<-100)=NaN;
            z(z<-100)=NaN;
            iaf(iaf<-100)=NaN;
            nanmask=zeros(1,length(iaf));
            nanmask(mod(iaf,2)==1)=11;
            clear rainflag* rain_intsty BB_height BB 
            BB=zeros(1,num_tim);
            rainflag(nanmask>10)=0;
            BB_height=NaN(1,num_tim);
            BB_bottom=NaN(1,num_tim);
            BB_lr=NaN(1,num_tim);
            BB_T=NaN(1,num_tim);
            BB_v=NaN(1,num_tim);
            fday=str2num(ymd(7:8));
            fyear=str2num(ymd(1:4));
            fmonth=str2num(ymd(5:6));
            k=0;
            min_hgt=1;
            while height_nc(min_hgt)<=400
                min_hgt=min_hgt+1;
            end
        %% Check Total Number and Cloud amount
            for ti=1:num_tim
                if nanmask(ti)>10   
                    totalnum(fmonth,ti)=totalnum(fmonth,ti)+1;
                    z_nan=length(z(~isnan(z(:,ti)),ti));
                    if z_nan>0
                        cloud_num(fmonth,ti)=cloud_num(fmonth,ti)+1;
                    end
                    clear z_nan
                end
        %% Check Melting Layer Presence and Height
                ldr_nan=length(ldr(~isnan(ldr(:,ti)),ti));
                max_z=nanmax(z(min_hgt:num_hgt,ti));
                max_ldr=nanmax(ldr(min_hgt:num_hgt,ti));
                ldrthres=-20;
                if ldr_nan>0&&nanmask(ti)>10&&max_z>-10
                   [BB_height(ti), BB_bottom(ti), BB(ti), BB_bin] = BB_mask_func(height_nc,z(:,ti),vel(:,ti),ldr(:,ti),1,NaN,NaN);
                end
            end
            for trial=2:6
                for ti=1:num_tim
                    if ti<t5||ti>num_tim-t5-1
                        mid=0;
                    else
                        mid=sum(BB(ti-(t5-1):ti+t5-1))/t10>=0.6;
                    end
                    if ti<t10
                        left=0;
                        right=sum(BB(ti:ti+t10-1))/t10>=0.6;
                    elseif ti>num_tim-(t10-1)
                        right=0;
                        left=sum(BB(ti:ti-(t10-1)))/t10>=0.6;
                    else
                        right=sum(BB(ti:ti+t10-1))/t10>=0.6;
                        left=sum(BB(ti:ti-t10+1))/t10>=0.6;
                    end
                    ldr_nan=length(ldr(~isnan(ldr(:,ti)),ti));
                    max_z=nanmax(z(min_hgt:num_hgt,ti));
                    max_ldr=nanmax(ldr(min_hgt:num_hgt,ti));
                    leftbound=max(ti-(t10-1),1);
                    rightbound=min(ti+(t10-1),num_tim);
                    if left+right+mid>0&&ldr_nan>0&&nanmask(ti)>10&&max_z>-10
                        med_top=median(BB_height(leftbound:rightbound),'omitnan');
                        med_bot=median(BB_bottom(leftbound:rightbound),'omitnan');
                        [BB_height(ti), BB_bottom(ti), BB(ti), BB_bin] = BB_mask_func(height_nc,z(:,ti),vel(:,ti),ldr(:,ti),trial,med_top,med_bot);
                    end
                    if left+right+mid>0&&ldr_nan>0&&nanmask(ti)>10&&max_z>-10
                        med_top=median(BB_height(leftbound:rightbound),'omitnan');
                        med_bot=median(BB_bottom(leftbound:rightbound),'omitnan');
                        [BB_height(ti), BB_bottom(ti), BB(ti), BB_bin] = BB_mask_func(height_nc,z(:,ti),vel(:,ti),ldr(:,ti),trial,med_top,med_bot);
                    elseif BB(ti)>0&&sum(BB(leftbound:rightbound))>=2&&trial>=6&&BB_height(ti)>=median(BB_height(leftbound:rightbound),'omitnan')+600
                        BB(ti)=0;
                        BB_height(ti)=NaN;
                        BB_bottom(ti)=NaN;
%                     elseif BB(ti)>0&&sum(BB(max(ti-4,1):min(ti+4,1)))<2&&trial==6
                    elseif BB(ti)>0&&sum(BB(leftbound:rightbound))<2&&trial>=6
                        BB(ti)=0;
                        BB_height(ti)=NaN;
                        BB_bottom(ti)=NaN;
                    elseif BB(ti)>0&&trial>=6
                        med_top=median(BB_height(leftbound:rightbound),'omitnan');
                        med_bot=median(BB_bottom(leftbound:rightbound),'omitnan');
                        if BB_height(ti)>med_top||BB_bottom(ti)<med_bot
                            BB(ti)=0;
                            BB_height(ti)=NaN;
                            BB_bottom(ti)=NaN;
                        end
                    end
                end
            end
            for ti=1:num_tim
                leftbound=max(ti-(t10-1),1);
                rightbound=min(ti+(t10-1),num_tim);
                med_top=median(BB_height(leftbound:rightbound),'omitnan')+600;
                med_bot=median(BB_bottom(leftbound:rightbound),'omitnan')-600;
                if BB(ti)>0&&sum(BB(leftbound:rightbound))<max(t10/20,2)
                    BB(ti)=0;
                    BB_height(ti)=NaN;
                    BB_bottom(ti)=NaN;
                elseif BB(ti)>0&&BB_height(ti)>med_top
                    BB(ti)=0;
                    BB_height(ti)=NaN;
                    BB_bottom(ti)=NaN;
                elseif BB_bottom(ti)<med_bot
                    BB(ti)=0;
                    BB_height(ti)=NaN;
                    BB_bottom(ti)=NaN;
                end
            end
            for ti=1:num_tim
            if BB(ti)>0
%% If BB detected
                BB_bin=floor(BB_height(ti)/300)+1;
                BB_height_bin(fmonth,ti,BB_bin)=BB_height_bin(fmonth,ti,BB_bin)+1;
        %% Read METfile
                if length(time_met)==86400
                    met_ti=floor(time_nc(ti))+1;
                elseif length(time_met)==1440
                    met_ti=floor(time_nc(ti)/60)+1;
                else
                    t_d=abs(time_met-time_nc(ti));
                    met_ti=find(t_d==min(t_d),1);
                end
                BB_T(ti)=temp(met_ti);
                BB_RH(ti)=RH(met_ti);
                BB_lr(ti)=temp(met_ti)/BB_height(ti);
                hs=find(height_nc(:)<=BB_height(ti));
                BB_v(ti)=nanmin(vel(hs));
                BB_all(Bi,1)=BB_height(ti);
                BB_all(Bi,2)=BB_bottom(ti);
                BB_all(Bi,3)=BB_T(ti);
                BB_all(Bi,4)=BB_lr(ti); 
                BB_all(Bi,5)=BB_v(ti); 
                BB_all(Bi,6)=BB_RH(ti); 
                Bi=Bi+1;
            end
            end
            rainmask(isnan(z))=NaN;
            filex=dir(matfname);
            if ~isempty(filex)
                save(matfname,'BB_height','BB_bottom','BB_lr','BB_T','BB_RH','BB_v','-append')
            else
                save(matfname,'BB_height','BB_bottom','BB_lr','BB_RH','BB_T','BB_v')
            end
            save(matfname,'BB','-append')
            clear BB_height BB BB_T BB_lr BB_v
            clear BB BB_height z ldr vel
        end
    end
    Bi=0
    filex=dir([site 'Cloud_BB_Rain']);
    if ~isempty(filex)
        save([site 'Cloud_BB_Rain'],'totalnum','cloud_num','BB_num','BB_height_bin','BB_all','-append');
    else
        save([site 'Cloud_BB_Rain'],'totalnum','cloud_num','BB_num','BB_height_bin','BB_all');
    end
    clear BB_all cloud_num BB_num BB_height_bin totalnum
end
% era5comp
%BB_contour_figs
