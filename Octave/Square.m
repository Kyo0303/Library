%���Ԏ��̐ݒ�
t=0:1e-9:1e-4 ;
%�O���t����ǂݎ��l�̑�� 
T=1e-4 ;
D=0.5;
tau=0.002*T*D;
A=1;

%���g��
n=1;
f_S=0;
Cn_S=0;
F=[0,0];

for n = 1:10000
     Cn_1 =A*tau/T*sin(n*pi*tau/T)/(n*pi*tau/T)*exp(-j*n*2*pi/T*(tau/2)); 
     Cn_2 =-A*tau/T*sin(n*pi*tau/T)/(n*pi*tau/T)*exp(-j*n*2*pi/T*(T/2))*exp(-j*n*2*pi/T*(tau/2));
     Cn_S = Cn_1+Cn_2;
     f_S = f_S + 2*real(Cn_S*exp(j*2*pi*n/T*t)); %�����͐��̎��g�������ƕ��̎��g�������Ń[���ƂȂ�Ɖ���Areal�Ŏ�����
     Cn_Samp=20*log10(abs(Cn_S))+120;
     F(n,1) = n/T;
     F(n,2) = Cn_Samp;
endfor

T=[t;f_S];
plot (t,f_S);
csvwrite('Square_freq.csv',F)
csvwrite('Square_time.csv',T')


