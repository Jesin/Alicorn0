local gen = require "terms-generators"
local derivers = require "derivers"
local terms = require "terms"

local value = terms.value

---@module "types.edgenotif"
local EdgeNotif = gen.declare_type()

local SubtypeRelation = terms.SubtypeRelation

-- stylua: ignore
EdgeNotif:define_enum("edgenotif", {
	{ "Constrain", {
		"left",  gen.builtin_number,
		"rel",  SubtypeRelation,
		"right", gen.builtin_number,
		"shallowest_block", gen.builtin_number,
		"cause",  terms.constraintcause,
	} },
	{ "CallLeft", {
		"left",  gen.builtin_number,
		"arg",  value,
		"rel",  SubtypeRelation,
		"right", gen.builtin_number,
		"shallowest_block", gen.builtin_number,
		"cause",  terms.constraintcause,
	} },
	{ "CallRight", {
		"left",  gen.builtin_number,
		"rel",  SubtypeRelation,
		"right", gen.builtin_number,
		"arg",  value,
		"shallowest_block", gen.builtin_number,
		"cause",  terms.constraintcause,
	} },
}
)

EdgeNotif:derive(derivers.pretty_print)

return { subtype_relation_mt = terms.subtype_relation_mt, SubtypeRelation = SubtypeRelation, EdgeNotif = EdgeNotif }
