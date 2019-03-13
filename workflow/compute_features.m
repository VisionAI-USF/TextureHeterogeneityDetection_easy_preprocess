function [ set_features ] = compute_features( dataset, hV )
    
    set_features = [];
    tmp = {};
    %parfor j = 1:length(dataset)
    for j = 1:length(dataset)    
        img = dataset{j}.data;
        mask = dataset{j}.mask;
        figure;
        imagesc(img);
        colormap gray;
        
        
        [hab, features] = extract_habitats(img, mask, hV);
        figure;
        show_habitats(hab);
        tmp{j} = features;
        %tmp_patches{j} = habitat_patches;
        if j ==4
        
            disp('check');
        
        end
        
        
    end
    
    for j = 1:length(tmp)
        result.feature = tmp{j};
        result.info = dataset{j}.info;
        %result.patches = tmp_patches{j};
        %result.img = dataset{j}.data;
        %result.mask = dataset{j}.mask;
        
        set_features = [set_features, result];
    end

