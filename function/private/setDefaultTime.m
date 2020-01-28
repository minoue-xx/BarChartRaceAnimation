function time = setDefaultTime(inputs)
% A function to generate the default values for 'Time'
% Copyright 2020 Michio Inoue

if isa(inputs,'timetable')
    time = inputs.Time;
else
    time = 1:size(inputs,1);
end