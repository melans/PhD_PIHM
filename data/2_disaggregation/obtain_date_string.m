function date_string = obtain_date_string()

%excel_date = 36526:55153; %datevalue from Jan,1st,2000 to Dec 31st, 2050
%excel_date = 18264:55153; %datevalue from Jan,1st,1950 to Dec 31st, 2050
%excel_date = 18264:36525; %for calibration
excel_date = 22282:40543; %for 1961-2010
date_matlab = x2mdate(excel_date,0);
date_string = datestr(date_matlab,'yyyy mm dd');
return
