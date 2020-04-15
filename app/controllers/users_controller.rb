class UsersController < ApplicationController
  require 'net/http'
  require 'uri'
  def index
    respond_to do |format|
      begin
        uri = URI.parse("https://www.lpga.com/tournaments/volvik-founders-cup/results?filters=2019&archive=")
        response = Net::HTTP.get_response(uri)
        parse_data = Nokogiri::HTML.parse(response.body)
        parse_data.search('.body').each do |data|
          name = data.search('.player-name').first.content
          score = data.search('.scores').first.content.gsub(/\s/,'')
          User.create!(name: name, score: score)
          # parsed_data.search('.body')[2].search('.player-name').first.content
          # parsed_data.search('.body')[2].search('.scores').first.content
        end
        return render json: {message: 'Records saved successfully'} 
      rescue Exception => e
        return render json: {error: 'Please try again'}
      end
    end
  end
end
