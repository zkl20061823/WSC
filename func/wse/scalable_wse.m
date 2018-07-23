function [CtA, Wt, objout] = scalable_wse(A, group, config)

% Get config
outdim = get_field(config, 'embedding_dim', 2);
type_lap = get_field(config, 'type_laplacian', 'norm');
speedup = get_field(config, 'speedup', 'fast');
optimizer = get_field(config, 'optimizer', 'agd');
epoch = get_field(config, 'epoch', 50);
graph_partition = get_field(config, 'graph_partition', 2);
log_opt = get_field(config, 'log_opt', []);
lambda = get_field(config, 'lambda', 0.3413);
eta = get_field(config, 'eta', 0.1);
gamma = get_field(config, 'gamma', 0.9);

assert(lambda ~= 0, 'lambda has to be 0');

% Calculate degree matrix 
degs = sum(A, 2);
D    = sparse(1:size(A, 1), 1:size(A, 2), degs);

% Compute unnormalized Laplacian
L = D - A;
L = sparse(L);

% Compute normalized Laplacian if needed
if strcmp(type_lap, 'norm')
    % avoid dividing by zero
    degs(degs == 0) = eps;
    % calculate ingerse of D
    D = spdiags(1./degs, 0, size(D, 1), size(D, 2));

    % calculate normalized Laplacian
    L = D * L;
end 

% Init
W0 = orth(rand(size(L, 1), outdim));
Wt = W0;
V = Wt;

switch optimizer
    case 'sgd'
        n = size(L, 1);
        nnz_ = nnz(L);
        batch_size = fix(nnz_/graph_partition);
        
        t = 0;
        CtA = [];
        for iepoch = 1:epoch
            if mod(iepoch, 5) == 0 ; eta = eta*0.1; end
            ind = randperm(nnz_);
            [i_,j_,s_] = find(L);
            row_  = i_(ind);
            column_ = j_(ind);
            value_ = s_(ind);
            for ibatch = 1:graph_partition
                
                ibegin = (ibatch-1)*batch_size + 1;
                if ibatch == graph_partition
                    iend = nnz_;
                else
                    iend = ibatch*batch_size;
                end
                L_tilt = sparse(row_(ibegin:iend),column_(ibegin:iend),...,
                value_(ibegin:iend), n, n);
                fprintf('Samping L_tilt#%2d in epoch#%2d\n',ibatch,iepoch);
                % start to learn wse
                t = t + 1;
                [Ct, Wt, V, obj{t}, obj1{t}, obj2{t}] = wse(L_tilt, Wt, V, ...
                    group, eta, gamma, lambda, speedup, optimizer, log_opt);
                CtA = [CtA; Ct];
            end
        end
    case 'agd'
        [CtA, Wt, V, obj, obj1, obj2] = wse(L, Wt, V, group, eta, gamma, ...
            lambda, speedup, optimizer, log_opt);
end

% Pack outputs
objout.obj  = obj;
objout.obj1 = obj1;
objout.obj2 = obj2;

