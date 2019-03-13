function [ result ] = find_idx_by_pid( cohort, pid, tp )
    result = 0;
    for j = 1:length(cohort)
        
        patient = cohort{j}.info;
        if (patient.name == pid) && (patient.time_point == tp)
            result = j;
            return  
        end
    end

end

