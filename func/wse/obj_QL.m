function obj = obj_QL(W, Wt, lambda, L, eta, group)

n = size(Wt, 1);
group_t = unique(group);
obj2_ = zeros(size(group_t,1),1);
for k = 1:size(group_t,1)
    gind = find(group==group_t(k));
    ng = numel(gind);
    Cg = eye(ng) - ones(ng)/ng;
    obj2_(k) = n/(numel(group_t)* ng)*trace(W(gind,:)'*Cg*W(gind,:));
end
obj2 = sum(obj2_);

obj = trace(Wt'*L*Wt) + trace( (W-Wt)'* (2*L*Wt) ) + ...
      norm(W-Wt, 'fro')^2 / (2*eta) + ...
      lambda *obj2;
