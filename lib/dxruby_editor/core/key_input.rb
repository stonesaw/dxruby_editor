module DXRubyEditor
  module Core
    module KeyInput
      @@_old_keys = []
      @@_record_pressed_key = [
        # key(num), tick
        nil, 0
      ]
      @@_keys = {
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
        "YEN": ['\\', '|'],
        "AT": ['@', '`'],
        "LBRACKET": ['[', '{'],
        "RBRACKET": [']', '}'],
        "SEMICOLON": [';', '+'],
        "COLON": [':', '*'],
        "COMMA": [',', '<'],
        "PERIOD": ['.', '>'],
        "SLASH": ['/', '?'],
        "BACKSLASH": ['\\', '_'],
        "SPACE": [' ', ' ']
      }
      ('A'..'Z').each do |c|
        @@_keys[c.to_sym] = [c.downcase, c]
      end
      @@_int2keycode = {}
      @@_keycode2int = {}
      @@_keys.each do |key, _val|
        # rubocop:disable Security/Eval
        @@_int2keycode[eval("K_#{key}")] = key
        @@_keycode2int[:"K_#{key}"] = eval("K_#{key}")
      end

      # @param [EditorContext] context
      module_function def update(context)
        _update # update key record
        update_cursor(context)

        @@_keys.each do |key, val|
          next unless pressed?(@@_keycode2int[:"K_#{key}"])

          if Input.key_down?(K_LSHIFT) || Input.key_down?(K_RSHIFT) # uppercase
            next if val[1].nil?

            context.text[context.cursor_y - 1].insert(context.cursor_x - 1, val[1])
          else # lowercase
            context.text[context.cursor_y - 1].insert(context.cursor_x - 1, val[0])
          end
          context.cursor_x += 1
        end

        if pressed?(K_RETURN)
          slice_head = context.text[context.cursor_y - 1][0...context.cursor_x - 1]
          slice_tail = context.text[context.cursor_y - 1][context.cursor_x - 1..-1]
          context.text[context.cursor_y - 1] = slice_head
          context.text.insert(context.cursor_y, slice_tail)
          context.cursor_x = 1
          context.cursor_y += 1
        end
        if pressed?(K_BACK)
          if context.cursor_x == 1
            if context.cursor_y != 1
              _x = context.text[context.cursor_y - 2].length + 1
              context.text[context.cursor_y - 2] << context.text[context.cursor_y - 1]
              context.text.delete_at(context.cursor_y - 1)
              context.cursor_x = _x
              context.cursor_y -= 1
            end
          else
            context.text[context.cursor_y - 1][context.cursor_x - 2] = ''
            context.cursor_x -= 1
          end
        end
        if pressed?(K_DELETE)
          if context.cursor_x == context.text[context.cursor_y - 1].length + 1
            if context.cursor_y != context.text.length
              context.text[context.cursor_y - 1] << context.text[context.cursor_y]
              context.text.delete_at(context.cursor_y)
            end
          else
            context.text[context.cursor_y - 1][context.cursor_x - 1] = ''
          end
        end
        if pressed?(K_TAB)
          space = context.tab_size - (context.cursor_x - 1) % context.tab_size
          context.text[context.cursor_y - 1].insert(context.cursor_x - 1, ' ' * space)
          context.cursor_x += space
        end
      end

      module_function def _update
        new_keys = Input.keys - @@_old_keys
        @@_record_pressed_key = [new_keys[0], 0] if new_keys != []
        if !@@_record_pressed_key[0].nil? && Input.key_down?(@@_record_pressed_key[0])
          @@_record_pressed_key[1] += 1
        end
        @@_old_keys = Input.keys
      end

      module_function def kept_pressed?(keycode)
        Input.key_down?(keycode) &&
        @@_record_pressed_key[0] == keycode &&
        @@_record_pressed_key[1] > 40 # <- waiting frames
      end

      module_function def pressed?(keycode)
        Input.key_push?(keycode) || kept_pressed?(keycode)
      end

      class << self
        def update_cursor(context)
          # TODO: Ctrl で単語ごとに移動
          # if Input.key_down?(K_LCONTROL) || Input.key_down?(K_RCONTROL)
          # end

          if pressed?(K_RIGHT)
            context.cursor_x += 1
            if context.cursor_x >= context.text[context.cursor_y - 1].length + 2 &&
               context.cursor_y != context.text.length
              context.cursor_x = 0
              context.cursor_y += 1
            end
          end
          if pressed?(K_LEFT)
            context.cursor_x -= 1
            if context.cursor_x <= 0 && context.cursor_y > 1
              context.cursor_x = context.text[context.cursor_y - 2].length + 1
              context.cursor_y -= 1
            end
          end
          if pressed?(K_DOWN)
            context.cursor_y += 1
            if context.cursor_y > context.text.length
              context.cursor_x = context.text[context.cursor_y - 2].length + 1
            end
          end
          if pressed?(K_UP)
            context.cursor_y -= 1
            context.cursor_x = 0 if context.cursor_y < 1
          end

          context.cursor_y = [[1, context.cursor_y].max, context.text.length].min
          context.cursor_x = [[1, context.cursor_x].max, context.text[context.cursor_y - 1].length + 1].min
        end
      end
    end
  end
end
