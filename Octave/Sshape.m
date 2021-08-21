%���Ԏ��̐ݒ�
t=0:1e-9:100e-6 ;
%�O���t����ǂݎ��l�̑�� 
T=1e-5 ;
D=0.5;
dtaur=0.2*1e-6 ;
taur=0.1*1e-6 ;
tau=5e-6 ;
A=1;


%���g��
omega0=2*pi/T ;

n=1;

%�ȉ�Sshape�t�[���G�W���̊e�l

f_S=0;
Cn_S=0;
x=0;
C=[0,0,0,0];

for n = 1:10000
     Cn_S =A*tau/T*sinc(n*omega0*tau/2)*sinc(n*omega0*(taur-dtaur)/2)*sinc(n*omega0*dtaur/2)*exp(-j*n*omega0*(tau+taur)/2); 
     f_S = f_S + Cn_S * exp(-j*omega0*n*(t));
     Cn_Samp=20*log10((abs(Cn_S))^2)+120;
     %C(1,1)={"Freq"};
     %C(1,2)={"R"};
     %C(1,3)={"X"};
     %C(1,4)={"Amp"};
     C(n,1) = n/T/2;
     C(n,2) = real(Cn_S);
     C(n,3) = real(-i*Cn_S);
     C(n,4) = Cn_Samp;
     %semilogx(n/T,Cn_Samp,'cs-.'); 
     %hold on;
     %input ("Press Return");
endfor


plot (t,f_S);
csvwrite('Sshape_time.csv',C)
csvwrite('Sshape_freq.csv',real(f_S).')



%Sshape�t�[���G�W��
%Cn_S=coeff*(term1 - term2 - term3 + term4 - term5 + term6 + term7 - term8);
%for n = 1:10
%f_S=Cn_S*exp(j*omega0*n*t)
%endfor

%V_S = sum(f_S,n,0,10)
%'''


