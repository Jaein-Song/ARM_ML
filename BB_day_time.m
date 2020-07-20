fl=ls('./mat/*20150712.mat');
for i=1:1%length(fl)
    fn=['./mat/' fl(i,:)];
    load(fn,'BB_height');
    if ~isempty(BB_height(~isnan(BB_height)))
        yy=str2num(fn(15:18));
        mm=str2num(fn(19:20));
        dd=str2num(fn(21:22));
    end
%     clear BB_height
end