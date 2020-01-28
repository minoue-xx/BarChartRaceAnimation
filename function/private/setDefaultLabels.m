function labels = setDefaultLabels(inputs)
% A function to generate the default values for 'LabelNames' and
% 'ColorGroups'
% Copyright 2020 Michio Inoue

if isa(inputs,'timetable') || isa(inputs,'table')
    labels = string(inputs.Properties.VariableNames);
elseif isa(inputs,'double')
    labels = "name" + string(1:size(inputs,2));
end