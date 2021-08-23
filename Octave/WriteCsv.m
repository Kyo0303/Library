function [Report,DataCell] = WriteCsv(FileName,Data,varargin)
% 
% WriteCsv: 2�����s��f�[�^���e�L�X�g�t�@�C���ɏ����o��
%
% [Report,DataCell] = WriteCsv(FileName,Data,Delim,Levels,ColNames,Comment,[options])
% 
%    Report       �t�@�C���ɉ��������o���Ȃ����0���A�V�K�t�@�C���ɏ����o
%                 ������1���A�����t�@�C����u����������2���A�����t�@�C����
%                 ������������3���o�͂��܂��B
%    DataCell     Data �̓��e���Z���z��ɒu�����������̂��o�͂���܂��B
%                 Levels ���w�肳��Ă���ƁA�������ɒu���������Ă��܂��B
% 
%    FileName     �o�͐�̃t�@�C�����ie.g., 'Data.csv'�j�B�ȗ��s�B
%    Data         �f�[�^�i2�����s��j�B�ȗ��s�B
%    Delim        ��؂蕶���B�^�u��'\t'�Ǝw�肵�ĉ������B�ȗ��B�ȗ�����
%                 ','���g���܂��B
%    Levels       �������̈ꗗ�i�Z���z��j�B�ȗ��B
%    ColNames     Data�̊e��̖��́B�`���̍s�ɂ��̓��e���o�͂��܂��B�ȗ��B
%    Comment      �R�����g�i������j�B1�s�ڂɂ��̂܂܏o�͂���܂��B�ȗ��B
% 
%    �ȉ��̃I�v�V�������w��ł��܂��i�ȗ��j�F
%    '-overwrite' �t�@�C���㏑���̊m�F�������A�����I�ɏ㏑�����܂��B
%    '-append'    �����̃t�@�C���̌�ɏ��������܂��B
%    '-unix'      ���s�R�[�h�� LF ��p���܂��iUnix, MacOSX�����j�B
%    '-win'       ���s�R�[�h�� CR+LF ��p���܂��iWindows�����j�B
%    '-mac'       ���s�R�[�h�� CR ��p���܂��iMacOS9�����j�B
%
%  2�����s��̃f�[�^ Data ���e�L�X�g�t�@�C���ɏ����o���܂��B���Ƃ��΁A1��
%  �ڂɗv��1�̐����A2��ڂɗv��2�̐����A3��ڂɑ���l���L�������̂悤�ȃf
%  �[�^���l���܂��B
% 
%     Data = [
%        1   1   337.1
%        1   1   460.2
%        1   1   390.0
%        1   2   561.9
%        1   2   884.8
%        1   3   409.8
%        1   3   552.9
%        2   1   294.2
%        2   1   711.0
%        2   1   551.8
%        2   2   580.2
%        2   2   609.5
%        2   3   442.4
%        2   3   493.1
%     ];
% 
%  ����ɑ΂��āA WriteCsv('Data.csv',Data) �����s����ƁA���̂悤�ȓ��e
%  �̃e�L�X�g�t�@�C�� Data.csv ���o�͂���܂��B
% 
%     1,1,337.100000
%     1,1,460.200000
%        �i�����j
%     2,3,493.100000
% 
%  ��؂蕶���� Delim �Ŏw��ł��܂��BWriteCsv('Data.txt',Data,';') 
%  �Ƃ���� 
%
%     1;1;337.100000
%     1;1;460.200000
%        �i�����j
%     2;3;493.100000
%
%  �̂悤�ɂȂ�܂��B�^�u�� '\t' �Ǝw�肵�ĉ������BDelim ���ȗ������ƃJ
%  ���}���g���܂��B
%
%  ���� Levels �Ő������̈ꗗ��^����ƁA���l�𐅏����ɒu���������܂��B
%  Levels �̓Z���z��ł��BLevels{N} �́AData ��N��ڂɑΉ����鐅�����̃Z
%  ���z��ł��B���Ƃ��Ύ��̂悤�ɐ��������w�肵�܂��B
% 
%    Levels{1} = {'F','M'}                     % �v��1�̐�����
%    Levels{2} = {'����A','����B','��������'}  % �v��2�̐�����
% 
%  ����� WriteCsv('Data.txt',Data,[],Levels) �Ƃ���Ή��̂悤�ɂȂ�܂��B
%
%     F,����A,337.100000
%     F,����A,460.200000
%        �i�����j
%     M,��������,493.100000
%
%  Data �̂����ALevels �Œu���������̒l�́A���R���łȂ���΂Ȃ�܂���B
%  �v��2�����������ɒu�������A�v��1�͒u�������Ȃ��ꍇ�ALevels{1} �ɋ� []
%  ���w�肵�Ă��������B
%  
%  Levels�ŁA�������̈ꗗ�̂����� '%n' ���܂ޕ������1�����w�肷��ƁA
%  '%n' �� Data ���̐��l�ɒu�����������������o�͂��܂��B����́A�팱��
%  �ԍ��� 'Subject1' �̂悤�ȕ�����ɒu��������ꍇ�ɕ֗��ł��B���Ƃ��΁A
% 
%    Levels{1} = {'Subject%n'}                  % �팱�Ҕԍ�
%    Levels{2} = {'����A','����B','��������'}   % �v���̐�����
% 
%  �Ƃ���ƁA���̂悤�Ȍ��ʂɂȂ�܂��B
%
%     Subject1,����A,337.100000
%     Subject1,����A,460.200000
%        �i�����j
%     Subject2,��������,493.100000
%
%  ColNames �ŗ�Ɍ��o���������܂��BColNames �̓Z���z��ł��B���Ƃ���
%
%     ColNames = {'����','����','��������(ms)'}
% 
%  �Ƃ��āAWriteCsv('Data.txt',Data,[],[],ColNames) �Ƃ���΁A
% 
%     ����,����,��������(ms)
%     1,1,337.100000
%     1,1,460.200000
%        �i�����j
%     2,3,493.100000
% 
%  �̂悤�ɁA�`���Ɍ��o���������܂��B���o�����������Ȃ���ɑ΂��ẮA
%  ����w�肵�ĉ������B���̗�ł́A2��ڂɌ��o�������܂���B
% 
%     ColNames = {'����','','��������(ms)'}
% 
%  Comment �ɕ�������w�肷��ƁA���̓��e���P�s�ڂɏo�͂���܂��B���Ƃ���
% 
%     Comment = '# Experiment 1, 2015/09/01'
% 
%  �Ƃ��āAWriteCsv('Data.txt',Data,[],[],[],Comment) �Ƃ���΁A
% 
%     # Experiment 1, 2015/09/01
%     1,1,337.100000
%     1,1,460.200000
%        �i�����j
%     2,3,493.100000
% 
%  �̂悤�ɁA1�s�ڂɃR�����g���ǉ�����܂��B'-append' ���w�肳��Ă����
%  ���AComment �� ColNames �͏������������̍ŏ��ɏo�͂���܂��B
% 
%  FileName �Ŏw�肳�ꂽ�t�@�C�������łɑ��݂���ꍇ�A�㏑�����Ă悢���m
%  �F�����߂܂��By ����͂���Ώ㏑�����An ����͂���Ώ㏑�������ɏI����
%  �܂��B�I�v�V���� '-overwrite' ���w�肷��ƁA���̊m�F�����܂���B
% 
%  �I�v�V������'-'�Ŏn�܂镶����Ŏw�肵�܂��B�w�肷�鏇���͔C�ӂł��B
% 
%   '-overwrite' �t�@�C���̏㏑���m�F�������A�����I�ɏ㏑�����܂��B
%   '-append'    FileName�Ŏw�肳�ꂽ�t�@�C�������݂���΁A���������܂��B
%                �t�@�C�������݂��Ȃ���΁A�V�K�Ƀt�@�C�����쐬���܂��B
% 
%  ���s�R�[�h���w�肷��ɂ͈ȉ��̃I�v�V�������g���܂��i�����R�[�h�̕ϊ���
%  �s�Ȃ��܂���j�B���̂�������w�肵�Ȃ��ƁALF ���p�����܂��B
% 
%   '-unix'      ���s�R�[�h�� LF ��p���܂��iUnix, Mac OSX�����j�B
%   '-win'       ���s�R�[�h�� CR+LF ��p���܂��B����́A�o�͂��ꂽ�t�@�C
%                ����Windows�̃������ŊJ���ꍇ�Ȃǂɕ֗��ł��B
%   '-mac'       ���s�R�[�h�� CR ��p���܂��iMac OS9�����j�B
% 
% (2015/09/15 by R Niimi. Tested with Octave 4.0.0 on Windows8)

Report = 0;
Levels = {};
ColNames = {};
Delim = ','; % default value
Comment = [];
ReturnCode = {'\n','\r\n','\r'};
FilePresence = [];

%%%%% Parameter Verification %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VN = nargin;

if VN < 2
	error('Usage: WriteCsv(FileName,Data[,options])');
end
if ~ischar(FileName)
	error('[WriteCsv] Invalid file name');
end
% if ~ismatrix(Data)
if ~isnumeric(Data) | ~isempty(find(size(Data)==1)) % function "ismatrix" is not available in some environrments
	error('[WriteCsv] Data must be a matrix.');
end
if length(size(Data))>2
	error('[WriteCsv] Data must be a 2-dimensional matrix.');
end
[RowN ColN] = size(Data);

if VN>2
	Delim = varargin{1};
	if  ~isempty(Delim) & ~ischar(Delim)
		error('[WriteCsv] Delim must be a text string (eg ',').');
	end
	if isempty(Delim) % if empty string is given by the user, ...
		Delim = ','; % ...put the default value
	end
end
if VN>3
	Levels = varargin{2};
	if ~isempty(Levels) & ~iscell(Levels)
		if ischar(Levels) % if user gave single text string as Levels, ...
			Levels = {Levels}; % ...interpret it as Levels{1}.
		else
			error('[WriteCsv] Levels must be a cell array.');
		end
	end
end
if VN>4
	ColNames = varargin{3};
	if  ~isempty(ColNames) & ~iscell(ColNames)
		error(['[WriteCsv] ColNames must be a cell array.']);
	end
end
if VN>5
	Comment = varargin{4};
	if  ~isempty(Comment) & ~ischar(Comment)
		error(['[WriteCsv] Comment must be a text string.']);
	end
end
%%%%% Option Verification %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Options = [0 0 0 0 0];
for v=7:VN
	if ischar(varargin{v-2})
		if strcmp(varargin{v-2},'-overwrite')
			Options(1) = 1;
		elseif strcmp(varargin{v-2},'-append')
			Options(2) = 1;
		elseif strcmp(varargin{v-2},'-unix')
			Options(3) = 1;
		elseif strcmp(varargin{v-2},'-win')
			Options(4) = 1;
		elseif strcmp(varargin{v-2},'-mac')
			Options(5) = 1;
		end
	end
end
if sum(Options(1:2))>1
	error(['[WriteCsv] Options ''-overwrite'' and ''-append'' cannot be used at the same time.']);
end
if sum(Options(3:5))>1
	error(['[WriteCsv] Please specify one of ''-unix'', ''-win'', and ''-mac''.']);
elseif sum(Options(3:5))==0
	ReturnCode = '\n'; % default value
else
	ReturnCode = ReturnCode{find(Options(3:5))}; % using a return code specified by the option
end
% overwriting confirmation
if exist(FileName)~=0 % if file exists
	FilePresence = 1;
	if sum(Options(1:2))==0 % if user have not specified neither '-overwrite' nor '-append'
		tmp = [''];
		while 1
			tmp = input(['  [WriteCsv] File ' FileName ' already exists. Are you sure to overwrite it? [y/n]'],'s'); % yes_or_no is unavailable for old MATLAB
			if strcmp(tmp,'y')
				Options(1) = 1; break;
			elseif strcmp(tmp,'n')
				Options(1) = 0; break;
			end
		end
		if Options(1)==0
			disp('  [WriteCsv] ...okay, nothing done.');
			return;
		end
	end
else
	FilePresence = 0;
end

%%%%% Data Conversion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DataCell = cell(RowN, ColN);
FormatSpec = ['']; tmp = [];
for c=1:ColN
	% Converting data (numeric values) into cell array
	if c>length(Levels) % Levels has no entry for column c. Column c is for data.
		DataCell(:,c) = num2cell(Data(:,c)); % convert the column into cell array
		if sum(round(Data(:,c))~=Data(:,c))>0 % contains values not integer
			FormatSpec = [FormatSpec '%.12f' Delim];
		else
			FormatSpec = [FormatSpec '%g' Delim]; % integers only. will omit '.000000'
		end
	elseif isempty(Levels{c}) % Levels has empty data for columns c. Column c is for data.
		DataCell(:,c) = num2cell(Data(:,c)); % convert the column into cell array
		if sum(round(Data(:,c))~=Data(:,c))>0 % contains values not integer
			FormatSpec = [FormatSpec '%.12f' Delim];
		else
			FormatSpec = [FormatSpec '%g' Delim]; % integers only. will omit '.000000'
		end
	% Processing the parameter Levels
	else % Levels has entry for Column c. Column c is for factor, not for data.
		% Levels{c} is like 'subject%n'
		tmp = [];
		if (~iscell(Levels{c}) & ischar(Levels{c})) % if Levels{c} is not cell array but a text string,
			Levels{c} = {Levels{c}}; % put the text string into 1x1 cell array.
		end
		if length(Levels{c})==1 && ischar(Levels{c}{1}) % if Levels{c} is a single text string
			Ni = strfind(Levels{c}{1},'%n');
			if ~isempty(Ni) % and if there is '%n' in Levels{c}{1}
				tmpN = cellstr(num2str(Data(:,c),'%-g'));
				tmpSP = num2cell(char(ones(RowN,1) * ' ')); % RowN x 1 cell array of space characters
				Ni = [-1 Ni];
				for n=1:(length(Ni)-1)
					Tok = Levels{c}{1}((Ni(n)+2):(Ni(n+1)-1));
					if ~isempty(Tok)
						tmp = strcat(tmp,cellstr(char(ones(RowN,1)*Tok)));
					end
					for sp=1:(length(Tok)-length(deblank(Tok)))
						tmp = strcat(tmp,tmpSP); % since cellstr removes spaces at the end of the line, add spaces (if any) manually
					end
					tmp = strcat(tmp,tmpN);
				end
				if length(Levels{c}{1}) > (Ni(end)+1) % there is a string after the last '%n'
					Tok = Levels{c}{1}((Ni(end)+2):end);
					tmp = strcat(tmp,cellstr(char(ones(RowN,1)*Tok)));
					for sp=1:(length(Tok)-length(deblank(Tok)))
						tmp = strcat(tmp,tmpSP); % since cellstr removes spaces at the end of the line, add spaces (if any) manually
					end
				end
				DataCell(:,c) = tmp;
			end
		end
		% Levels{c} is like {'Level1name' 'Level2name', ...}
		if isempty(tmp)
			if prod(size(Levels{c})) ~= length(Levels{c}) % if Levels{c} is not 1 x N cell array
				error(['  [WriteCsv]  Levels{' num2str(c) '} is not a 1-dimensional cell array.']);
			elseif min(Data(:,c))<1
				error(['  [WriteCsv]  Column ' num2str(c) ': Please speficy 1 or larger integer as level index.']);
			elseif max(Data(:,c)) > length(Levels{c})
				error(['  [WriteCsv]  Column ' num2str(c) ': Level index exceeds the length of Levels{' num2str(c) '}.']);
			elseif sum(round(Data(:,c))~=Data(:,c))>0 % if Data(:,c) contains values not integer
				error(['  [WriteCsv]  Column ' num2str(c) ': Level index must be positive integer.']);
			end
			tmpSP = cell(length(Levels{c}),1);
			for n=1:length(Levels{c})
				if isempty(Levels{c}{n}) % if empty is specified as level name
					Levels{c}{n} = num2str(n); % preserve the values of Data(:,c)
				end
				for sp=1:(length(Levels{c}{n})-length(deblank(Levels{c}{n}))) % making a cell array of spaces
					tmpSP{n} = [tmpSP{n} ' '];
				end
			end
			LevelIndex = Data(:,c);
			DataCell(:,c) = cellstr(strvcat(Levels{c}{LevelIndex})); % replace the numbers with level names
			DataCell(:,c) = strcat(DataCell(:,c),tmpSP{LevelIndex}); % since cellstr removes spaces at the end of the line, add spaces (if any) manually
		end
		FormatSpec = [FormatSpec '%s' Delim];
	end
end
FormatSpec = FormatSpec(1:(length(FormatSpec) - length(Delim))); % removing Delim at the end of the line
FormatSpec = [FormatSpec ReturnCode];

% File open.
% If the file is opened with text mode (e.g., fopen(FileName,'wt') ), local OS's default return code will be used.
% To control return code by options, open the file with binary mode (e.g., fopen(FileName,'w') ).
tmp = [];
if FilePresence==0
	fid = fopen(FileName,'w'); % create a file in writing mode
	tmp = 1; % this will be copied to Report
elseif Options(1)==1 && FilePresence==1 % if '-overrite' is specified (or overwriting is allowed by user) and file already exists
	fid = fopen(FileName,'w'); % open the file in writing mode
	tmp = 2; % this will be copied to Report
elseif Options(2)==1 && FilePresence==1 % if '-append' is specified and file already exists
	fid = fopen(FileName,'a'); % open the file in appending mode
	tmp = 3; % this will be copied to Report
end

% Processing the parameter Comment
if ~isempty(Comment)
	fprintf(fid,['%s' ReturnCode],Comment); % writing the comment line (if any)
	Report = tmp;
end
% Processing the parameter ColNames
if ~isempty(ColNames)
	HeaderFormatSpec = [];
	for c=1:length(ColNames)
		HeaderFormatSpec = [HeaderFormatSpec '%s' Delim];
	end
	HeaderFormatSpec = HeaderFormatSpec(1:(length(HeaderFormatSpec) - length(Delim))); % removing Delim at the end of the line
	HeaderFormatSpec = [HeaderFormatSpec ReturnCode];
	fprintf(fid,HeaderFormatSpec,ColNames{:}); % writing the header line i.e., ColNames (if any)
	Report = tmp;
end
% Write DataCell on the file
for c=1:RowN	
	fprintf(fid,FormatSpec,DataCell{c,:});
	Report = tmp;
end
fclose(fid);

