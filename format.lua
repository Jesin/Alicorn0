-- SPDX-License-Identifier: Apache-2.0
-- SPDX-FileCopyrightText: 2025 Fundament Software SPC <https://fundament.software>
local U = require "alicorn-utils"
local string_format = string.format

local lpeg = require "lpeg"
local P, C, Cg, Cc, Cmt, Ct, Cb, Cp, Cf, Cs, S, V, R =
	lpeg.P, lpeg.C, lpeg.Cg, lpeg.Cc, lpeg.Cmt, lpeg.Ct, lpeg.Cb, lpeg.Cp, lpeg.Cf, lpeg.Cs, lpeg.S, lpeg.V, lpeg.R

-- SLN
-- expressions, atoms, lists
-- documentation for the SLN: https://scopes.readthedocs.io/en/latest/dataformat/
-- a python SLN parser: https://github.com/salotz/python-sln/blob/master/src/sln/parser.py

local function DebugPrint(s, patt)
	patt = P(function()
		print(s)
		return true
	end) * patt
	return patt
end

---@class Anchor
---@field internal boolean
---@field id string
---@field line integer
---@field char integer
local Anchor = {}

local anchor_mt = {
	---@param fst Anchor
	---@param snd Anchor
	---@return boolean
	__lt = function(fst, snd)
		-- __lt(false, false) = false
		-- __lt(false, true) = true
		-- __lt(true, false) = false
		-- __lt(true, true) = false
		local fst_internal, snd_internal = fst.internal, snd.internal
		if not fst_internal and snd_internal then
			return true
		end
		if fst_internal == snd_internal then
			local fst_id, snd_id = fst.id, snd.id
			if fst_id < snd_id then
				return true
			end
			if fst_id == snd_id then
				local fst_line, snd_line = fst.line, snd.line
				if fst_line < snd_line then
					return true
				end
				if fst_line == snd_line then
					return fst.char < snd.char
				end
			end
		end
		return false
	end,
	---@param fst Anchor
	---@param snd Anchor
	---@return boolean
	__le = function(fst, snd)
		-- __lt(false, false) = false
		-- __lt(false, true) = true
		-- __lt(true, false) = false
		-- __lt(true, true) = false
		local fst_internal, snd_internal = fst.internal, snd.internal
		if not fst_internal or snd_internal then
			return true
		end
		if fst_internal == snd_internal then
			local fst_id, snd_id = fst.id, snd.id
			if fst_id < snd_id then
				return true
			end
			if fst_id == snd_id then
				local fst_line, snd_line = fst.line, snd.line
				if fst_line < snd_line then
					return true
				end
				if fst_line == snd_line then
					return fst.char <= snd.char
				end
			end
		end
		return false
	end,
	---@param fst Anchor
	---@param snd Anchor
	---@return boolean
	__eq = function(fst, snd)
		return fst.internal == snd.internal and fst.id == snd.id and fst.line == snd.line and fst.char == snd.char
	end,
	---@param self Anchor
	---@return string
	__tostring = function(self)
		local start_line, start_char = self.line, self.char
		local internal_prefix, internal_suffix = "", ""
		if self.internal then
			internal_prefix, internal_suffix = "⦃", "⦄"
		end
		return string_format(
			"%s%s%s:%s:%s",
			internal_prefix,
			tostring(self.id),
			internal_suffix,
			tostring(start_line),
			tostring(start_char)
		)
	end,
	__index = Anchor,
	__newindex = function(k, v)
		error(("Anchor is immutable and can't set %s to %s"):format(tostring(k), tostring(v)))
	end,
}

---@param internal boolean
---@param id string
---@param line integer
---@param char integer
---@return Anchor
local function create_anchor(internal, id, line, char)
	return setmetatable({
		internal = internal,
		id = id,
		line = line,
		char = char,
	}, anchor_mt)
end
create_anchor = U.memoize(create_anchor, false)

---@class Span
---@field start Anchor
---@field stop Anchor
local Span = {}

local span_mt = {
	---@param fst Span
	---@param snd Span
	---@return boolean
	__lt = function(fst, snd)
		-- __lt(false, false) = false
		-- __lt(false, true) = true
		-- __lt(true, false) = false
		-- __lt(true, true) = false
		local fst_start, snd_start = fst.start, snd.start
		local fst_internal, snd_internal = fst_start.internal, snd_start.internal
		if not fst_internal and snd_internal then
			return true
		end
		if fst_internal == snd_internal then
			local fst_id, snd_id = fst_start.id, snd_start.id
			if fst_id < snd_id then
				return true
			end
			if fst_id == snd_id then
				local fst_start_line, snd_start_line = fst_start.line, snd_start.line
				if fst_start_line < snd_start_line then
					return true
				end
				if fst_start_line == snd_start_line then
					local fst_start_char, snd_start_char = fst_start.char, snd_start.char
					if fst_start_char < snd_start_char then
						return true
					end
					if fst_start_char == snd_start_char then
						local fst_stop, snd_stop = fst.stop, snd.stop
						local fst_stop_line, snd_stop_line = fst_stop.line, snd_stop.line
						if fst_stop_line < snd_stop_line then
							return true
						end
						if fst_stop_line == snd_stop_line then
							return fst_stop.char < snd_stop.char
						end
					end
				end
			end
		end
		return false
	end,
	---@param fst Span
	---@param snd Span
	---@return boolean
	__le = function(fst, snd)
		-- __lt(false, false) = false
		-- __lt(false, true) = true
		-- __lt(true, false) = false
		-- __lt(true, true) = false
		local fst_start, snd_start = fst.start, snd.start
		local fst_internal, snd_internal = fst_start.internal, snd_start.internal
		if not fst_internal and snd_internal then
			return true
		end
		if fst_internal == snd_internal then
			local fst_id, snd_id = fst_start.id, snd_start.id
			if fst_id < snd_id then
				return true
			end
			if fst_id == snd_id then
				local fst_start_line, snd_start_line = fst_start.line, snd_start.line
				if fst_start_line < snd_start_line then
					return true
				end
				if fst_start_line == snd_start_line then
					local fst_start_char, snd_start_char = fst_start.char, snd_start.char
					if fst_start_char < snd_start_char then
						return true
					end
					if fst_start_char == snd_start_char then
						local fst_stop, snd_stop = fst.stop, snd.stop
						local fst_stop_line, snd_stop_line = fst_stop.line, snd_stop.line
						if fst_stop_line < snd_stop_line then
							return true
						end
						if fst_stop_line == snd_stop_line then
							return fst_stop.char <= snd_stop.char
						end
					end
				end
			end
		end
		return false
	end,
	---@param fst Span
	---@param snd Span
	---@return boolean
	__eq = function(fst, snd)
		return fst.start == snd.start and fst.stop == snd.stop
	end,
	---@param self Span
	---@return string
	__tostring = function(self)
		local start, stop = self.start, self.stop
		local start_line, stop_line = start.line, stop.line
		local internal_prefix, internal_suffix = "", ""
		if start.internal then
			internal_prefix, internal_suffix = "⦃", "⦄"
		end
		if start_line ~= stop_line then
			return string_format(
				"%s%s%s:%s:%s-%s:%s",
				internal_prefix,
				tostring(start.id),
				internal_suffix,
				tostring(start_line),
				tostring(start.char),
				tostring(stop_line),
				tostring(stop.char)
			)
		end
		local start_char, stop_char = start.char, stop.char
		if start_char ~= stop_char then
			return string_format(
				"%s%s%s:%s:%s-%s",
				internal_prefix,
				tostring(start.id),
				internal_suffix,
				tostring(start_line),
				tostring(start_char),
				tostring(stop_char)
			)
		end
		return string_format(
			"%s%s%s:%s:%s",
			internal_prefix,
			tostring(start.id),
			internal_suffix,
			tostring(start_line),
			tostring(start_char)
		)
	end,
	__index = Span,
	__newindex = function(k, v)
		error(("Span is immutable and can't set %s to %s"):format(tostring(k), tostring(v)))
	end,
}

---@param start Anchor
---@param stop Anchor
---@return Span
local function create_span(start, stop)
	if start.internal ~= stop.internal then
		error(("Span `internal` mismatch: %s, %s"):format(tostring(start), tostring(stop)))
	elseif start.id ~= stop.id then
		error(("Span `id` mismatch: %s, %s"):format(tostring(start), tostring(stop)))
	elseif start.line >= stop.line then
		if start.line > stop.line then
			error(("Span `line` mismatch: %s, %s"):format(tostring(start), tostring(stop)))
		elseif start.char > stop.char then
			error(("Span `char` mismatch: %s, %s"):format(tostring(start), tostring(stop)))
		end
	end
	return setmetatable({ start = start, stop = stop }, span_mt)
end
create_span = U.memoize(create_span, false)

---@param stop Anchor
---@return Span
function Anchor:span(stop)
	return create_span(self, stop)
end

lpeg.locale(lpeg)

local function create_element(capture)
	capture.span, capture.start_anchor, capture.stop_anchor = capture.start_anchor:span(capture.stop_anchor), nil, nil
	return capture
end

local function element(kind, pattern)
	return Ct(Cg(V "anchor", "start_anchor") * Cg(Cc(kind), "kind") * pattern) / create_element
end

local function symbol(value)
	return element("symbol", Cg(value, "str") * Cg(V "anchor", "stop_anchor"))
end

local function space_tokens(pattern)
	local token_spacer = S "\t " ^ 0
	return pattern * token_spacer
end

-- Incrementally Fold Repetitions at Match Time
-- incrementally fold the stack into actual tables to prevent stack overflows
local function IFRmt(pattern, numtimes)
	local repetition

	if numtimes == 0 then
		repetition = Cg(Ct(pattern ^ -1), "IFRmt_acc")
			* Cg(
					Cmt(Cb("IFRmt_acc") * pattern, function(_, _, prev, newval)
						table.insert(prev, newval)
						return true, prev
					end),
					"IFRmt_acc"
				)
				^ 0
	elseif numtimes > 0 then
		repetition = Cg(Ct(pattern), "IFRmt_acc")
			* Cg(
					Cmt(Cb("IFRmt_acc") * pattern, function(_, _, prev, newval)
						table.insert(prev, newval)
						return true, prev
					end),
					"IFRmt_acc"
				)
				^ (numtimes - 1)
	end

	-- / func can return multiple values which become multiple distinct captures
	-- which prevents needing to change the behavior of list
	repetition = repetition * (Cb("IFRmt_acc") / function(vals)
		return table.unpack(vals)
	end)

	return repetition
end

local function create_list(start_anchor, elements, stop_anchor)
	return {
		kind = "list",
		span = start_anchor:span(stop_anchor),
		elements = elements,
	}
end

local function list(pattern)
	return (V "anchor" * Ct(pattern) * V "anchor") / create_list
end

---@class Literal
---@field start_anchor Anchor
---@field kind LiteralKind
---@field literaltype LiteralType?
---@field val integer | table | nil

---@alias LiteralKind "list" | "symbol" | "string" | "literal"
---@alias LiteralType "u8" | "u16" | "u32" | "u64" | "i8" | "i16" | "i32" | "i64"  | "f32" | "f64" | "bytes" | "unit"

local function set_ffp_ctx(name, furthest_forward_ctx, start_anchor)
	if furthest_forward_ctx.start_anchor then
		if furthest_forward_ctx.start_anchor == start_anchor then
			local acc = true
			for i, v in ipairs(furthest_forward_ctx.expected) do
				acc = acc and not (v == name)
			end
			if acc then
				table.insert(furthest_forward_ctx.expected, name)
			end
		elseif furthest_forward_ctx.start_anchor < start_anchor then
			furthest_forward_ctx.start_anchor = start_anchor
			furthest_forward_ctx.expected = { name }
		end
	else
		furthest_forward_ctx.start_anchor = start_anchor
		furthest_forward_ctx.expected = { name }
	end
end

local function update_ffp(name, patt)
	-- stage the error
	-- if the pattern matches, erase the stage
	-- if the pattern doesn't match, the stage persists

	-- should there be some mechanism to not include the results of emptylines? ignore them?

	return patt
		+ (
			Cmt(lpeg.Carg(2) * V "anchor", function(_, _, furthest_forward_ctx, start_anchor)
				set_ffp_ctx(name, furthest_forward_ctx, start_anchor)

				return false
			end) * P(1) -- this segment always fails, so P(1) is to assure lpeg that this isn't an empty loop
		)
end

local function clear_ffp()
	return lpeg.Carg(2)
		/ function(furthest_forward_ctx)
			furthest_forward_ctx.start_anchor = nil
			furthest_forward_ctx.expected = nil
		end
end

local function create_literal(start_anchor, elements, stop_anchor)
	if stop_anchor == nil then
		U.debug_break()
	end
	local val = {
		span = start_anchor:span(stop_anchor),
		kind = "literal",
		literaltype = "bytes",
		val = {},
	}

	for char in elements:gmatch "." do
		table.insert(val.val, string.byte(char))
	end

	return val
end

local function erase(pattern)
	return pattern / {}
end

---@param f? (integer | function)
---@return Anchor
local function anchor_here(f)
	if type(f) ~= "function" then
		f = (f or 1) + 1
	end
	if debug then
		local info = debug.getinfo(f, "Sl")
		return create_anchor(true, "SYNTH:" .. info.source, info.currentline, 0)
	end

	return create_anchor(true, "SYNTH: <debug info disabled>", 0, 0)
end

---@param f? (integer | function)
---@return Span
local function span_here(f)
	if type(f) ~= "function" then
		f = (f or 1) + 1
	end
	local anchor = anchor_here(f)
	return create_span(anchor, anchor)
end

---@class LinePosition
---@field line integer
---@field pos integer
local LinePosition = {}

local line_position_mt = {
	__tostring = function(self)
		return "line " .. tostring(self.line) .. " starting at position " .. tostring(self.pos)
	end,
	__index = LinePosition,
}

local function create_line_position(pos, line)
	return setmetatable({ pos = pos, line = line }, line_position_mt)
end

local grammar = P {
	"ast",
	-- initializes empty capture groups at the start, remember to update when tracking new things!
	foreward = Cg(Cc(0), "indent_level"),

	ast = V "foreward" * list(
		IFRmt(V "empty_line" + ((V "newline" + V "filestart") * V "baselevel" * V "naked_list"), 0)
	) * V "eof" * clear_ffp(),

	-- either match the newline or match the beginning of the file
	filestart = Cmt(P "", function(_, mypos)
		return mypos == 1
	end),
	eof = P(-1),

	newline = (P "\r" ^ 0 * P "\n") * Cmt(lpeg.Carg(1), function(_, position, line_ctx)
		if line_ctx.positions[#line_ctx.positions].pos < position then
			-- print("new line! last line_ctx position:", tostring(line_ctx.positions[#line_ctx.positions]))
			line_ctx.positions[#line_ctx.positions + 1] =
				create_line_position(position, line_ctx.positions[#line_ctx.positions].line + 1)
		end

		return true
	end),
	empty_line = V "newline" * S "\t " ^ 0 * #(V "newline" + V "eof"),

	anchor = Cmt(lpeg.Carg(1), function(_, position, line_ctx)
		local line_index = #line_ctx.positions
		-- assert(line_ctx.positions[line_index].pos <= position, "assertion failed! anchor at " .. tostring(position) .. " means backtracking to before " .. tostring(line_ctx.positions[line_index]))

		while (position < line_ctx.positions[line_index].pos) and (0 < line_index) do
			line_index = line_index - 1
		end
		local simple_anchor = create_anchor(
			false,
			line_ctx.id,
			line_ctx.positions[line_index].line,
			position - line_ctx.positions[line_index].pos + 1
		)
		return true, simple_anchor
	end),

	count_tabs = update_ffp(
		"spaces should not be interspersed in indentation",
		Cmt(V "anchor" * C(S "\t " ^ 0), function(_, _, start_anchor, indentstring)
			if string.find(indentstring, " ") then
				return false
			end
			return true, string.len(indentstring)
		end)
	),

	-- use indent and dedent to control the expected indentation level of a context
	-- samedent is the token that is consumed on a newline

	indent = Cg(Cb("indent_level") / function(level)
		return math.max(0, level + 1)
	end, "indent_level"),
	dedent = Cg(Cb("indent_level") / function(level)
		return math.max(0, level - 1)
	end, "indent_level"),

	baselevel = update_ffp(
		"no indentation",
		Cmt(Cb("indent_level") * V "count_tabs", function(_, _, prev_indent, tabscount)
			return (prev_indent == 0) and (tabscount == 0)
		end)
	),

	blockline = update_ffp(
		"block level newline",
		V "newline"
			* Cmt(Cb("indent_level") * V "count_tabs", function(_, _, prev_indent, tabscount)
				return tabscount == prev_indent
			end)
	),

	superior_indent = update_ffp(
		"dedent",
		V "newline"
			* Cmt(Cb("indent_level") * V "count_tabs", function(_, _, prev_indent, tabscount)
				return tabscount <= prev_indent
			end)
	),

	subordinate_indent = update_ffp(
		"subordinate indent",
		V "newline"
			* Cmt(Cb("indent_level") * V "count_tabs", function(_, _, prev_indent, tabscount)
				local normalized_tabs = string.rep("\t", tabscount - prev_indent)
				return tabscount >= prev_indent, normalized_tabs
			end)
	),

	-- probably works but it doesn't have complex tests
	splice = P "${" * V "naked_list" * P "}" + P "$" * V "symbol",
	escape_chars = Cs(P [[\\]] / [[\]] + P [[\"]] / [["]] + P [[\n]] / "\n" + P [[\r]] / "\r" + P [[\t]] / "\t"),
	unicode_escape = P "\\u" * (V "hex_digit") ^ -4,

	string_literal = V "anchor" * Cs(
		(V "escape_chars" + V "unicode_escape" + C(1 - (S [["\]] + V "newline" + V "splice"))) ^ 1
	) * V "anchor" / create_literal,
	string = element(
		"string",
		P '"'
			* Cg(Ct((V "string_literal" + V "splice") ^ 0), "elements")
			* update_ffp('"', P '"')
			* Cg(V "anchor", "stop_anchor")
	),

	longstring_literal = V "anchor" * Cs(
		((V "subordinate_indent" + V "empty_line") + C((V "unicode_escape" + (1 - (V "newline" + V "splice"))))) ^ 1
	) * V "anchor" / create_literal,
	longstring = element(
		"string",
		P '""""'
			* V "indent"
			* Cg(Ct((V "longstring_literal" + V "splice") ^ 0), "elements")
			* Cg(V "anchor", "stop_anchor")
			* V "dedent"
	),

	comment_body = C((1 - V "newline") ^ 1),
	comment = update_ffp(
		"line comment",
		element("comment", (P "#" * Cg(V "comment_body" ^ -1, "val") * Cg(V "anchor", "stop_anchor")))
	),
	block_comment = update_ffp(
		"block comment",
		element(
			"comment",
			(
				P "####"
				* V "indent"
				* Cg(Cs((V "subordinate_indent" + V "comment_body" + V "empty_line") ^ 0), "val")
				* Cg(V "anchor", "stop_anchor")
				* V "dedent"
			)
		)
	),

	tokens = update_ffp(
		"token",
		space_tokens(
			V "comment"
				+ V "infix_brace"
				+ V "function_call"
				+ V "paren_list"
				+ V "longstring"
				+ V "string"
				+ V "number"
				+ V "symbol"
		)
	),

	semicolon = update_ffp(";", space_tokens(P ";") * (V "comment" * #(V "newline" + V "eof")) ^ -1),

	naked_list = V "empty_line"
		+ V "block_comment"
		+ (((V "tokens" * V "comment" ^ -1) + V "comment") * (V "empty_line" + (V "indent" * V "blockline" * V "block_comment" * V "dedent")) ^ 0 * #(V "superior_indent" + V "eof"))
		+ (list(V "tokens" ^ 0 * V "semicolon") * #(V "blockline" + V "eof"))
		+ list(
			(((list(V "tokens" ^ 1 * V "semicolon") + V "semicolon") ^ 1 * V "tokens" ^ 0) + V "tokens" ^ 1)
				* V "indent"
				* IFRmt(((V "blockline" * V "naked_list") + V "empty_line"), 0)
		),

	-- PARENTHETICAL LIST BEHAVIOR
	paren_spacers = (
		V "empty_line"
		+ (erase(V "subordinate_indent") * V "block_comment" * #(V "newline" + V "eof"))
		+ erase(V "subordinate_indent") --
		+ (V "comment" * #(V "newline" + V "eof"))
		+ S "\t " ^ 1
	) ^ 0,
	paren_tokens = update_ffp(
		"tokens",
		(
			(P [[\]] * V "paren_spacers" * V "naked_list") -- \ escape char enters naked list mode from inside a paren list. there's probably an edge case here, indentation is going to be wacky
			+ V "tokens"
		) * V "paren_spacers"
	),

	comma = update_ffp('","', P "," * V "paren_spacers"),
	comma_paren_body = ((list(IFRmt(V "paren_tokens", 2)) + V "paren_tokens") * V "comma") ^ 1
		* (list(IFRmt(V "paren_tokens", 2)) + V "paren_tokens"),

	braced_symbol = symbol(V "symbol_chars" ^ -1 * ((P "[_]" + P "{_}") * V "symbol_chars" ^ 0) ^ 1),
	infix_brace = V "braced_symbol" + list(
		Cg(C(V "symbol_chars" ^ 1), "braceacc")
			* ((V "open_bracket" + V "open_curly") * list(
					V "paren_spacers" * (V "comma_paren_body" + V "paren_tokens") ^ -1
				) * V "infix_braceclose_accumulator")
				^ 1
	) / function(list)
		--assert(list.elements["braceacc"])

		error("FIXME")
		table.insert(list.elements, 1, {
			kind = "symbol",
			str = list.elements["braceacc"],
			start_anchor = list.start_anchor,
		})

		list.elements["braceacc"] = nil

		return list
	end,

	infix_braceclose_accumulator = V "close_brace" * Cg(
		Cb("braceacc")
			* Cs(Cb("bracetype") / { ["["] = "[_]", ["{"] = "{_}" } * C(V "symbol_chars"))
			/ function(prev, new)
				return prev .. new
			end,
		"braceacc"
	),

	open_paren = Cg(C(P "("), "bracetype"),
	open_bracket = Cg(C(P "["), "bracetype"),
	open_curly = Cg(C(P "{"), "bracetype"),
	open_brace = (V "open_paren" * symbol(Cc("paren-list")))
		+ (V "open_bracket" * symbol(Cc("square-list")))
		+ (V "open_curly" * symbol(Cc("curly-list"))),
	close_brace = update_ffp(
		"matching close brace",
		Cmt(Cb("bracetype") * C(S "])}"), function(_, _, bracetype, brace)
			local matches = {
				["("] = ")",
				["["] = "]",
				["{"] = "}",
			}
			return matches[bracetype] == brace
		end)
	),

	inner_comma = element("comma", P "," * V "paren_spacers" * Cg(V "anchor", "stop_anchor")),
	inner_semicolon = element("semicolon", P ";" * V "paren_spacers" * Cg(V "anchor", "stop_anchor")),

	-- the original parenlist was more idiomatic but took quadratic time, so it has been bodged
	paren_list = Cmt(
		lpeg.Carg(2)
			* V "anchor"
			* V "open_brace"
			* V "indent"
			* V "paren_spacers"
			* Ct((V "paren_tokens" + V "inner_semicolon" + V "inner_comma") ^ 0)
			* ((V "dedent" * V "blockline") ^ -1 * V "close_brace")
			* V "anchor",
		function(_, _, ctx, list_start_anchor, brace, elements, list_stop_anchor)
			local found_semicolons = false
			local found_commas = false

			local acc = {}

			for _, v in ipairs(elements) do
				if v["kind"] and (v["kind"] == "semicolon") then
					if found_commas == true then
						set_ffp_ctx("comma", ctx, v.span.start)
						return false
					end
					found_semicolons = true
				elseif v["kind"] and (v["kind"] == "comma") then
					if found_semicolons == true then
						set_ffp_ctx("semicolon", ctx, v.span.start)
						return false
					end
					found_commas = true
				end
			end

			if found_semicolons then
				local semicolon_outer_acc = {}
				local semicolon_acc = {}

				for _, v in ipairs(elements) do
					if v["kind"] == "semicolon" then
						table.insert(
							semicolon_outer_acc,
							create_list(semicolon_acc[1].span.start, semicolon_acc, v.span.stop)
						)
						semicolon_acc = {}
					else
						table.insert(semicolon_acc, v)
					end
				end

				for _, v in ipairs(semicolon_acc) do
					table.insert(semicolon_outer_acc, v)
				end

				acc = semicolon_outer_acc
			elseif found_commas then
				local comma_outer_acc = {}
				local comma_acc = {}

				for _, v in ipairs(elements) do
					if v["kind"] == "comma" then
						if #comma_acc > 1 then
							table.insert(comma_outer_acc, create_list(comma_acc[1].span.start, comma_acc, v.span.stop))
						else
							table.insert(comma_outer_acc, comma_acc[1])
						end
						comma_acc = {}
					else
						table.insert(comma_acc, v)
					end
				end

				if #comma_acc > 1 then
					table.insert(comma_outer_acc, create_list(comma_acc[1].span.start, comma_acc, list_stop_anchor))
				elseif #comma_acc == 1 then
					table.insert(comma_outer_acc, comma_acc[1])
				end

				acc = comma_outer_acc
			else
				acc = elements
			end

			if brace["kind"] ~= "symbol" then
				error("kind not a symbol??")
			end
			if (brace["str"] == "square-list") or (brace["str"] == "curly-list") then
				table.insert(acc, 1, brace)
			end

			return true, create_list(list_start_anchor, acc, list_stop_anchor)
		end
	),

	function_call = V "symbol" * Ct(
		list(
			(
				V "open_paren"
				+ (V "open_bracket" * Cg(symbol(Cc("_[_]")), "brace"))
				+ (V "open_curly" * Cg(symbol(Cc("_{_}")), "brace"))
			)
				* V "paren_spacers"
				* (V "comma_paren_body" + list(V "paren_tokens" ^ 2) + V "paren_tokens") ^ -1
				* V "paren_spacers"
				* V "close_brace"
		) ^ 1
	) / function(symbol, argcalls)
		local acc = {}

		acc = table.remove(argcalls, 1)
		table.insert(acc.elements, 1, symbol)
		acc.start_anchor = symbol.start_anchor
		if acc.elements["brace"] then
			table.insert(acc.elements, 1, acc.elements["brace"])
			acc.elements[1].start_anchor = acc.start_anchor
		end

		for _, v in ipairs(argcalls) do
			table.insert(v.elements, 1, acc)
			v.start_anchor = acc.start_anchor
			acc = v

			if acc.elements["brace"] then
				table.insert(acc.elements, 1, acc.elements["brace"])
				acc.elements[1].start_anchor = acc.start_anchor
			end
		end

		return acc
	end,

	-- numbers are limited, they are not bignums, they are standard lua numbers. scopes shares the problem of files not having arbitrary precision
	-- so it probably doesn't matter.
	number = element(
		"literal",
		Cg((V "float_special" + V "hex" + V "big_e") / tonumber, "val") * V "types" * Cg(V "anchor", "stop_anchor")
	),
	types = Cg(
		(P ":" * C((S "iu" * (P "8" + P "16" + P "32" + P "64")) + (P "f" * (P "32" + P "64")))) + P "" / "f64",
		"literaltype"
	),
	digit = R("09") ^ 1,
	hex_digit = (V "digit" + R "AF" + R "af") ^ 1,
	decimal = S "-+" ^ -1 * V "digit" * (P "." * V "digit") ^ -1,
	hex = S "+-" ^ -1 * P "0x" * V "hex_digit" * (P "." * V "hex_digit") ^ -1,
	big_e = V "decimal" * (P "e" * V "decimal") ^ -1,
	float_special = P "+inf" + P "-inf" + P "nan",

	symbol_chars = (1 - (S '\\#()[]{};,"\t\r\n ' + lpeg.space)) ^ 1,
	symbol = symbol(V "symbol_chars"),
}

local function span_error(start_anchor, subject, msg)
	local lines = {}
	for line in subject:gmatch("([^\n\r]*)\r*\n") do
		table.insert(lines, line)
	end
	local line = lines[start_anchor.line] or ""

	local _, tabnum = line:gsub("\t", "")
	local caret_wsp = ("\t"):rep(tabnum) .. (" "):rep(start_anchor.char - (1 + tabnum))
	local linenum_wsp = (" "):rep(string.len(start_anchor.line))

	local span = string_format(
		[[
error: %s
--> %s:%i:%i
%s |
%i |%s
%s |%s^
	]],
		msg,
		start_anchor.id,
		start_anchor.line,
		start_anchor.char,
		linenum_wsp,
		start_anchor.line,
		line,
		linenum_wsp,
		caret_wsp
	)

	return span
end

---@class FormatList
---@field start_anchor Anchor
---@field stop_anchor Anchor
---@field kind LiteralKind
---@field elements table[]

---@param input string
---@param filename string
---@return FormatList?
local function parse(input, filename)
	if not filename then
		error("filename is required")
	end

	if not (string.len(input) > 0) then
		print("empty file")
		return nil
	end

	local line_ctx = {
		id = filename,
		positions = { create_line_position(1, 1) },
	}
	local furthest_forward_ctx = { start_anchor = nil }
	local ast = lpeg.match(grammar, input, 1, line_ctx, furthest_forward_ctx)

	if furthest_forward_ctx.start_anchor then
		local expected = "{"
		for i, v in ipairs(furthest_forward_ctx.expected) do
			expected = expected .. v .. ", "
		end
		expected = expected .. "}"

		error(span_error(furthest_forward_ctx.start_anchor, input, "expected " .. expected))
	end

	return ast
end

return {
	parse = parse,
	anchor_mt = anchor_mt,
	create_anchor = create_anchor,
	anchor_here = anchor_here,
	span_mt = span_mt,
	create_span = create_span,
	span_here = span_here,
}
