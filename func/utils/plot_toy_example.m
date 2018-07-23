function plot_toy_example(obj, clusters, feat, label, wlbl)
% Plot WSE toy example at different iterations

% Setup
h1 = figure(1);
set(h1, 'PaperOrientation', 'landscape');
fs = 14;  % Font size
ds = 10;  % Display step
num_iter = length(obj.obj);

output_dir = fullfile('results', 'figures');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

for i = [1:ds:num_iter, num_iter] 
    figure(1);
    
    % Plot weak annotation (wlbl)
    subplot(141);
    plot_toy_samples(feat, wlbl);
    title('Weak annotation (wlbl)', 'fontsize', fs);
    
    % Plot objective
    subplot(142);
    cols = [200 45 43; 37 64 180; 0 176 80; 0 0 0]/255; box on;
    plot(1:i, obj.obj(1:i),'color', cols(2,:), 'linewidth', 4);
    set(gca, 'xlim', [0, num_iter], ...
        'ylim', [min(obj.obj)-0.05, max(obj.obj)], ...
        'xtick', 0:20:num_iter, ...
        'xticklabel', 0:20:num_iter);
    xlabel('#iterations', 'fontsize', fs);
    title('Objective value', 'fontsize', fs);
    grid on; axis tight;
    
    % Plot samples
    subplot(143);
    plot_toy_samples(feat, clusters(i, :));
    title(sprintf('WSE #iter %3d', i), 'fontsize', fs);
    
    % Plot ground truth
    subplot(144);
    plot_toy_samples(feat, label);
    title('Ground truth', 'fontsize', fs);
    set(gcf, 'position', [100, 100, 960, 240]);
    drawnow;
    
    % Save final result to file
%     savename = fullfile(output_dir, sprintf('itr_%d.png', i));
%     print(savename, '-dpng');
%     fprintf('Saved final results to %s\n', savename);
    
end

% Save final result to file
savename = fullfile(output_dir, sprintf('itr_%d.png', i));
print(savename, '-dpng');
fprintf('Saved final results to %s\n', savename);
