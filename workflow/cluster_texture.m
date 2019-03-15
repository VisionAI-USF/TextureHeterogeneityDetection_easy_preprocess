function [ idx, centroids ] = cluster_texture( features, N, options )

min_patch_size = 57;

[r,~] = size(features);

idx=[];
centroids=[];

if r==1
    
    idx = 1;
    centroids = features;
    return
end


rng('default')

pix_num = size(features,1);
c_num = round(pix_num/min_patch_size);
c_num = max(1,c_num);
klist=1:min(N,c_num);
opt_num = fcm_cnum_validity(features,klist);

cluster_num = min(opt_num,N);
scale_features = features;
idx = fcm_function(features, cluster_num);
for k = 1:cluster_num

    if sum(idx==k)==1

        centroids = [centroids;scale_features(idx==k,:)];

    else

        centroids = [centroids;mean(scale_features(idx==k,:))];

    end
end

end
    
    
    
    
    
