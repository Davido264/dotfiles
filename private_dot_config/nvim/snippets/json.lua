require("luasnip.session.snippet_collection").clear_snippets "json"

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local r = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("json", {
  s(
    "jsconf",
    fmt(
      [[
{{
  "compilerOptions": {{
    "module": "commonjs",
    "target": "es6",
    "checkJs": true,
    "baseUrl": "."
  }},
  "include": [
    "src/**/*"
  ]
}}
  ]],
      {}
    )
  ),
  s(
    "c_sharpd",
    fmt(
      [[
{{
  "RoslynExtensionsOptions": {{
    "enableDecompilationSupport": true
  }}
}}
  ]],
      {}
    )
  ),
  s(
    "msbuild",
    fmt(
      [[
{{
  "msbuild": {{
    "enabled": true,
    "ToolsVersion": null,
    "VisualStudioVersion": null,
    "Configuration": null,
    "Platform": null,
    "EnablePackageAutoRestore": false,
    "MSBuildExtensionsPath": null,
    "TargetFrameworkRootPath": null,
    "MSBuildSDKsPath": null,
    "RoslynTargetsPath": null,
    "CscToolPath": null,
    "CscToolExe": null,
    "loadProjectsOnDemand": false,
    "GenerateBinaryLogs": false
  }}
}}
  ]],
      {}
    )
  ),
})
