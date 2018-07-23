function val = get_field(struct_var, field_name, default_val)

if isfield(struct_var, field_name)
    val = struct_var.(field_name);
else
    val = default_val;
end