return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-lua/plenary.nvim",
    },
    {
      "nvim-lua/popup.nvim",
    },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
    {
      "nvim-telescope/telescope-ui-select.nvim",
    },
    {
      "debugloop/telescope-undo.nvim",
    },
  },
  cmd = "Telescope",
  keys = {
    {
      "<leader>,",
      function()
        require("telescope.builtin").buffers { sort_mru = true, sort_lastused = true }
      end,
      desc = "Switch to Buffer",
      silent = true,
    },
    {
      "<leader>af",
      function()
        require("telescope.builtin").find_files { hidden = true }
      end,
      desc = "All files",
      silent = true,
    },
    {
      "<leader>ff",
      function()
        local ok, _ = pcall(require("telescope.builtin").git_files)
        if not ok then
          require("telescope.builtin").find_files { hidden = true }
        end
      end,
      desc = "Git files",
      silent = true,
    },
    {
      "<leader>/",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Live grep",
      silent = true,
    },
    {
      "<leader>vo",
      function()
        require("telescope.builtin").vim_options()
      end,
      desc = "Vim Options",
      silent = true,
    },
    {
      "<leader>h",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Help Tags",
      silent = true,
    },
    { -- lazy style key map
      "<leader>u",
      "<cmd>Telescope undo<cr>",
      desc = "undo history",
    }
  },
  config = function()
    local actions = require "telescope.actions"
    local actions_layout = require "telescope.actions.layout"
    local disabled_action = function(_) end

    local imode_mappings = {
      -- Close
      ["<Esc>"] = actions.close,
      ["<M-p>"] = actions_layout.toggle_preview,

      -- Navigation
      ["<C-n>"] = actions.move_selection_next,
      ["<C-p>"] = actions.move_selection_previous,
      ["<Tab>"] = disabled_action,
      ["<S-Tab>"] = disabled_action,
      -- Selection
      ["<CR>"] = actions.select_default,

      -- Scroll
      ["<C-u>"] = actions.preview_scrolling_up,
      ["<C-d>"] = actions.preview_scrolling_down,
      ["<C-k>"] = actions.results_scrolling_up,
      ["<C-j>"] = actions.results_scrolling_down,
    }

    require("telescope").setup {
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {},
        },
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
      undo = {
        side_by_side = true,
        layout_strategy = "vertical",
        layout_config = {
          preview_height = 0.8,
        },
      },
      defaults = {
        preview = { hide_on_startup = true },
        prompt_prefix = "> ",
        color_devicons = true,
        file_ignore_patterns = {
          "%.pyc$",
          "[/\\]_build[/\\]",
          "[/\\]coverage[/\\]",
          "[/\\]node_modules[/\\]",
          "[/\\]android[/\\]",
          "[/\\]ios[/\\]",
          "[/\\]%.git[/\\]",
          "%.exe$",
          "[/\\]__pycache__[/\\]",
          "[/\\]build[/\\]",
          "[/\\]obj[/\\]",
          "[/\\]%.env[/\\]",
          "[/\\]%.direnv[/\\]",
          "[/\\]%.venv[/\\]",
        },
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--trim",
        },

        mappings = {
          i = imode_mappings,
        },

        -- theme
        layout_strategy = "bottom_pane",
        layout_config = {
          height = 15,
          prompt_position = "bottom",
        },
        sorting_strategy = "descending",
        border = true,
        borderchars = {
          results = { "─", " ", " ", " ", "─", "─", " ", " " },
          prompt = { " " },
          preview = { "─", " ", " ", " ", "─", "─", " ", " " },
        },
      },
    }

    require("telescope").load_extension "fzf"
    require("telescope").load_extension "ui-select"
    require("telescope").load_extension "undo"
  end,
}
