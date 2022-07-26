function  Q_information =  Rank_Q(Q_data, Q_sim, K, N)
% K-NN resampling method, N is the simulation times of interest
% Dimension is the dimension, e.g 12 months
% Q_data is the original aggregated streamflow data
% Q_sim is the simulated value (of interest)

% Q_data here is the aggregated data e.g annual streamflor in thie example

Q_data(:,2)=Q_data;
% give an index to each element
Q_data(:,1)=1:length(Q_data);
% calculate the difference between simulated value and history data
Q_data(:,3)=Q_data(:,2)-Q_sim;
Q_data(:,3)=abs(Q_data(:,3));
[b,I]=sort(Q_data,1,'ascend');
% the minimum difference will be on the first row, which by means is rank 1
% Abstract the history data according to the Index
Q_information=Q_data(:,2);
series=I(1:K,3);
% K-NN are of interest
Q_information = Q_information(series);
Q_information(:,2) = 1:length(Q_information);
Q_information(:,3) = 1./Q_information(:,2);
Q_information(:,4) = Q_information(:,3)./sum(Q_information(:,3));
Q_information(:,5) = round(Q_information(:,4)*N);
return

