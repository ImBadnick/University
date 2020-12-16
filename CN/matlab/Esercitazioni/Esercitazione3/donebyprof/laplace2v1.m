%Costruisce la matrice tridiagonale con 2 sulla diagonale principale e -1 
%sulle diagonali secondarie
function A=laplace(n)
A=2*eye(n);
for i=2:n
        A(i, i-1)=-1;
        A(i-1,i)=-1;
end
end
