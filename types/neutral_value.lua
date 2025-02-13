-- THIS FILE AUTOGENERATED BY terms-gen-meta.lua
---@meta "types.neutral_value"

---@class (exact) neutral_value: EnumValue
neutral_value = {}

---@return boolean
function neutral_value:is_free() end
---@return free free
function neutral_value:unwrap_free() end
---@return boolean
---@return free free
function neutral_value:as_free() end
---@return boolean
function neutral_value:is_application_stuck() end
---@return neutral_value f
---@return value arg
function neutral_value:unwrap_application_stuck() end
---@return boolean
---@return neutral_value f
---@return value arg
function neutral_value:as_application_stuck() end
---@return boolean
function neutral_value:is_enum_elim_stuck() end
---@return value mechanism
---@return neutral_value subject
function neutral_value:unwrap_enum_elim_stuck() end
---@return boolean
---@return value mechanism
---@return neutral_value subject
function neutral_value:as_enum_elim_stuck() end
---@return boolean
function neutral_value:is_enum_rec_elim_stuck() end
---@return value handler
---@return neutral_value subject
function neutral_value:unwrap_enum_rec_elim_stuck() end
---@return boolean
---@return value handler
---@return neutral_value subject
function neutral_value:as_enum_rec_elim_stuck() end
---@return boolean
function neutral_value:is_object_elim_stuck() end
---@return value mechanism
---@return neutral_value subject
function neutral_value:unwrap_object_elim_stuck() end
---@return boolean
---@return value mechanism
---@return neutral_value subject
function neutral_value:as_object_elim_stuck() end
---@return boolean
function neutral_value:is_tuple_element_access_stuck() end
---@return neutral_value subject
---@return number index
function neutral_value:unwrap_tuple_element_access_stuck() end
---@return boolean
---@return neutral_value subject
---@return number index
function neutral_value:as_tuple_element_access_stuck() end
---@return boolean
function neutral_value:is_record_field_access_stuck() end
---@return neutral_value subject
---@return string field_name
function neutral_value:unwrap_record_field_access_stuck() end
---@return boolean
---@return neutral_value subject
---@return string field_name
function neutral_value:as_record_field_access_stuck() end
---@return boolean
function neutral_value:is_host_application_stuck() end
---@return any function
---@return neutral_value arg
function neutral_value:unwrap_host_application_stuck() end
---@return boolean
---@return any function
---@return neutral_value arg
function neutral_value:as_host_application_stuck() end
---@return boolean
function neutral_value:is_host_tuple_stuck() end
---@return ArrayValue leading
---@return neutral_value stuck_element
---@return ArrayValue trailing
function neutral_value:unwrap_host_tuple_stuck() end
---@return boolean
---@return ArrayValue leading
---@return neutral_value stuck_element
---@return ArrayValue trailing
function neutral_value:as_host_tuple_stuck() end
---@return boolean
function neutral_value:is_host_if_stuck() end
---@return neutral_value subject
---@return value consequent
---@return value alternate
function neutral_value:unwrap_host_if_stuck() end
---@return boolean
---@return neutral_value subject
---@return value consequent
---@return value alternate
function neutral_value:as_host_if_stuck() end
---@return boolean
function neutral_value:is_host_intrinsic_stuck() end
---@return neutral_value source
---@return Anchor start_anchor
function neutral_value:unwrap_host_intrinsic_stuck() end
---@return boolean
---@return neutral_value source
---@return Anchor start_anchor
function neutral_value:as_host_intrinsic_stuck() end
---@return boolean
function neutral_value:is_host_wrap_stuck() end
---@return neutral_value content
function neutral_value:unwrap_host_wrap_stuck() end
---@return boolean
---@return neutral_value content
function neutral_value:as_host_wrap_stuck() end
---@return boolean
function neutral_value:is_host_unwrap_stuck() end
---@return neutral_value container
function neutral_value:unwrap_host_unwrap_stuck() end
---@return boolean
---@return neutral_value container
function neutral_value:as_host_unwrap_stuck() end

---@class (exact) neutral_valueType: EnumType
---@field define_enum fun(self: neutral_valueType, name: string, variants: Variants): neutral_valueType
---@field free fun(free: free): neutral_value
---@field application_stuck fun(f: neutral_value, arg: value): neutral_value
---@field enum_elim_stuck fun(mechanism: value, subject: neutral_value): neutral_value
---@field enum_rec_elim_stuck fun(handler: value, subject: neutral_value): neutral_value
---@field object_elim_stuck fun(mechanism: value, subject: neutral_value): neutral_value
---@field tuple_element_access_stuck fun(subject: neutral_value, index: number): neutral_value
---@field record_field_access_stuck fun(subject: neutral_value, field_name: string): neutral_value
---@field host_application_stuck fun(function: any, arg: neutral_value): neutral_value
---@field host_tuple_stuck fun(leading: ArrayValue, stuck_element: neutral_value, trailing: ArrayValue): neutral_value
---@field host_if_stuck fun(subject: neutral_value, consequent: value, alternate: value): neutral_value
---@field host_intrinsic_stuck fun(source: neutral_value, start_anchor: Anchor): neutral_value
---@field host_wrap_stuck fun(content: neutral_value): neutral_value
---@field host_unwrap_stuck fun(container: neutral_value): neutral_value
return {}
