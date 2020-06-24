function [fig,bttns,hslide,cntctObs] = visualize_socialization_model(day,G,Comms,Y,meta_data)

% This function makes a figure that shows the social network, the 659
% "close friend" groups, and has an interactive slider that animates the
% simulation as the contacts and statuses change day by day. The slider
% allows the user to scroll easily back and forth.
%
% INPUTS:
%       day is the Matlab structure type variable that stored the
%       information about the simulation. So day(i).contacts is a Matlab
%       graph object recording the in-person contacts on day i. 
%
%       G is the 3826x3826 adjacency data of the social network (full format, not sparse array)
%
%       Comms is the 659x1 cell variable defining the friend groups, so
%       Comms{i} is a row array of the numeric labels of the individuals in
%       group i
%
%       Y is a 3826x2 array defining the x,y coordinates by which to plot
%       the nodes of the network diagram produced by this function
%
%       meta_data is a 3826x7 numeric array where row i encodes some
%       annonimized information about individual i such as classyear or
%       housing
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first we plot the social network, we use a lower alpha for between-group
% connections because the friend groups are not easy to see if all 
% connections in the network have the same alpha 
%
if issparse(G)
    G = full(G);
end
% This logical variable is useful to separate the connections into the two
% networks, on for in-group one for between-group
n = size(G,1);
sz = size(Comms,2);
L = false(n,n);
for ii = 1:sz
    labels = Comms{ii};
    L(labels,labels) = true;
end
%
fig = figure;
fig.Position = [203.4000 69 1.0904e+03 692.8000];
fig.Color = [1 1 1];
%
%
color1 = [0 0.447 0.741];
%% draw the between group edges
Gout = G;
Gout(L) = 0;
Gout=graph(Gout);
fout = plot(Gout,'Marker','none','NodeLabel',[]);
fout.XData = Y(:,1)';
fout.YData = Y(:,2)';
fout.EdgeColor = color1;
fout.EdgeAlpha = 0.01;
%% illustrate the groups
G0 = G;
G0(~L) = 0;
G0=graph(G0);
hold on
f0 = plot(G0,'Marker','none','NodeLabel',[]);
f0.XData = Y(:,1)';
f0.YData = Y(:,2)';
f0.EdgeColor = color1;
f0.EdgeAlpha = 0.2;
%% adjust the axis and clipping settings and add annotation
ax=fig.Children;
xlimz = [-32.9110658058788 40.7039150708126];
ylimz = [-17.8250608610579 40.2357869594294];
axis off
set(gca,'Clipping','off')
axis equal
ax.XLim = xlimz;
ax.YLim = ylimz;
dim = [.30 .48 .5 .3];
str = 'the social network';
ttl = annotation('textbox',dim,'String',str,'LineStyle','none','FontSize',18);
hold off
%% illustrate the class years
% we will actually start these with visibility set to off
class2009=find(meta_data(:,6)==2009)';
class2008=find(meta_data(:,6)==2008)';
class2007=find(meta_data(:,6)==2007)';
dcol9 = [0.9921 0.2666 0.2509];
dcol8 = [0  0.325490196078431  0];
dcol7 = [0.603921568627451  0.301960784313725  0.258823529411765];
% create storage for graphis object for class year labels in case we want
% to see them later
classyears = gobjects(3,2);
hold on
classyears(1,1) = plot(Y(class2009,1),Y(class2009,2),'o','MarkerEdgeColor',dcol9,'MarkerFaceColor',dcol9,'MarkerSize',2);
classyears(2,1) = plot(Y(class2008,1),Y(class2008,2),'o','MarkerEdgeColor',dcol8,'MarkerFaceColor',dcol8,'MarkerSize',2);
classyears(3,1) = plot(Y(class2007,1),Y(class2007,2),'o','MarkerEdgeColor',dcol7,'MarkerFaceColor',dcol7,'MarkerSize',2);
hold off
classLabelxy = zeros(3,2);
classLabelxy(1,:) = [-38.292265072788  21.2796602984913];
classLabelxy(2,:) = [-5.47883974647864   13.7136574663598];
classLabelxy(3,:) = [14.2585589460383   20.5395078475219];
classyears(1,2) = text(classLabelxy(1,1),classLabelxy(1,2),'class of `09','Color',dcol9,'FontSize',22);
classyears(2,2) = text(classLabelxy(2,1),classLabelxy(2,2),'class of `08','Color',dcol8,'FontSize',22);
classyears(3,2) = text(classLabelxy(3,1),classLabelxy(3,2),'class of `07','Color',dcol7,'FontSize',22);
classyears(1,1).Visible = 'off';
classyears(2,1).Visible = 'off';
classyears(3,1).Visible = 'off';
classyears(1,2).Visible = 'off';
classyears(2,2).Visible = 'off';
classyears(3,2).Visible = 'off';

%--------------------------------------------------------------------------
% add some buttons to toggle some info
bttns = gobjects(1,2);
bttns(1) = uicontrol('Style', 'pushbutton','Callback',{@toggle_classyears, ...
                classyears},...
                'String', 'class years', 'Position',[40 650 90 20]);
bttns(2) = uicontrol('Style', 'pushbutton','Callback',{@toggle_groups, ...
                fout},...
                'String', 'close friends', 'Position',[40 620 90 20]);

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% in this section we will plot all the daily contact network data from the
% simulation but set visibility off for each......when the user uses the
% slider the correct daily contact data will be displayed
numday = size(day,1); % <--this is the number of days in the simulation
% we use this function to create an array of that we can store graphics
% object handles to
cntctObs = gobjects(1,numday);
% set the current day to zero since the user has not used the slider yet
crrday = 0;
% this is a special color for the contacts plots
color3 = [ 0.0784313725490196   0.976470588235294  1];
% these are special colors for the virus status plots
yellow = [1  0.992156862745098  0];
blue = [0 0.458823529411765  0.874509803921569];
orange = [0.992156862745098   0.266666666666667  0.250980392156863];
red = [0.415686274509804  0.00392156862745098  0];
pink = [0.819607843137255   0.643137254901961  1];
green = [0  0.933333333333333  0.274509803921569];

hold on
for ii = 1:numday
    cntctObs(ii) = plot(day(ii).contacts,'Marker','none','NodeLabel',[]);
    cntctObs(ii).XData = Y(:,1)';
    cntctObs(ii).YData = Y(:,2)';
    cntctObs(ii).EdgeColor = color3;
    cntctObs(ii).EdgeAlpha = 0.3;
    cntctObs(ii).Visible = 'off';
end
hold off
%--------------------------------------------------------------------------

fig.UserData.crrday = crrday;
% create a slider object and a listener that triggers the makeplot function
hslide = uicontrol('style','slider','units','pixel','position',[60 10 960 15]);
addlistener(hslide,'ContinuousValueChange',@(hObject, event) ...
    doit(hObject,fig,numday,f0,fout,cntctObs));           

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               BELOW CALLED BY ABOVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function toggle_classyears(src,e,classyears)

dim1 = size(classyears,1);
dim2 = size(classyears,2);
for i = 1:dim1
    for j = 1:dim2
        state = classyears(i,j).Visible;
        if strcmp(state,'on')
            classyears(i,j).Visible = 'off';
        else
            classyears(i,j).Visible = 'on';
        end
    end
end
%--------------------------------------------------------------------------
function toggle_groups(src,e,fout)

if strcmp(fout.Visible,'on')
    fout.Visible = 'off';
else
    fout.Visible = 'on';
end
%--------------------------------------------------------------------------
function doit(hObject,fig,maxval,f0,fout,cntctObs)
% value of "t"
t = get(hObject,'Value');
t = round(t*maxval); %<-- in this we round so that the change of values
% is discrete and mapped to the interval [0,maxval]
if (t-fig.UserData.crrday) ~= 0
    % when the discrete value of t has changed we implement new visual
    if t~=0
        fig.Color = [0.2 0.2 0.2];
        f0.Visible = 'off';
        fout.Visible = 'off';
        prev = fig.UserData.crrday;
        if prev>0
            cntctObs(prev).Visible = 'off';
        end
        cntctObs(t).Visible = 'on';
    else
        fig.Color = [1 1 1];
        f0.Visible = 'on';
        fout.Visible = 'on';
        prev = fig.UserData.crrday;
        if prev>0
            cntctObs(prev).Visible = 'off';
        end
    end    
    fig.UserData.crrday = t;
end

