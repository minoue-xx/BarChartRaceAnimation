%% Bar Chart Rate Plot (Multi color version: multi bar objects)
% Copyright (c) 2020 Michio Inoue
close all
clear

%% Setup
generateGIF = false; % If you want to create gif file, change it to true;
filename = 'barChartRace.gif'; % Specify the output file name

% name of variables (変数名）
names = ["A","B","C","D","E"];
% names = ["A","B","C","D","E","F","G"];

% 色グループ：同じ色で棒を描く場合は同じグループ名を付けてください。
% groups = categorical(["group1","group1","group1","group1","group1"]);
groups = categorical(["group1","group2","group3","group4","group5"]);
% groups = categorical(["group1","group1","group2","group2","group3"]);


%% Create Sample Data
nItems = length(names); % Number of items 

% Some toy (time series) data set
maxT = 45;
time = 0:maxT;
x0 = 1:nItems; % Initial Value
data = zeros(length(time),length(x0));
rate = (nItems:-1:1)/100*2; % growth rate
data(1,:) = x0;
for ii=2:length(time)
    data(ii,:) = data(ii-1,:).*(1+rate);
end

%% Ranking of each variable (names) at each time step
rankings = zeros(size(data));
for ii=1:length(time)
    [~,tmp] = sort(data(ii,:),'descend');
    rankings(ii,tmp) = 1:nItems;
end

% Interpolation: Generate 10 data point in between
time2plot = linspace(0,maxT,length(time)*5);
ranking2plot = interp1(time,rankings,time2plot,'linear');
data2plot = interp1(time,data,time2plot,'linear');

% Plot of variables and the transition of their rankings
figure(1)
subplot(2,1,1)
plot(time,data,'LineWidth',2)
legend(names)
subplot(2,1,2)
plot(time2plot,ranking2plot,'LineWidth',2)
legend(names)

%% Let's create Bar Chart
handle_figure = figure(2);
handle_axes = gca;
hold(handle_axes,'on');
handle_axes.XGrid = 'on';
handle_axes.XMinorGrid = 'on';

% Some visual settings 
handle_axes.FontSize = 20;
handle_axes.YAxis.Direction = 'reverse'; % rank 1 needs to be on the top
handle_axes.YLim = [0, nItems+1];

defaultWidth = 0.8; % Default BarWidth

% Initial data (time = 1)
ranking = ranking2plot(1,:);
value2plot = data2plot(1,:);

% Find color groups
[cGroup,cID] = findgroups(groups);

% Divide dataset for each color
nColors = length(cID);
dataSet = cell(nColors,1);
for ii=1:nColors
    tmp = zeros(size(data2plot));
    tmp(:,cGroup == ii) = data2plot(:,cGroup == ii);
    dataSet{ii} = tmp;
end

% Create bar plot
barHandles = cell(nColors,1);
scaleWidth = min(diff(sort(ranking)));
for kk=1:nColors
    tmp = barh(ranking,dataSet{kk}(1,:));
    % Fix the BarWidth
    tmp.BarWidth = defaultWidth/scaleWidth;
    barHandles{kk} = tmp;
end

% Set YTick position by ranking
% Set YTickLabel with variable names
[ytickpos,idx] = sort(ranking,'ascend');
handle_axes.YTick = ytickpos;
handle_axes.YTickLabel = names(idx);

% Better to fix XLim
% Here I set maxValue time 1.5. (can be anything)
maxValue = max(value2plot);
handle_axes.XLim = [0, maxValue*1.5];

%% From the 2nd step and later
for ii=2:length(ranking2plot)
    
    ranking = ranking2plot(ii,:);
    value2plot = data2plot(ii,:);
    
    % barh gives an error if ranking has duplicate values
    % Thus skip it.
    if length(unique(ytickpos)) < nItems
        continue;
    end
    
    % Get the scale for BarWidth
    scaleWidth = min(diff(sort(ranking)));
    
    % Set to new data
    for kk=1:nColors
        tmp = barHandles{kk};
        % Fix the BarWidth
        tmp.BarWidth = defaultWidth/scaleWidth;
        tmp.XData = ranking;
        tmp.YData = dataSet{kk}(ii,:);
    end
    
    % Set YTick position by ranking
    % Set YTickLabel with variable names
    [ytickpos,idx] = sort(ranking,'ascend');
    handle_axes.YTick = ytickpos;
    handle_axes.YTickLabel = names(idx);
    
    % Better to fix XLim
    % Here I set maxValue time 1.5. (can be anything)
    maxValue = max(value2plot);
    handle_axes.XLim = [0, maxValue*1.5];
    
    if generateGIF
        frame = getframe(gcf); %#ok<UNRCH> % Figure 画面をムービーフレーム（構造体）としてキャプチャ
        tmp = frame2im(frame); % 画像に変更
        [A,map] = rgb2ind(tmp,256); % RGB -> インデックス画像に
        if ii == 2 % 新規 gif ファイル作成
            imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.05);
        else % 以降、画像をアペンド
            imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.05);
        end
    end
    
    pause(0.05)
end

hold(handle_axes,'off');