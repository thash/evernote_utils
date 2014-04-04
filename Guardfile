guard :rspec, all_on_start: false, all_after_pass: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

## notification :gntp, sticky: true, host: '127.0.0.1'
notification :tmux,
  display_message: true, timeout: 10,
  default_message_format: '[%s] %s', line_separator: ' > ',
  color_location: 'status-left-bg'
