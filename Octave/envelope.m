clear
clc
clf

pkg load signal
pkg load image
file = uigetfile
if (file == 0)
  f = msgbox('Operation failed')
else
filename1 = [file]; %�ǂݍ��݃t�@�C�����̐ݒ�
spec = csvread(filename1); % csv�t�@�C���̓ǂݍ���(�s��?�z��?�`��)
freq= spec(:,1);
for i=[1:1:5];      %���荀�ڐ�(i=1����4�܂�+1)
p{i} = semilogx(freq,spec(:,i+1)); %�O���t�̏����ݒ�
hold on
 s=(spec(:,i+1)+1000)';
 [pks idx] = findpeaks(s, "MinPeakDistance",50); %ESR7��70, ADS��15
 s(idx)=s(idx)-1000;
q{i} = semilogx(freq(idx),s(idx)); %�O���t�̏����ݒ�
A=freq(idx)';
A(1,5000)=0;
B=s(idx);
B(1,5000)=0;
enve{2*i-1}=A';
enve{2*i}=B';
xlabel('Frequency (Hz)', 'fontsize',20)
ylabel('Power Spectrum', 'fontsize',20)
ylim ([40 120])
hold on
end  %for�\��(i)�p
enve=enve;
data = cell2mat(enve); %data�ϐ��փf�[�^�̏�������
hold off
cd envelope; %�t�H���_�̈ړ�
filename2 = [file, 'envelope.eps']; %eps�t�@�C�����̐ݒ�
print(filename2);  %eps�t�@�C���̕ۑ�
filename3 = [file, 'envelope.csv']; %csv�t�@�C�����̐ݒ�
csvwrite(filename3, data);  %csv�t�@�C���̕ۑ�
cd ..; %���̃t�H���_(.m�t�@�C��������t�H���_)�ւ̈ړ�
f = msgbox('Completed')
end