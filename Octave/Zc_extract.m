clear 
clc
y = csvread('trace1.csv') ;
clc
x=25;
f=10^6;
omega=2*pi*f;
for n=[1:1:x]
  R{n}=y(:,2*n-1);
  L{n}=y(:,2*n);
endfor
  R = cell2mat(R);
  R = R*10^6;
  L = cell2mat(L);
  L = imag(L)*10^9/omega;
for a=[1:1:x]
  for b=[1:1:x]
  K{a,b} = L(a,b)/sqrt(L(a,a)*L(b,b));
  end
end
  K = cell2mat(K);
save Rmatrix.txt R -ascii
save Lmatrix.txt L -ascii
save Kmatrix.txt K -ascii