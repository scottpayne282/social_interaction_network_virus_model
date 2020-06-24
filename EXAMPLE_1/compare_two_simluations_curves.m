
%%
load('simulation_April20_friendsonly_default.mat')
load('simulation_April20_randomizedversion_default.mat')
%%
[curves1] = virus_curves(day);
[curves2] = virus_curves(dayV2);
%%
% show infected curves
figure('Position',[488.2000 103.4000 903.2000 658.4000]);
ds1 = size(day,1);
ds2 = size(dayV2,1);
plot(1:ds1,curves1(3,:));
hold on
plot(1:ds2,curves2(3,:));
hold off
title('number infected by day')
legend({'simulation1','simulation2'})
%%
% show severely ill curves
figure('Position',[488.2000 103.4000 903.2000 658.4000]);
ds1 = size(day,1);
ds2 = size(dayV2,1);
plot(1:ds1,curves1(4,:));
hold on
plot(1:ds2,curves2(4,:));
hold off
title('number severe by day')  
legend({'simulation1','simulation2'})



