clear
clc
clf

pkg load signal
pkg load image
file = uigetfile
if (file == 0)
  f = msgbox('Operation failed')
else
filename1 = [file]; %読み込みファイル名の設定
spec = csvread(filename1); % csvファイルの読み込み(行列?配列?形式)
freq= spec(:,1);
for i=[1:1:5];      %測定項目数(i=1から4まで+1)
p{i} = semilogx(freq,spec(:,i+1)); %グラフの書式設定
hold on
 s=(spec(:,i+1)+1000)';
 [pks idx] = findpeaks(s, "MinPeakDistance",50); %ESR7は70, ADSは15
 s(idx)=s(idx)-1000;
q{i} = semilogx(freq(idx),s(idx)); %グラフの書式設定
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
end  %for構文(i)用
enve=enve;
data = cell2mat(enve); %data変数へデータの書き込み
hold off
cd envelope; %フォルダの移動
filename2 = [file, 'envelope.eps']; %epsファイル名の設定
print(filename2);  %epsファイルの保存
filename3 = [file, 'envelope.csv']; %csvファイル名の設定
csvwrite(filename3, data);  %csvファイルの保存
cd ..; %元のフォルダ(.mファイルがあるフォルダ)への移動
f = msgbox('Completed')
end