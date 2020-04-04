function c = myFunction(a,b,options)

arguments
    a (1,1) {mustBeInteger(a),mustBePositive(a)} = 1
    b = 2
    options.Method {mustBeMember(options.Method,{'linear','spline'})} = 'linear'
end

c = a+b;
disp(options.Method);

end