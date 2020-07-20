clear
matdir='./mat/';
file_list=ls([matdir '*.mat']);
file_leng=length(file_list);
k=0;
for fi=1:file_leng
    file_name=[matdir file_list(fi,:)];
    load(file_name,'BB_height');
    nnan_leng=length(BB_height(~isnan(BB_height)));
    if nnan_leng>0
        y=str2num(file_list(fi,9:12));
        m=str2num(file_list(fi,13:14));
        d=str2num(file_list(fi,15:16));
        for ti=1:24
            sti=(ti-1)*30+1;
            edi=ti*30;
            BB_inst=BB_height(sti:edi);
            if length(BB_inst(~isnan(BB_inst)))>5
                k=k+1;
                BB_list(k,1)=y;
                BB_list(k,2)=m;
                BB_list(k,3)=d;
                BB_list(k,4)=ti-1;
                BB_list(k,5)=nanmean(BB_inst);
            end
        end
    end
end
