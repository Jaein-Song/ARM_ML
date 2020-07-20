function [ BB_height, BB_bottom, BB, BB_bin ] = BB_mask_func( height, z, vel, ldr ,trial, top, bot)
    BB_height=NaN;
    BB_bottom=NaN;
    BB=0;
    BB_bin=NaN;
    BB_flag=0;
    z_diff=diff(z(:));
    vel_diff=diff(vel(:));
    ldr_diff=diff(ldr(:));
    k=0;
    num_hgt=length(height);
    h_intv=height(2)-height(1);
    hi=1;
%     ldr_low_max=max(ldr(1:hd120*50),'omitnan');
%     ldr_low_min=min(ldr(1:hd120*50),'omitnan');
%     ldrthres=-30;
    hd120=round(120/h_intv);
    hd60=round(60/h_intv);
    ldrthres=median(ldr(1:hd120*50),'omitnan');
    ldr_no_nan_length=length(ldr(~isnan(ldr)));
    if ldr_no_nan_length<10
        ldrthres=-40;
    end
    
    refthres=max(quantile(z,0.75),-10);
    refthres=min(refthres,5);
    if trial<2||isnan(top)
        while height(hi)<=400
            hi=hi+1;
        end
        bot=hi;
        top=num_hgt;
        
    else
        ii=1;
        
        while height(ii)<=bot
           ii=ii+1;
        end
        bot=ii;
        while height(ii)<=top+hd120*3&&ii<num_hgt
            ii=ii+1;
        end
        top=ii;
        %bot=find(height==bot);
        %top=find(height==top);
        while hi<=bot-hd120*3
            hi=hi+1;
        end
    end
    
    
    %     hi=9;
    ldr_slope_thresh=0.2*h_intv/15;
    ref_slope_thresh=0.1*h_intv/15;
    vel_max_min=0.9;
    vel_rel_diff=0.2;
    max_vel_thresh=0.5;
    min_vel_thresh=-1.0;
    low_vel_thresh=-3;
    z_diff_minmax_thresh=3;
    ldr_diff_minmax_thresh=3;
    if trial~=1
        ldr_slope_thresh=ldr_slope_thresh/trial;
        ref_slope_thresh=ref_slope_thresh/trial;
        vel_max_min=vel_max_min/trial;
        low_vel_thresh=low_vel_thresh*trial;
        z_diff_minmax_thresh=2/trial+1;
        ldr_diff_minmax_thresh=2.5/trial+0.5;

%         vel_rel_diff=0.2/trial;
%        max_vel_thresh=0.5*trial;
 %       min_vel_thresh=-1.5/trial;
    end    
        if hi<=hd120
            hi=hd120+1;
        end
        if trial==1
            max_hi=num_hgt;
        else
            max_hi=top;
        end
    while hi<max_hi&&~isempty(z(~isnan(z(hi:top))))&&(nanmax(ldr)-ldrthres)>ldr_diff_minmax_thresh
        if (z_diff(hi)<0&&z_diff(hi-1)>0||z_diff(hi)==0)&&max(ldr(hi-hd120:min(hi+hd120,max_hi)))>ldrthres&&z(hi)>refthres
            low_bound=max(hi-hd120*4,1);
            upp_bound=min(hi+hd120*4,top-1);
            max_diff=nanmax(z_diff(low_bound:hi));
            min_diff=nanmax(z_diff(hi:upp_bound));
            hi_max=low_bound;
            hi_min=upp_bound;
            for hhi=low_bound:hi
                if z_diff(hhi)>=max_diff
                    max_diff=z_diff(hhi);
                    hi_max=hhi;
                end
            end
            for hhi=hi:upp_bound
                if z_diff(hhi)<=min_diff
                    min_diff=z_diff(hhi);
                    hi_min=hhi+1;
                end
            end
            clear max_diff min_diff
            slope_left=(z(hi)-z(hi_max))/(hi-hi_max);
            slope_right=(z(hi)-z(hi_min))/(hi_min-hi);

            low_bound=max(hi_max-hd120*3,1);
            upp_bound=min(hi_max+hd120*3,top);
            z_diff_minmax_l=nanmax(z(low_bound:upp_bound))-nanmin(z(low_bound:hi_max));
            z_diff_minmax_u=nanmax(z(low_bound:upp_bound))-nanmin(z(hi_max:upp_bound));
            if hi==hi_max
                slope_left=0;
            elseif hi==hi_min
                slope_right=0;
            end
            low_bound=max(hi_max-hd120,1);
            upp_bound=min(hi_max+hd120,top);

            ldr_nan_partial=length(ldr(~isnan(ldr(low_bound:low_bound))));
            low_bound=max(hi-hd120*2,1);
            upp_bound=min(hi+hd120*2,top);
            max_ldr=nanmax(ldr(low_bound:upp_bound));
            if ldr_nan_partial>0&&slope_left>=ref_slope_thresh&&slope_right*2>=ref_slope_thresh&&z_diff_minmax_l*2>z_diff_minmax_thresh &&z_diff_minmax_u>z_diff_minmax_thresh&&~isnan(max_ldr)
                if max_ldr~=ldr(low_bound)&&max_ldr~=ldr(upp_bound)
                    for hhi=low_bound:upp_bound

                        if ldr(hhi)==max_ldr
                            hi_xldr=hhi;
                        end
                    end
                    low_bound=max(hi_xldr-hd120*4,1);
                    upp_bound=min(hi_xldr+hd120*4,top);
                    if upp_bound>=num_hgt
                        upp_bound=num_hgt-1;
                    end
                    max_diff=nanmax(ldr_diff(low_bound:hi_xldr));
                    min_diff=nanmin(ldr_diff(hi_xldr:upp_bound));
                    for hhi=low_bound:hi_xldr
                        if ldr_diff(hhi)>=max_diff
                            hi_max=hhi;
                        end
                    end
                    for hhi=hi_xldr:upp_bound
                        if ldr_diff(hhi)<=min_diff
                            hi_min=hhi+1; 
                        end
                    end
                    slope_left=(ldr(hi_xldr)-ldr(hi_max))/(hi_xldr-hi_max);
                    slope_right=(ldr(hi_xldr)-ldr(hi_min))/(hi_min-hi_xldr);
                    if slope_left>=ldr_slope_thresh&&slope_right>=ldr_slope_thresh&&max_ldr-ldrthres>ldr_diff_minmax_thresh/3
                        if (nanmax(vel(hi_xldr:upp_bound))-nanmin(vel(low_bound:hi_xldr)))>vel_max_min
                            if nanmax(vel(hi_xldr:upp_bound))<max_vel_thresh&&nanmin(vel(low_bound:hi_xldr))<min_vel_thresh&&nanmax(vel(low_bound:upp_bound))>=low_vel_thresh
                                k=k+1;
                                ldr_val(k)=max_ldr;
                                BB_loc(k)=hi_xldr;
                                ldr_slope(k)=slope_left+slope_right;
                                BB_flag=1;
                                BB_h=height(hi_xldr);
                                BB_height=BB_h;
                                BB=1;
                            end
                        end
                    end
                end
            end
        end
        hi=hi+1;
    end 
    if k>=1
        ldr_val_max=ldr_val(1);
        ldr_slope_max=ldr_slope(1);
        BB_h=height(BB_loc(1));
        BB_height=BB_h;
        BB_loc_max=BB_loc(1);
        BB_bottom=NaN;
        if trial<2||top==num_hgt
            low_bound=max(BB_loc_max-hd120*5,1);
            upp_bound=min(BB_loc_max+hd120*5,num_hgt);
            vel_diff_max=max(abs(vel_diff(max(BB_loc_max-hd120,1):min(BB_loc_max+hd120,num_hgt))));
        else
            low_bound=max(bot-hd120*5,1);
            upp_bound=min(top+hd120*5,num_hgt);
            vel_diff_max=max(abs(vel_diff(low_bound:upp_bound)));
        end
        if z(BB_loc_max) < refthres
            BB_flag=0;
        end
        for ki=1:k
            if trial<2||top==num_hgt
                low_bound=max(BB_loc_max-hd120*5,1);
                upp_bound=min(BB_loc_max+hd120*5,num_hgt);
                vel_diff_max=max(abs(vel_diff(max(BB_loc_max-hd120,1):min(BB_loc_max+hd120,num_hgt))));
            else
                low_bound=max(bot-hd120*5,1);
                upp_bound=min(top+hd120*5,num_hgt);
                vel_diff_max=max(abs(vel_diff(low_bound:upp_bound)));
            end
            if ldr_val(ki)>ldr_val_max||(ldr_val(ki)==ldr_val_max&&ldr_slope(ki)>ldr_slope_max)&&z(BB_loc(k))>=refthres&&BB_loc(k)<=top&&BB_loc(k)>=bot
                BB_h=height(BB_loc(k)); 
                BB_height=BB_h;
                ldr_val_max=ldr_val(ki);    
                ldr_slope_max=ldr_slope(ki);
                BB_loc_max=BB_loc(k);
                BB_flag=1;   
            elseif ki==1&&z(BB_loc(k))>=refthres&&BB_loc(k)<=top&&BB_loc(k)>=bot
                BB_h=height(BB_loc(k)); 
                BB_height=BB_h;
                ldr_val_max=ldr_val(ki);    
                ldr_slope_max=ldr_slope(ki);
                BB_loc_max=BB_loc(k);
                BB_flag=1;   
            end
            if BB_flag==1
                hi=BB_loc_max;
                while abs(vel_diff_max)*vel_rel_diff<abs(vel_diff(hi))&&hi<num_hgt
                    hi=hi+1;
                end
                BB_h=height(hi);
                BB_height=BB_h;
                hi=BB_loc_max;
                while abs(vel_diff_max)*vel_rel_diff<abs(vel_diff(hi))&&hi>1
                    hi=hi-1;
                end
                BB_b=height(hi);
                BB_bottom=BB_b;
                BB_bin=floor(BB_h/300)+1;
            end
        end
        if z(BB_loc_max)<refthres
            BB_height=NaN;
            BB_bottom=NaN;
            BB=0;
            BB_bin=NaN;
            BB_flag=0;
        end
    end
    
end

