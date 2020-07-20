function [ data ] = UTC2KST( data,dimno )
%convert data utc to kst
%   자세한 설명 위치
if dimno==1
    inst=data(451:720);
    data(271:720)=data(1:450);
    data(1:270)=inst;
elseif dimno==2
    inst=data(:,451:720);
    data(:,271:720)=data(:,1:450);
    data(:,1:270)=inst;
elseif dimno==3
    inst=data(:,451:720,:);
    data(:,271:720,:)=data(:,1:450,:);
    data(:,1:270,:)=inst;
end
end

