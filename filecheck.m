fl=ls('./cilnc/*cfradial');
flen=length(fl);
varname='linear_depolarization_ratio';
varthresh=5;

li=1;
for i=1:flen
    fn=strcat('./cilnc/',fl(i,:));
    var=ncread(fn,varname);
    if ~isnan(find(var>varthresh))
        efl(li,:)=fn;
        li=li+1
    end
end
clear varotm
fn=efl(6,:)
var=ncread(fn,varname);
for i=1:1000
for j=1:720
if(var(i,j)>varthresh)
varotm(i,j)=var(i,j);
else
    varotm(i,j)=NaN;
end
end
end

contourf(varotm)