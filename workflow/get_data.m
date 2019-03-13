function [ C1, C2 ] = get_data(  )

C1={};
C2={};
res_side = 512;


path = pwd;
path = [path,'/data/labels.txt'];

labels = load(path);
PID = labels(:,1);
labels = labels(:,2);


path = pwd;
path = [path,'/data/cancer_type.txt'];
CC_type = load(path);
CC_labels = CC_type(:,2);
CC_PID = CC_type(:,1);

path = pwd;
path = [path,'/data/C1_representatives/'];
cases = dir(path);

for j =3:length(cases)
    
    case_path = [path,cases(j).name,'/'];
    data = load([case_path,'data.txt']);
    mask = load([case_path,'mask.txt']);
    [row,col] = size(data);
    
    if ((row+20)>res_side)||((col+20)>res_side)
       disp(['size is to small for ',case_path]);
       disp(['size is ',num2str(row),' ', num2str(col)]);
       continue
    end
    
    res_data = zeros(res_side);
    res_mask = zeros(res_side);
    x = (1:row) +20;
    y = (1:col) + 20;
    res_data(x,y) = data(:,:);
    res_mask(x,y) = mask(:,:);
    result.data = res_data;
    result.mask = res_mask;
    [name, time_point] = get_name(cases(j).name);
    
    result.info.name = name;
    result.info.time_point = time_point;
    result.info.label = get_label(name,PID, labels);
    result.info.CC_type = get_label(name, CC_PID, CC_labels);
    C1{j-2} = result;
    
end


path = pwd;
path = [path,'/data/C2_representatives/'];
cases = dir(path);

for j =3:length(cases)
    
    case_path = [path,cases(j).name,'/'];
    data = load([case_path,'data.txt']);
    mask = load([case_path,'mask.txt']);
    [row,col] = size(data);
    
    if ((row+20)>res_side)||((col+20)>res_side)
       disp(['size is to small for ',case_path]);
       disp(['size is ',num2str(row),' ', num2str(col)]);
       continue
    end
    
    res_data = zeros(res_side);
    res_mask = zeros(res_side);
    x = (1:row) +20;
    y = (1:col) + 20;
    res_data(x,y) = data(:,:);
    res_mask(x,y) = mask(:,:);
    result.data = res_data;
    result.mask = res_mask;
    [name, time_point] = get_name(cases(j).name);
    
    result.info.name = name;
    result.info.time_point = time_point;
    result.info.label = get_label(name,PID, labels);
    result.info.CC_type = get_label(name, CC_PID, CC_labels);
    C2{j-2} = result;
    
end

end


function [ name, time_point ] = get_name(info)

    name = str2double(info(1:6));
    time_point = str2double(info(11));

end


function [label_val] = get_label(name,PID, labels)

    label_val=[];
    idx = find(PID==name);
    if(isempty(idx))
        return
    end
    label_val = labels(idx);


end
