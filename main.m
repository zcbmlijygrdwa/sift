close all
clear all


%based on https://blog.csdn.net/weixin_38404120/article/details/73740612
%https://www.cnblogs.com/wangguchangqing/p/4853263.html


sigma  = 0.6;
k = 1/4;

% load image
img = imread('test2.jpg');
img = rgb2gray(img);
img = imresize(img,0.3);
%imshow(img)

sclaes = []
%create scales
for i = 1:4
sclaes(i) = (k^i)*sigma*2;
end



%create gussian kernel 高斯核
for i = 1:4
gk{i} = createGussianKernel(5,sclaes(i));
end


%convolution on image with gussian kernel
%https://www.mathworks.com/help/matlab/ref/conv2.html
% img =gk conv2(img,gk);
% img = uint8(img);


%create Laplassian of gussian
%resize of 5 level
LOG1 = {};
for i = 1:5
   LOG1{i} = imresize(img,0.5^(i-1));
end


%for each Octave create image for different gaussian
LOG = {};
for i = 1:5
    for j = 1:4
        LOG{i}.gussian{j} = conv2(LOG1{i},gk{j});
    end
end


%create DOG
DOG = {};
for i = 1:5
    for j = 1:3
        DOG{i}.gussian{j} = LOG{i}.gussian{j+1} - LOG{i}.gussian{j};
    end
end

%search for exrtem value
extrems = {};
extrmsIdx = 1;
for i = 1:5
    for gLevel = 1+1:3-1
        
        tempImg = DOG{i}.gussian{gLevel};
        width = size(tempImg,1);
        height = size(tempImg,2);
        
        tempImg_upper = DOG{i}.gussian{gLevel-1};
        tempImg_lower = DOG{i}.gussian{gLevel-1};
        
        for m = 1+1:width-1
            for n = 1+1:height-1
                [i,gLevel,m,n]
                current = tempImg(m,n);
                
                %search for 26 pixels around
                around = tempImg_upper(m-1:m+1,n-1:n+1);
                around = [around, tempImg_lower(m-1:m+1,n-1:n+1)];
                
                around = [around(1,:), around(2,:) around(3,:)];
                
                for x = -1:1
                    for y = -1:1
                        if(~(x==0&&y==0))
                           around = [around,tempImg(m+x,n+y)]; 
                        end
                    end
                end
                if(current<min(around) || current > max(around))
                    extrems{extrmsIdx}.location = [n,m];
                    extrems{extrmsIdx}.scale = sclaes(gLevel);
                    extrems{extrmsIdx}.octaive = i;
                    
                    extrmsIdx = extrmsIdx +1;
                end
                
            end
        end
    end
end

%show extrem points
figure
for i = 1:5
    subplot(1,5,i)
    imshow(LOG{i}.gussian{1},[])
    size(LOG{i}.gussian{1})
    hold on;
    for j = 1:length(extrems)
        count = 0;
       if(extrems{j}.octaive==i)
           location = extrems{j}.location;
            plot(location(1),location(2),'o'); 
            count = count +1;
       end
       count;
    end
end
hold off


