function seeds = select_initial_seeds_fast(W, D, K)
    N = size(W, 1);
    if K > N
        error('K 不能超过节点总数 N');
    end

    % 将相似度转换为距离
    W_dist = W;
    W_dist(W == 0) = Inf;
    W_dist(W > 0) = 1 ./ W_dist(W > 0);
    
    G = graph(W_dist);

    % 第一个种子：度最大的节点
    degrees = diag(D);
    [~, first] = max(degrees);
    seeds = first;

    % 初始化距离
    minDist = distances(G, first, 1:N);
    
    % 处理不可达节点
    finiteMax = max(minDist(isfinite(minDist)));
    if isempty(finiteMax)
        finiteMax = 1;
    end
    minDist(isinf(minDist)) = 2 * finiteMax;
    
    % 排除已选种子
    minDist(seeds) = -Inf;

    % 迭代
    for i = 2:K
        % 选择距离最大的节点
        [~, newSeed] = max(minDist);
        
        % 计算新种子到所有节点的距离
        distNew = distances(G, newSeed, 1:N);
        distNew(isinf(distNew)) = 2 * finiteMax;
        
        % 【核心更新】保留到最近种子的距离
        minDist = min(minDist, distNew);
        
        % 排除已选种子
        minDist(seeds) = -Inf;
        
        seeds = [seeds, newSeed];
    end
end