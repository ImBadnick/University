function x=tri_solve(alfa,beta,gamma,b)

%a_1=alfa(1)
%c_i=beta(i)/a(i)
%a_{i+1}+alfa(i+1)-c(i)*gamma(i)
n=length(b);
a(1)=alfa(1);

for i=1:n-1
    c(i)=beta(i)/a(i);
    a(i+1)=alfa(i+1)-c(i)*gamma(i);
end

L=eye(n)+diag(c,-1);
U=diag(a)+diag(gamma,1);
y=inf_bisolve(L,b);
x=sup_bisolve(U,y);

end
