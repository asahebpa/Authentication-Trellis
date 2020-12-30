function sumout = hvaliditycheckwithinds(h2, trelis, tedad, permmat, numtrel, permiu)

 for nn2 = 1:tedad 
   statenow = 0;
   path = [statenow];
   for nn=1:2*numtrel+1
      temptrel = trelis{nn};
      trelbranch = temptrel(:,2);
      treleft = temptrel(:,1);
      indnow = find(treleft==statenow);
      trelright = temptrel(indnow,3);
      if (mod(permiu(nn),2)==1)
          branchmustbe = round(rand(1));
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
   chooseme2 = pathalan2;
   chooseme2 = [chooseme2(:,1:2:end) chooseme2(:,2:2:end)]*permmat;
   chooseme22(nn2,:) = chooseme2;
   jama(nn2) = sum(mod(h2*chooseme2',2)');

 end
 
sumout =  sum(jama);


end