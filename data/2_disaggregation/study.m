function  []=study(output_folder)

longitude_start = -85.4375;
latitude_start = 30.3125;
longitude_end = -83.6875;
latitude_end = 34.3125;

%longitude_start = -85.4375;
%latitude_start = 31.3125;
%longitude_end = -83.6875;
%latitude_end = 31.3125;

%longitude_start = -84.4375;
%latitude_start = 31.4375;
%longitude_end = -84.4375;
%latitude_end = 31.4375;

longitude_start = -84.9375;
latitude_start = 30.9375;
longitude_end = -84.9375;
latitude_end = 30.9375;


longitude_series = longitude_start; %:0.125:longitude_end;
latitude_series = latitude_start; %: 0.125 : latitude_end;

K=30;
N=100;
start_year = 1950;

new_folder = "X_output";
% mkdir(new_folder);
% disp(length(latitude_series));
for i = 1:length(latitude_series)
    for j = 1:length(longitude_series)
        lat_temp = latitude_series(i);
        long_temp = longitude_series(j);
        % filename = strcat('X_input_data_','data_',num2str(lat_temp),'_',num2str(long_temp)); % on unix and windows,\ or / is different
        filename = "X_input_data_data_30.9375_-84.9375";
% disp(filename);
        % judge = fopen(filename);
        % if (judge == -1)
% disp("filename_out_prcp");
           % do nothing
           
        % else
            % read data of observed precip, max temp and min temp
            [m_1,m_2,m_3,m_4,m_5,m_6,m_7,m_8,m_9,m_10,m_11,m_12,d_1,d_2,d_3,d_4,d_5,d_6,d_7,d_8,d_9,d_10,d_11,d_12,long_series_prcp] = read_data(filename,1);
            % [m_1_tmax,m_2_tmax,m_3_tmax,m_4_tmax,m_5_tmax,m_6_tmax,m_7_tmax,m_8_tmax,m_9_tmax,m_10_tmax,m_11_tmax,m_12_tmax,d_1_tmax,d_2_tmax,d_3_tmax,d_4_tmax,d_5_tmax,d_6_tmax,d_7_tmax,d_8_tmax,d_9_tmax,d_10_tmax,d_11_tmax,d_12_tmax,long_series_tmax] = read_data(filename,2);
            % [m_1_tmin,m_2_tmin,m_3_tmin,m_4_tmin,m_5_tmin,m_6_tmin,m_7_tmin,m_8_tmin,m_9_tmin,m_10_tmin,m_11_tmin,m_12_tmin,d_1_tmin,d_2_tmin,d_3_tmin,d_4_tmin,d_5_tmin,d_6_tmin,d_7_tmin,d_8_tmin,d_9_tmin,d_10_tmin,d_11_tmin,d_12_tmin,long_series_tmin] = read_data(filename,3);
            
            % preprocess tmax and tmin to get tavg for that month, 
            % m_1_tavg = (m_1_tmax + m_1_tmin)/2;
            % m_2_tavg = (m_2_tmax + m_2_tmin)/2;
            % m_3_tavg = (m_3_tmax + m_3_tmin)/2;
            % m_4_tavg = (m_4_tmax + m_4_tmin)/2;
            % m_5_tavg = (m_5_tmax + m_5_tmin)/2;
            % m_6_tavg = (m_6_tmax + m_6_tmin)/2;
            % m_7_tavg = (m_7_tmax + m_7_tmin)/2;
            % m_8_tavg = (m_8_tmax + m_8_tmin)/2;
            % m_9_tavg = (m_9_tmax + m_9_tmin)/2;
            % m_10_tavg = (m_10_tmax + m_10_tmin)/2;
            % m_11_tavg = (m_11_tmax + m_11_tmin)/2;
            % m_12_tavg = (m_12_tmax + m_12_tmin)/2;
            
             % extract data of monthly forecast
            L = (longitude_series(j)-(-124.6875))/0.125 + 1;
            M = (latitude_series(i)-(25.1875))/0.125 + 1;
            
            %[precip temp]= read_GCM_data(L,M,GCM_precip_scenario,GCM_tmp_scenario); % write a function to read precip and temp data and organize it as needed
            % disaggregate for the first 50 years, for temperature
            % filename = strcat('X_monthly_input_','data_',num2str(lat_temp),'_',num2str(long_temp)); % on unix and windows,\ or / is different
            filename = "X_monthly_input_data_30.9375_-84.9375"; % on unix and windows,\ or / is different
            precip = importdata(filename);
            precip_Jan = monthly_to_daily_disaggregation_opt_k(precip(1:50,1),m_1,d_1,0);
            precip_Feb = monthly_to_daily_disaggregation_opt_k(precip(1:50,2),m_2,d_2,0);
            precip_Mar = monthly_to_daily_disaggregation_opt_k(precip(1:50,3),m_3,d_3,0);
            precip_Apr = monthly_to_daily_disaggregation_opt_k(precip(1:50,4),m_4,d_4,0);
            precip_May = monthly_to_daily_disaggregation_opt_k(precip(1:50,5),m_5,d_5,0);
            precip_Jun = monthly_to_daily_disaggregation_opt_k(precip(1:50,6),m_6,d_6,0);
            precip_Jul = monthly_to_daily_disaggregation_opt_k(precip(1:50,7),m_7,d_7,0);
            precip_Aug = monthly_to_daily_disaggregation_opt_k(precip(1:50,8),m_8,d_8,0);
            precip_Sep = monthly_to_daily_disaggregation_opt_k(precip(1:50,9),m_9,d_9,0);
            precip_Oct = monthly_to_daily_disaggregation_opt_k(precip(1:50,10),m_10,d_10,0);
            precip_Nov = monthly_to_daily_disaggregation_opt_k(precip(1:50,11),m_11,d_11,0);
            precip_Dec = monthly_to_daily_disaggregation_opt_k(precip(1:50,12),m_12,d_12,0);
            
            daily_precip_final = combine_all_months_data(start_year,precip_Jan,precip_Feb,precip_Mar,precip_Apr,precip_May,precip_Jun,precip_Jul,precip_Aug,precip_Sep,precip_Oct,precip_Nov,precip_Dec);

            %obtain date string
            date_string = obtain_date_string();
            
            % write to a file for precipitation
            filename_out_prcp = strcat(new_folder,'_','PRCP_',num2str(lat_temp),'_', num2str(long_temp));
            %filename_out_temp = strcat(new_folder,'\','TEMP_',num2str(lat_temp),'_', num2str(long_temp));
            
            fid = fopen(filename_out_prcp,'w');
            fprintf(fid,'%s         %s \n', 'DATE','PCP');
            for ii=1:length(date_string)
            fprintf(fid,'%s  %6.1f \n', date_string(ii,:),daily_precip_final(ii));
            end
            fclose(fid);

%         end
    end
end