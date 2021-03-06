clear
clc

%時間軸の設定
t=0:1e-9:1e-4 ;
%グラフから読み取る値の代入 
T_0=1e-4 ;
T_reso=0.2e-7;
D=0.5;
ts=0.002*T_0*D;
tw=T_0*D ;
A=1;
A_reso=0.25;
k_reso=10e6;

%周波数
n=1;
f_S=A/2;
Cn=0;
F=[0,0];

for n = 1:10000
     Cn_S =A*tw/T_0*sin(n*pi*ts/T_0)/(n*pi*ts/T_0)*sin(n*pi*tw/T_0)/(n*pi*tw/T_0)*exp(-j*n*pi/T_0*(tw+ts)); 
     Cn_reso1=(exp((-j*n*2*pi/T_0+j*2*pi/T_reso-k_reso)*tw)-1)/((-j*n*2*pi/T_0+j*2*pi/T_reso-k_reso));
     Cn_reso2=(exp((-j*n*2*pi/T_0-j*2*pi/T_reso-k_reso)*tw)-1)/((-j*n*2*pi/T_0-j*2*pi/T_reso-k_reso));
     Cn_reso_H=A_reso/(j*2*T_0)*exp(-j*n*2*pi/T_0*ts)*(Cn_reso1-Cn_reso2);
     Cn_reso_L=-A_reso/(j*2*T_0)*exp(-j*n*2*pi/T_0*(T_0/2+ts))*(Cn_reso1-Cn_reso2);  
     Cn = Cn_S+ Cn_reso_H+Cn_reso_L;
     f_S = f_S + 2*real(Cn*exp(j*2*pi*n/T_0*t)); %虚部は正の周波数成分と負の周波数成分でゼロとなると仮定、realで実数化
     Cn_Samp=20*log10(abs(Cn))+120;
     F(n,1) = n/T_0;
     F(n,2) = Cn_Samp;
     wait=n/10000*100
endfor

T=[t;f_S];
plot (t,f_S);
csvwrite('Trap_ring_freq.csv',F)
csvwrite('Trap_ring_time.csv',T')


