class GeocodeUserJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.geocode
  end

  after_enqueue do |job|
    logger.debug("----------after_enqueue----------")
  end

  after_perform do |job|
    logger.debug("----------after_enqueue----------")
  end
end
