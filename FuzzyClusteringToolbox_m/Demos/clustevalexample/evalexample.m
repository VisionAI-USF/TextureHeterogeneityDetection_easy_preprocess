clc;
clear;
close all;
path(path,'..\..\FUZZCLUST')

%loading the data
%load data2.txt
%data.X = data2;

load data2.txt -ascii
data.X = data2;

%normalization and plotting
data = clust_normalize(data, 'range');
%plot(data.X(:,1),data.X(:,2),'.')
%hold on
%plot(0.5,0.5,'ro')
%hold on
%parameters
param.m = 2; param.c = 3; param.e = 1e-3;
%GK clustering
result = FCMclust(data,param);
%plot(result.cluster.v(:,1),result.cluster.v(:,2),'m*')
new.X = data.X;
%new.X = [0.5 0.5];
param.val = 2;
result = validity(result,data,param);
eval = clusteval(new,result,param);
