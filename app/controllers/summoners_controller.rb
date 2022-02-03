class SummonersController < ApplicationController
  def analyze
    AnalyzeSummonerJob.perform_later(params[:summoner_id])
  end
end
