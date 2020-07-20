function [ cfadnum,datalen ] = CFAD_func( z, ylen, z_min, z_max, z_num, nandata, nanthres)
%make a CFAD data for data z.
%   자세한 설명 위치
    datalen=length(nandata>nanthres);
    z_intv=(z_max-z_min)/z_num;
    cfadnum=zeros(ylen,z_num);
    for yi=1:ylen %z[y,x]
        for zi=1:z_num
            if zi==1
                cfadnum(yi,zi)=cfadnum(yi,zi)+length(find(z(yi,:)<z_min+z_intv));
            elseif zi==z_num
                cfadnum(yi,zi)=cfadnum(yi,zi)+length(find(z(yi,:)>=z_max-z_intv));
            else
                cfadnum(yi,zi)=cfadnum(yi,zi)+length(find(z(yi,:)>=z_min+z_intv*(zi-1)&z(yi,:)<z_min+z_intv*zi));
            end
        end
    end
end

