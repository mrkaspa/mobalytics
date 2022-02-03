class RiotClient
  include HTTParty

  def initialize(url:, token:)
    @url = url
    @token = token
    self.class.base_uri(@url)
  end

  def get_summoner_info(summoner_id)
    self.class.get("/lol/summoner/v4/summoners/by-name/#{summoner_id}", {query: {api_key: @token}})
  end
end
