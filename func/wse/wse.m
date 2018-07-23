function [CtA, Wt, V, obj, obj1, obj2] = ...
    wse(L, Wt, V, group, eta, gamma, lambda, speedup, optimizer, log_opt)

% Get config
is_log = get_field(log_opt, 'is_log', false);
num_clusters = get_field(log_opt, 'num_clusters', 2);
disp_steps = get_field(log_opt, 'disp_steps', 1);

% Init
a0 = 1;
itr = 1000;
n = size(Wt, 1);
group_t = unique(group);
is_converge = false;
t = 1;
obj = zeros(itr, 1);
obj1 = zeros(itr, 1);
obj2 = zeros(itr, 1);
CtA = cell(itr, 1);

while t < itr && ~is_converge
    
    [obj(t), obj1(t), obj2(t)] = obj_wse(lambda, Wt, L, group);
    if t > 2
        if abs(obj(t) - obj(t-1)) < 1e-5 
            fprintf('Quitting: obj stop changing\n');
            is_converge = true;
            break; 
        elseif obj(t) > obj(t-1)
            fprintf('Quitting: obj start increasing\n');
            is_converge = true;
            break
        end
    end
    
    % update eta
    while obj(t) > obj_QL(Wt, V, lambda, L, eta, group)
        eta = gamma * eta;  fprintf('Updating eta = %.9f\n', eta);
    end
    
    Wprev = Wt;
    V  = Wt - eta * (2*L*Wt); % update V
    
    % get derivative of gv
    switch speedup
        case 'standard'
            for i = 1:size(group_t,1)
                gind  = find(group == group_t(i));
                ng    = numel(gind); %size(Vt1(gind,:), 1);
                Cg    = eye(ng) - ones(ng)/ng;        
                Wt(gind,:) = (eye(ng) + ...,
                2*lambda*eta*n/(ng*numel(group_t))*Cg) \ V(gind,:);       
            end
        case 'fast'
            for i = 1:size(group_t,1)
                gind  = find(group == group_t(i));
                ng    = numel(gind); 
                beta  = 2*lambda*eta*n / (ng*numel(group_t));                  
            % Speed up version with closed-form update
                beta_a = 1+beta;
                beta_b = -beta/ng;
                Wt(gind,:) = 1/beta_a*V(gind,:) - ...,
                beta_b/(beta_a*(beta_a+beta_b*ng))*repmat(sum(V(gind,:),1),[numel(gind) 1]);
            end
    end
    % 1: reuglard gradient descent update
	%Wt = Wprev - gamma * Wt;
    
    % 2: accelerated gradient descent update
    at = 2 / (t+3);
    delta = Wt - Wprev;
    Wt = Wt + (1-a0)/a0*at*delta;
    a0 = at;
    Wt = orth(Wt);
    
    % Get cluster results
    if is_log && strcmp(optimizer, 'agd')
        [Ct, ~] = litekmeans(Wt, num_clusters, 'Replicates', 100);
        CtA{t} = Ct';
    end
    
    % Display
    if mod(t, disp_steps) == 0
        fprintf('Iter#%4d, obj=%.4f, obj1=%.4f, obj2=%.4f\n', t, obj(t), obj1(t), obj2(t));
    end
    
    t = t + 1;
end
fprintf('WSE: Early stop at iter #%d\n', t);

% Pack results
obj = obj(1:t-1);
obj1 = obj1(1:t-1);
obj2 = obj2(1:t-1);
CtA = cell2mat(CtA(1:t));