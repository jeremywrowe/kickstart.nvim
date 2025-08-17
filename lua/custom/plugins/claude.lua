-- Claude integration with tmux
return {
  -- This setup uses your existing vim-tmux-runner plugin
  {
    'christoomey/vim-tmux-runner',
    config = function()
      -- Create global functions to work with claude in tmux
      _G.setup_claude_tmux_pane = function()
        -- Configure for horizontal split (below) with 33% height
        vim.g.VtrOrientation = "v"  -- v for vertical split (which puts pane below)
        vim.g.VtrPercentage = 33
        
        -- Always open a new pane if it doesn't exist
        if vim.fn.exists('g:VTR_pane') == 0 or vim.g.VTR_pane == '' then
          vim.cmd('VtrOpenRunner')
          vim.cmd('VtrSendCommand "claude"')
        end
      end
      
      _G.send_to_claude = function()
        -- Get visual selection
        local visual_selection = vim.fn.getreg('"')
        if visual_selection and visual_selection ~= '' then
          vim.cmd('VtrSendCommand "' .. vim.fn.escape(visual_selection, '"') .. '"')
        else
          print("No text selected")
        end
      end
      
      -- Key mappings for working with Claude
      vim.keymap.set('n', '<leader>cc', _G.setup_claude_tmux_pane, { desc = 'Open Claude in tmux pane' })
      vim.keymap.set('v', '<leader>cs', function()
        -- Yank selection to register first
        vim.cmd('normal! y')
        _G.send_to_claude()
      end, { desc = 'Send selection to Claude' })
      
      -- Register in which-key
      require('which-key').register({
        ['<leader>c'] = {
          name = 'Claude',
          c = { _G.setup_claude_tmux_pane, 'Open Claude in tmux pane' },
          s = { _G.send_to_claude, 'Send to Claude' },
        },
      })
    end,
    dependencies = {
      'folke/which-key.nvim',
    },
  }
}