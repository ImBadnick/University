function u = ndicondizionamento(A,norma)

u = norm(A,norma) * norm(A^(-1),norma);