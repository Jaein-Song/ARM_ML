
inst=rains10(451:720);
rains10kst(1:270)=inst;
rains10kst(271:720)=rains10(1:450);
inst=rains00(451:720);
rains00kst(1:270)=inst;
rains00kst(271:720)=rains00(1:450);
inst=rains15(451:720);
rains15kst(1:270)=inst;
rains15kst(271:720)=rains15(1:450);
ntotalkst(1:270)=ntotal(451:720);
ntotalkst(271:720)=ntotal(1:450);
for m=1:12
    inst=rains10m(451:720,m);
    rains10mkst(1:270,m)=inst;
    rains10mkst(271:720,m)=rains10m(1:450,m);
    inst=rains00m(451:720,m);
    rains00mkst(1:270,m)=inst;
    rains00mkst(271:720,m)=rains00m(1:450,m);
    inst=rains15m(451:720,m);
    rains15mkst(1:270,m)=inst;
    rains15mkst(271:720,m)=rains15m(1:450,m);
    ntotalmkst(1:270,m)=ntotalm(451:720,m);
    ntotalmkst(271:720,m)=ntotalm(1:450,m);
end
for i=1:24
    rains10kst24freq(i)=sum(rains10kst((i-1)*30+1:i*30))/sum(ntotalkst((i-1)*30+1:i*30));
    rains00kst24freq(i)=sum(rains00kst((i-1)*30+1:i*30))/sum(ntotalkst((i-1)*30+1:i*30));
    rains15kst24freq(i)=sum(rains15kst((i-1)*30+1:i*30))/sum(ntotalkst((i-1)*30+1:i*30));
    for m=1:12
        rains10mkst24freq(i,m)=sum(rains10mkst((i-1)*30+1:i*30,m))/sum(ntotalmkst((i-1)*30+1:i*30,m));
        rains00mkst24freq(i,m)=sum(rains00mkst((i-1)*30+1:i*30,m))/sum(ntotalmkst((i-1)*30+1:i*30,m));
        rains15mkst24freq(i,m)=sum(rains15mkst((i-1)*30+1:i*30,m))/sum(ntotalmkst((i-1)*30+1:i*30,m));
    end
end