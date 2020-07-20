clear
fl=ls('mat/*mat');
cbhmask_cr=zeros(4,12,1000,720);
cbhmask_cl=zeros(4,12,1000,720);
cbhnumb_cr=zeros(4,12,1000,720);
cbhnumb_cl=zeros(4,12,1000,720);
cbhfreq_cr=zeros(4,12,1000,720);
cbhfreq_cl=zeros(4,12,1000,720);
for fi=1:length(fl)
    matfname=strcat('mat/',fl(fi,:));
    ymd=fl(fi,9:16);
    ceilfls=ls(strcat('ceilall/*',ymd,'*.cdf'));
    if ~isempty(ceilfls)
        ceilfname=strcat('ceilall/',ceilfls);
        load(matfname,'rainflag','rainmask')
        ncbh=ncread(ceilfname,'ncbh');
        vcbh=ncread(ceilfname,'valid_cbh1');
        cbh1=ncread(ceilfname,'first_cbh_avg');
        cbh2=ncread(ceilfname,'second_cbh_avg');
        cbh3=ncread(ceilfname,'third_cbh_avg');
        m=str2num(ymd(5:6));
        for ti=1:720
            cbhi=1;
%             if rainflag(ti)==0&&ncbh(ti)>0
            if ~isnan(rainflag(ti))&&ncbh(ti)>0
                cbhnumb_cr(:,m,:,ti)=cbhnumb_cr(:,m,:,ti)+1;
                cbhnumb_cl(:,m,:,ti)=cbhnumb_cl(:,m,:,ti)+1;
                for hi=2:1000
                    if rainmask(hi-1,ti)~=0&&rainmask(hi,ti)==0
                        if cbhi<=3
                            cbhmask_cr(cbhi,m,hi,ti)=cbhmask_cr(cbhi,m,hi,ti)+1;
                            cbhi=cbhi+1;
                        end
                        cbhmask_cr(4,m,hi,ti)=cbhmask_cr(4,m,hi,ti)+1;
                    end
                end
                if vcbh(ti)>0
                    cbhmask_cl(1,m,floor(cbh1(ti)/15),ti)=cbhmask_cl(1,m,floor(cbh1(ti)/15),ti)+1;
                    cbhmask_cl(4,m,floor(cbh1(ti)/15),ti)=cbhmask_cl(4,m,floor(cbh1(ti)/15),ti)+1;
                    if ~isnan(cbh2(ti))
                    cbhmask_cl(2,m,floor(cbh2(ti)/15),ti)=cbhmask_cl(2,m,floor(cbh2(ti)/15),ti)+1;
                    cbhmask_cl(4,m,floor(cbh2(ti)/15),ti)=cbhmask_cl(4,m,floor(cbh2(ti)/15),ti)+1;
                    end
                    if ~isnan(cbh3(ti))
                    cbhmask_cl(3,m,floor(cbh3(ti)/15),ti)=cbhmask_cl(3,m,floor(cbh3(ti)/15),ti)+1;
                    cbhmask_cl(4,m,floor(cbh3(ti)/15),ti)=cbhmask_cl(4,m,floor(cbh3(ti)/15),ti)+1;
                    end
                end
            end
        end
    end
    clear ncbh cbh1 cbh2 rainmask rainflag
end

cbhmask_cr_KST(:,:,:,1:270)=cbhmask_cr(:,:,:,451:720);
cbhmask_cr_KST(:,:,:,271:720)=cbhmask_cr(:,:,:,1:450);
cbhnumb_cr_KST(:,:,:,1:270)=cbhnumb_cr(:,:,:,451:720);
cbhnumb_cr_KST(:,:,:,271:720)=cbhnumb_cr(:,:,:,1:450);
cbhmask_cl_KST(:,:,:,1:270)=cbhmask_cl(:,:,:,451:720);
cbhmask_cl_KST(:,:,:,271:720)=cbhmask_cl(:,:,:,1:450);
cbhnumb_cl_KST(:,:,:,1:270)=cbhnumb_cl(:,:,:,451:720);
cbhnumb_cl_KST(:,:,:,271:720)=cbhnumb_cl(:,:,:,1:450);
cbhfreq_cr_KST=cbhmask_cr_KST./cbhnumb_cr_KST;
cbhfreq_cl_KST=cbhmask_cl_KST./cbhnumb_cl_KST;

cbhmask_cr_KST_sea(:,1,:,:)=cbhmask_cr_KST(:,3,:,:)+cbhmask_cr_KST(:,4,:,:)+cbhmask_cr_KST(:,5,:,:);
cbhmask_cr_KST_sea(:,2,:,:)=cbhmask_cr_KST(:,6,:,:)+cbhmask_cr_KST(:,7,:,:)+cbhmask_cr_KST(:,8,:,:);
cbhmask_cr_KST_sea(:,3,:,:)=cbhmask_cr_KST(:,9,:,:)+cbhmask_cr_KST(:,10,:,:)+cbhmask_cr_KST(:,11,:,:);
cbhmask_cr_KST_sea(:,4,:,:)=cbhmask_cr_KST(:,12,:,:)+cbhmask_cr_KST(:,1,:,:)+cbhmask_cr_KST(:,2,:,:);

cbhnumb_cr_KST_sea(:,1,:,:)=cbhnumb_cr_KST(:,3,:,:)+cbhnumb_cr_KST(:,4,:,:)+cbhnumb_cr_KST(:,5,:,:);
cbhnumb_cr_KST_sea(:,2,:,:)=cbhnumb_cr_KST(:,6,:,:)+cbhnumb_cr_KST(:,7,:,:)+cbhnumb_cr_KST(:,8,:,:);
cbhnumb_cr_KST_sea(:,3,:,:)=cbhnumb_cr_KST(:,9,:,:)+cbhnumb_cr_KST(:,10,:,:)+cbhnumb_cr_KST(:,11,:,:);
cbhnumb_cr_KST_sea(:,4,:,:)=cbhnumb_cr_KST(:,12,:,:)+cbhnumb_cr_KST(:,1,:,:)+cbhnumb_cr_KST(:,2,:,:);

cbhmask_cl_KST_sea(:,1,:,:)=cbhmask_cl_KST(:,3,:,:)+cbhmask_cl_KST(:,4,:,:)+cbhmask_cl_KST(:,5,:,:);
cbhmask_cl_KST_sea(:,2,:,:)=cbhmask_cl_KST(:,6,:,:)+cbhmask_cl_KST(:,7,:,:)+cbhmask_cl_KST(:,8,:,:);
cbhmask_cl_KST_sea(:,3,:,:)=cbhmask_cl_KST(:,9,:,:)+cbhmask_cl_KST(:,10,:,:)+cbhmask_cl_KST(:,11,:,:);
cbhmask_cl_KST_sea(:,4,:,:)=cbhmask_cl_KST(:,12,:,:)+cbhmask_cl_KST(:,1,:,:)+cbhmask_cl_KST(:,2,:,:);

cbhnumb_cl_KST_sea(:,1,:,:)=cbhnumb_cl_KST(:,3,:,:)+cbhnumb_cl_KST(:,4,:,:)+cbhnumb_cl_KST(:,5,:,:);
cbhnumb_cl_KST_sea(:,2,:,:)=cbhnumb_cl_KST(:,6,:,:)+cbhnumb_cl_KST(:,7,:,:)+cbhnumb_cl_KST(:,8,:,:);
cbhnumb_cl_KST_sea(:,3,:,:)=cbhnumb_cl_KST(:,9,:,:)+cbhnumb_cl_KST(:,10,:,:)+cbhnumb_cl_KST(:,11,:,:);
cbhnumb_cl_KST_sea(:,4,:,:)=cbhnumb_cl_KST(:,12,:,:)+cbhnumb_cl_KST(:,1,:,:)+cbhnumb_cl_KST(:,2,:,:);

cbhmask_cr_KST_tot=zeros(4,1000,720);
cbhnumb_cr_KST_tot=zeros(4,1000,720);
cbhmask_cl_KST_tot=zeros(4,1000,720);
cbhnumb_cl_KST_tot=zeros(4,1000,720);
for i=1:4
    cbhmask_cr_KST_tot(:,:,:)=cbhmask_cr_KST_tot(:,:,:)+squeeze(cbhmask_cr_KST_sea(:,i,:,:));
    cbhnumb_cr_KST_tot(:,:,:)=cbhnumb_cr_KST_tot(:,:,:)+squeeze(cbhnumb_cr_KST_sea(:,i,:,:));
    cbhmask_cl_KST_tot(:,:,:)=cbhmask_cl_KST_tot(:,:,:)+squeeze(cbhmask_cl_KST_sea(:,i,:,:));
    cbhnumb_cl_KST_tot(:,:,:)=cbhnumb_cl_KST_tot(:,:,:)+squeeze(cbhnumb_cl_KST_sea(:,i,:,:));
end
cbhfreq_cr_KST_tot=cbhmask_cr_KST_tot./cbhnumb_cr_KST_tot;
cbhfreq_cl_KST_tot=cbhmask_cl_KST_tot./cbhnumb_cl_KST_tot;

cbhfreq_cr_KST_sea=cbhmask_cr_KST_sea./cbhnumb_cr_KST_sea;
cbhfreq_cl_KST_sea=cbhmask_cl_KST_sea./cbhnumb_cl_KST_sea;
cbhfreq_cr_KST_sea_24=zeros(4,4,50,26);
cbhfreq_cl_KST_sea_24=zeros(4,4,50,26);
cbhfreq_cr_KST_24=zeros(4,12,50,26);
cbhfreq_cl_KST_24=zeros(4,12,50,26);
cbhfreq_cr_KST_tot_24=zeros(4,50,26);
cbhfreq_cl_KST_tot_24=zeros(4,50,26);
for ti=1:24
    for hi=1:50
        for cbhi=1:4
            data=cbhfreq_cr_KST_tot(cbhi,(hi-1)*20+1:hi*20,(ti-1)*30+1:ti*30);
            cbhfreq_cr_KST_tot_24(cbhi,hi,ti+1)=mean(data(~isnan(data)));
            clear data
            data=cbhfreq_cl_KST_tot(cbhi,(hi-1)*20+1:hi*20,(ti-1)*30+1:ti*30);
            cbhfreq_cl_KST_tot_24(cbhi,hi,ti+1)=mean(data(~isnan(data)));
            clear data
            for mi=1:4
                data=cbhfreq_cr_KST_sea(cbhi,mi,(hi-1)*20+1:hi*20,(ti-1)*30+1:ti*30);
                cbhfreq_cr_KST_sea_24(cbhi,mi,hi,ti+1)=mean(data(~isnan(data)));
                clear data
                data=cbhfreq_cl_KST_sea(cbhi,mi,(hi-1)*20+1:hi*20,(ti-1)*30+1:ti*30);
                cbhfreq_cl_KST_sea_24(cbhi,mi,hi,ti+1)=mean(data(~isnan(data)));
                clear data
                data=cbhfreq_cr_KST(cbhi,mi,(hi-1)*20+1:hi*20,(ti-1)*30+1:ti*30);
                cbhfreq_cr_KST_24(cbhi,mi,hi,ti+1)=mean(data(~isnan(data)));
                clear data
                data=cbhfreq_cl_KST(cbhi,mi,(hi-1)*20+1:hi*20,(ti-1)*30+1:ti*30);
                cbhfreq_cl_KST_24(cbhi,mi,hi,ti+1)=mean(data(~isnan(data)));
                clear data
            end
            for mi=5:12
                data=cbhfreq_cr_KST(cbhi,mi,(hi-1)*20+1:hi*20,(ti-1)*30+1:ti*30);
                cbhfreq_cr_KST_24(cbhi,mi,hi,ti+1)=mean(data(~isnan(data)));
                clear data
                data=cbhfreq_cl_KST(cbhi,mi,(hi-1)*20+1:hi*20,(ti-1)*30+1:ti*30);
                cbhfreq_cl_KST_24(cbhi,mi,hi,ti+1)=mean(data(~isnan(data)));
                clear data
            end
        end
    end
end

cbhfreq_cr_KST_sea_24(:,:,:,1)=cbhfreq_cr_KST_sea_24(:,:,:,25);
cbhfreq_cl_KST_sea_24(:,:,:,1)=cbhfreq_cl_KST_sea_24(:,:,:,25);
cbhfreq_cr_KST_tot_24(:,:,1)=cbhfreq_cr_KST_tot_24(:,:,25);
cbhfreq_cl_KST_tot_24(:,:,1)=cbhfreq_cl_KST_tot_24(:,:,25);
cbhfreq_cr_KST_24(:,:,:,1)=cbhfreq_cr_KST_24(:,:,:,25);
cbhfreq_cl_KST_24(:,:,:,1)=cbhfreq_cl_KST_24(:,:,:,25);
cbhfreq_cr_KST_sea_24(:,:,:,26)=cbhfreq_cr_KST_sea_24(:,:,:,2);
cbhfreq_cl_KST_sea_24(:,:,:,26)=cbhfreq_cl_KST_sea_24(:,:,:,2);
cbhfreq_cr_KST_24(:,:,:,26)=cbhfreq_cr_KST_24(:,:,:,2);
cbhfreq_cl_KST_24(:,:,:,26)=cbhfreq_cl_KST_24(:,:,:,2);
cbhfreq_cr_KST_24(:,:,:,26)=cbhfreq_cr_KST_24(:,:,:,2);
save('cbhcomp_total','cbhmask*','cbhnumb*','cbhfreq*')

    h=[15:15:15000];
    t24=[-0.5:1:24.5];
    h24=[300:300:15000];
%% OUTFILE SETUP FOR PLOTTING
% define var, name, xax xlim xlb, yax, ylim, ylb, prefix_filename
%define cmin, cmax, cint, cbint, cticks
for i=1:4
            out{1,i}.var=squeeze(cbhfreq_cl_KST_sea_24(4,i,:,:))*100;
            out{2,i}.var=squeeze(cbhfreq_cr_KST_sea_24(4,i,:,:))*100;
end
            contourflag=0;
            contourline=0;
                prefix_filename{1}='CL51_CBH_FREQ_total';
                prefix_filename{2}='CR_CBH_FREQ_total';
            for oi=1:2
                out{oi,1}.name='MAM';
                out{oi,2}.name='JJA';
                out{oi,3}.name='SON';
                out{oi,4}.name='DJF';
                for oj=1:4
                    out{oi,oj}.cmin=0;
                    out{oi,oj}.cmax=1;
                    out{oi,oj}.cint=200;
                    out{oi,oj}.cbint=0.2;
                    out{oi,oj}.cb_name='%';
                        k=1;
                    for cti=out{oi,oj}.cmin:out{oi,oj}.cbint:out{oi,oj}.cmax
                        out{oi,oj}.cticks{k}=num2str(cti);
                        k=k+1;
                    end
                    out{1,oj}.xax=t24;
                    out{2,oj}.xax=t24;
                    out{oi,oj}.xlim=[0 24];
                    out{oi,oj}.xlb='Hour (KST)';
                    out{1,oj}.yax=h24/1000;
                    out{2,oj}.yax=h24/1000;
                    out{oi,oj}.ylim=[0 15];
                    out{oi,oj}.ylb='Height (km)';
                    out{oi,oj}.ctl=1;
                end
            end
%% CALL PLOTTING FUCTION 
            Figure_make
