function [weigths] = optimize_weights(img, habitat_patches, options)

w_dim = length(options.harmonicsVector);
min_w = options.ga.min_w;
max_w = options.ga.max_w;
sigma = options.ga.sigma;
population = options.ga.population;
child = options.ga.child;
max_iter = options.ga.max_iter;
hV = options.harmonicsVector;
stop_crit =options.ga.stop_crit;


weigths = cell(size(habitat_patches));

[row, col] = size(habitat_patches);

response_hist = zeros(1, max_iter+2);

for j = 1:row

    for k = 1:col
        result = [];
        before_evol = get_response (ones(size(hV)), img, habitat_patches{j,k}, hV, j,options);
        response_hist(1) = before_evol;
        
        generation = create_population(min_w,max_w,population,w_dim);
        initiall_response = get_response (generation, img, habitat_patches{j,k}, hV, j,options);
        response_hist(2) = max(initiall_response);
        evol_response = initiall_response;
        
        for l = 1:max_iter
            
            [evol_response, generation] = evolve(generation, evol_response, img, habitat_patches{j,k}, hV, j,options, sigma,child );
            max_response = max(evol_response);
            response_hist(l+2) = max_response;

            if((response_hist(l+2) - response_hist(l+1))<stop_crit)
                [~,maxarg] = max(evol_response);
                result = generation(maxarg);
                break
            end
        end
        
        weigths{j,k} = result;
        
    end
end
%R = normrnd(mu,sigma);

end

function [ response ] = get_response(generation, img, habitat_patch,hV, scale,options)
    
    [row,~] = size(generation);
    response = zeros(row,1);
    for j = 1:row
        
        w_i = generation(j,:);
        harmonics = hV;
        harmonics = harmonics.*w_i;
        f_vals = get_feature(img, habitat_patch, harmonics, options);
        response(j) = sum(f_vals{scale});
    end

end

function [generation] = create_population(min_w,max_w,population,w_dim)
    
    generation = rand(population,w_dim);
    generation = generation.*(max_w-min_w)+min_w;
    generation = make_simetric(generation,w_dim);

end

function [weight] = make_simetric(generation, w_dim)
    
    weight = generation;
    rng1 = 1:((w_dim - 1)/2);
    rng2 = w_dim:-1:((w_dim - 1)/2+2);
    weight(:,rng1) = weight(:,rng2);

end

function [nodule_feature] = get_feature(img, mask, hV, options)


% parameters for texture analysis
patchRadius = options.patchRadius;                                                 % radius of the circular patch
distCtrs = options.distCtrs;                                                    % distance between the centers of the patches (controls patch overlap)
harmonicsVector = hV;                                            % number of circular harmonics
num_scales = options.num_scales;                                                   % number of scales: number of iterations of the isotropic wavelet transform
pyramid = options.pyramid;                                                      % 1: decimated, 0: undecimated wavelet transform
align = options.align;                                                        % 0: no steering, >1: moving frames built from scale = align
complexType = options.complexType;                                              % 'abs' is recommended if align = 0. 'concatenated' should be used otherwise
cropSupport = options.cropSupport;                                                  % crop the mask based on the spatial support of the wavelet to avoid the influence of surrounding objects

nodule_feature = {};
% extract circular harmonic wavelet (CHW) coefficientstruth
Qu1 = SWMtextureAnalysis(img,harmonicsVector,num_scales,pyramid,align);


for j = 1:num_scales
    Qu = {};
    Qu{1} = Qu1{j};

    feat = averageChannelAbsInMask(Qu,mask,complexType,harmonicsVector,pyramid,cropSupport);
    
    nodule_feature{j} =feat;
end
end

function [evol_response, generation] = evolve(gen, resp, img, patch, hV, scale, options, sigma, child )

[row, col] = size(gen);

evol_response = resp;
generation = gen;

parfor j = 1: row
    
    parent = gen(j,:);
    kids = zeros(child,col);
    for k = 1:child
        
        kids(k,:) = normrnd(parent,sigma);
        
    end
    
    kids = make_simetric(kids, col);
    kids_responce = get_response(kids, img, patch,hV, scale,options);
    parent_resp = resp(j);
    [kids_responce, kid_idx] = max(kids_responce);
    
    if (kids_responce>parent_resp)
        evol_response(j) = kids_responce;
        generation(j,:) = kids(kid_idx,:);
    end;
    
end


end