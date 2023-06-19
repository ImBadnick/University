function [G,rhoG,ABSrhoG] = GS(A)
syms a
n=length(A);

M = tril(A);
N = -(A - M);

G = (M^-1)*(N);

rhoG = eig(G);

ABSrhoG = eval(abs(rhoG));