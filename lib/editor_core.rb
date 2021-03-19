class EditorCore
  attr_accessor :content, :cursor_x, :cursor_y

  def initialize
    @content = ['']
    @cursor_x = 1
    @cursor_y = 1

    @_old_keys = []

    @_continuation_key_down = [
      # key(num), tick
      nil, 0,
    ]
    @_keys = {
      # keycode: [str, str(+shift)]
      "1": ['1', '!'],
      "2": ['2', '"'],
      "3": ['3', '#'],
      "4": ['4', '$'],
      "5": ['5', '%'],
      "6": ['6', '&'],
      "7": ['7', "'"],
      "8": ['8', '('],
      "9": ['9', ')'],
      "0": ['0', nil],
      "MINUS": ['-', '='],
      "PREVTRACK": ['^', '~'],
      "YEN": ["\\", '|'],
      "AT": ['@', '`'],
      "LBRACKET": ['[', '{'],
      "RBRACKET": [']', '}'],
      "SEMICOLON": [';', '+'],
      "COLON": [':', '*'],
      "COMMA": [',', '<'],
      "PERIOD": ['.', '>'],
      "SLASH": ['/', '?'],
      "BACKSLASH": ["\\", '_'],
      "SPACE": [' ', ' '],
    }
    ('A'..'Z').each do |c|
      @_keys[c.to_sym] = [c.downcase, c]
    end
    @_int2keycode = {}
    @_keys.each do |key, val|
      @_int2keycode[eval("K_#{key}")] = key
    end
  end

  def update_cursor(tick)
    # TODO ↑ に移動したとき
    # abc|③ de
    # f|②
    # ghi|①
    # みたいにしたい

    if Input.key_push?(K_RIGHT) || continuation_key_down?(K_RIGHT)
      @cursor_x += 1
      if @cursor_x >= @content[@cursor_y - 1].length + 2 && @cursor_y != @content.length
        @cursor_x = 0
        @cursor_y += 1
      end
    end

    if Input.key_push?(K_LEFT) || continuation_key_down?(K_LEFT)
      @cursor_x -= 1
      if @cursor_x <= 0 && @cursor_y > 1
        @cursor_x = @content[@cursor_y - 2].length + 1
        @cursor_y -= 1
      end
    end
    @cursor_y += 1 if Input.key_push?(K_DOWN)
    @cursor_y -= 1 if Input.key_push?(K_UP)

    @cursor_y = [[1, @cursor_y].max, @content.length].min
    @cursor_x = [[1, @cursor_x].max, @content[@cursor_y - 1].length + 1].min

    new_keys = Input.keys - @_old_keys
    if new_keys != []
      @_continuation_key_down = [new_keys[0], 0]
    end
    @_continuation_key_down[1] += 1 if !@_continuation_key_down[0].nil? && Input.key_down?(@_continuation_key_down[0])
    @_old_keys = Input.keys
  end

  def input(tick)
    update_cursor(tick)
    @_keys.each do |key, val|
      next unless Input.key_push?(eval("K_#{key}"))

      if Input.key_down?(K_LSHIFT) || Input.key_down?(K_RSHIFT)
        next if val[1].nil?
        @content[@cursor_y - 1].insert(@cursor_x - 1, val[1])
      else
        @content[@cursor_y - 1].insert(@cursor_x - 1, val[0])
      end
      @cursor_x += 1
    end
    check_continuation_key_down

    if Input.key_push?(K_RETURN) || continuation_key_down?(K_RETURN)
      if @cursor_x == 1
        slice_head = ''
        slice_tail = @content[@cursor_y - 1]
      else
        slice_head = @content[@cursor_y - 1][0..@cursor_x - 2]
        slice_tail = @content[@cursor_y - 1][@cursor_x - 1, @content[@cursor_y - 1].length - (@cursor_x - 1)]
      end
      @content[@cursor_y - 1] = slice_head
      @content.insert(@cursor_y, slice_tail)
      @cursor_x = 1
      @cursor_y += 1
    end
    if Input.key_push?(K_BACK) || continuation_key_down?(K_BACK)
      if @cursor_x == 1
        if @cursor_y != 1
          _x = @content[@cursor_y - 2].length + 1
          @content[@cursor_y - 2] << @content[@cursor_y - 1]
          @content.delete_at(@cursor_y - 1)
          @cursor_x = _x
          @cursor_y -= 1
        end
      else
        @content[@cursor_y - 1][@cursor_x - 2] = ''
      end
    end
  end

  def string
    str = ''
    @content.each do |_str|
      str << _str << "\n"
    end
    str
  end

  def check_continuation_key_down
    if !@_continuation_key_down[0].nil? && Input.key_down?(@_continuation_key_down[0]) && @_continuation_key_down[1] > 40
      keycode = @_int2keycode[@_continuation_key_down[0]]
      return nil if @_keys[keycode].nil?
      if Input.key_down?(K_LSHIFT) || Input.key_down?(K_RSHIFT)
        key = @_keys[keycode][1]
      else
        key = @_keys[keycode][0]
      end
      return nil if key.nil?

      @content[@cursor_y - 1].insert(@cursor_x - 1, key)
      @cursor_x += 1
    end
  end

  def continuation_key_down?(keycode)
    Input.key_down?(keycode) && @_continuation_key_down[0] == keycode && @_continuation_key_down[1] > 40
  end
end
