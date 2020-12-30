function [gout hout] = ghyabfor2stateswithinds(numtrel, moduli, trelis, permiu)
%%
for gg=1:numtrel+1
   pos = 2*(gg-1)+1;
   pos = find(permiu==pos);
   statenow = 0;
   path = [statenow];
   for nn=1:2*numtrel+1
      temptrel = trelis{nn};
      trelbranch = temptrel(:,2);
      treleft = temptrel(:,1);
      indnow = find(treleft==statenow);
      trelright = temptrel(indnow,3);
      if (mod(permiu(nn),2)==1)
          branchmustbe = 0;
          if (nn==pos)
            branchmustbe = 1;
          end
      end
      if (mod(permiu(nn),2)==0)
          branchmustbe = trelbranch(indnow);
      end
      indbranch = find(trelbranch(indnow)==branchmustbe);
      path = [path branchmustbe trelright(indbranch)];
      statenow = trelright(indbranch); 
   end
   pathalan = path(2:2:end);
   for lk = 1:length(pathalan)
      pathalan2(lk) = pathalan(find(permiu==lk));
   end
   chooseme(gg, :) = pathalan2;
end

g = chooseme;
g = [g(:,1:2:end) g(:,2:2:end)];
gright = g(:,gg+1:end);
h = [mod(gright',moduli) eye(size(gright,2))];
gout = g;
hout = h;

end