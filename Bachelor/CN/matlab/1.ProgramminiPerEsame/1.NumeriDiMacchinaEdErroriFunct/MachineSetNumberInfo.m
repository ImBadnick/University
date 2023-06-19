function [card,min,max,numberdistance,machinePrecisionTronc, machinePrecisionApprox] = MachineSetNumberInfo(B,t,m,M)

card = 1 + 2*(m+M+1) * ((B-1)*B^(t-1));

min = B^(-m-1);

max = B^(M) * (1-B^(-t));

numberdistance = B^(p-t);

machinePrecisionTronc = B^(1-t);

machinePrecisionApprox= (1/2)*(B^(1-t));



