clear
fl=ls('./ceilall/*.cdf');
fln=length(fl);
lcn=0;
l2m=0;
o2m=0;
for i=1:fln
    f=['ceilall/' fl(i,:)];
    cbh=ncread(f,'first_cbh_avg');
    n=ncread(f,'ncbh');
    v=ncread(f,'valid_cbh1');
    for j=1:length(n)
        if cbh(j)<=3000
            lcn=lcn+1;
            if v(j)<n(j)
                l2m=l2m+1;
            else
                o2m=o2m+1;
            end
        end
    end
end