function bloc = subdivide_block(class)
%% DOCUMENTATION

% FUNCTION FOR IMPLEMENTATION FOR LAB 5
% FUNCTION ACCEPTS A CLASS (SIZE 128x128) AND SUBDIVIDES IT INTO BLOCKS (SIZE 16x16)
% FUNCTION OUTPUTS A 16x16x64 ARRAY OR MATRICIES CONTAINING THE PIXEL
% VALUES FOR EACH BLOCK (BLOCK 1 BEING THE TOP LEFT AND 64 BEING BOTTOM RIGHT)

% MADE BY: DANIEL SHERMAN
% MARCH 23, 2020

%% START OF CODE
iter = 1;

for m = 0:7
    for n = 0:7
        eval(strcat(['bloc(:,:,', num2str(iter), ...
            ') = double(class(1 + m*16: 16*(m + 1), 1 + n*16: 16*(n + 1)));']));
        iter = iter + 1;
    end
end

