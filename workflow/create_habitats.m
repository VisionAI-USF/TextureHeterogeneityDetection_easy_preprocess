function [ habitats ] = create_habitats(patches, cluster_idx, mask, options)

[row,col] = size(mask);
%habitats = cell(1,scale_num);
habitats = [];
%for j =1:scale_num

cid = unique(cluster_idx);
if length(cid) == 1
    habitats = zeros(1,size(mask,1),size(mask,1));
    habitats(1,:,:) = mask>1;
    return
end


cluster_num = length(cid);

habitats = zeros(cluster_num,row,col);

for scale = 1:length(cid)
    idx = cid(scale);

    coord_idx = find(cluster_idx==idx);
    for j = 1:length(coord_idx)
        
        habitats(scale,patches(coord_idx(j),1),patches(coord_idx(j),2))=idx;
        
    end
    
   
end




