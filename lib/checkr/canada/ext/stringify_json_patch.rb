# frozen_string_literal: true

# Fix setting body to '{}' when it is blank
module StringifyJsonPatch
  def build(env)
    return env unless env[:format] == "json"
    new_env = super
    new_env.delete(:body_string) if env[:body].nil? || env[:body].empty?
    new_env
  end
end
