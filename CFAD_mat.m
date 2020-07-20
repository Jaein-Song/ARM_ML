clear
%%Consecutive Cloud Detector CONCLUDE
matdir='./mat';
prefix{1}='./nqcnc/';
prefix{2}='./cilnc/';
fl{1}=ls('./nqcnc/*.cfradial');
fl{2}=ls('./cilnc/*.cfradial');
fn=length(fl{:,1});
j=0;
ldrthres=-10.5;
k=1;
maxtlen=720;
nanthres=10;
num=100;
minv=[-50 -50 -10 -40];
maxv=[30 30 2 20];
ylen=1000;
for QCi=1:2
    for VARi=1:4
        cfad{QCi,VARi}.var=zeros(ylen,num);
        cfad_num{QCi,VARi}.var=zeros(ylen,num);
    end
end

for i=1:fn
    for QCi=1:2
        fname=[prefix{QCi} fl{QCi}(i,:)];
        var{1}=ncread(fname,'reflectivity_h');
        var{2}=ncread(fname,'reflectivity_v');
        var{3}=ncread(fname,'mean_doppler_velocity_h');
        var{4}=ncread(fname,'linear_depolarization_ratio');
        fname=[prefix{1} fl{1}(i,:)];
        nanmask=ncread(fname,'nyquist_velocity');
        for VARi=1:4
%             nanmask
            [i QCi VARi]
            
            [cfad_inst, cfad_num_inst]=CFAD_func(var{VARi},1000,minv(VARi),maxv(VARi),num,nanmask,10);
            cfad{QCi,VARi}.var=cfad{QCi,VARi}.var+cfad_inst;
            cfad_num{QCi,VARi}.var=cfad_num{QCi,VARi}.var+cfad_num_inst;
%             [cfad_inst, cfad_num_inst]=CFAD_func(var{VARi},1000,minv(VARi),maxv(VARi),num,nanmask,10);
%             cfad{QCi,VARi}=cfad{QCi,VARi}+cfad_inst;
%             cfad_num=cfad_num(QCi,VARi)+cfad_num_inst;
%             [cfad{QCi,VARi}.var, cfad_num(QCi,VARi).var]=[cfad{QCi,VARi}.var, cfad_num(QCi,VARi).var]+CFAD_func(var{VARi},ylen,minv(VARi),maxv(VARi),num,nanmask,10);
        end
    end
%     clear ref* *mask nanlength nanstart
end
%             [cfad_inst, cfad_num_inst]=CFAD_func(var{VARi},1000,minv(VARi),maxv(VARi),num,nanmask,10);
%             cfad{QCi,VARi}=cfad{QCi,VARi}+cfad_inst;
%             cfad_num=cfad_num(QCi,VARi)+cfad_num_inst;