function index=decidi(x)
%Restituisce 1 se x approx di -1
%Restituisce 2 se x apporx di 1/2 + sqrt(3/2)i
%Restituisce 3 se x approx di 1/2 - sqrt(3/2)i


 xx=[-1, 1/2 + (sqrt(3)/2)*i, 1/2-(sqrt(3)/2)*i];
 r=abs(xx-x); %Sottrae x da ogni elemento di xx
 [~,index]=min(r);
 
 
 