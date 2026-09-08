class PushNotificationSender
  def initialize(task)
    @task = task
  end

  def call
    @task.user.push_subscriptions.find_each do |subscription|
      send_to(subscription)
    end
    @task.update!(last_notified_at: Time.current)
  end

  private

  def send_to(subscription)
    ::WebPush.payload_send(
      message: { title: "Unstuck", body: "「#{@task.name}」の報告時間です" }.to_json,
      endpoint: subscription.endpoint,
      p256dh: subscription.p256dh,
      auth: subscription.auth,
      vapid: vapid_options
    )
  rescue ::WebPush::ExpiredSubscription
    subscription.destroy
  end

  def vapid_options
    {
      subject: "mailto:example@example.com",
      public_key: Rails.application.credentials.vapid[:public_key],
      private_key: Rails.application.credentials.vapid[:private_key]
    }
  end
end
