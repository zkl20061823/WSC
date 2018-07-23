function perturbed_labels = perturb_labels(labels, psnr)
% PERTURB_LABELS add psnr% of noise to every class in labels 
%
% labels:  A vector of class IDs or labels 
% psnr:  A scalar in [0, 1] indicating the % of noise to perturb

label_set = unique(labels);
perturbed_labels = labels;

for ilabel = 1:length(label_set)
    label = label_set(ilabel);
    idx = find(labels == label);
    n = length(idx);
    sample_set = setdiff(label_set, label);

    % Sample new class IDs to perturb
    num_perturb = fix(psnr*n);
    pos = randi(length(sample_set), num_perturb, 1);
    perturb_class_ids = sample_set(pos);

    % Apply perturbation
    perturb_idx = randperm(n, num_perturb);
    perturbed_labels(idx(perturb_idx)) = perturb_class_ids;
end
