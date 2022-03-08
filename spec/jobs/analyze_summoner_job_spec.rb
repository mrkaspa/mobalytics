require "rails_helper"
require "lib/riot_client"

RSpec.describe AnalyzeSummonerJob, :type => :job do
  let(:username) { "mrkaspa07" }
  let (:user_data) do
    {
      id: "q3z8TJVRZwqjeOu6nl73CbRIxeOlr5RvAaz3DdnArjUN7l5DErgv07dmEQ",
      "accountId": "RK38eqhlZ2b10Jb7ykYoNAo8WDI-p_Yuz0QWRTUWRI3Gt0Gm1YB32o4W",
      puuid: "lFw9rp8no1sx03ZdrAk1XPrObjEqV6W3ujgsJUKyGp8cQhTJmyqFFmT88yOec0f1HaB9hejZQ3ftdQ",
      name: username,
      "profileIconId": 5134,
      revisionDate: 1643553748000,
      summonerLevel: 77
  }
  end

  describe "#perform_later" do
    it "enqueues an id to analyze" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        AnalyzeSummonerJob.perform_later(username)
      }.to have_enqueued_job
    end
  end

  describe "#update_information" do
    before do
      allow(RiotClient).to receive(:new) { riot_client }
    end

    let!(:riot_client){ double("riot_client") }

    it "should fetch and store the information" do
      allow(riot_client).to receive(:get_summoner_info).and_return(user_data)
      RiotClient.new(url: "", token: "").get_summoner_info(username)

      ActiveJob::Base.queue_adapter = :test
      AnalyzeSummonerJob.perform_now()
      expect(riot_client).to have_received(:get_summoner_info).with(username)

      expect(Summoner.count).to eq(1)
    end
  end
end
