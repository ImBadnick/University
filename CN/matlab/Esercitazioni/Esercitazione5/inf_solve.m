function x=inf_solve(A,b)
%Risolve un sistema lineare triangolare inferiore
%Assumiamo che A sia non singolare 

n = length(b);

x=zeros(n,1); %Forzo il vettore x ad essere un vettore colonna, sennò sarebbe un vettore riga se assegnassi ogni volta x(1)=1 ecc..

for i=1:n
    somma=0;
    for j=1:i-1
        somma=somma+A(i,j)*x(j);
    end
    x(i)= (b(i)-somma)/A(i,i);
    
end
end