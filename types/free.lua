-- THIS FILE AUTOGENERATED BY terms-gen-meta.lua
---@meta "types.free"

---@class (exact) free: EnumValue
free = {}

---@return boolean
function free:is_metavariable() end
---@return Metavariable metavariable
function free:unwrap_metavariable() end
---@return boolean
---@return Metavariable metavariable
function free:as_metavariable() end
---@return boolean
function free:is_placeholder() end
---@return integer index
---@return spanned_name debug
function free:unwrap_placeholder() end
---@return boolean
---@return integer index
---@return spanned_name debug
function free:as_placeholder() end
---@return boolean
function free:is_unique() end
---@return table id
function free:unwrap_unique() end
---@return boolean
---@return table id
function free:as_unique() end

---@class (exact) freeType: EnumType
---@field define_enum fun(self: freeType, name: string, variants: Variants): freeType
---@field metavariable fun(metavariable: Metavariable): free
---@field placeholder fun(index: integer, debug: spanned_name): free
---@field unique fun(id: table): free
return {}
