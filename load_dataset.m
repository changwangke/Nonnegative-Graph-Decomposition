function [X_data, trueLabels, K] = load_dataset(selected_dataset)
    [~, ~, ext] = fileparts(selected_dataset);

    %数据加载
    if any(strcmpi(ext, {'.csv','.data'}))
        try
            data = readtable(selected_dataset, 'FileType', 'text');
        catch
            data = array2table(load(selected_dataset));
        end

        %检查表格中是否包含非数值列
        numericVars = varfun(@isnumeric, data, 'OutputFormat', 'uniform');

        if all(numericVars)
            %如果所有列都是数值型
            [X_data, trueLabels] = deal(data{:,1:end-1}, data{:,end});
        else
            %如果有非数值列，找到最后一列数值列作为标签
            numericCols = find(numericVars);
            if isempty(numericCols)
                error('数据集中没有数值列');
            end

            %使用最后一列数值列作为标签
            labelCol = numericCols(end);
            featureCols = numericCols(1:end-1);

            X_data = data{:, featureCols};
            trueLabels = data{:, labelCol};
        end

    elseif strcmpi(ext, '.mat')
        data = load(selected_dataset); 
        vars = fieldnames(data);
        [X_data, trueLabels] = deal(data.(vars{1}), data.(vars{min(2,end)}));
    else
        error('不支持的文件格式: %s', ext); 
    end

    %确保数据是 double 类型
    X_data = double(X_data);
    trueLabels = double(trueLabels);

    %标签处理和聚类数计算
    trueLabels = grp2idx(trueLabels);
    K = max(trueLabels);
end