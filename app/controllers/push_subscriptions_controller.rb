class PushSubscriptionsController < ApplicationController
  def create
    current_user.push_subscriptions.find_or_create_by(endpoint: params[:endpoint]) do |subscription|
      subscription.p256dh = params[:p256dh]
      subscription.auth = params[:auth]
    end
    head :ok
  end
end
