function A = get_graph(X, dataset, varargin)
% Get graph in adjanceny matrix A
%
% Parameters are:
% 
% 'graph_type' - Define the type of similarity graph
%   'full' - Full Similarity Graph
%   'mutual_knn' - Mutual kNeares Neighbors Graph [default]
%   'knn' - kNearest Neighbors Graph
%
% 'nn_opt' - Option for computing k-NN
%   'pdist' [default] 
%   'flann'
%
% 'is_load_graph' - Load pre-computed graph or not
%    false [default]
%
% 'num_nn' - Number of nearest neighbors to build graph
%    100 [default]
%    0.1 - If num_nn is in [0, 1], we used num_nn as the % of all samples

% Setup
pnames = {'graph_type', 'nn_opt', 'is_load_graph', 'num_nn'};
dflts = {'mutual_knn', 'pdist', false, 100};
[graph_type, nn_opt, is_load_graph, k] = ...
    get_args(pnames, dflts, varargin{:});

% Init
n = size(X, 2);
if k < 1
    k = round(k * n);
end

output_dir = fullfile('.', 'results', 'graph');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end
savename = fullfile(output_dir, ['gh_', dataset, '.mat']);
has_saved_file = logical(exist(savename, 'file'));

if has_saved_file && is_load_graph
    graph = load(savename);
    fprintf('Loaded graph from %s\n', savename);
    A = graph.A;

elseif strcmp(nn_opt, 'pdist')
    fprintf('Computing graph using pdist with %d neighbors ... ', k);
    tic;
    dist = pdist2(X', X');
    isnn = false(n);
    
    % Create directed neighbor graph
    for iRow = 1:n
        [val, idx] = sort(dist(iRow, :), 'ascend');
        isnn(iRow, idx(1:k+1)) = true;
    end
    knndist = sparse(n, n);
    knndist(isnn) = dist(isnn);
    clear dist;
    if strcmp(graph_type, 'mutual_knn')
        knndist = min(knndist, knndist');
    elseif strcmp(graph_type, 'knn')
        knndist = max(knndist, knndist'); 
    end
    
    sigma = median(knndist(isnn));  % Gaussian parameter
    A = spfun(@(knndist) (sim_gaussian(knndist, sigma)), knndist);
    save(savename, 'A');
    fprintf('done in %.2f secs\n', toc);

elseif strcmp(nn_opt, 'flann')
    build_params.algorithm = 'kdtree';
    build_params.trees     = 100;
    k = 100; % Number of nearest neighbors      
    flann_set_distance_type('euclidean'); 
    
    fprintf('Computing graph using flann with %d neighbors ... ', k);
    [index, parameters, speedup] = flann_build_index(X, build_params);
    [result, dist] = flann_search(index, X, k, parameters);
    flann_free_index(index);
    idx = result + repmat([0:n:(n-1)*n], [k,1]);
    keyboard
    knndist = sparse(idx(:), 1, dist(:), n*n, 1);
    knndist = reshape(knndist, [n ,n]);
    if strcmp(graph_type, 'mutual_knn')
        knndist = min(knndist, knndist');
    elseif strcmp(graph_type, 'knn')
        knndist = max(knndist, knndist');
    end
    varparam = 1; % Gaussian parameter
    A = spfun(@(knndist) (sim_gaussian(knndist, varparam)), knndist);
    fprintf('done\n');

    dumvar = 0;
    save(savename, 'A', 'dumvar', '-v7.3');        
end