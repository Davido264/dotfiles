require("luasnip.session.snippet_collection").clear_snippets "tex"

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local r = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("tex", {
  s(
    "image",
    fmt(
      [[
\begin{{figure}}[H]
  \begin{{center}}
    \includegraphics[width=\linewidth]{{{}}}
    \caption{{{}}}
  \end{{center}}
\end{{figure}}
    ]],
      { i(1, "image_path"), i(2, "caption") }
    )
  ),
  s(
    "head",
    fmt(
      [[
\documentclass{{{}}}
\usepackage[spanish,mexico-com]{{babel}}

\usepackage{{graphicx}} % soporte para imágenes
\usepackage{{float}} % forzar la posición de las figuras
\usepackage{{listings}} %soporte para resaltado de sintaxis al momento de escribir código
\usepackage{{hyperref}} % soporte para URLS
\usepackage{{natbib}} % cite
\usepackage{{apacite}} % apa


\title{{{}}}
\author{{David Ballesteros}}

\begin{{document}}
\maketitle
\end{{document}}
  ]],
      { i(1, "document type"), i(0) }
    )
  ),
  s("code", fmt([[\lstinline[language={}]{{{}}}]], { i(1, "lang"), i(0) })),
  s(
    "codeblk",
    fmt(
      [[
\begin{{verbatim}}
  {}
\end{{verbatim}}
  ]],
      { i(0) }
    )
  ),
  s(
    "codeblkminted",
    fmt(
      [[
\begin{{figure}}[H]
  \begin{{center}}
    \begin{{minted}}{{{}}}
      {}
    \end{{minted}}
  \end{{center}}
\end{{figure}}
  ]],
      { i(1, "lang"), i(2) }
    )
  ),
})
