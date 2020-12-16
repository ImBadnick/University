function A=generateA(alfa,n)

v=ones(1,n);
A=zeros(n)+diag(v,0)+diag((ones(1,n-1)*alfa),-1);
A(1,n)=alfa;
rand(n,1);
