% this is used to disaggregate future monthly precip to daily precip by optimizing the quantiles of precip 
% 0_ (p1)_ _ _1 _ _(p2) _ _ 5 _ _(p3) _ _ 15 _ _(p4) _ _30 _ _ _ _ _50 (>50)

function [out] = monthly_to_daily_disaggregation_opt_k(GCM_forecast_input,monthly_observation,daily_observation,flag)
% index 0---precip, 1--t_max, 2--t_min

N=100;
K=2; %Make changes here if need optimized K - TS
%K= Find_K(monthly_observation,daily_observation,flag); % if no semi-column used, K will be displayed as the optimum K
s=monthly_observation;
Q_monthly_data = monthly_observation;
Q_daily_data=daily_observation;
monthly_forecast = GCM_forecast_input;
    
for i=1:length(GCM_forecast_input)
       monthly_forecast_mean = monthly_forecast(i);
       %s(i)= monthly_forecast_mean;
    % abstract the corresponding row as candidate month
        comparable_month=s(:,:);
    % use 1:year_length as an index for this month
        comparable_month(2,:)=1:length(s);
    % leave one cross out
        %comparable_month(:,i)=[];
        b= comparable_month(2,:);
        Q_information =  Rank_Q(comparable_month(1,:)', monthly_forecast_mean, K, N);
     
     % get the index of the choosing year
        
       for k = 1:K
           temp=b(comparable_month(1,:)==Q_information(k));
           x(k,1)=temp(1);
       end
       
    % get the corresponding probability of choosing years
        x(:,2)= Q_information(:,5);
       
    % abstract the corresponding monthly value of the specific season from original data
       B=Q_daily_data(:,x(:,1));
       Prob = sum(B,2)/sum(sum(B,2));
    %B not being used later, this part
       
    % calculate the frequency for each selected year
       T(:,1)=x(:,1);
       T(:,2)=Q_information(:,4);
       S=discrete_sample(T,N);

       for ii=1:length(S)
           Y_star = Q_daily_data(:,S(ii));
           if (flag==0)
                for k = 1:length(daily_observation(:,1))
                   X_sim(k) = Y_star(k)+(monthly_forecast_mean-sum(Y_star)).*Prob(k);
                end
               X_sim(X_sim<0)=0;
           else
               X_sim = Y_star;
           end
           X_final_matrix(:,ii)=X_sim;
       end
       
       out(:,i) = mean(X_final_matrix,2);

       
end
    
