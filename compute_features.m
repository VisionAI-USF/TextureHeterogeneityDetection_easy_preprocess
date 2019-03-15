function [habitats, features] = compute_features(img, mask, hV, varargin)
    
    N = 15;
    options = get_options(hV);
    
    [tex_features, coords] = nodule_texture_features( img, mask, options );
    
    
    if size(tex_features,1)~=sum(sum(mask>0))
        error('# of texture feature mismatch with # of pixels in the mask');
    end
    
    [cluster_idx, cluster_centroids] = cluster_texture(tex_features, N, options);

    habitats = create_habitats(coords, cluster_idx, mask, options);


    features = nodule_classification_features( habitats, mask,cluster_centroids);

end

function [params] = get_options(hV)

    params.cluster_num = 6;
    params.kmean_replicate = 40;

    params.patchRadius = 6;                                                 % radius of the circular patch
    params.distCtrs = 3;                                                    % distance between the centers of the patches (controls patch overlap)
    params.harmonicsVector = hV;% [-4,-3,-2,-1,0,1,2,3,4];                                            % number of circular harmonics
    params.num_scales = 3;                                                   % number of scales: number of iterations of the isotropic wavelet transform
    params.pyramid = 0;                                                      % 1: decimated, 0: undecimated wavelet transform
    params.align = 3;                                                        % 0: no steering, >1: moving frames built from scale = align
    params.complexType = 'abs';                                              % 'abs' is recommended if align = 0. 'concatenated' should be used otherwise
    params.cropSupport = 0;


end
