clear all
clc
load('halata2.mat')
withoutredun = halatacell;
load('halata2redun.mat')
withredun = halatacell;
clear halatacell
indchoose = [2 3];
moduli = 2;
numtrel = 100;
trelis{1} = [0 0 0;0 1 1];
for hh=1:numtrel-1
   trelis{2*hh} = withredun{4};
   trelis{2*hh+1} = withoutredun{randi(2)+1};%randi(2)+1
end
trelis{2*numtrel} = withredun{4};
trelis{2*numtrel+1} = withoutredun{1};

inds = [1:2*numtrel+1];
permind = randperm(size(inds,2));
permmatinds = eye(length(permind));
permmatinds = permmatinds(:,permind);
indsnew = inds*permmatinds;
indsnew(find(indsnew==1)) = [];
indsnew(find(indsnew==(2*numtrel+1))) = [];
indsnew = [1 indsnew 2*numtrel+1];

permmatinds = eye(length(permind));
permmatinds = permmatinds(:,indsnew);
trelisbefore = trelis;
for hh=1:length(indsnew)
   trelishaminjoori{hh} = trelis{indsnew(hh)};
end
trelis = trelishaminjoori;


[g h] = ghyabfor2stateswithinds(numtrel, moduli, trelis, indsnew);
ni = 4;
[chartavec]= fourvecs(h, ni, numtrel);
[vecs4change]= allvecs(ni, chartavec);
gnew = [g;chartavec];
gnewsys = gsysmake(gnew, numtrel);
gright = gnewsys(:,size(gnewsys,1)+1:end);
hnew = [mod(gright',moduli) eye(size(gright,2))];

for mm = 1:size(vecs4change,1)
    vecs4changenew = vecs4change(mm,:);
    vecs4changenew = [reshape([vecs4changenew(1:numtrel);vecs4changenew(numtrel+2:end)],1,2*numtrel) vecs4changenew(numtrel+1)];
    vecs4changenew = vecs4changenew*permmatinds;
    newtrelis = changetrel(trelis, vecs4changenew,numtrel);
    trelistot{mm} = newtrelis;
end

permind = randperm(size(hnew,2));
permmat = eye(length(permind));
permmat = permmat(:,permind);
tempil=[1:2:size(hnew,2) 2:2:size(hnew,2)];
hnewnew =[];
for jjj=1:length(tempil)
   indic = find(tempil==jjj);
   hnewnew= [hnewnew hnew(:,indic)];
end
L = GeneratingFullRankmat(size(hnewnew, 1));
hnew2 = mod(L*hnewnew*permmatinds*permmat,2);


desiredweight = input('Enter desired weight: (example: 60) ');
numpos1 = input('How many positions must be ones: (example: 10) ');
numpos0 = input('How many positions must be zeros: (example: 10) ');
while(true)
    numbits = size(hnew2,2);
    indpermout = [1:2*numtrel+1]*permmat;
    desiredpositionkol = [randperm(numbits,numpos1+numpos0)];

    desiredposition2 = desiredpositionkol(1:numpos1);
    for gl = 1:length(desiredposition2)
        desiredposition1(gl) = (indpermout(desiredposition2(gl)));
    end


    desiredposition20 =desiredpositionkol(numpos1+1:numpos1+numpos0);
    if (length(desiredposition20)~=0)
        for gl = 1:length(desiredposition20)
            desiredposition10(gl) = (indpermout(desiredposition20(gl)));
        end
    else
        desiredposition10 = [];
    end
    vecrandi = zeros(size(hnew2,1), size(hnew2, 2));
    vecrandi(:, desiredposition20) = round(rand(size(hnew2,1), length(desiredposition20)));
    hnew2 = mod(hnew2+vecrandi,2);
    flag = 1;
    zz = 1;
    bitchoose = [];

    parfor zz=1:16
        trelis = trelistot{zz};
        weight0 = [];
        path0 = [];
        weight1 = [];
        path1 = [];
        for nn=1:1
          nn;
          temptrel = trelis{nn};
          trelbranch = temptrel(:,2);
          treleft = temptrel(:,1);
          trelright = temptrel(:,3);
          indssefr = find(trelright==0);
          indsyek = find(trelright==1);
          path0 = temptrel(indssefr,:);
          path1 = temptrel(indsyek,:); 
          weight0 = sum(path0(2:2:end),2);
          weight1 = sum(path1(2:2:end),2);
          ifhast = find(desiredposition1==nn);
          if (length(ifhast)~=0)
             indigo = find(path0(:,end-1)==1);
             path0 = path0(indigo,:);
             indigo = find(path1(:,end-1)==1);
             path1 = path1(indigo,:);
          end
        end

        for nn=2:numbits
          nn;
          temptrel = trelis{nn};
          trelbranch = temptrel(:,2);
          treleft = temptrel(:,1);
          trelright = temptrel(:,3);
          inds0r = find(trelright==0);
          inds1r = find(trelright==1);
          inds0l = find(treleft==0);
          inds1l = find(treleft==1);
          if isempty([repmat(path0,length(inds0l),1) repmat(temptrel(inds0l,2:end), size(path0,1),1)])
              pathstot = [repmat(path1,length(inds1l),1) repmat(temptrel(inds1l,2:end),size(path1,1),1)];
          elseif isempty([repmat(path1,length(inds1l),1) repmat(temptrel(inds1l,2:end),size(path1,1),1)])
              pathstot = [repmat(path0,length(inds0l),1) repmat(temptrel(inds0l,2:end),size(path0,1),1)];
          else
               pathstot = [repmat(path0,length(inds0l),1) repmat(temptrel(inds0l,2:end)...
              ,size(path0,1),1);repmat(path1,length(inds1l),1) repmat(temptrel(inds1l,2:end),size(path1,1),1)];
          end
          path0 = pathstot(find(pathstot(:,end)==0),:);
          if(length(find(pathstot(:,end)==1))~=0)
            path1 = pathstot(find(pathstot(:,end)==1),:);
          end 
          weight0 = sum(path0(:,2:2:end),2);
          weight1 = sum(path1(:,2:2:end),2);
          if(nn>30)
              [mag ja hame] = unique(weight0);
              ja = [];
              for ml=1:length(mag)
                  indtempol = find(hame==ml);
                  ja = [ja indtempol(randperm(length(indtempol),1))];
              end
              path0 = path0(ja,:);
              [mag ja hame] = unique(weight1);
              ja = [];
              for ml=1:length(mag)
                  indtempol = find(hame==ml);
                  ja = [ja indtempol(randperm(length(indtempol),1))];
              end
              path1 = path1(ja,:);
              weight0 = sum(path0(:,2:2:end),2);
              weight1 = sum(path1(:,2:2:end),2);
              path0(find(weight0>desiredweight),:) = [];
              path1(find(weight1>desiredweight),:) = [];
          end
          ifhast = find(desiredposition1==nn);
          if (length(ifhast)~=0)
             indigo = find(path0(:,end-1)==1);
             path0 = path0(indigo,:);
             indigo = find(path1(:,end-1)==1);
             path1 = path1(indigo,:);
          end

          ifhast = find(desiredposition10==nn);
          if (length(ifhast)~=0)
             indigo = find(path0(:,end-1)==0);
             path0 = path0(indigo,:);
             indigo = find(path1(:,end-1)==0);
             path1 = path1(indigo,:);
          end

          if ((size(path0,1)==0)&&(size(path1,1)==0))
              bb = 'dfsdfsd'
              break
          end
        end
        weight0 = sum(path0(:,2:2:end),2);
        ind = find(weight0==desiredweight);
        if ~isempty(path0(ind,2:2:end))
            bitchoose = [bitchoose ;path0(ind,2:2:end)];
        end
    end

    if ~isempty(bitchoose)
        for gg = 1:size(bitchoose)
            codefinal = bitchoose(gg,:)*permmat;
            display("\nOne of the valid codewords with desired weight and some specified positions for ones and zeros\n");
            codefinal
            display("\n Multiplication of the codeword by H matrix sent by user during registration: (for a valid codeword must be 0)\n")
            validity = sum((mod(hnew2*codefinal', 2)),1)
            display("\n Weight of the codeword:\n")
            wightfinal = sum(codefinal,2)
            display("\n Bits on positions which must be ones:\n")
            onepose = codefinal(desiredposition2)
            display("\n Bits on positions which must be zeros:\n")
            zeropose = codefinal(desiredposition20)  
        end
        break
    else
        errorr = 'No valid codeword found';
    end
end
 