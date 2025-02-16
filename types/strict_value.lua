-- THIS FILE AUTOGENERATED BY terms-gen-meta.lua
---@meta "types.strict_value"

---@class (exact) strict_value: EnumValue
strict_value = {}

---@return boolean
function strict_value:is_visibility_type() end
---@return nil
function strict_value:unwrap_visibility_type() end
---@return boolean
function strict_value:as_visibility_type() end
---@return boolean
function strict_value:is_visibility() end
---@return visibility visibility
function strict_value:unwrap_visibility() end
---@return boolean
---@return visibility visibility
function strict_value:as_visibility() end
---@return boolean
function strict_value:is_param_info_type() end
---@return nil
function strict_value:unwrap_param_info_type() end
---@return boolean
function strict_value:as_param_info_type() end
---@return boolean
function strict_value:is_param_info() end
---@return strict_value visibility
function strict_value:unwrap_param_info() end
---@return boolean
---@return strict_value visibility
function strict_value:as_param_info() end
---@return boolean
function strict_value:is_result_info_type() end
---@return nil
function strict_value:unwrap_result_info_type() end
---@return boolean
function strict_value:as_result_info_type() end
---@return boolean
function strict_value:is_result_info() end
---@return result_info result_info
function strict_value:unwrap_result_info() end
---@return boolean
---@return result_info result_info
function strict_value:as_result_info() end
---@return boolean
function strict_value:is_pi() end
---@return strict_value param_type
---@return strict_value param_info
---@return strict_value result_type
---@return strict_value result_info
function strict_value:unwrap_pi() end
---@return boolean
---@return strict_value param_type
---@return strict_value param_info
---@return strict_value result_type
---@return strict_value result_info
function strict_value:as_pi() end
---@return boolean
function strict_value:is_closure() end
---@return string param_name
---@return typed code
---@return strict_value capture
---@return var_debug capture_dbg
---@return var_debug param_debug
function strict_value:unwrap_closure() end
---@return boolean
---@return string param_name
---@return typed code
---@return strict_value capture
---@return var_debug capture_dbg
---@return var_debug param_debug
function strict_value:as_closure() end
---@return boolean
function strict_value:is_range() end
---@return ArrayValue<strict_value> lower_bounds
---@return ArrayValue<strict_value> upper_bounds
---@return strict_value relation
function strict_value:unwrap_range() end
---@return boolean
---@return ArrayValue<strict_value> lower_bounds
---@return ArrayValue<strict_value> upper_bounds
---@return strict_value relation
function strict_value:as_range() end
---@return boolean
function strict_value:is_name_type() end
---@return nil
function strict_value:unwrap_name_type() end
---@return boolean
function strict_value:as_name_type() end
---@return boolean
function strict_value:is_name() end
---@return string name
function strict_value:unwrap_name() end
---@return boolean
---@return string name
function strict_value:as_name() end
---@return boolean
function strict_value:is_operative_value() end
---@return strict_value userdata
function strict_value:unwrap_operative_value() end
---@return boolean
---@return strict_value userdata
function strict_value:as_operative_value() end
---@return boolean
function strict_value:is_operative_type() end
---@return strict_value handler
---@return strict_value userdata_type
function strict_value:unwrap_operative_type() end
---@return boolean
---@return strict_value handler
---@return strict_value userdata_type
function strict_value:as_operative_type() end
---@return boolean
function strict_value:is_tuple_value() end
---@return ArrayValue<strict_value> elements
function strict_value:unwrap_tuple_value() end
---@return boolean
---@return ArrayValue<strict_value> elements
function strict_value:as_tuple_value() end
---@return boolean
function strict_value:is_tuple_type() end
---@return strict_value desc
function strict_value:unwrap_tuple_type() end
---@return boolean
---@return strict_value desc
function strict_value:as_tuple_type() end
---@return boolean
function strict_value:is_tuple_desc_type() end
---@return strict_value universe
function strict_value:unwrap_tuple_desc_type() end
---@return boolean
---@return strict_value universe
function strict_value:as_tuple_desc_type() end
---@return boolean
function strict_value:is_enum_value() end
---@return string constructor
---@return strict_value arg
function strict_value:unwrap_enum_value() end
---@return boolean
---@return string constructor
---@return strict_value arg
function strict_value:as_enum_value() end
---@return boolean
function strict_value:is_enum_type() end
---@return strict_value desc
function strict_value:unwrap_enum_type() end
---@return boolean
---@return strict_value desc
function strict_value:as_enum_type() end
---@return boolean
function strict_value:is_enum_desc_type() end
---@return strict_value universe
function strict_value:unwrap_enum_desc_type() end
---@return boolean
---@return strict_value universe
function strict_value:as_enum_desc_type() end
---@return boolean
function strict_value:is_enum_desc_value() end
---@return MapValue<string, flex_value> variants
function strict_value:unwrap_enum_desc_value() end
---@return boolean
---@return MapValue<string, flex_value> variants
function strict_value:as_enum_desc_value() end
---@return boolean
function strict_value:is_record_value() end
---@return MapValue<string, flex_value> fields
function strict_value:unwrap_record_value() end
---@return boolean
---@return MapValue<string, flex_value> fields
function strict_value:as_record_value() end
---@return boolean
function strict_value:is_record_type() end
---@return strict_value desc
function strict_value:unwrap_record_type() end
---@return boolean
---@return strict_value desc
function strict_value:as_record_type() end
---@return boolean
function strict_value:is_record_desc_type() end
---@return strict_value universe
function strict_value:unwrap_record_desc_type() end
---@return boolean
---@return strict_value universe
function strict_value:as_record_desc_type() end
---@return boolean
function strict_value:is_object_value() end
---@return MapValue<string, typed> methods
---@return StrictRuntimeContext capture
function strict_value:unwrap_object_value() end
---@return boolean
---@return MapValue<string, typed> methods
---@return StrictRuntimeContext capture
function strict_value:as_object_value() end
---@return boolean
function strict_value:is_object_type() end
---@return strict_value desc
function strict_value:unwrap_object_type() end
---@return boolean
---@return strict_value desc
function strict_value:as_object_type() end
---@return boolean
function strict_value:is_star() end
---@return number level
---@return number depth
function strict_value:unwrap_star() end
---@return boolean
---@return number level
---@return number depth
function strict_value:as_star() end
---@return boolean
function strict_value:is_prop() end
---@return number level
function strict_value:unwrap_prop() end
---@return boolean
---@return number level
function strict_value:as_prop() end
---@return boolean
function strict_value:is_host_value() end
---@return any host_value
function strict_value:unwrap_host_value() end
---@return boolean
---@return any host_value
function strict_value:as_host_value() end
---@return boolean
function strict_value:is_host_type_type() end
---@return nil
function strict_value:unwrap_host_type_type() end
---@return boolean
function strict_value:as_host_type_type() end
---@return boolean
function strict_value:is_host_number_type() end
---@return nil
function strict_value:unwrap_host_number_type() end
---@return boolean
function strict_value:as_host_number_type() end
---@return boolean
function strict_value:is_host_bool_type() end
---@return nil
function strict_value:unwrap_host_bool_type() end
---@return boolean
function strict_value:as_host_bool_type() end
---@return boolean
function strict_value:is_host_string_type() end
---@return nil
function strict_value:unwrap_host_string_type() end
---@return boolean
function strict_value:as_host_string_type() end
---@return boolean
function strict_value:is_host_function_type() end
---@return strict_value param_type
---@return strict_value result_type
---@return strict_value result_info
function strict_value:unwrap_host_function_type() end
---@return boolean
---@return strict_value param_type
---@return strict_value result_type
---@return strict_value result_info
function strict_value:as_host_function_type() end
---@return boolean
function strict_value:is_host_wrapped_type() end
---@return strict_value type
function strict_value:unwrap_host_wrapped_type() end
---@return boolean
---@return strict_value type
function strict_value:as_host_wrapped_type() end
---@return boolean
function strict_value:is_host_unstrict_wrapped_type() end
---@return strict_value type
function strict_value:unwrap_host_unstrict_wrapped_type() end
---@return boolean
---@return strict_value type
function strict_value:as_host_unstrict_wrapped_type() end
---@return boolean
function strict_value:is_host_user_defined_type() end
---@return { name: string } id
---@return ArrayValue<strict_value> family_args
function strict_value:unwrap_host_user_defined_type() end
---@return boolean
---@return { name: string } id
---@return ArrayValue<strict_value> family_args
function strict_value:as_host_user_defined_type() end
---@return boolean
function strict_value:is_host_nil_type() end
---@return nil
function strict_value:unwrap_host_nil_type() end
---@return boolean
function strict_value:as_host_nil_type() end
---@return boolean
function strict_value:is_host_tuple_value() end
---@return ArrayValue<any> elements
function strict_value:unwrap_host_tuple_value() end
---@return boolean
---@return ArrayValue<any> elements
function strict_value:as_host_tuple_value() end
---@return boolean
function strict_value:is_host_tuple_type() end
---@return strict_value desc
function strict_value:unwrap_host_tuple_type() end
---@return boolean
---@return strict_value desc
function strict_value:as_host_tuple_type() end
---@return boolean
function strict_value:is_singleton() end
---@return strict_value supertype
---@return strict_value value
function strict_value:unwrap_singleton() end
---@return boolean
---@return strict_value supertype
---@return strict_value value
function strict_value:as_singleton() end
---@return boolean
function strict_value:is_program_end() end
---@return strict_value result
function strict_value:unwrap_program_end() end
---@return boolean
---@return strict_value result
function strict_value:as_program_end() end
---@return boolean
function strict_value:is_program_cont() end
---@return table action
---@return strict_value argument
---@return strict_continuation continuation
function strict_value:unwrap_program_cont() end
---@return boolean
---@return table action
---@return strict_value argument
---@return strict_continuation continuation
function strict_value:as_program_cont() end
---@return boolean
function strict_value:is_effect_elem() end
---@return effect_id tag
function strict_value:unwrap_effect_elem() end
---@return boolean
---@return effect_id tag
function strict_value:as_effect_elem() end
---@return boolean
function strict_value:is_effect_type() end
---@return nil
function strict_value:unwrap_effect_type() end
---@return boolean
function strict_value:as_effect_type() end
---@return boolean
function strict_value:is_effect_row() end
---@return SetValue<table> components
function strict_value:unwrap_effect_row() end
---@return boolean
---@return SetValue<table> components
function strict_value:as_effect_row() end
---@return boolean
function strict_value:is_effect_row_type() end
---@return nil
function strict_value:unwrap_effect_row_type() end
---@return boolean
function strict_value:as_effect_row_type() end
---@return boolean
function strict_value:is_program_type() end
---@return strict_value effect_sig
---@return strict_value base_type
function strict_value:unwrap_program_type() end
---@return boolean
---@return strict_value effect_sig
---@return strict_value base_type
function strict_value:as_program_type() end
---@return boolean
function strict_value:is_srel_type() end
---@return strict_value target_type
function strict_value:unwrap_srel_type() end
---@return boolean
---@return strict_value target_type
function strict_value:as_srel_type() end
---@return boolean
function strict_value:is_variance_type() end
---@return strict_value target_type
function strict_value:unwrap_variance_type() end
---@return boolean
---@return strict_value target_type
function strict_value:as_variance_type() end
---@return boolean
function strict_value:is_intersection_type() end
---@return strict_value left
---@return strict_value right
function strict_value:unwrap_intersection_type() end
---@return boolean
---@return strict_value left
---@return strict_value right
function strict_value:as_intersection_type() end
---@return boolean
function strict_value:is_union_type() end
---@return strict_value left
---@return strict_value right
function strict_value:unwrap_union_type() end
---@return boolean
---@return strict_value left
---@return strict_value right
function strict_value:as_union_type() end

---@class (exact) strict_valueType: EnumType
---@field define_enum fun(self: strict_valueType, name: string, variants: Variants): strict_valueType
---@field visibility_type strict_value
---@field visibility fun(visibility: visibility): strict_value
---@field param_info_type strict_value
---@field param_info fun(visibility: strict_value): strict_value
---@field result_info_type strict_value
---@field result_info fun(result_info: result_info): strict_value
---@field pi fun(param_type: strict_value, param_info: strict_value, result_type: strict_value, result_info: strict_value): strict_value
---@field closure fun(param_name: string, code: typed, capture: strict_value, capture_dbg: var_debug, param_debug: var_debug): strict_value
---@field range fun(lower_bounds: ArrayValue<strict_value>, upper_bounds: ArrayValue<strict_value>, relation: strict_value): strict_value
---@field name_type strict_value
---@field name fun(name: string): strict_value
---@field operative_value fun(userdata: strict_value): strict_value
---@field operative_type fun(handler: strict_value, userdata_type: strict_value): strict_value
---@field tuple_value fun(elements: ArrayValue<strict_value>): strict_value
---@field tuple_type fun(desc: strict_value): strict_value
---@field tuple_desc_type fun(universe: strict_value): strict_value
---@field enum_value fun(constructor: string, arg: strict_value): strict_value
---@field enum_type fun(desc: strict_value): strict_value
---@field enum_desc_type fun(universe: strict_value): strict_value
---@field enum_desc_value fun(variants: MapValue<string, flex_value>): strict_value
---@field record_value fun(fields: MapValue<string, flex_value>): strict_value
---@field record_type fun(desc: strict_value): strict_value
---@field record_desc_type fun(universe: strict_value): strict_value
---@field object_value fun(methods: MapValue<string, typed>, capture: StrictRuntimeContext): strict_value
---@field object_type fun(desc: strict_value): strict_value
---@field star fun(level: number, depth: number): strict_value
---@field prop fun(level: number): strict_value
---@field host_value fun(host_value: any): strict_value
---@field host_type_type strict_value
---@field host_number_type strict_value
---@field host_bool_type strict_value
---@field host_string_type strict_value
---@field host_function_type fun(param_type: strict_value, result_type: strict_value, result_info: strict_value): strict_value
---@field host_wrapped_type fun(type: strict_value): strict_value
---@field host_unstrict_wrapped_type fun(type: strict_value): strict_value
---@field host_user_defined_type fun(id: { name: string }, family_args: ArrayValue<strict_value>): strict_value
---@field host_nil_type strict_value
---@field host_tuple_value fun(elements: ArrayValue<any>): strict_value
---@field host_tuple_type fun(desc: strict_value): strict_value
---@field singleton fun(supertype: strict_value, value: strict_value): strict_value
---@field program_end fun(result: strict_value): strict_value
---@field program_cont fun(action: table, argument: strict_value, continuation: strict_continuation): strict_value
---@field effect_elem fun(tag: effect_id): strict_value
---@field effect_type strict_value
---@field effect_row fun(components: SetValue<table>): strict_value
---@field effect_row_type strict_value
---@field program_type fun(effect_sig: strict_value, base_type: strict_value): strict_value
---@field srel_type fun(target_type: strict_value): strict_value
---@field variance_type fun(target_type: strict_value): strict_value
---@field intersection_type fun(left: strict_value, right: strict_value): strict_value
---@field union_type fun(left: strict_value, right: strict_value): strict_value
return {}
