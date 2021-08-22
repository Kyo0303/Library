clear 
clc

filelist=dir('*.csv');
if (isempty(filelist)==1)
  f msgbox('operation failed')
else
  filelist=struct2cell(filelist);
  filelist=filelist(1,:) %display filelist
  
  %input data format
  %caution:empty column can't counted
    offset=21 %start_measdata_column
    ch_num=5  %channel number
    index_length=9 %meas_length_column
    index_samptime=8 %samplingtime_column
    %index_sampfreq=    
    
    
  for N = [1:1:max(size(filelist))]
    file = char(filelist(1,N));
    filename = [file]
    data = csvread(filename);
    %text = strsplit(fileread(N_filename));
    length=data(index_length,2);
    timestep=data(index_samptime,2);
    
    time = linspace(0,timestep*length,length);
    data = data(offset:end,1:ch_num);
    data = [time;data']';
    
    thr = 7 %threshold for binary
    ave_point=64 %average sample number
    ttt = ave_point*timestep*10^6
    BW=double(data(:,3)>thr);
    
    for M =[ave_point:1:length]
##      dd=BW(aaa-15:aaa);
##      sum_BW = sum(dd);
##      sz_BW=size(dd,1);
##      ave=sum_BW/sz_BW
      ave=floor(mean(BW(M-ave_point+1:M)));
      ref(M)=ave;
##      if ave < thr 
##        BW(aaa)=0;
##      else
##        BW(aaa)=1;
##      end
    end
    
    for i = [1:1:4]
      color= ['k','b','r','g'];
      str = {'ch1', 'ch2', 'ch3', 'ch4'};
      subplot(2,3,i)
      p=plot(data(:,1),data(:,i+2),color(i));
      title(str(i));
    end
      subplot(2,3,5);
      p=plot(data(:,1),ref);
      ylim([-1 2]);
      title('REF');
     
    [ch1_max_value{N}, ch1_max_index{N}]=max(data(:,3));
    ch1_max_time{N}=data(ch1_max_index{N},1);
    [ch2_max_value{N}, ch2_max_index{N}]=max(data(:,4));
    ch2_max_time{N}=data(ch2_max_index{N},1);
    [ch3_max_value{N}, ch3_max_index{N}]=max(data(:,5));
    ch3_max_time{N}=data(ch3_max_index{N},1);
    [ch4_max_value{N}, ch4_max_index{N}]=max(data(:,6));
    ch4_max_time{N}=data(ch4_max_index{N},1);
    
  end
  ans=[ch1_max_index;ch2_max_time;ch2_max_value]'
  %output = cell2mat([]);
  %csvwrite('output.csv',output)
  f=msgbox('completed');  
end %for\•¶(j)—p