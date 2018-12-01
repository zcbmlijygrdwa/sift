close all;
clear all;

img1 = imread('test.jpg');
img2 = imread('test2.jpg');

img1 = imresize(img1,0.5);
img2 = imresize(img2,0.5);

img1 = rgb2gray(img1);
img2 = rgb2gray(img2);


descriptorSet1 = SIFT_key(img1);
descriptorSet2 = SIFT_key(img2);

corr = zeros(length(descriptorSet1),2);
matchedPoints1 = zeros(length(descriptorSet1),2);
matchedPoints2 = zeros(length(descriptorSet1),2);

for i =1:length(descriptorSet1)
    min = 100000;
    minIdx = -1;
    for j = 1:length(descriptorSet2)
        diff= sum(abs(descriptorSet1{i}.featureVector - descriptorSet2{j}.featureVector));
        if(diff<min)
           min = diff;
           minIdx = j;
        end
    end
    corr(i,:) = [i,j];
    matchedPoints1(i,:) = descriptorSet1{i}.location;
    matchedPoints2(i,:) = descriptorSet2{minIdx}.location;
    
end

showFeatureCorr(img1,img2,matchedPoints1,matchedPoints2)