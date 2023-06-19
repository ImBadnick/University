function a=myexp(x,n)
% implementazione della funzione esponenziale usando il polinomio di taylor
% arrestato al termine n-esimo

a=1;

for k=1:n
    a = a+pow(x,k)/fattoriale(k);
end
end