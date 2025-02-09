-- SPDX-License-Identifier: Apache-2.0
-- SPDX-FileCopyrightText: 2025 Fundament Software SPC <https://fundament.software>
local terms = require "terms"
local derivers = require "derivers"
local traits = require "traits"
local acg = require "libs.abstract-codegen"
local U = require "alicorn-utils"

-- minimal example:
-- ---@meta "purity.lua"

-- ---@class (exact) purity: EnumValue
-- purity = {}

-- ---@return boolean
-- function purity:is_effectful() end
-- ---@return nil
-- function purity:unwrap_effectful() end
-- ---@return boolean
-- function purity:as_effectful() end
-- ---@return boolean
-- function purity:is_pure() end
-- ---@return nil
-- function purity:unwrap_pure() end
-- ---@return boolean
-- function purity:as_pure() end

-- ---@class (exact) purityType: EnumType
-- ---@field define_enum fun(self: purityType, name: string, variants: Variants): purityType
-- ---@field effectful purity
-- ---@field pure purity
-- return {}

local meta_gen = acg.generator {
	file = [[
-- THIS FILE AUTOGENERATED BY terms-gen-meta.lua
---@meta "$filename"

$definition
]],

	record_definition = [[
---@class (exact) $typename: RecordValue
$typename = {}

$(
)methods

-- TODO: constructor annotation
---@class (exact) $moduletypename: RecordType
---@field define_record fun(self: $moduletypename, kind: string, params_with_types: ParamsWithTypes): $moduletypename
return {}]],

	enum_definition = [[
---@class (exact) $typename: EnumValue
$typename = {}

$(
)methods

---@class (exact) $moduletypename: EnumType
---@field define_enum fun(self: $moduletypename, name: string, variants: Variants): $moduletypename
$(
)constructors
return {}]],

	is_method = [[
---@return boolean
function $typename:is_$variant() end]],

	unwrap_method = [[
---@return $(
---@return )parts
function $typename:unwrap_$variant() end]],

	as_method = [[
---@return $(
---@return )parts
function $typename:as_$variant() end]],

	unit_constructor = [[---@field $variant $typename]],

	record_constructor = [[---@field $variant fun($(, )params): $typename]],
}

---@param info RecordDeriveInfo
local function build_meta_file_for_record(info)
	local kind = info.kind
	local params = info.params
	local params_types = info.params_types
	local methods = {}
	-- p(info)
	local params_ascribed = {}
	local unwraptypes = {}
	for i, param in ipairs(params) do
		local param_type = params_types[i]
		local ptype = traits.value_name:get(param_type).value_name()
		params_ascribed[#params_ascribed + 1] = param .. ": " .. ptype
		unwraptypes[#unwraptypes + 1] = ptype
	end
	local constructor = {
		kind = "record_constructor",
		typename = kind,
		variant = kind,
		params = params_ascribed,
	}
	methods[#methods + 1] = {
		kind = "unwrap_method",
		typename = kind,
		variant = kind,
		parts = unwraptypes,
	}
	return U.notail(meta_gen({
		kind = "file",
		filename = "types." .. kind,
		definition = {
			kind = "record_definition",
			typename = kind,
			moduletypename = kind .. "Type",
			methods = methods,
			constructor = constructor,
		},
	}))
end

---@param info EnumDeriveInfo
local function build_meta_file_for_enum(info)
	local name = info.name
	local variants = info.variants
	local methods = {}
	local constructors = {}
	-- p(info)
	for _, vname in ipairs(variants) do
		local vkind = name .. "." .. vname
		local vdata = variants[vname]
		local vtype = vdata.type
		local vinfo = vdata.info
		--p(vdata)
		local params_ascribed = {}
		local unwraptypes = {}
		local astypes = { "boolean" }
		if vtype == derivers.EnumDeriveInfoVariantKind.Record then
			for i, param in ipairs(vinfo.params) do
				local param_type = vinfo.params_types[i]
				local ptype = traits.value_name:get(param_type).value_name()
				params_ascribed[#params_ascribed + 1] = param .. ": " .. ptype
				unwraptypes[#unwraptypes + 1] = ptype .. " " .. param
				astypes[#astypes + 1] = ptype .. " " .. param
			end
			constructors[#constructors + 1] = {
				kind = "record_constructor",
				typename = name,
				variant = vname,
				params = params_ascribed,
			}
		elseif vtype == derivers.EnumDeriveInfoVariantKind.Unit then
			unwraptypes[#unwraptypes + 1] = "nil"
			constructors[#constructors + 1] = {
				kind = "unit_constructor",
				typename = name,
				variant = vname,
			}
		else
			p(vdata)
			error "unknown variant type"
		end
		methods[#methods + 1] = {
			kind = "is_method",
			typename = name,
			variant = vname,
		}
		methods[#methods + 1] = {
			kind = "unwrap_method",
			typename = name,
			variant = vname,
			parts = unwraptypes,
		}
		methods[#methods + 1] = {
			kind = "as_method",
			typename = name,
			variant = vname,
			parts = astypes,
		}
	end
	return U.notail(meta_gen({
		kind = "file",
		filename = "types." .. name,
		definition = {
			kind = "enum_definition",
			typename = name,
			moduletypename = name .. "Type",
			methods = methods,
			constructors = constructors,
		},
	}))
end

---@type Deriver
local gen_type = {
	record = function(t, info)
		local file = io.open("types/" .. info.kind .. ".lua", "wb")
		if file then
			file:write(build_meta_file_for_record(info))
			file:close()
		end
	end,
	enum = function(t, info)
		local file = io.open("types/" .. info.name .. ".lua", "wb")
		if file then
			file:write(build_meta_file_for_enum(info))
			file:close()
		end
	end,
}

for i, k, v in U.table_stable_pairs(terms) do
	if k and type(v) == "table" and v.derive then
		---@cast v Type
		v:derive(gen_type)
		-- print(k)
		-- for a, b in pairs(v.meta) do
		--     print("", a, b)
		-- end
		-- for a, b in pairs(getmetatable(v)) do
		--     print(a, b)
		-- end
	end
end

local aux = require "evaluator-types"

for i, k, v in U.table_stable_pairs(aux) do
	if k and type(v) == "table" and v.derive then
		---@cast v Type
		v:derive(gen_type)
	end
end

return {}
