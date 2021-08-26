module DXRubyEditor
  module Key
    @_old_keys = []

    @_pressed_keys = [
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
      # rubocop:disable Security/Eval
      @_int2keycode[eval("K_#{key}")] = key
    end

    def check_pressed_keys
      if !@_pressed_keys[0].nil? &&
        Input.key_down?(@_pressed_keys[0]) && @_pressed_keys[1] > 40
        keycode = @_int2keycode[@_pressed_keys[0]]
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

    def self.pressed?(keycode)
      Input.key_down?(keycode) &&
      @_pressed_keys[0] == keycode &&
      @_pressed_keys[1] > 40
    end
  end
end
