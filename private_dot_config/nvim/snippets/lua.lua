require("luasnip.session.snippet_collection").clear_snippets "lua"

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local r = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("lua", {
  s(
    "snippet",
    fmt(
      [[
require("luasnip.session.snippet_collection").clear_snippets "{}"

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local r = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("{}", {{
{}
}})
  ]],
      { i(1), r(1), i(0) }
    )
  ),
})
