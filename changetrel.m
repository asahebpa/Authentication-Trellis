function newtrelis = changetrel(trelis, vec, numtrel)
newtrelis{1} = trelis{1}+repmat([0 vec(1) 0],size(trelis{1},1),1);
    for bb = 2:2*numtrel+1
       temptrel = trelis{bb};
       newtrelis{bb} = mod(temptrel+repmat([0 vec(bb) 0],size(temptrel,1),1),2);
    end
end


%        if (mod(bb,2)==1)
%            temptrel2 = mod(temptrel + [0 0 0;0 0 0;0 vec(bb) 0;0 vec(bb) 0], 2); 
%        end
%        if (mod(bb,2)==0)
%            temptrel2 = mod(temptrel + [0 0 0;0 vec(bb) 0], 2); 
%        end 