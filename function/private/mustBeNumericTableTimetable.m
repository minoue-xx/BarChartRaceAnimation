function mustBeNumericTableTimetable(arg)
% Custom validation function for input data
% Copyright 2020 Michio Inoue

if isa(arg,'timetable') || isa(arg,'table')
    if ~isnumeric(arg.Variables)
        error("Variables must be numeric");
    end
elseif ~isa(arg,'double')
    error("Input data must be either timetable, table, or numeric array (double)");
end

end