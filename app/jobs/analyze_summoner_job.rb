class AnalyzeSummonerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    summoner_id = args[0]
    return if Summoner.find_by(name: summoner_id)

    sum = update_information(summoner_id)
    if sum.valid?
      logger.info "Summoner #{summoner_id} saved"
    else
      logger.info "Errors saving summoner #{sum.errors.full_messages}"
    end
  end

  def update_information(summoner_id)
    info = RiotClient.new(url: Rails.application.config.riot_url).get_summoner_info(summoner_id)
    sum = Summoner.new(info)

    sum.save.inspect
    sum
  end
end
