function Tot = GeneratingFullRankmat(k)

%% Generating an Upper-triangular Matrix(all of the diagonal elements are 1)
b= triu(round(rand(k,k))); 
b(logical(eye(k))) = ones(1,k);

%% Generating a Lower-triangular Matrix(all of the diagonal elements are 1)
c= tril(round(rand(k,k)));
c(logical(eye(k))) = ones(1,k);

%% Generating a Permutation Matrix
P = PermutationMatrix(k);

%% The final Full-rank Matrix
Tot = mod(P'*c*b,2);

end