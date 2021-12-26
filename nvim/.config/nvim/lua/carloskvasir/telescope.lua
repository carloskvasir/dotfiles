require('telescope.builtin').buffers({ sort_lastused = true, ignore_current_buffer = true })
require('telescope').load_extension('fzf')
require('telescope').setup{
    defaults = {
        color_devicons = false,
        layout_config = {
            width = 0.7,
            horizontal = {
                preview_width = 0.6
            }
        }
    }
}
