function config = get_config(alg, dataset)
% Get config for different algorithms and datasets

switch alg
    case 'wse'
        switch dataset
            case 'toy'
                config.optimizer = 'agd';
                config.embedding_dim = 2;
                config.type_laplacian = 'norm';
                config.speedup = 'fast';
                config.epoch = 50;
                config.graph_partition = 2;
                config.lambda = 0.3413;
                config.log_opt.is_log = true;
                config.log_opt.num_clusters = 2;
                config.log_opt.disp_steps = 5;

            case 'au_data'
                config.optimizer = 'agd';
                config.embedding_dim = 10;
                config.type_laplacian = 'norm';
                config.speedup = 'fast';
                config.epoch = 50;
                config.graph_partition = 2;
                config.lambda = 1;
                config.log_opt.is_log = false;
                
            case 'mnist'
                config.optimizer = 'agd';
                config.embedding_dim = 2;
                config.type_laplacian = 'norm';
                config.speedup = 'fast';
                config.epoch = 50;
                config.graph_partition = 2;
                config.lambda = 10000;
                config.lambda = 0.1;
                config.log_opt.is_log = true;
                config.log_opt.num_clusters = 2;
                config.log_opt.disp_steps = 1;
        end
        
    case 'reannotation'
        switch dataset
            case 'au_data'
                config.batch = 1000;
                config.num_knn = 50;
                config.build_params.algorithm = 'kdtree';
                config.build_params.trees = 1000;
                config.build_params.checks = 100;
                config.remove_outlier = false;
        end
end

% Display config
fprintf('Loaded config for "%s":\n', dataset);
T = struct2table(config);
new_T = cell2table(table2cell(T)');
new_T.Properties.RowNames = T.Properties.VariableNames;
new_T.Properties.VariableNames{'Var1'} = 'Value';
disp(new_T);