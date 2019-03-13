function [ idx, centroids ] = cluster_texture( features, N, options )

min_patch_size = 57;

[r,~] = size(features{1});

idx={};
centroids={};

if r==1
    
    idx{1} = 1;
    centroids{1} = features{1};
    return
end


rng('default')
for j = 1:1
    
    
    pix_num = size(features{1},1);
    c_num = round(pix_num/min_patch_size);
    c_num = max(1,c_num);
    opt_num = fcm_cnum_validity(features{j},1:min(N,c_num));
    
    cluster_num = opt_num;
    scale_features = features{j};
    idx{1} = fcm_function(features{1}, cluster_num);
    for k = 1:cluster_num
        
        if sum(idx{1}==k)==1
            
            centroids{k} = scale_features(idx{1}==k,:);
            
        else
        
            centroids{k} = mean(scale_features(idx{1}==k,:));
    
        end
    end
end

end
    
    
    
    
    
