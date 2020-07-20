flist=ls('./cilnc/*.cfradial');
fsize=size(flist);
ymt=zeros(4,12);
for fi=1:fsize(1,1)
    yy=str2num(flist(fi,30:33));
    mm=str2num(flist(fi,34:35));
    ymt(yy-2013,mm)=ymt(yy-2013,mm)+1;
end

    SCS              = get(0,'screensize');
    height           = 1080*0.9;
    width            = 1920*0.9;
    ncol             = 2;
    nrow             = 2;
    figcolor='w';
    MenuBar          = 'figure';
    ToolBar          = 'figure';
    marginl=0.02;
    marginr=0.02;
    margind=0.02;
    marginu=0.02;
    margini=0.01;
    figoh=(1-margind-marginu)/ncol;
    figow=(1-marginr-marginl)/nrow;
        figure1 = figure('color',figcolor,'PaperSize',[height*4 width*4],'units','pixels','position',[0 0 width height],'menubar',MenuBar,'toolbar',ToolBar);

% axes 생성
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% bar에 대한 행렬 입력값을 사용하여 여러 라인을 생성함
bar1 = bar(ymt','BarLayout','stacked','Parent',axes1);
set(bar1(4),'facecolor','black','DisplayName','      2017','LineWidth',1.5);
set(bar1(3),'facecolor',[0.3 0.3 0.3],'DisplayName','      2016','LineWidth',1.5);
set(bar1(2),'facecolor',[0.7 0.7 0.7],'DisplayName','      2015','LineWidth',1.5);
set(bar1(1),'facecolor','white','DisplayName','      2014','LineWidth',1.5);

xlim(axes1,[0 13]);
box(axes1,'on');
% 나머지 axes 속성 설정
set(axes1,'FontName','Minion Pro','FontSize',20,'FontWeight','bold',...
    'LineWidth',1.5,'XTick',[1 2 3 4 5 6 7 8 9 10 11 12]);
% legend 생성
legend(axes1,'show');
legend('boxoff')