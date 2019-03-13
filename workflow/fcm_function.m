function [indeces] = fcm_function(features, Nc)
    
    opt = [2.0,100,	1e-5,0];
    
    [~, U]=fcm(features, Nc, opt);
    indeces = zeros(size(features,1),1);
    for j = 1:size(features,1)
        v = U(:,j);
        [~,I] = max(v);
        indeces(j) = I;
    end
    
end

