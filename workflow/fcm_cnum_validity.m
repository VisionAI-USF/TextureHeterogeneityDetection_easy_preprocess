function [opt_num] = fcm_cnum_validity(features,klist)

    xb_index = zeros(length(klist),1);
    for j = 1:length(klist)
        data.X = features;
        data = clust_normalize(data, 'range');
        param.c = klist(j);
        result = FCMclust(data,param);
        new.X = data.X;
        param.val = 2;
        result = validity(result,data,param);
        xb_index(j) = result.validity.XB;
    end
    opt_num = find(xb_index==min(xb_index));
    opt_num = opt_num(1);
    
end