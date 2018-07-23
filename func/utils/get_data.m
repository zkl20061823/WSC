function [feat, label, wlbl] = get_data(dataset)
% Get feature and label from dataset
% Also load weak labels (wlbl) if necessary

db_file = fullfile('data', [dataset, '.mat']);
err_str = sprintf('Dataset %s does not exist', db_file);
assert(logical(exist(db_file, 'file')), err_str);

db = load(db_file);

switch dataset
    case 'toy'
        feat = db.feat;
        label = db.label;
        
        % Get weak labels by perturbing ground-truth labels
        psnr = 0.3;  % Perturb labels for 30% samples in each class
        wlbl = perturb_labels(label, psnr);
        
    case 'au'
        feat = db.feat';
        label = db.label;
        wlbl = db.predL;  % Get pre-computed weak labels
        
    case 'mnist'
        num_class = 2;
        labels = double(db.labels);
        inds = cell(num_class, 1);
        n = 100;  % num to sample per class
        for iclass = 1:num_class
            ind = find(labels == (iclass-1));
            inds{iclass} = ind(randperm(length(ind), n));
        end
        inds = cell2mat(inds)';
        inds = inds(:);
        feat = reshape(db.images(inds, :, :), [num_class*n, 784]);
        feat = double(feat');
        label = labels(inds);
        
        % Get weak labels by perturbing ground-truth labels
        psnr = 0;  % Perturb labels for 30% samples in each class
        wlbl = perturb_labels(label, psnr);
end

fprintf('Loaded data from %s\n', db_file);