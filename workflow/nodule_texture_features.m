function [ nodule_feature, locatoins ] = nodule_texture_features( img, mask, options )



% parameters for texture analysis
patchRadius = options.patchRadius;                                                 % radius of the circular patch
distCtrs = options.distCtrs;                                                    % distance between the centers of the patches (controls patch overlap)
harmonicsVector = options.harmonicsVector;                                            % number of circular harmonics
num_scales = options.num_scales;                                                   % number of scales: number of iterations of the isotropic wavelet transform
pyramid = options.pyramid;                                                      % 1: decimated, 0: undecimated wavelet transform
align = options.align;                                                        % 0: no steering, >1: moving frames built from scale = align
complexType = options.complexType;                                              % 'abs' is recommended if align = 0. 'concatenated' should be used otherwise
cropSupport = options.cropSupport;                                                  % crop the mask based on the spatial support of the wavelet to avoid the influence of surrounding objects
locatoins = [];
nodule_feature = {};
mask_bool = mask>0;
patches_ready = 0;

% extract circular harmonic wavelet (CHW) coefficientstruth
features = [];
p_idx = 1;

[row, col] = find(mask);

patch_size = 12;

c_map = generate_coordinate_map(size(img));
%np = 0;
for j=1:length(row)

    x = col(j);
    y = row(j);
    [patch, patch_mask, coords] = get_mask(img, mask, c_map, x, y);

    if sum(sum(patch_mask))>0
%             np=np+1;
        Qu1 = SWMtextureAnalysis(patch,harmonicsVector,num_scales,pyramid,align);
        [feat,pos] = compute_local_texture(Qu1, patch_mask, coords, options);
        features = [features;feat];
        locatoins = [locatoins; pos];
    else
        error('Segmentation missalignment error during texture computation');
    end

end
same = [];

for j = 1:size(locatoins,1)
    for k = j+1:size(locatoins,1)

        cj = locatoins(j,:);
        ck = locatoins(k,:);
        if (cj(1)==ck(1))&&(cj(2)==ck(2))
            same = [same;j];
        end

    end
end
features(same,:) = [];
locatoins(same,:) = [];
%disp(['np: ', num2str(np)]);

if isempty(features)
%     x = mean(find(max(mask)>0));
%     y = mean(find(max(mask')>0));
%     
%     patch = getCircularPatch(img,x,y,patchRadius);
    feat = averageChannelAbsInMask(Qu1,mask,complexType,harmonicsVector,pyramid,cropSupport);
    
    features = [features;feat];
    patches_set{p_idx} = mask>0; 
    p_idx= p_idx + 1;
    
end


patches_ready = 1;
nodule_feature{1} =features;

end

function [feat, pos] = compute_local_texture(Qu1, mask, map, options)

    harmonicsVector = options.harmonicsVector;                                            % number of circular harmonics
    pyramid = options.pyramid;                                                      % 1: decimated, 0: undecimated wavelet transform
    complexType = options.complexType;                                              % 'abs' is recommended if align = 0. 'concatenated' should be used otherwise
    cropSupport = options.cropSupport;                                                  % crop the mask based on the spatial support of the wavelet to avoid the influence of surrounding objects
    patchRadius = options.patchRadius; 
    
    feat = [];
    pos = [];

    [row, col] = find(mask);
    patch = getCircularPatch(mask,row,col,patchRadius);
    feat = averageChannelAbsInMask(Qu1,patch,complexType,harmonicsVector,pyramid,cropSupport);
    pos = map;
    

end


function [coordinate_map] = generate_coordinate_map(ims)

    x = 1:ims(2);
    y = 1:ims(1);
    coordinate_map = zeros(ims(1),ims(1),2);
    [xm,ym] = meshgrid(x,y);
    coordinate_map(:,:,2) = xm;
    coordinate_map(:,:,1) = ym;

end




function [patch, patch_mask,coords] = get_mask(img, mask,c_map, x, y)
    y_min = (y-15);
    y_max = (y+16);
    x_min = (x-15);
    x_max = (x+16);
    [r,c] = size(img);
    
    if y_min < 1
        dx = 1 - y_min;
        y_min = y_min + dx;
        y_max = y_max + dx;
    end
    if y_max > r
        dx = y_max-r;
        y_min = y_min - dx;
        y_max = y_max - dx;
    end
    if x_min < 1
        dx = 1 - x_min;
        x_min = x_min + dx;
        x_max = x_max + dx;
    end
    if x_max > c
        dx = x_max-c;
        x_min = x_min - dx;
        x_max = x_max - dx;
    end
    
    
    patch_mask = mask(y_min:y_max,x_min:x_max);
    patch = img(y_min:y_max,x_min:x_max);
    
    coords = [y,x];
    info_mask = zeros(32,32);
    

    info_mask(16,16) =1;
    patch_mask = patch_mask & info_mask;

end








