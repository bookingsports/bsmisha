json.partial! 'markers', stadiums: @stadiums

if params[:include_stadiums]
  json.stadiums "#{h render partial: @stadiums, formats: [:html]}"
end
