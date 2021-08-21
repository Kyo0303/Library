clear 
clc

% chirp-Z 変換の関数を定義（任意の点数でFFTみたいな変換が可能っぽい）
% https://gist.github.com/fasiha/79b130812271e74a1ed3
function czt = czt(x, m, w, a)
   if nargin < 1 || nargin > 4, print_usage; end
  [row, col] = size(x);
  if row == 1, x = x(:); col = 1; end
  if nargin < 2 || isempty(m), m = length(x(:,1)); end
  if length(m) > 1, error('czt: m must be a single element\n'); end
  if nargin < 3 || isempty(w), w = exp(-2*j*pi/m); end
  if nargin < 4 || isempty(a), a = 1; end
  if length(w) > 1, error('czt: w must be a single element\n'); end
  if length(a) > 1, error('czt: a must be a single element\n'); end
  n = length(x(:,1));
  N = [0:n-1]'+n;
  NM = [-(n-1):(m-1)]'+n;
  M = [0:m-1]'+n;
  nfft = 2^nextpow2(n+m-1); % fft pad
  W2 = w.^(([-(n-1):max(m-1,n-1)]'.^2)/2); % chirp
  for idx = 1:col
    fg = fft(x(:,idx).*(a.^-(N-n)).*W2(N), nfft);
    fw = fft(1./W2(NM), nfft);
    gg = ifft(fg.*fw, nfft);
    czt(:,idx) = gg(M).*W2(M);
  end
  if row == 1, czt = czt.'; end
end 
file = uigetfile
if (file == 0)
  f = msgbox('Operation failed')
else
filename1 = [file]; %読み込みファイル名の設定
y = csvread(filename1); % csvファイルの読み込み(行列?配列?形式)
T = 400*10^-12
L = 100000
Fs = 1/T;                    % サンプリング周波数
y = y(2:end,:);
wf = (hanning(L)); %窓関数[ハニング窓]
acf = 1/(sum(wf)/L) %窓関数補正係数
for i=[1:1:5];%測定項目数(i=1から4まで+1)
Y = czt(y(:,i+1).*wf); %読み取ったデータのfft変換
Ya=20*log10(acf*(abs(Y(1:L)))*sqrt(2)/L); %振幅RMS変換
f = linspace(0,Fs,L); %周波数データ(保存されるcsvファイルの1列目のデータ)
c{1} =f'; %1列目の書き込み(周波数データ)
c{i+1}=Ya; %2列目以降の書き込み(FFTのスペクトルデータ)
p{i} = semilogx(f,Ya); %グラフの書式設定
hold on
end  %for構文(i)用
data = cell2mat(c); %data変数へデータの書き込み
hold off
cd fft; %フォルダの移動
filename2 = [file, 'fft.eps']; %epsファイル名の設定
print(filename2);  %epsファイルの保存
filename3 = [file, 'fft.csv']; %csvファイル名の設定
csvwrite(filename3, data);  %csvファイルの保存
cd ..; %元のフォルダ(.mファイルがあるフォルダ)への移動
f = msgbox('Completed')
end %for構文(j)用