class ScrollablePage < RenderTarget
  attr_reader :pos
  attr_accessor :scrollbar, :scrollbar_base

  def initialize(width, height, bgcolor: [0, 0, 0, 0],
                 page_width: nil, page_height: nil,
                 bar_w: 16, bar_color: [200, 200, 200], bar_base_color: C_WHITE)
    super(width, height, bgcolor)
    @page_width = page_width || self.width
    @page_height = page_height || self.height

    @bar_h_per = [self.height.to_f / @page_height, 1].min
    @scrollbar = Image.new(bar_w, (self.height * @bar_h_per).to_i, bar_color)
    @scrollbar_base = Image.new(bar_w, self.height, bar_base_color)

    @pos = 0
    @_before_mouse_wheel = Input.mouse_wheel_pos
  end

  def draw_scrollbar
    draw(width - @scrollbar_base.width, @pos, @scrollbar_base)
    draw(width - @scrollbar.width + 1, @pos * @bar_h_per + @pos, @scrollbar)
  end

  def update
    scroll_volume = (@_before_mouse_wheel - Input.mouse_wheel_pos) / 120
    scroll_volume *= 50
    @_before_mouse_wheel = Input.mouse_wheel_pos

    @pos += scroll_volume
    @pos = [0, [@pos, @page_height - height].min].max
  end

  # wrapping methods
  def draw(x, y, image, z = 0)
    super(x, y - @pos, image, z)
  end

  def draw_scale(x, y, image, scale_x, scale_y, center_x = nil, center_y = nil, z = 0)
    super(x, y - @pos, image, scale_x, scale_y, center_x, center_y, z)
  end

  def draw_rot(x, y, image, angle, center_x = nil, center_y = nil, z = 0)
    super(x, y - @pos, image, angle, center_x, center_y, z)
  end

  def draw_alpha(x, y, image, alpha, z = 0)
    super(x, y - @pos, image, alpha, z)
  end

  def draw_add(x, y, image, z = 0)
    super(x, y - @pos, image, z)
  end

  def draw_sub(x, y, image, z = 0)
    super(x, y - @pos, image, z)
  end

  def draw_shader(x, y, image, shader, z = 0)
    super(x, y - @pos, image, shader, z)
  end

  def draw_ex(x, y, image, option = {})
    super(x, y - @pos, image, option)
  end

  def draw_font(x, y, text, font, option = {})
    super(x, y - @pos, text, font, option)
  end

  def draw_font_ex(x, y, text, font, option = {})
    super(x, y - @pos, text, font, option)
  end

  def draw_morph(x1, y1, x2, y2, x3, y3, x4, y4, image, option = {})
    super(x1, y1 - @pos, x2, y2 - @pos,
          x3, y3 - @pos, x4, y4 - @pos,
          image, option)
  end

  def draw_tile(base_x, base_y, map, image_array, start_x, start_y, size_x, size_y, z = 0)
    super(base_x, base_y - @pos, map, image_array, start_x, start_y, size_x, size_y, z)
  end

  def draw_pixel(x, y, color, z = 0)
    super(x, y - @pos, color, z)
  end

  def draw_line(x1, y1, x2, y2, color, z = 0)
    super(x1, y1 - @pos, x2, y2 - @pos, color, z)
  end

  def draw_box(x1, y1, x2, y2, color, z = 0)
    super(x1, y1 - @pos, x2, y2 - @pos, color, z)
  end

  def draw_box_fill(x1, y1, x2, y2, color, z = 0)
    super(x1, y1 - @pos, x2, y2 - @pos, color, z)
  end

  def draw_circle(x, y, r, color, z = 0)
    super(x, y - @pos, r, color, z)
  end

  def draw_circle_fill(x, y, r, color, z = 0)
    super(x, y - @pos, r, color, z)
  end
end
