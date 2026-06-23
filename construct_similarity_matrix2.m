function A = construct_similarity_matrix2(X, k)
   
    
    N = size(X, 1);
  
    distances = pdist(X, 'euclidean');
    distances = squareform(distances);

    
    A = zeros(N,N);

    for i = 1:N      
        [sorted_distances, sorted_indices] = sort(distances(i, :));        
        knn_indices(i,1:k) = sorted_indices(2:k+1);  
        knn_distances(i,1:k) = sorted_distances(2:k+1);
        knnm(i)=mean(knn_distances(i,:));
        for j=1:k
            if knn_distances(i,j)<0.2*knnm(i)
                knn_distances(i,j)=0.5*knnm(i);
            end
        end
        knnm(i)=mean(knn_distances(i,:));
    end
  knnm;
   Km=min(knnm);
 %  KM=max(knnm);
   kk=ceil(exp(-(knnm./Km-1))*k);
 % kk=ceil(exp((knnm./KM)-1)*k);

   for i=1:N
      A(i,knn_indices(i,1:kk))=1./knn_distances(i,1:kk);
      A(i,i)=0;
   end

   A=(triu(A)+triu(A)');    
end