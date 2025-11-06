return {
  {
	  "mfussenegger/nvim-dap",
	  config = function()
		  require("dap").adapters.mix_task = {
			  type = "executable",
			  command = "/Users/sanmiguel/git/elixir-lsp/elixir-ls/release/debug_adapter.sh",
			  args = {}
		  }
		  require("dap").configurations.elixir = {
			  {
				  adapter = "mix_task",
				  type = "mix_task",
				  name = "mix test",
				  task = 'test',
				  taskArgs = {"--trace"},
				  request = "launch",
				  startApps = true, -- for Phoenix projects
				  projectDir = "${workspaceFolder}",
				  requireFiles = {
					  "test/**/test_helper.exs",
					  "test/**/*_test.exs"
				  }
			  },
		  }
	  end
  },
  "jfpedroza/neotest-elixir",
  {
      "nvim-neotest/neotest",
      dependencies = {
		  "nvim-neotest/nvim-nio",
		  "mfussenegger/nvim-dap",
          "nvim-lua/plenary.nvim",
          "antoinemadec/FixCursorHold.nvim",
          "nvim-treesitter/nvim-treesitter",
          "jfpedroza/neotest-elixir",
      },
	  config = function()
		  require("neotest").setup({
			  adapters = {
				  require("neotest-elixir"){
					args = { "--cover" }
				  }
			  }
		  })
	  end,
  },
  {
	  "andythigpen/nvim-coverage",
	  version = "*",
	  config = function()
		  require("coverage").setup({
			  highlights = {
				covered = { fg = "#B771F0" },
				uncovered = { fg = "#FA7167" },

			  },
			  auto_reload = true,
			  lang = {
				  elixir = {
					  coverage_file = ".sanmiguel/cover/lcov.info",
				  },
			  },
		  })
	  end,
  },
}
