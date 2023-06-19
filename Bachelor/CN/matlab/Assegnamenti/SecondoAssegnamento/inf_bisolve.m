function y=inf_bisolve(alfa,beta,b)

n=length(b);
y=zeros(n,1);

y(1)=b(1)/alfa;

for i=2:n
    y(i)=(b(i)-beta*y(i-1))/alfa;
    
end
end