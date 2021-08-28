# frozen_string_literal: true

require_relative 'dxruby_editor/version'

require 'pp'
require 'dxruby'
require 'ripper'

require_relative 'dxruby_editor/core/key_input'
require_relative 'dxruby_editor/core/mouse_input'
require_relative 'dxruby_editor/core/renderer'
require_relative 'dxruby_editor/core/command'
require_relative 'dxruby_editor/core/theme'
require_relative 'dxruby_editor/editor_context'
require_relative 'dxruby_editor/editor'

module DXRubyEditor
  class Error < StandardError; end
  # Your code goes here...
end
