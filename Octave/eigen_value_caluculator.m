clear 
clc
clf
hold off

pkg load symbolic
 syms s
 syms R0 R1 R2 L0 L1 L2 C1 C2 positive
 R0=0.5
 R1=0.5
 R2=0.5
 L0=56*10^-9
 L1=15*10^-9
 L2=0
 C1=562*10^-12
 C2=152*10^-12
 for n = 1:4
 X=10*n*10^-12;
 C2=X
 A1 = [[L0+L1 L0 0 0];
 [L0 L0+L2 0 0];
 [0 0 C1 0];
 [0 0 0 C2]];
 A2 = [[-R0-R1 -R0 -1 0];
 [-R0 -R0-R2 0 -1];
 [1 0 0 0];
 [0 1 0 0]];
 A= inv(A1)*A2 ;
 b= eig(A)
 res=real(b);
 f=imag(b./2./pi./10^6)
 %figure(1);
 subplot(1,2,1);
 plot (X,f(1),'1', "MarkerSize", 30);
 xlim ([0 X])
 ylim ([15 30])
 set(gca, "fontsize", 30)
 xlabel({'Parameter'})
 ylabel({'Frequency (MHz)'})
 hold on
 %figure(2);
 subplot(1,2,2);
  plot (X,b(1),'3', "MarkerSize", 30);
  xlim ([0 X])
  ylim ([-10*10^6 0])
 set(gca, "fontsize", 30)
 xlabel({'Parameter'})
 ylabel({'Real part of s'})
 hold on
 endfor
%saveas(gcf,'RLC.png')
