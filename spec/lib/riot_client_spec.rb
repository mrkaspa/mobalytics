require "rails_helper"
require "lib/riot_client"

RSpec.describe RiotClient do
  describe "#get_summoner_info" do
    let(:username) { "mrkaspa07" }
    let(:riot_client) do
      RiotClient.new(
        url: Rails.application.config.riot_url,
        token: Rails.application.config.riot_token,
      )
    end

    it "fetch the summoner info" do
      VCR.use_cassette("get_summoner") do
        data = riot_client.get_summoner_info(username)
        expect(data["name"]).to eq(username)
      end
    end
  end
end
