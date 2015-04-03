function [ test_vec ] = test_func( poles, input )
%test_func An attempt to see how Matlab processes vectors that are passed
%into a function and have math performed on them.

test_vec = 0;
sprintf('Inside test_func, input_vector is %d', input)
for i = 1:poles
    test_vec = test_vec + i*input;
    disp(test_vec)
end

end

