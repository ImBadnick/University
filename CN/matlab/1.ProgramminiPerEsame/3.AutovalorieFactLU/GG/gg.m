function gg(A)
n=size(A, 1); %cosa fa questa istruzione?

clf; %elimina i disegni preesistenti
hold on; %fa si’ che ogni disegno non cancelli il precedente
axis('equal'); %forza la stessa scala su x e y

autovalori=eig(A);
plot(real(autovalori),imag(autovalori),'r*');
% ’r*’: disegna solo i punti, non collegandoli con linee di colore rosso (red)
%"help plot" per altre stringhe magiche
for k=1:n
    center=A(k,k);
    radius=0; %accumulatore
    for j=1:n
        if(j~=k)
        radius=radius+abs(A(k,j));
    end
end
circle(center,radius);
end
end