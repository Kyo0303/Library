clear 
clc

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
y = csvread(filename1); % csv�t�@�C���̓ǂݍ���(�s��?�z��?�`��)
T = 400*10^-12
L = 100000
Fs = 1/T;                    % �T���v�����O���g��
y = y(2:end,:);
wf = (hanning(L)); %���֐�[�n�j���O��]
acf = 1/(sum(wf)/L) %���֐��␳�W��
for i=[1:1:5];%���荀�ڐ�(i=1����4�܂�+1)
Y = czt(y(:,i+1).*wf); %�ǂݎ�����f�[�^��fft�ϊ�
Ya=20*log10(acf*(abs(Y(1:L)))*sqrt(2)/L); %�U��RMS�ϊ�
f = linspace(0,Fs,L); %���g���f�[�^(�ۑ������csv�t�@�C����1��ڂ̃f�[�^)
c{1} =f'; %1��ڂ̏�������(���g���f�[�^)
c{i+1}=Ya; %2��ڈȍ~�̏�������(FFT�̃X�y�N�g���f�[�^)
p{i} = semilogx(f,Ya); %�O���t�̏����ݒ�
hold on
end  %for�\��(i)�p
data = cell2mat(c); %data�ϐ��փf�[�^�̏�������
hold off
cd fft; %�t�H���_�̈ړ�
filename2 = [file, 'fft.eps']; %eps�t�@�C�����̐ݒ�
print(filename2);  %eps�t�@�C���̕ۑ�
filename3 = [file, 'fft.csv']; %csv�t�@�C�����̐ݒ�
csvwrite(filename3, data);  %csv�t�@�C���̕ۑ�
cd ..; %���̃t�H���_(.m�t�@�C��������t�H���_)�ւ̈ړ�
f = msgbox('Completed')
end %for�\��(j)�p