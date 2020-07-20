clear
ymd='20170905';
fl=ls(strcat('*/*',ymd,'*','cfradial'));
for i=1:2
    if(fl(i,10))=='Q'
        prefix_filename{i}='QCed';
        in_file_name=strcat('./cilnc/',fl(i,:));
    else
        prefix_filename{i}='noQC';
        in_file_name=strcat('./nqcnc/',fl(i,:));
    end
    out{i,1}.var=ncread(in_file_name,'reflectivity_h');
    out{i,2}.var=ncread(in_file_name,'reflectivity_v');
    out{i,3}.var=ncread(in_file_name,'mean_doppler_velocity_h');
    out{i,4}.var=ncread(in_file_name,'linear_depolarization_ratio');
    out{i,1}.cmin=-40;
    out{i,1}.cmax=20;
    out{i,1}.cint=200;
    out{i,1}.cbint=10;
    out{i,2}.cmin=-40;
    out{i,2}.cmax=20;
    out{i,2}.cint=200;
    out{i,2}.cbint=10;
    
    out{i,3}.cmin=-1;
    out{i,3}.cmax=1;
    out{i,3}.cint=200;
    out{i,3}.cbint=0.2;
    
    out{i,4}.cmin=-40;
    out{i,4}.cmax=0;
    out{i,4}.cint=200;
    out{i,4}.cbint=10;
    out{i,1}.cb_name='dBZ';
    out{i,2}.cb_name='dBZ';
    out{i,3}.cb_name='ms^{-1}';
    out{i,4}.cb_name='dB';
    
    for j=1:4
        out{i,j}.xax=ncread(in_file_name,'time')/3600;
        out{i,j}.xlim=[0 24];
        out{i,j}.xlb='Time (UTC)';
            k=1;

        for cti=out{i,j}.cmin:out{i,j}.cbint:out{i,j}.cmax
            out{i,j}.cticks{k}=num2str(cti);
            k=k+1;
        end
    end
end
QCfmax=2;
    h=ncread(in_file_name,'range');

