require "digest/md5"

module Payments::Utility
  def md5_string
    interpolate self.class.md5_string
  end

  def security_key
    Digest::MD5.hexdigest(md5_string).downcase
  end

  private

    def interpolate string
      string.gsub /\{([a-zA-Z_,]*)\}/ do |match|
        real_match = $1.split(",")
        case real_match.last
        when "m"
          ActionController::Base.helpers.number_with_precision send(real_match.first), precision: 2, separator: "."
        else
          send(real_match.first)
        end
      end
    end
end
