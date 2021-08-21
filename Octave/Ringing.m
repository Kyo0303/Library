clear
clc

%ŠÔ²‚Ìİ’è
t=0:1e-10:2e-7 ;
%ƒOƒ‰ƒt‚©‚ç“Ç‚İæ‚é’l‚Ì‘ã“ü 
T_0=1e-7 ;
T_reso=1e-9;
D=0.5;
ts=0.02*T_0*D;
tw=T_0*D ;
A=0;
A_reso=1;
k_reso=1e8;

%ü”g”
n=1;
f_S=A/2;
Cn_S=0;
F=[0,0];

for n = 1:1000
     Cn_reso1=(exp((-j*n*2*pi/T_0+j*2*pi/T_reso-k_reso)*tw)-1)/((-j*n*2*pi/T_0+j*2*pi/T_reso-k_reso));
     Cn_reso2=(exp((-j*n*2*pi/T_0-j*2*pi/T_reso-k_reso)*tw)-1)/((-j*n*2*pi/T_0-j*2*pi/T_reso-k_reso));
     Cn_reso=A_reso/(j*2*T_0)*exp(-j*n*2*pi/T_0*ts)*(Cn_reso1-Cn_reso2);
     f_S = f_S + 2*real(Cn_reso*exp(j*2*pi*n/T_0*t)); %‹••”‚Í³‚Ìü”g”¬•ª‚Æ•‰‚Ìü”g”¬•ª‚Åƒ[ƒ‚Æ‚È‚é‚Æ‰¼’èAreal‚ÅÀ”‰»
     Cn_Samp=20*log10(abs(Cn_reso))+120;
     F(n,1) = n/T_0;
     F(n,2) = Cn_Samp;
endfor

T=[t;f_S];
plot (t,f_S);
csvwrite('Ringing_freq.csv',F)
csvwrite('Ringing_time.csv',T')


