function [vecha]= fourvecs(h, ni, numtrel)
    vecha = [];
    vv = 1;
    while(1)
     vectemp = [zeros(1,numtrel+1+vv-1) 1  round(rand(1,size(h,2)-numtrel-vv-1))];
     if (sum(mod(h*vectemp',2)')~=0)
        vecha = [vecha;vectemp]; 
        vv = vv+1;
     end
     if (size(vecha,1)==ni)
         break
     end
    end
end

