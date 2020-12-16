function x=sup_solve(A,b)
%Risolve un sistema lineare triangolare inferiore
%Assumiamo che A sia non singolare 

n = length(b);

for i=n:-1:1
    somma=0;
    for j=i+1:n
        somma=somma+A(i,j)*x(j);
    end
    x(i)= (b(i)-somma)/A(i,i);
    
end
end