function [logicalValue]=isConsecutiveNatural(A,pairsNumber)
%%%this function calculates if there are consecutive natural numbers in the
%%%array A
%%%%pairsNumber determines minimum of the consecutive pairs in the array A,
%%%%(pairsNumber+1)*binSize is the duration of threshold crossing
%%%%maximum value for pairsNumber is 5

for p=1:pairsNumber
    
    L=length(A);
    B=zeros(1,L-1);
    for i=1:L-1
    B(i)=A(i+1)-A(i);
    end
    B;
    B1=find(B==1);
    
    A=B1;
    
end

    if ~isempty(B1) 
          logicalValue=true;
    else
          logicalValue=false;
    end



end