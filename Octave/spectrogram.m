clear 
clc


hold off
pkg load signal

% chirp-Z �ϊ��̊֐����`�i�C�ӂ̓_����FFT�݂����ȕϊ����\���ۂ��j
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
filename1 = [file]; %�ǂݍ��݃t�@�C�����̐ݒ�
data = csvread(filename1); % csv�t�@�C���̓ǂݍ���(�s��?�z��?�`��)
ds=size(data); % �z��̎����̒������擾
%rows_size=ds(1)% �z��̎����̒������擾
%column_size=ds(2)% �z��̎����̒������擾
%sample_time = data(3,1)-data(2,1)%�T���v�����O����
sample_time = 400*10^-12
data_number=ds(1)-1;%�f�[�^��
repeat=2%�J��Ԃ���
start_time=data(2,1)
end_time=data(end,1)
Time=linspace(start_time,end_time,data_number);%���ԍ���
ch=5;
object=data(2:end,ch);
Fs=1/sample_time
num_window=40; %���ԑ��̌�
seg=round(data_number/num_window)
wf = (hanning(seg)); %���֐�[�n�j���O��]
[S, f, t] = specgram(object, seg, Fs, wf, length(wf)*0.98); %�ǂݎ�����f�[�^��fft�ϊ�
S=abs(S);
   S = S/max(S(:));           # normalize magnitude so that max is 0 dB.
   S=20*log10(S);
hokan=1 %�J���[�}�b�v�̂̕⊮�W��
S=interp2(S,hokan,'spline');
imagesc(f,Time,S')
xlabel('Frequency (Hz)', "fontsize", 44)
ylabel('Time (s)', "fontsize", 44)
xlim ([0 1e8])
ylim ([0e-6 20e-6])
set(gca, "linewidth", 2, "fontsize", 44)
caxis([-80 -20])
colormap(jet(1000))
colorbar
end %for�\��(j)�p