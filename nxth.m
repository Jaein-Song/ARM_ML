function [ minti,maxti,minhi,maxhi ] = nxth( ti,hi,mask )
%UNTITLED4 �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ
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

