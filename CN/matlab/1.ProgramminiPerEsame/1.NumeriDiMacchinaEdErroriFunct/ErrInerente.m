function Ein = ErrInerente(f)
syms x

fderiv = diff(f);
Ein = simplify((fderiv/f)*x);
fplot(Ein)