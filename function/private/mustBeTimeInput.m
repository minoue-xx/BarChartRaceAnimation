function mustBeTimeInput(arg, inputs)
% Custom validation function for Name-Pair Value 'Time'
% Copyright 2020 Michio Inoue

if ~(isnumeric(arg) || isdatetime(arg))
    error("The datatype must be numeric or datetime.");
end

if length(arg) ~= size(inputs,1)
    error("The length must be same as that of inputs ("...
        + num2str(size(inputs,1)) + ")");
end
end