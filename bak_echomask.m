clear
fl1=ls('./nqcnc/*20170107*.cfradial');
fl2=ls('./cilnc/*20170107*.cfradial');
fn=length(fl1);
j=0;
ref1mask=zeros(1000,720);
refmask=zeros(1000,720)-1;
ref2mask=zeros(1000,720);
ldrthres=-10.5;
k=1;
for i=1:1
    fname1=strcat('./nqcnc/',fl1(i,:));
    ref1inst=ncread(fname1,'reflectivity_h');
    fname2=strcat('./cilnc/',fl2(i,:));
    ref2inst=ncread(fname2,'reflectivity_h');
    for ti=1:720
        for hi=1:1000
            if ~isnan(ref2inst(hi,ti))
%                 [minti,maxti,minhi,maxhi]=nxth(ti,hi);
%                 if max(refmask(minhi:maxhi,ti))<0&&max(refmask(hi,minti:maxti))<0
%                     k=k+1;
%                 end
%                     refmask(hi,ti)=k;
%                 else
%                     refmask(ti,hi)=
                refmask(hi,ti)=(ti-1)*1000+hi;
            else
                refmask(hi,ti)=NaN;
            end
        end
    end
    refmasko=refmask;
    for ti=1:720
        for hi=1:1000
            
                [minti,maxti,minhi,maxhi]=nxth(ti,hi,refmask);
            if hi==347&&ti==300
                refmask(minhi:maxhi,ti)
                refmask(hi,minti:maxti)
            end
            if ~isnan(refmask(hi,ti))
            refmask(hi,ti)=min(refmask(hi,minti:maxti),[],'omitnan');
            refmask(hi,ti)=min(refmask(minhi:maxhi,ti),[],'omitnan');
            for hii=minhi:maxhi
                if ~isnan(refmask(hii,ti))
                    refmask(hii,ti)=refmask(hi,ti);
                end
            end
            for tii=minti:maxti
                if ~isnan(refmask(hi,tii))
                    refmask(hi,tii)=refmask(hi,tii);
                end
            end
            
            else
%             if refmask(hi,ti)==7200000
                refmask(hi,ti)=NaN;
            end
        end
    end
%     clear *inst *1m
end
h=[15:15:15000];
t=[120:120:86400]/3600;
pcolor(t,h,refmask);shading flat
