function pathi = getapath(trelis, permmat, numtrel)
statenow = 0;
path = [statenow];
for nn=1:2*numtrel+1

  temptrel = trelis{nn};
  trelbranch = temptrel(:,2);
  treleft = temptrel(:,1);
  indnow = find(treleft==statenow);
  trelright = temptrel(indnow,3);
  if (mod(nn,2)==1)
      branchmustbe = round(rand(1));
  end
   if (mod(nn,2)==0)
      branchmustbe = trelbranch(indnow);
  end
  indbranch = find(trelbranch(indnow)==branchmustbe);
  path = [path branchmustbe trelright(indbranch)];
  statenow = trelright(indbranch); 
end
chooseme2 = [path(2:2:end)];
chooseme2 = [chooseme2(:,1:2:end) chooseme2(:,2:2:end)]*permmat;
pathi = chooseme2;
end