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
					post_process_command = function(cmd)
						-- Extract the test file path from the command
						-- Command format: {"elixir", ..., "-S", "mix", "test", ..., "test/path/file_test.exs"}
						local test_file = cmd[#cmd]
						
						-- Only process if it's a test file (not a directory)
						if test_file and test_file:match("_test%.exs$") then
							-- Read the test file to detect @moduletag
							local file = io.open(test_file, "r")
							if file then
								local content = file:read("*all")
								file:close()
								
								local tags_found = {}
								
								-- Look for @moduletag :tagname pattern
								for tag in content:gmatch("@moduletag%s+:([%w_]+)") do
									tags_found[tag] = true
								end
								
								-- Also handle @moduletag tagname: value syntax
								for tag in content:gmatch("@moduletag%s+([%w_]+):%s*[^%s]+") do
									tags_found[tag] = true
								end
								
								-- Insert --include flags before the test file path
								for tag, _ in pairs(tags_found) do
									table.insert(cmd, #cmd, "--include")
									table.insert(cmd, #cmd, tag .. ":true")
								end
							end
						end
						
						return cmd
					end
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
