clc
clear all



[X_data, trueLabels, K] = load_dataset('OneCrossTwoEllipses.csv');

X_data = zscore(X_data);

%% construct graph
num=20;
accs=zeros(1,num);
nmis=zeros(1,num);
purs=zeros(1,num);
times=zeros(1,num);

k = 25;
W = construct_similarity_matrix2(X_data, k);
[N, ~] = size(W);
W = max(W, W'); % 
W = W - diag(diag(W)); % 
D=diag(sum(W,2));
Wn=inv(D)*W;
fprintf('数据信息: N=%d, K=%d\n', N, K);
%%




for tt=1:num
max_iter = 20;       % max iteration



    %  NGD

    

    % initialization   
 
    X=rand(N,K)*0.001; 
    seeds = select_initial_seeds_fast(W, D, K);% here we can also apply randon initialization, seeds=randperm(N,K);
                                              %  though peroformance will be lower but faster as shown in paper
    
    for ss=1:K
        X(seeds(ss),ss)=1;
    end
    X=normc(X);
   

    % timing start
    tic;

    % main loop iteration
    for iter = 1:max_iter
        WX = Wn * X;  % for applied aganin

       
        LambdaInv = 1./diag(X' * WX);    % update X and Lambda, sometimes add 1e-4 in the denominator
        X = WX *(diag(LambdaInv));    
       
        X = X .* (X == max(X, [], 2));    % discreization                
        X = normc(X);              %normlize in column

      
    end

    
    runtime = toc;  %record time
 
    times(tt)=runtime;

    [~, predLabels] = max(X, [], 2);  %get the predicting labels


    results= ClusteringMeasure(predLabels, trueLabels);  %calculate the metric
    accs(tt)=results(1);
    nmis(tt)=results(2);
    purs(tt)=results(3);

 
end
 mean(accs) 
 mean(nmis)
 mean(purs)
 mean(times)

