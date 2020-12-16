%Esercizio 3.2 Costruire matrice particolare diagonale.

function A=bidiag(a,b,n)
A=a*eye(n);
for i=2:n
        A(i,i-1)=b;
end
end


        
        