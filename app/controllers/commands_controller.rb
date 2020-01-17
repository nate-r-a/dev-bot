class CommandsController < ApplicationController
  # Rails complains about most Slack requests coming in without this line:
  skip_before_action :verify_authenticity_token

  def love
    # Slack will get mad at you if you don't send a 200 response back immediately
    head :ok

    # Initialize our Slack client
    client = Slack::Web::Client.new(token: ENV["slack_love_bot_bot_access_token"])

    client.chat_postMessage(channel: params[:channel_id],
                            text: "I love #{params[:text]}!")
  end
end