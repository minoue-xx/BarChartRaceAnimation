function [handle_barplot,handle_dataplot] = barChartRace(inputs,options)
%BARCHARTRACE Bar chart race plot
%
%   BARCHARTRACE(X) draws the animation of the bar chart for each rows of X. 
%   X can be numeric array, table, or timetable.
%
%   [H1] = BARCHARTRACE(...) returns a handle (H1) to the figure with bar chart.
%
%   [H1,H2] = BARCHARTRACE(...) returns a handle (H2) to the figure with the data
%   details in addition to H1.
%
%   Use the following parameter name/value pairs to control the figure display.
%
%      'Time' - A vector (numeric or datetime) that represents the time for each raw of X. The
%             default is 1:size(X,1)
%
%      'LabelNames' - A cell or string vector of the variable names, each
%                   element corresponds to each columns of X. The default is
%                   "name" + string(1:size(X,2)) if X is a numeric array or the
%                   name of varialbes if X is a table or timetable.
%
%      'ColorGroups' - A cell or string vector of color group name. each
%                   element corresponds to each columns of X. The default is
%                   "name" + string(1:size(X,2)) if X is a numeric array or the
%                   name of varialbes if X is a table or timetable.
%                   Example: 'ColorGroups' = ['g1','g1','g2','g1','g2']
%                   The bars of 1st, 2nd, 4th column of inputs will the same
%                   color. The default color order will be used.
%
%      'NumDisplay' - A number of variable to display from the top. The
%                  default is all, size(X,2))
%
%      'NumInterp' - A number of datapoints to be generated between each time
%                  stamp of X. The larger the value is the smoother/slower the transtion.
%                  The default is 2.
%
%      'Method' - A method for above interpolation. The default is 'linear',
%                 but can be 'spline' for more dynamic bar transition.
%
%      'GenerateGIF' - If TRUE GIF animation of bar chart race will be
%                      generated.
%
%      'Outputfilename' - Output GIF file name
%
%      'XlabelName' - The XLabelName, the defaultis "" (emtpy)
%
%      'IsInteger' - If TRUE, the text shown next to each bar will be arounded to interger value.
%                    The default is TRUE.
%
%      'FontSize' - Axes fontsize, the default is 15.
%
%      'DisplayFontSize' - The fontsize of the time stamp display, the default is 15.
%
%      'YTickLabelRotation' - The angle of the y-axes label text, the default is 0.
%
%      'Position' - Location and size of the drawable area, specified as a vector of 
%                   the form [left bottom width height]. The deafult is 'DefaultFigurePosition'
%
%      'GIFDelayTime' ? Delay before displaying next image. Delay before displaying next image, 
%                       in seconds, a scalar value in the range [0,655].
%                       Default is 0.05
%                       (see imwrite)
%
%   Example:
%
%   % Some toy (time series) data set
%   maxT = 45;
%   time = 0:50;
%   x0 = 1:5; % initial data
%   rate = (5:-1:1)/100*2; % growth rate
%   data = zeros(length(time),length(x0));
%   data(1,:) = x0;
%   for ii=2:length(time)
%      data(ii,:) = data(ii-1,:).*(1+rate);
%   end
%   barChartRace(data)
%
%
%   Copyright 2020 Michio Inoue

% What is arguments?
% see: https://jp.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html
arguments
    inputs {mustBeNumericTableTimetable(inputs)}
    options.Time (:,1) {mustBeTimeInput(options.Time,inputs)} = setDefaultTime(inputs)
    options.LabelNames {mustBeVariableLabels(options.LabelNames,inputs)} = setDefaultLabels(inputs)
    options.ColorGroups {mustBeVariableLabels(options.ColorGroups,inputs)} = setDefaultLabels(inputs)
    options.NumDisplay (1,1) double {mustBeInteger,mustBeNonzero} = length(setDefaultLabels(inputs));
    options.NumInterp (1,1) double {mustBeInteger,mustBeNonzero} = 2;
    options.Method char {mustBeMember(options.Method,{'linear','spline'})} = 'linear'
    options.GenerateGIF (1,1) {mustBeNumericOrLogical} = false
    options.Outputfilename char {mustBeNonempty} = 'output.gif'
    options.XlabelName char = ""
    options.IsInteger (1,1) {mustBeNumericOrLogical} = true
    options.FontSize (1,1) double {mustBeInteger,mustBeNonzero,mustBeNonNan} = 15
    options.DisplayFontSize (1,1) {mustBeInteger,mustBeNonzero} = 15
    options.YTickLabelRotation (1,1) {mustBeNumericOrLogical} = 0
    options.Position (1,4) {mustBeNumeric,mustBeNonzero} = get(0, 'DefaultFigurePosition')
    options.GIFDelayTime (1,1) {mustBeNumeric,mustBeNonzero} = 0.05
end

if isa(inputs,'timetable') || isa(inputs,'table')
    data = inputs.Variables;
elseif isa(inputs,'double')
    data = inputs;
end

time = options.Time;
LabelNames = string(options.LabelNames);
ColorGroups = string(options.ColorGroups);
Outputfilename = options.Outputfilename;
NumInterp = options.NumInterp;
Method = options.Method;
XlabelName = options.XlabelName;
IsInteger = options.IsInteger;
NumDisplay = options.NumDisplay;

nVariables = length(LabelNames); % Number of items

%% Ranking of each variable (names) at each time step
rankings = zeros(size(data));
for ii=1:size(data,1)
    [~,tmp] = sort(data(ii,:),'descend');
    rankings(ii,tmp) = 1:nVariables;
end

%% Interpolation: Generate nInterp data point in between
time2plot = linspace(time(1),time(end),length(time)*NumInterp);
ranking2plot = interp1(time,rankings,time2plot,Method);
data2plot = interp1(time,data,time2plot,Method);

%% Plot of variables and the transition of their rankings
if nargout == 2
    handle_dataplot = figure;
    subplot(2,1,1)
    plot(time,data,'LineWidth',2)
    legend(LabelNames)
    subplot(2,1,2)
    plot(time2plot,ranking2plot,'LineWidth',2)
    legend(LabelNames)
end

%% Let's create Bar Chart
handle_barplot = figure;
handle_barplot.Position = options.Position;
handle_axes = gca;
hold(handle_axes,'on');
handle_axes.XGrid = 'on';
handle_axes.XMinorGrid = 'on';

% Some visual settings
handle_axes.FontSize = options.FontSize;
handle_axes.YTickLabelRotation = options.YTickLabelRotation;
handle_axes.YAxis.Direction = 'reverse'; % rank 1 needs to be on the top
handle_axes.YLim = [0, NumDisplay+0.5];

defaultWidth = 0.8; % Default BarWidth

%% Plot the initial data (time = 1)
ranking = ranking2plot(1,:);
value2plot = data2plot(1,:);

% Create bar plot
handle_bar = barh(ranking, value2plot);

% Fix the BarWidth
scaleWidth = min(diff(sort(ranking)));
handle_bar.BarWidth = defaultWidth/scaleWidth;

% Set YTick position by ranking
% Set YTickLabel with variable names
[ytickpos,idx] = sort(ranking,'ascend');
handle_axes.YTick = ytickpos;
handle_axes.YTickLabel = LabelNames(idx);

% Better to fix XLim
% Here I set maxValue time 1.5. (can be anything)
maxValue = max(value2plot);
handle_axes.XLim = [0, maxValue*1.5];

% Add value string next to the bar
if IsInteger
    displayText = string(round(value2plot(idx)));
else
    displayText = string(value2plot(idx));
end
xTextPosition = value2plot(idx) + maxValue*0.05;
yTextPosition = ytickpos;

% NumDisplay values are used
xTextPosition = xTextPosition(1:NumDisplay);
yTextPosition = yTextPosition(1:NumDisplay);
displayText = displayText(1:NumDisplay);
handle_text = text(xTextPosition,yTextPosition,displayText,'FontSize',options.FontSize);

% Display time
handle_timeText = text(0.9,0.1,string(time2plot(1)),'HorizontalAlignment','right',...
    'Units','normalized','FontSize', options.DisplayFontSize);
handle_axes.XLabel.String = XlabelName;

% Display created by MATLAB message
text(0.99,0.02,"Visualized by MATLAB",'HorizontalAlignment','right',...
    'Units','normalized','FontSize', 10,'Color',0.5*[1,1,1]);

% Change the Bar Color
handle_bar.FaceColor = 'flat';
% Find color groups
[cGroup,cID] = findgroups(ColorGroups);

nColors = length(cID);
defaultColorOrder = get(handle_axes,'ColorOrder'); % 7x3 (7 color patterns)
colorScheme = zeros(nVariables,3);
for ii=1:nColors
    idx = cGroup == ii;
    rgb = defaultColorOrder(mod(ii-1,7)+1,:);
    colorScheme(idx,:) = repmat(rgb,sum(idx),1);
end
handle_bar.CData = colorScheme(idx);

%% From the 2nd step and later
for ii=2:length(ranking2plot)
    
    ranking = ranking2plot(ii,:);
    value2plot = data2plot(ii,:);
    
    % barh gives an error if ranking has duplicate values
    % Thus skip it.
    if length(unique(ranking)) < nVariables
        continue;
    end
    
    % Set to new data
    handle_bar.XData = ranking;
    handle_bar.YData = value2plot;
    
    % Fix the BarWidth
    scaleWidth = min(diff(sort(ranking)));
    handle_bar.BarWidth = defaultWidth/scaleWidth;
    
    % Set YTick position by ranking
    % Set YTickLabel with variable names
    [ytickpos,idx] = sort(ranking,'ascend');
    handle_axes.YTick = ytickpos;
    handle_axes.YTickLabel = LabelNames(idx);
    
    % Fix CData
    handle_bar.CData = colorScheme(idx,:);
    
    % Better to fix XLim
    % Here I set maxValue time 1.5. (can be anything)
    maxValue = max(value2plot);
    handle_axes.XLim = [0, maxValue*1.5];
    
    % Add value string next to the bar
    xTextPosition = value2plot(idx) + maxValue*0.05;
    tmp = value2plot(idx); % data to display
    for jj = 1:NumDisplay
        handle_text(jj).Position = [xTextPosition(jj), ytickpos(jj)];
        if IsInteger
            handle_text(jj).String = string(round(tmp(jj))); % Modified
        else
            handle_text(jj).String = string(tmp(jj));
        end
    end
    
    % Display the original time stamp (or index)
    handle_timeText.String = string(time(ceil(ii/NumInterp)));
    
    if options.GenerateGIF
        frame = getframe(gcf); %#ok<UNRCH> % Figure ��ʂ����[�r�[�t���[���i�\���́j�Ƃ��ăL���v�`��
        tmp = frame2im(frame); % �摜�ɕύX
        [A,map] = rgb2ind(tmp,256); % RGB -> �C���f�b�N�X�摜��
        if ii == 2 % �V�K gif �t�@�C���쐬
            imwrite(A,map,Outputfilename,'gif','LoopCount',Inf,'DelayTime',options.GIFDelayTime);
        else % �ȍ~�A�摜���A�y���h
            imwrite(A,map,Outputfilename,'gif','WriteMode','append','DelayTime',options.GIFDelayTime);
        end
    end
    
    pause(0.05)
end

hold(handle_axes,'off');

end