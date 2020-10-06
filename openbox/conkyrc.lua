conky.config = {
  alignment = 'top_middle',
  background = true,
  border_width = 1,
  cpu_avg_samples = 2,
  default_color = 'black',
  default_outline_color = 'white',
  default_shade_color = 'white',
  draw_borders = false,
  draw_graph_borders = true,
  draw_outline = false,
  draw_shades = false,
  use_xft = true,
  font = 'DejaVu Sans Mono:size=12',
  gap_x = 5,
  gap_y = 60,
  minimum_height = 5,
  minimum_width = 5,
  net_avg_samples = 2,
  no_buffers = true,
  out_to_console = false,
  out_to_stderr = false,
  extra_newline = false,
  own_window = false,
  own_window_class = 'Conky',
  own_window_type = 'desktop',
  stippled_borders = 0,
  update_interval = 1.0,
  uppercase = false,
  use_spacer = 'none',
  show_graph_scale = false,
  show_graph_range = false
}

conky.text = [[
KERNEL: $kernel | NET: ${execi 60 (ip addr | awk '/state UP/ {print $2}' | sed 's/.$//')} ${execi 60 cat /sys/class/net/$(ip addr | awk '/state UP/ {print $2}' | sed 's/.$//')/address } ${execi 60 hostname -I}
]]
