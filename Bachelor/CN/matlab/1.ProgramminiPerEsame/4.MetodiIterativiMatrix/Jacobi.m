function [J,rhoJ,ABSrhoJ] = Jacobi(A)
syms a
n=length(A);

M = diag(diag(A));
N = -(A - diag(diag(A)));

J = (M^-1)*(N);

rhoJ=eig(J);

ABSrhoJ = eval(abs(rhoJ));