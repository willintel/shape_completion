%% Visualize Supervised Network Results
clear all; close all; clc

addpath(genpath('./'))
addpath(genpath('./../Tools/'))

mesh_0 = load('./artist_models/model_0_remesh'); mesh_0 = mesh_0.part;
mesh_1 = load('./artist_models/model_1_remesh'); mesh_1 = mesh_1.model;

%X = load('./Supervised Network Results/test_list_0_1.mat');
%[~, supervised_matches] = max(squeeze(X.softCorr),[],1);
load('./Supervised Network Results/matches_supervised.mat');

colors = create_colormap(mesh_1,mesh_1);
figure;
subplot(1,2,1); colormap(colors);
plot_scalar_map(mesh_1,[1: size(mesh_1.VERT,1)]');freeze_colors;title('Target');

subplot(1,2,2); colormap(colors(supervised_matches,:));
plot_scalar_map(mesh_0,[1: size(mesh_0.VERT,1)]');freeze_colors;title('Source');

%save('matches_supervised.mat','supervised_matches');