function dp=derivate(p)
%Dato un vettore che rappresenta un polinomio, calcolo il vettore che
%rappresenta la sua derivata

n=length(p)-1; %Lunghezza di dp, ovvero grado di p

dp=(n:-1:1).*p(1:n); %dp=[p(1)*n, p(2)*(n-1) ... p(n)*1]


