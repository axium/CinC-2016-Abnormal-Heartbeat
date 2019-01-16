function G = GaussianKernel(U,V)
       Lema = 1;
       G = exp( - Lema * norm( U-V, 2).^2 ) )
end