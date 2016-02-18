class AddressParser
  def initialize(object)
    @object = object
  end

  def perform
    return unless @object.address.present?

    @object.update_columns(latitude: latitude, longitude: longitude)
  end

  private

    def latitude
      if parsed_address["results"].empty?
        nil
      else
        parsed_address["results"][0]["geometry"]["location"]["lat"]
      end
    end

    def longitude
      if parsed_address["results"].empty?
        nil
      else
        parsed_address["results"][0]["geometry"]["location"]["lng"]
      end
    end

    def parsed_address
      @parsed_address ||= JSON.parse(open("http://maps.googleapis.com/maps/api/geocode/json?address=" + escaped_address + "&sensor=false").read)
    end

    def escaped_address
      CGI::escape(@object.address)
    end
end
