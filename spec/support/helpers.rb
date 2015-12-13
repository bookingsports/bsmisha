require "support/helpers/session_helpers"
require "support/helpers/setup_helpers"

RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include TennisHelpers::SetupHelpers
end
