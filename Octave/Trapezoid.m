%時間軸の設定
t=0:1e-9:1e-4 ;
%グラフから読み取る値の代入 
T=1e-4 ;
D=0.5;
ts=0.002*T*D;
tw=T*D ;
A=1;

%周波数
n=1;
f_S=A/2;
Cn_S=0;
F=[0,0];

for n = 1:10000
      Cn_S =A*tw/T*sin(n*pi*ts/T)/(n*pi*ts/T)*sin(n*pi*tw/T)/(n*pi*tw/T)*exp(-j*n*pi/T*(tw+ts)); 
     f_S = f_S + 2*real(Cn_S*exp(j*2*pi*n/T*t)); %虚部は正の周波数成分と負の周波数成分でゼロとなると仮定、realで実数化
     Cn_Samp=20*log10(abs(Cn_S))+120;
     F(n,1) = n/T;
     F(n,2) = Cn_Samp;
endfor

T=[t;f_S];
plot (t,f_S);
csvwrite('Trapezoid_freq.csv',F)
csvwrite('Trapezoid_time.csv',T')


