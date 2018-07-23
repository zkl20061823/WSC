function plot_toy_samples(feat, label)
% Plot function for demo_toy.m

class_ids = unique(label);

for iclass = 1:numel(class_ids)
    class_id = class_ids(iclass);
    class_ind = label == class_id;
    xx = feat(1, class_ind);
    yy = feat(2, class_ind);
    if mean(yy) < 0
        scatter(xx, yy, 20, 'co', ...
            'markerfacecolor', [.98, .95, .95], ...
            'markeredgecolor', [.85, 0, 0], ...
            'linewidth', 1);
    else
        scatter(xx, yy, 20, 'bs', ...
            'markerfacecolor', [.9, .9, 1], ...
            'linewidth', 1);
    end
    hold on;
end
axis off equal tight;