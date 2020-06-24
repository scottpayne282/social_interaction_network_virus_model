

%% load saved data and create virus curve profiles for each simulation
load('simulation_April20_friendsonly_default.mat')
[curves1] = virus_curves(day);
load('simulation_April20_friendsonly_default_repeat.mat')
[curves2] = virus_curves(day2);
load('simulation_April20_friendsonly_default_repeat2.mat')
[curves3] = virus_curves(day2);
load('simulation_April20_friendsonly_default_repeat3.mat')
[curves4] = virus_curves(day2);
%% view curves for number infected per day
figure('Position',[488.2000 103.4000 903.2000 658.4000]);
ds1 = size(curves1,2);
ds2 = size(curves2,2);
ds3 = size(curves3,2);
ds4 = size(curves4,2);
plot(1:ds1,curves1(3,:));
hold on
plot(1:ds2,curves2(3,:));
plot(1:ds3,curves3(3,:));
plot(1:ds4,curves4(3,:));
hold off
title('number infected by day')
legend({'simulation1','simulation2','simulation3','simulation4'})
%% view curves for number severe per day
figure('Position',[488.2000 103.4000 903.2000 658.4000]);
ds1 = size(curves1,2);
ds2 = size(curves2,2);
ds3 = size(curves3,2);
ds4 = size(curves4,2);
plot(1:ds1,curves1(4,:));
hold on
plot(1:ds2,curves2(4,:));
plot(1:ds3,curves3(4,:));
plot(1:ds4,curves4(4,:));
hold off
title('number severe by day')
legend({'simulation1','simulation2','simulation3','simulation4'})


