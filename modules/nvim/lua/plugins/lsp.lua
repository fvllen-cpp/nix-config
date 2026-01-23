return {
    {
	"neovim/nvim-lspconfig",
	opts = {
	    servers = {
		clangd = { 
		    cmd = { "clangd", "--background-index" },
		    filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
		},

		pyright = {
		    settings = {
			python = {
			    analysis = {
				typeCheckingMode = "basic",
			    }
			}
		    }
		},
	    }
	}
    }
}
