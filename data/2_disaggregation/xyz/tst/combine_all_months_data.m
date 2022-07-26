function out = combine_all_months_data(start_year,precip_Jan,precip_Feb,precip_Mar,precip_Apr,precip_May,precip_Jun,precip_Jul,precip_Aug,precip_Sep,precip_Oct,precip_Nov,precip_Dec)
%function       out = combine_all_months_data(start_year,precip_Jan,precip_Feb)
       start_length = 1;
       [l m]=size(precip_Jan);
       for i=1:m
           
           if isleap(start_year+i-1)==0
              out(start_length:start_length+31-1)=precip_Jan(:,i);
              start_length = start_length+31;
              out(start_length:start_length+28-1)=precip_Feb(:,i);
              start_length = start_length+28;
              out(start_length:start_length+31-1)=precip_Mar(:,i);
              start_length = start_length+31;
              out(start_length:start_length+30-1)=precip_Apr(:,i);
              start_length = start_length+30;
              out(start_length:start_length+31-1)=precip_May(:,i);
              start_length = start_length+31;
              out(start_length:start_length+30-1)=precip_Jun(:,i);
              start_length = start_length+30;
              out(start_length:start_length+31-1)=precip_Jul(:,i);
              start_length = start_length+31;
              out(start_length:start_length+31-1)=precip_Aug(:,i);
              start_length = start_length+31;
              out(start_length:start_length+30-1)=precip_Sep(:,i);
              start_length = start_length+30;
              out(start_length:start_length+31-1)=precip_Oct(:,i);
              start_length = start_length+31;
              out(start_length:start_length+30-1)=precip_Nov(:,i);
              start_length = start_length+30;
              out(start_length:start_length+31-1)=precip_Dec(:,i);
              start_length = start_length+31;
          else
              out(start_length:start_length+31-1)=precip_Jan(:,i);
              start_length = start_length+31;
              out(start_length:start_length+28-1)=precip_Feb(:,i);
              out(start_length+28)= 0;
              start_length = start_length+29;
              out(start_length:start_length+31-1)=precip_Mar(:,i);
              start_length = start_length+31;
              out(start_length:start_length+30-1)=precip_Apr(:,i);
              start_length = start_length+30;
              out(start_length:start_length+31-1)=precip_May(:,i);
              start_length = start_length+31;
              out(start_length:start_length+30-1)=precip_Jun(:,i);
              start_length = start_length+30;
              out(start_length:start_length+31-1)=precip_Jul(:,i);
              start_length = start_length+31;
              out(start_length:start_length+31-1)=precip_Aug(:,i);
              start_length = start_length+31;
              out(start_length:start_length+30-1)=precip_Sep(:,i);
              start_length = start_length+30;
              out(start_length:start_length+31-1)=precip_Oct(:,i);
              start_length = start_length+31;
              out(start_length:start_length+30-1)=precip_Nov(:,i);
              start_length = start_length+30;
              out(start_length:start_length+31-1)=precip_Dec(:,i);
              start_length = start_length+31;
               
               
           end
           
           
       end
       