function [m_1,m_2,m_3,m_4,m_5,m_6,m_7,m_8,m_9,m_10,m_11,m_12,d_1,d_2,d_3,d_4,d_5,d_6,d_7,d_8,d_9,d_10,d_11,d_12,long_series] = read_data(filename,flag)
input_data = importdata(filename); % read the four column of data into a variable
  
   if (flag==1) % first column for precip
    precip = input_data(:,1);
   elseif (flag==2) % second column for max temperature
    precip = input_data(:,2);
   elseif (flag == 3) % 3rd column for min temperature
    precip = input_data(:,3);
   end
   
   long_series = precip;
%    disp(length(precip))
    A = cell(50,1);
    A{1} = precip(1:365); % starting year 1961 is a non-leap year
    start_id  = length(A{1});
    for i = 2:50
        i;
        y = isleap(1960+i);
%    disp(sprintf('%d , %d',1960+i,y));   
    %  disp(y);

        if y == 0
           A{i}=precip(start_id+1:start_id +1+364);
           start_id = start_id + length(A{i});
        else
          A{i}=precip(start_id+1:start_id +1+365);
          start_id = start_id + length(A{i});
        end
    end
            
    % A{50}=precip(start_id +1:end); % for the year 2000, only 7 months data is available
    
    % take the last value of Feb out, for leap years
    for i=1:50
        % disp(sprintf('%d , %d',i,length(A{i})))
        if length(A{i})==366
           A{i}(60)=[];
        end
    end
    
    % A{50}(60)=[];
    % disp((A{50}))
    for i = 1:50
        Precipitation_Jan_matrix(:,i)=A{i}(1:31);
    end
    
       
    for i = 1:50
        Precipitation_Feb_matrix(:,i)=A{i}(32:59);
    end
    
        
    for i = 1:50
        Precipitation_Mar_matrix(:,i)=A{i}(60:90);
    end
    
        
    for i = 1:50
        Precipitation_Apr_matrix(:,i)=A{i}(91:120);
    end
    
        
    for i = 1:50
        Precipitation_May_matrix(:,i)=A{i}(121:151);
    end
    
        
    for i = 1:50
        Precipitation_Jun_matrix(:,i)=A{i}(152:181);
    end
    
    
        
    for i = 1:50
        Precipitation_Jul_matrix(:,i)=A{i}(182:212);
    end
    
    
        
    for i = 1:50
        Precipitation_Aug_matrix(:,i)=A{i}(213:243);
    end
    
        
    for i = 1:50
        Precipitation_Sep_matrix(:,i)=A{i}(244:273);
    end
    
        
    for i = 1:50
        Precipitation_Oct_matrix(:,i)=A{i}(274:304);
    end
    
        
    for i = 1:50
        Precipitation_Nov_matrix(:,i)=A{i}(305:334);
    end
    
        
    for i = 1:50
        Precipitation_Dec_matrix(:,i)=A{i}(335:365);
    end
    
    
   m_1 = sum(Precipitation_Jan_matrix);
   m_2= sum(Precipitation_Feb_matrix);
   m_3 = sum(Precipitation_Mar_matrix);
   m_4 = sum(Precipitation_Apr_matrix);
   m_5 = sum(Precipitation_May_matrix);
   m_6 = sum(Precipitation_Jun_matrix);
   m_7 = sum(Precipitation_Jul_matrix);
   m_8 = sum(Precipitation_Aug_matrix);
   m_9 = sum(Precipitation_Sep_matrix);
   m_10 = sum(Precipitation_Oct_matrix);
   m_11 = sum(Precipitation_Nov_matrix);
   m_12 = sum(Precipitation_Dec_matrix);
   
   d_1 = Precipitation_Jan_matrix;
   d_2= Precipitation_Feb_matrix;
   d_3 = Precipitation_Mar_matrix;
   d_4 = Precipitation_Apr_matrix;
   d_5 = Precipitation_May_matrix;
   d_6 = Precipitation_Jun_matrix;
   d_7 = Precipitation_Jul_matrix;
   d_8 = Precipitation_Aug_matrix;
   d_9 = Precipitation_Sep_matrix;
   d_10 = Precipitation_Oct_matrix;
   d_11 = Precipitation_Nov_matrix;
   d_12 = Precipitation_Dec_matrix;
    
fclose('all');

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
