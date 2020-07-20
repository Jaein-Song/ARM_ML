function [ minti,maxti,minhi,maxhi ] = nxth( ti,hi,mask )
%UNTITLED4 이 함수의 요약 설명 위치
%   자세한 설명 위치
            if ti==1
                minti=1;
                maxti=ti+1;
            elseif ti==720
                minti=ti-1;
                maxti=ti;
            else
                minti=ti-1;
                maxti=ti+1;
            end
            if hi==1
                minhi=1;
                maxhi=hi+1;
            elseif hi==1000
                minhi=hi-1;
                maxhi=hi;
            else
                minhi=hi-1;
                maxhi=hi+1;
            end
end

