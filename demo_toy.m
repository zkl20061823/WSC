% This demo shows WSE optimization process as Fig 2 in [1].
%
% Please feel free to contact me regarding bugs and suggestions.
%
% Contact: Kaili Zhao (kailizhao@bupt.edu.cn)
% Paper: http://openaccess.thecvf.com/content_cvpr_2018/CameraReady/0237.pdf
% Reference:
%   [1] "Learning Facial Action Units from Web Images with Scalable Weakly 
%        Supervised Cluster, " in CVPR 2018.

clc; clear all; addpaths;

%% Data preparation
% Get data
dataset = 'toy';
[feat, label, wlbl] = get_data(dataset);

% Get graph in adjanceny matrix A
A = get_graph( ...
    feat, dataset, 'graph_type', 'mutual_knn', ...
    'nn_opt', 'pdist', 'num_nn', 100);

%% Run WSE
config = get_config('wse', 'toy');
[clusters, W, obj] = scalable_wse(A, wlbl, config);

%% Display WSE distribution at different iterations
plot_toy_example(obj, clusters, feat, label, wlbl);