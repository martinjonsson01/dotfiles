{
  lib,
  config,
  ...
}:
with lib; {
  plugins.grug-far = {
    enable = false;

    lazyLoad.settings.cmd = "GrugFar";
  };

  extraConfigLuaPre = ''
    function grug_open_smart(search_globally)
    	local start_line = vim.fn.line("'<")
    	local end_line = vim.fn.line("'>")
    	local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")

    	local config = {
    		transient = true, -- the buffer will be unlisted and fully deletes itself when not in use
    		prefills = {
    			paths = search_globally and "" or vim.fn.expand("%"), -- Limit to current file
    			flags = start_line ~= end_line and "--multiline" or "", -- intelligently enable multiline mode if selection spans multiple lines
    			filesFilter = ext and ext ~= "" and "*." .. ext or nil, -- limit search to files of same type as current file
    		},
    	}

    	local mode = vim.fn.mode()
    	local has_visual_selection = mode == "v" or mode == "V"
    	if has_visual_selection then
    		return require("grug-far").with_visual_selection(config) -- Launch with the current visual selection
    	else
    		return require("grug-far").open(config)
    	end
    end

    function grug_bind_toggle_flag(key, flag)
    	vim.keymap.set("n", "<localleader>" .. key, function()
    		local state = unpack(require("grug-far").get_instance(0):toggle_flags({ flag }))
    		vim.notify("grug-far: toggled " .. flag .. " " .. (state and "ON" or "OFF"))
    	end, { buffer = true })
    end
  '';

  keymaps = mkIf config.plugins.grug-far.enable [
    {
      mode = ["n" "x"];
      key = "<C-f>";
      action.__raw = "function() grug_open_smart(false) end";
      options = {
        desc = "Find and replace in current file";
      };
    }
    {
      mode = ["n" "x"];
      key = "<leader>h";
      action.__raw = "function() grug_open_smart(true) end";
      options = {
        desc = "Find and replace globally";
      };
    }
  ];

  autoGroups = mkIf config.plugins.grug-far.enable {
    toggle_grug_multiline = {};
    toggle_grug_fixed_strings = {};
  };

  autoCmd = mkIf config.plugins.grug-far.enable [
    {
      group = "toggle_grug_multiline";
      event = ["FileType"];
      pattern = "grug-far";
      callback.__raw = ''function() grug_bind_toggle_flag("m", "--multiline") end'';
    }
    {
      group = "toggle_grug_fixed_strings";
      event = ["FileType"];
      pattern = "grug-far";
      callback.__raw = ''function() grug_bind_toggle_flag("z", "--fixed-strings") end'';
    }
  ];
}
