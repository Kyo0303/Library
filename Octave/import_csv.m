clear 
clc

%https://rnpsychology.org/others/WriteCsv.htm

filelist=dir('*.csv');
if (isempty(filelist)==1)
  hoge= msgbox('operation failed')
else
  filelist=struct2cell(filelist);
  filelist=filelist(1,:) %display filelist
  
  %input data format
  %caution:empty column can't counted
    offset=21 %start_measdata_column
    ch_num=5  %channel number
    index_length=9 %meas_length_column
    index_samptime=8 %samplingtime_column
    ch1_on=20
    ch1_off=-4
    thr = 15 %threshold for binary
    ave_point=255 %ODD NUMBER (average sample number)
    %index_sampfreq=    
    
h = waitbar(0,'running');
t = 0;
    
  for N = [1:1:max(size(filelist))]


    waitbar(N/max(size(filelist)))
    t = t + 1;

    clear time data trig ref
    
    file = char(filelist(1,N));
    filename{N} = [file];
    data = csvread(filename{N});
    %text = strsplit(fileread(N_filename));
    length=data(index_length,2);
    timestep=data(index_samptime,2);
    
    time = linspace(0,timestep*length,length);
    data = data(offset:end,1:ch_num);
    data = [time;data']';

    
    HL=double(data(:,3)>thr);

    ref(length)=0;  
    trig(length)=0;    
    
    for M =[1+(ave_point-1)/2:1:length-(ave_point-1)/2]
      ave=floor(mean(HL(M-(ave_point-1)/2:M+(ave_point-1)/2))); %If Value=1 for ave-point times, output=1.
      ref(M)=ave;
        if ref(M-1)~=ave %Two consecutive numbers have different values
            trig(M)=1;
        else
            trig(M)=0;
        end      
    end
    clear HL
##       trig1=find(trig==1) %[L-SW]____|*----|*____|*----|*____
##       trig1_sz=size(trig1',1)
##       ideal_trig=4 % numbers of *position
##       if trig1_sz ~= ideal_trig %Avoid false positives due to noise
##          f=msgbox('error : please change thr or ave-point ');
##          stop
##       else
##       end      
 
       %trig2 : search *position [L-SW]____|--*--|__*__|--*--|____       
       trig2=round(movmean(find(trig==1),2))(1,2:end);
       ideal_trig=3 ;% numbers of *position
       if size(trig2',1) ~= ideal_trig %Avoid false positives due to noise
          f=msgbox('error : please change thr or ave-point ');
          stop
       else
          %go!
       end
#####graph######
## 
##    for i = [1:1:4]
##      color= ['k','b','r','g'];
##      str = {'ch1', 'ch2', 'ch3', 'ch4'};
##      subplot(2,3,i)
##      p=plot(data(:,1),data(:,i+2),color(i));
##      title(str(i));
##    end
##      subplot(2,3,5);
##      p=plot(data(:,1),ref);
##      ylim([-1 2]);
##      title('REF');
##      
##      subplot(2,3,6);
##      p=plot(data(:,1),trig);
##      ylim([-1 2]);
##      title('trig');
#######graph######
    
    [ch1_max_value{N}, ch1_max_index{N}]=max(data(:,3));
    ch1_max_time{N}=data(ch1_max_index{N},1);
    ch1_90pct_fall_index{N}=min(find(data(trig2(1):trig2(2),3)<0.9*ch1_on))+trig2(1)-1;
    ch1_10pct_fall_index{N}=min(find(data(trig2(1):trig2(2),3)<0.1*ch1_on))+trig2(1)-1;
    ch1_10pct_rise_index{N}=min(find(data(trig2(2):trig2(3),3)>0.1*ch1_on))+trig2(2)-1;
    ch1_90pct_rise_index{N}=min(find(data(trig2(2):trig2(3),3)>0.9*ch1_on))+trig2(2)-1;
    format shortE
    p1{N}=data(ch1_90pct_fall_index{N},1);
    p2{N}=data(ch1_10pct_fall_index{N},1);
    p3{N}=data(ch1_10pct_rise_index{N},1);
    p4{N}=data(ch1_90pct_rise_index{N},1);
    ch1_tf{N}=(ch1_10pct_fall_index{N}-ch1_90pct_fall_index{N})*timestep;
    ch1_fall_dvdt{N}=(data(ch1_10pct_fall_index{N},3)-data(ch1_90pct_fall_index{N},3))/ch1_tf{N};
    ch1_tr{N}=(ch1_90pct_rise_index{N}-ch1_10pct_rise_index{N})*timestep;
    ch1_rise_dvdt{N}=(data(ch1_90pct_rise_index{N},3)-data(ch1_10pct_rise_index{N},3))/ch1_tf{N};
    INTEGRATE{N}=trapz(data(ch1_90pct_fall_index{N}:ch1_10pct_fall_index{N},3))*timestep;
    format short
    
    [ch2_max_value{N}, ch2_max_index{N}]=max(data(:,4));
    ch2_max_time{N}=data(ch2_max_index{N},1);
    [ch3_max_value{N}, ch3_max_index{N}]=max(data(:,5));
    ch3_max_time{N}=data(ch3_max_index{N},1);
    [ch4_max_value{N}, ch4_max_index{N}]=max(data(:,6));
    ch4_max_time{N}=data(ch4_max_index{N},1);
    
  end   
close(h)
  ####save variable setting####
variable_name={...
    'ch1_max_value';...
    'ch1_max_index';...
    'ch1_max_time';...
    'ch1_90pct_fall_index';...
    'ch1_10pct_fall_index';...
    'ch1_10pct_rise_index';...
    'ch1_90pct_rise_index';...
    'p1';...
    'p2';...
    'p3';...
    'p4';...
    'ch1_tf';...
    'ch1_fall_dvdt';...
    'ch1_tr';...
    'ch1_rise_dvdt';...
    'INTEGRATE';...
    'ch2_max_value';...
    'ch2_max_index';...
    'ch2_max_time';...
    'ch3_max_value';...
    'ch3_max_index';...
    'ch3_max_time';...
    'ch4_max_value';...
    'ch4_max_index';...
    'ch4_max_time'};
  
variable_data=[...
    ch1_max_value;...
    ch1_max_index;...
    ch1_max_time;...
    ch1_90pct_fall_index;...
    ch1_10pct_fall_index;...
    ch1_10pct_rise_index;...
    ch1_90pct_rise_index;...
    p1;...
    p2;...
    p3;...
    p4;...
    ch1_tf;...
    ch1_fall_dvdt;...
    ch1_tr;...
    ch1_rise_dvdt;...
    INTEGRATE;...
    ch2_max_value;...
    ch2_max_index;...
    ch2_max_time;...
    ch3_max_value;...
    ch3_max_index;...
    ch3_max_time;...
    ch4_max_value;...
    ch4_max_index;...
    ch4_max_time];

  output = 'output.txt';
  logdata = 'logdata.txt'
  diary logdata 
  [Report,DataCell] = WriteCsv(output,cell2mat(variable_data'),',',[],variable_name,[],['-overwrite']);
  hoge=msgbox('completed');  
end