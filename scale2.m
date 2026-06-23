function A=scale2(A,a)
  
  cc=0;
  sm=0;
  maxv=-1;
  [N,N]=size(A);
  for i=1:N
      for j=1:N
          if A(i,j)~=0
              cc=cc+1;
              sm=sm+A(i,j);
          end
          if A(i,j)>maxv
              maxv=A(i,j);
          end
      end
  end
  ma=sm/cc;
   A=A.*(10/(maxv-ma));
end