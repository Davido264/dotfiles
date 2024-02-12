return {
    "Olical/conjure",
    ft = { "clojure" }, -- etc
    -- [Optional] cmp-conjure for cmp
    dependencies = {
        {
            "PaterJason/cmp-conjure",
            config = function()
                local cmp = require("cmp")
                local config = cmp.get_config()
                table.insert(config.sources, {
                    name = "buffer",
                    option = {
                        sources = {
                            { name = "conjure" },
                        },
                    },
                })
                cmp.setup(config)
            end,
        },
    },
    config = function(_, _)
        require("conjure.main").main()
        require("conjure.mapping")["on-filetype"]()
    end,
    init = function()
        vim.g["conjure#debug"] = false
        vim.g["conjure#mapping#doc_word"] = false
        vim.g["conjure#mapping#doc_word"] = "gk"
        vim.g["conjure#mapping#prefix"] = "."
        vim.g["conjure#filetypes"] = {
          "clojure",
          "fennel",
          "janet",
          "julia",
          "racket",
          "scheme",
          "lisp",
          "sql"
        }
    end,
}
