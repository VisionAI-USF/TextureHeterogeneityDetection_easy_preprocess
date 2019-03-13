function [ ] = show_habitats( habitats )

habitats = habitats{1};
for j = 1:size(habitats,1)
    
    [cluster_num,row,col] = size(habitats);
    result=zeros(row,col);
    for k = 1:cluster_num
        idx = find(habitats(k,:,:));
        result(idx) = 5*k;
    end
    
end

cmap = hsv;
cmap(1,:) = [1,1,1];
result = uint8(result);
img = ind2rgb(result,cmap);
imshow(img)

end

