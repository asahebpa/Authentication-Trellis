function P = PermutationMatrix(n)
inds = [1:n];

%% Knuth Shuffle
for i = n:-1:2
    swap = randi(i);
    temp = inds(i);
    inds(i) = inds(swap);
    inds(swap) = temp; 
end
%% Transforming the permuted indices into the Permutation Matrix
P = zeros(n,n);
for i = 1:n
   P(i,inds(i)) = 1; 
end

end