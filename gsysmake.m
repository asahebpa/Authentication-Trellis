function matsys = gsysmake(mat, numtrel)
m = size(mat,1);
n = size(mat,2);
matsys = mat;
flag = 1;
i =1;
while(flag) 
    % if the ith diagonal element is one, it adds the ith row to other rows with
    % non-zero elements on the column i.
    % if the ith diagonal element is zero, it finds a row with non-zero
    % element on the ith column and(j th row) and swap those two rows.
    if matsys(i,i)==1 
        inds = find(matsys(:,i));
        inds(find(inds==i,1,'first')) = [];
        attack = zeros(m,n-i+1);
        attack(inds,:) = repmat(matsys(i,i:n),length(inds),1);
        matsys(:,i:n) = mod(matsys(:,i:n) + attack,2);   
    else
        ind = find(matsys(i+1:end,i),1,'first');
        attack = zeros(m,n);
        matsys([i ind+i],:) = matsys([ind+i i],:);
        i = i-1;
    end
    i = i+1;
    if i>(numtrel+1+4)
        flag=0;
    end
end

end


% for i = 1:numtrel+1+4
%    temp = gsys(i,:);
%    tempol = [1:size(gsys,1)];
%    tempol(find(tempol==i)) =[];
%    zir = gsys(tempol,i);
%    ind = find(zir~=0);
%    if length(ind)==0
%        continue
%    else
%        zeroha = zeros(size(gsys));
%        zeroha(tempol(ind),:)=repmat((moduli-zir(ind)),1,length(temp)).*repmat(temp,length(ind),1);
%        gsys = mod(gsys+zeroha,moduli);
%    end
% end