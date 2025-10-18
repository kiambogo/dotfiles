local M = {}

-- Cache workspace root to avoid repeated system calls
local workspace_cache = nil

local function get_workspace_root()
	if not workspace_cache then
		local result = vim.fn.systemlist('bazel info workspace 2>/dev/null')[1]
		if result and result ~= '' then
			workspace_cache = result
		end
	end
	return workspace_cache
end

-- Helper function for file navigation from terminal
local function navigate_to_file_from_terminal()
	local line = vim.api.nvim_get_current_line()
	local patterns = {
		'([%w_/.-]+%.%w+):(%d+):?(%d*)',  -- file.ext:line:col or file.ext:line
		'([%w_/.-]+%.%w+)%((%d+)%)',       -- file.ext(line)
		'%s+([%w_/.-]+%.%w+):(%d+)',       -- whitespace then file:line
	}

	for _, pattern in ipairs(patterns) do
		local file, line_num, col = line:match(pattern)
		if file and line_num then
			-- Convert relative paths to absolute if needed
			if not file:match('^/') then
				local workspace_root = get_workspace_root()
				if workspace_root then
					file = workspace_root .. '/' .. file
				end
			end

			-- Check if file exists
			if vim.fn.filereadable(file) == 1 then
				vim.cmd('close')
				vim.cmd('edit ' .. vim.fn.fnameescape(file))
				vim.cmd(line_num)
				if col and col ~= '' then
					vim.cmd('normal! ' .. col .. '|')
				end
				return
			end
		end
	end
end

-- Helper function to setup auto-scroll
local function setup_auto_scroll(bufnr)
	local auto_scroll = true

	vim.api.nvim_create_autocmd({'TextChanged', 'TextChangedI', 'TextChangedP'}, {
		buffer = bufnr,
		callback = function()
			if auto_scroll then
				vim.schedule(function()
					local win = vim.fn.bufwinid(bufnr)
					if win ~= -1 then
						local line_count = vim.api.nvim_buf_line_count(bufnr)
						vim.api.nvim_win_set_cursor(win, {line_count, 0})
					end
				end)
			end
		end,
	})

	vim.keymap.set('n', 'k', function()
		auto_scroll = false
		vim.cmd('normal! k')
	end, { buffer = bufnr, noremap = true, silent = true })

	vim.keymap.set('n', 'j', function()
		local line_count = vim.api.nvim_buf_line_count(bufnr)
		local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
		if cursor_line >= line_count - 1 then
			auto_scroll = true
		end
		vim.cmd('normal! j')
	end, { buffer = bufnr, noremap = true, silent = true })
end

-- Helper function to setup terminal buffer with navigation
local function setup_bazel_terminal(bufnr)
	vim.cmd('setlocal nobuflisted')
	vim.cmd('setlocal nonumber')
	vim.cmd('setlocal scrolloff=0')

	-- Close keybindings
	vim.keymap.set('n', 'q', ':close<CR>', { buffer = bufnr, noremap = true, silent = true })
	vim.keymap.set('n', '<Esc>', ':close<CR>', { buffer = bufnr, noremap = true, silent = true })

	-- File navigation on Enter
	vim.keymap.set('n', '<CR>', navigate_to_file_from_terminal, { buffer = bufnr, noremap = true, silent = true })

	-- Auto-scroll setup
	setup_auto_scroll(bufnr)

	vim.cmd('stopinsert')
	vim.cmd('wincmd p')
end

-- Helper to run bazel command in terminal
local function run_bazel_command(command)
	vim.cmd('botright 15split | terminal ' .. command)
	local bufnr = vim.api.nvim_get_current_buf()
	setup_bazel_terminal(bufnr)
end

-- Function to find the Bazel target for the current file
function M.get_current_target()
	local current_file = vim.fn.expand('%:t')
	local current_dir = vim.fn.expand('%:p:h')

	-- Look for BUILD or BUILD.bazel in current directory
	local build_file = nil
	if vim.fn.filereadable(current_dir .. '/BUILD') == 1 then
		build_file = current_dir .. '/BUILD'
	elseif vim.fn.filereadable(current_dir .. '/BUILD.bazel') == 1 then
		build_file = current_dir .. '/BUILD.bazel'
	end

	if not build_file then
		return nil
	end

	-- Read the BUILD file and search for targets that reference this file
	local build_content = vim.fn.readfile(build_file)
	local current_target = nil
	local in_target = false
	local target_name = nil
	local paren_depth = 0

	for _, line in ipairs(build_content) do
		-- Check if we're starting a target definition
		if line:match('^%s*[a-z_]+%s*%(') then
			in_target = true
			paren_depth = (line:match('%(') and 1 or 0) - (line:match('%)') and 1 or 0)
			target_name = nil
		end

		if in_target then
			-- Track parentheses depth
			for c in line:gmatch('.') do
				if c == '(' then paren_depth = paren_depth + 1
				elseif c == ')' then paren_depth = paren_depth - 1
				end
			end

			-- Extract target name
			local name_match = line:match('name%s*=%s*["\']([^"\']+)["\']')
			if name_match then
				target_name = name_match
			end

			-- Check if this line references our current file
			if line:match('"' .. current_file .. '"') or line:match("'" .. current_file .. "'") then
				if target_name then
					current_target = target_name
					break
				end
			end

			-- Check if target definition ended
			if paren_depth <= 0 then
				in_target = false
				target_name = nil
			end
		end
	end

	if current_target then
		-- Get package path relative to workspace root
		local package_path = current_dir
		local workspace_root = get_workspace_root()

		if workspace_root then
			-- Remove workspace root to get relative path
			package_path = package_path:gsub('^' .. vim.pesc(workspace_root .. '/'), '')
			return '//' .. package_path .. ':' .. current_target
		else
			-- Fallback: use directory name
			return '//' .. vim.fn.fnamemodify(current_dir, ':t') .. ':' .. current_target
		end
	end

	return nil
end

-- Function to test the current target
function M.test_current_target()
	local current_dir = vim.fn.expand('%:p:h')
	local workspace_root = get_workspace_root()

	if not workspace_root then
		vim.notify('Could not find Bazel workspace root', vim.log.levels.ERROR)
		return
	end

	-- Remove workspace root to get relative path
	local package_path = current_dir:gsub('^' .. vim.pesc(workspace_root .. '/'), '')
	local test_target = '//' .. package_path .. '/...'

	run_bazel_command('bazel test ' .. test_target)
end

-- Function to build the current target
function M.build_current_target()
	local target = M.get_current_target()

	if target then
		run_bazel_command('bazel build ' .. target)
	else
		vim.notify('Could not find Bazel target for current file', vim.log.levels.WARN)
	end
end

return M
