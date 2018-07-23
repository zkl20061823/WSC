function [obj, obj1, obj2] = obj_wse(lambda, Wt, L, group)

n = size(Wt, 1);
% compute the objective function
obj1 = trace(Wt'*L*Wt);
group_t = unique(group);
obj2_ = zeros(size(group_t,1),1);
for k = 1:size(group_t,1)
    gind = find(group==group_t(k));
    ng = numel(gind);
    Cg = eye(ng) - ones(ng)/ng;
    obj2_(k) = n/(numel(group_t)* ng)*trace(Wt(gind,:)'*Cg*Wt(gind,:)) ;
end
obj2 = sum(obj2_);

obj = obj1 + lambda * obj2;