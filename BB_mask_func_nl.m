function [ BB_height, BB_bottom, BB, BB_bin ] = BB_mask_func_nl( height, z, vel,trial, top, bot)
    BB_height=NaN;
    BB_bottom=NaN;
    BB=0;
    BB_bin=NaN;
    BB_flag=0;
    z_diff=diff(z(:));
    vel_diff=diff(vel(:));
    k=0;
    num_hgt=length(height);
    h_intv=height(2)-height(1);
    hi=1;
%     ldr_low_max=max(ldr(1:hd120*50),'omitnan');
%     ldr_low_min=min(ldr(1:hd120*50),'omitnan');
%     ldrthres=-30;
    hd120=round(120/h_intv);
    hd60=round(60/h_intv);
    
    refthres=max(quantile(z,0.75),-10);
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
    ref_slope_thresh=0.1*h_intv/15;
    vel_max_min=0.9;
    vel_rel_diff=0.2;
    max_vel_thresh=0.5;
    min_vel_thresh=-1.0;
    low_vel_thresh=-3;
    z_diff_minmax_thresh=3;
    if trial~=1
        ref_slope_thresh=ref_slope_thresh/trial;
        vel_max_min=vel_max_min/trial;
        low_vel_thresh=low_vel_thresh*trial;
        z_diff_minmax_thresh=2/trial+1;

%         vel_rel_diff=0.2/trial;
%        max_vel_thresh=0.5*trial;
 %       min_vel_thresh=-1.5/trial;
    end    
        if hi<=hd120
            hi=hd120+1;
        end
        if trial==1||top==num_hgt
            max_hi=num_hgt-hd120;
        else
            max_hi=top;
        end
    while hi<max_hi&&~isempty(z(~isnan(z(hi:top))))
        if (z_diff(hi)<0&&z_diff(hi-1)>0||z_diff(hi)==0)&&z(hi)>refthres
            low_bound=max(hi-hd120,1);
            upp_bound=min(hi+hd120,top);
            max_diff=z_diff(low_bound);
            min_diff=z_diff(upp_bound);
            hi_max=low_bound;
            hi_min=upp_bound;
            for hhi=low_bound:upp_bound
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

            low_bound=max(hi-hd120*2,1);
            upp_bound=min(hi+hd120*2,top);
            if slope_left>=ref_slope_thresh&&slope_right*2>=ref_slope_thresh&&z_diff_minmax_l*2>z_diff_minmax_thresh &&z_diff_minmax_u>z_diff_minmax_thresh
                        if (nanmax(vel(hi_max:upp_bound))-nanmin(vel(low_bound:hi_max)))>vel_max_min
                            if nanmax(vel(hi_max:upp_bound))<max_vel_thresh&&nanmin(vel(low_bound:hi_max))<min_vel_thresh&&nanmax(vel(low_bound:upp_bound))>=low_vel_thresh
                                k=k+1;
                                BB_loc(k)=hi_max;
                                slope(k)=slope_left+slope_right;
                                BB_flag=1;
                                ref_val(k)=z(hi_max);
                                BB_h=height(hi_max);
                                BB_height=BB_h;
                                BB=1;
                            end
                        end
            end
        end
        hi=hi+1;
    end 
    if k>=1
        ref_val_max=ref_val(1);
        slope_max=slope(1);
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
            if ref_val(ki)>ref_val_max||(ref_val(ki)==ref_val_max&&slope(ki)>slope_max)&&z(BB_loc(k))>=refthres&&BB_loc(k)<=top&&BB_loc(k)>=bot
                BB_h=height(BB_loc(k)); 
                BB_height=BB_h;
                ref_val_max=ref_val(ki);    
                slope_max=slope(ki);
                BB_loc_max=BB_loc(k);
                BB_flag=1;   
            elseif ki==1&&z(BB_loc(k))>=refthres&&BB_loc(k)<=top&&BB_loc(k)>=bot
                BB_h=height(BB_loc(k)); 
                BB_height=BB_h;
                ref_val_max=ref_val(ki);    
                slope_max=slope(ki);
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

