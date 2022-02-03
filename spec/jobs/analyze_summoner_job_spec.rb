require "rails_helper"
require "lib/riot_client"

RSpec.describe AnalyzeSummonerJob, :type => :job do
  let(:username) { "mrkaspa07" }

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
      allow(riot_client).to receive(:get_summoner_info).and_return({})
      RiotClient.new(url: "").get_summoner_info(username)

      ActiveJob::Base.queue_adapter = :test
      AnalyzeSummonerJob.perform_now()
      expect(riot_client).to have_received(:get_summoner_info).with(username)
    end
  end
end
