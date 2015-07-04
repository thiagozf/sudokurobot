function [ number ] = ocr( im, templates )
%OCR Executes a template matching based character recognition.
%   OCR classifies the input image as a numeric digit from 1 to 9 using an
%   optical character recognition method know as template matching. More
%   details can be found at https://en.wikipedia.org/wiki/Template_matching.
%   The distance function used by the function is the Manhattan Distance.
%
%   NUMBER = OCR (I, T) recognizes the character at the input image
%   I by comparing it with the templates of the T argument.
    [h,w] = size(im);
    ht = 20;
    wt = 15;
    
    %figure, imshow(im);
    
    if (w < 0.6 * h)
       number = 1;
       return;
    end
    
    imResized = 255*imresize(im, [ht wt]);
    similarity = zeros(1,9);
    
    for n=1:9
        for i=1:wt
            for j=1:ht
                diff = imResized(j,i) - double(templates{n}(j,i));
                similarity(n) = similarity(n) + abs(diff);
            end
        end
    end
    
    number = 0;
    maxSimilarity = +Inf;
    
    %similarity
    
    for n=2:9
        if (similarity(n) <= maxSimilarity)
            maxSimilarity = similarity(n);
            number = n;
        end
    end
end

