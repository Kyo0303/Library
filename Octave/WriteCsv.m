function [Report,DataCell] = WriteCsv(FileName,Data,varargin)
% 
% WriteCsv: 2次元行列データをテキストファイルに書き出し
%
% [Report,DataCell] = WriteCsv(FileName,Data,Delim,Levels,ColNames,Comment,[options])
% 
%    Report       ファイルに何も書き出さなければ0を、新規ファイルに書き出
%                 したら1を、既存ファイルを置き換えたら2を、既存ファイルに
%                 書き足したら3を出力します。
%    DataCell     Data の内容をセル配列に置き換えたものが出力されます。
%                 Levels が指定されていると、水準名に置き換えられています。
% 
%    FileName     出力先のファイル名（e.g., 'Data.csv'）。省略不可。
%    Data         データ（2次元行列）。省略不可。
%    Delim        区切り文字。タブは'\t'と指定して下さい。省略可。省略時は
%                 ','が使われます。
%    Levels       水準名の一覧（セル配列）。省略可。
%    ColNames     Dataの各列の名称。冒頭の行にこの内容を出力します。省略可。
%    Comment      コメント（文字列）。1行目にそのまま出力されます。省略可。
% 
%    以下のオプションを指定できます（省略可）：
%    '-overwrite' ファイル上書きの確認をせず、強制的に上書きします。
%    '-append'    既存のファイルの後に書き足します。
%    '-unix'      改行コードに LF を用います（Unix, MacOSX向け）。
%    '-win'       改行コードに CR+LF を用います（Windows向け）。
%    '-mac'       改行コードに CR を用います（MacOS9向け）。
%
%  2次元行列のデータ Data をテキストファイルに書き出します。たとえば、1列
%  目に要因1の水準、2列目に要因2の水準、3列目に測定値を記した下のようなデ
%  ータを考えます。
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
%  これに対して、 WriteCsv('Data.csv',Data) を実行すると、下のような内容
%  のテキストファイル Data.csv が出力されます。
% 
%     1,1,337.100000
%     1,1,460.200000
%        （中略）
%     2,3,493.100000
% 
%  区切り文字は Delim で指定できます。WriteCsv('Data.txt',Data,';') 
%  とすれば 
%
%     1;1;337.100000
%     1;1;460.200000
%        （中略）
%     2;3;493.100000
%
%  のようになります。タブは '\t' と指定して下さい。Delim が省略されるとカ
%  ンマが使われます。
%
%  引数 Levels で水準名の一覧を与えると、数値を水準名に置き換えられます。
%  Levels はセル配列です。Levels{N} は、Data のN列目に対応する水準名のセ
%  ル配列です。たとえば次のように水準名を指定します。
% 
%    Levels{1} = {'F','M'}                     % 要因1の水準名
%    Levels{2} = {'教示A','教示B','統制条件'}  % 要因2の水準名
% 
%  これで WriteCsv('Data.txt',Data,[],Levels) とすれば下のようになります。
%
%     F,教示A,337.100000
%     F,教示A,460.200000
%        （中略）
%     M,統制条件,493.100000
%
%  Data のうち、Levels で置き換える列の値は、自然数でなければなりません。
%  要因2だけ水準名に置き換え、要因1は置き換えない場合、Levels{1} に空 []
%  を指定してください。
%  
%  Levelsで、水準名の一覧のかわりに '%n' を含む文字列を1つだけ指定すると、
%  '%n' が Data 中の数値に置き換わった文字列を出力します。これは、被験者
%  番号を 'Subject1' のような文字列に置き換える場合に便利です。たとえば、
% 
%    Levels{1} = {'Subject%n'}                  % 被験者番号
%    Levels{2} = {'教示A','教示B','統制条件'}   % 要因の水準名
% 
%  とすると、下のような結果になります。
%
%     Subject1,教示A,337.100000
%     Subject1,教示A,460.200000
%        （中略）
%     Subject2,統制条件,493.100000
%
%  ColNames で列に見出しをつけられます。ColNames はセル配列です。たとえば
%
%     ColNames = {'性別','教示','反応時間(ms)'}
% 
%  として、WriteCsv('Data.txt',Data,[],[],ColNames) とすれば、
% 
%     性別,教示,反応時間(ms)
%     1,1,337.100000
%     1,1,460.200000
%        （中略）
%     2,3,493.100000
% 
%  のように、冒頭に見出しが加わります。見出しをつけたくない列に対しては、
%  空を指定して下さい。下の例では、2列目に見出しをつけません。
% 
%     ColNames = {'性別','','反応時間(ms)'}
% 
%  Comment に文字列を指定すると、その内容が１行目に出力されます。たとえば
% 
%     Comment = '# Experiment 1, 2015/09/01'
% 
%  として、WriteCsv('Data.txt',Data,[],[],[],Comment) とすれば、
% 
%     # Experiment 1, 2015/09/01
%     1,1,337.100000
%     1,1,460.200000
%        （中略）
%     2,3,493.100000
% 
%  のように、1行目にコメントが追加されます。'-append' が指定されている場
%  合、Comment や ColNames は書き足し部分の最初に出力されます。
% 
%  FileName で指定されたファイルがすでに存在する場合、上書きしてよいか確
%  認を求めます。y を入力すれば上書きし、n を入力すれば上書きせずに終了し
%  ます。オプション '-overwrite' を指定すると、この確認をしません。
% 
%  オプションは'-'で始まる文字列で指定します。指定する順序は任意です。
% 
%   '-overwrite' ファイルの上書き確認をせず、強制的に上書きします。
%   '-append'    FileNameで指定されたファイルが存在すれば、書き足します。
%                ファイルが存在しなければ、新規にファイルを作成します。
% 
%  改行コードを指定するには以下のオプションを使います（文字コードの変換は
%  行ないません）。下のいずれも指定しないと、LF が用いられます。
% 
%   '-unix'      改行コードに LF を用います（Unix, Mac OSX向け）。
%   '-win'       改行コードに CR+LF を用います。これは、出力されたファイ
%                ルをWindowsのメモ帳で開く場合などに便利です。
%   '-mac'       改行コードに CR を用います（Mac OS9向け）。
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

