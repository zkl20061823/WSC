function plot_samples(feat, label)
% Plot function for demo_toy.m

class_ids = unique(label);
cnames = colors('list');
ncolor = length(cnames);

for iclass = 1:numel(class_ids)
    class_id = class_ids(iclass);
    class_ind = label == class_id;
    xx = feat(1, class_ind);
    yy = feat(2, class_ind);
    color = colors(cnames{randi(ncolor)});
    scatter(xx, yy, 20, 'o', ...
        'markerfacecolor', color, ...
        'linewidth', 1);
    hold on;
end
axis off equal tight;