function [vecs]= allvecs(ni, vecha)
    tarkiba = de2bi([0:2^ni-1],ni);
    vecs = [];
    for nn=1:size(tarkiba,1)
    tempbit = tarkiba(nn,:);
    tempvec = mod(sum(repmat(tempbit',1,size(vecha,2)).*vecha,1),2);
    vecs = [vecs;tempvec];  
    end
end