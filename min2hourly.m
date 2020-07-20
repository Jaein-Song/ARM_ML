function [ data2 ] = min2hourly( data, dimno,x,y,z)
%UNTITLED5 이 함수의 요약 설명 위치
%   자세한 설명 위치

for i=1:24
    sti=(i-1)*30+1;
    ei=i*30;
    if dimno==1
        data2(i)=sum(data(sti:ei));
    elseif dimno==2
        for m=1:12
            data2(m,i)=sum(data(m,sti:ei));
        end
    elseif dimno==3
        for m=1:12
            for zi=1:z
                data2(m,i,zi)=sum(data(m,sti:ei,zi));
            end
        end
    end
end

end

