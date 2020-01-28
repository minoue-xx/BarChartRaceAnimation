function mustBeVariableLabels(arg, inputs)
% Custom validation function for Name-Pair Value 'LabelNames','ColorGroups'
% Copyright 2020 Michio Inoue

if ~(iscell(arg) || isstring(arg))
    error("The input must be a cell array of char or a vector of string");    
end

% if iscell(arg) && all(cellfun(@ischar,arg))
%     error("The input must be a cell array of char or a vector of string");
% end
    
if size(arg(:),1) ~= size(inputs,2)
    error("The size must be same as the number of variables of inputs ("...
        + num2str(size(inputs,2)) + ")");
end

end