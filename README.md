# How to make a Slack bot ~~and annoy your coworkers~~

1. Create a Rails app to host your bot
  `rails new dev-bot -T --database=postgresql`
   - (If you host your bot in Heorku later, it requires that you use Postgres)
   - `rails db:setup` and `rails db:migrate`
   - Add `gem 'figaro'` and `gem 'slack-ruby-client'`to your Gemfile, then `bundle install`,
     - then `bundle exec figaro install`

2. Register bot on Slack
   - <https://api.slack.com/apps?new_app=1>

3. Create bot user and set bot scopes
   - `Features > Bot Users`
   - `Features > OAuth & Permission`
   - Add the `commands` and `chat:write` Bot Token Scopes if they aren't already added

4. Install app from `Settings > Install App`

5. Go back to `Features > OAuth & Permission` and copy the Access Token
   - Open `application.yml` and save it as an application variable
   ![](https://i.imgur.com/oYLObRe.png)
   - You can now access it in your code as `ENV['slack_love_bot_bot_access_token']`

6. Create a controller and a route to catch Slack slash commands as they come in
   - ![](https://i.imgur.com/WYJjd9P.png)
   - Load up your rails server with `rails s` and connect ngrok to it with `ngrok http [PORT]`
   - Create a slash command that will send a POST to the endpoint you created
   - ![](https://i.imgur.com/gGzY231.png)

7. /invite your bot user to a channel (like #dev-bot-battleground) and test your command. See if ngrok is giving you a `200 OK` and check your server logs for activity

8. The params for a successful request will look something like this:

   ```
   {"token"=>"7NzvWUIjmu7Ulm9U4TtJH14u",
   "team_id"=>"T04DFV6UT",
   "team_domain"=>"crate-bind",
   "channel_id"=>"CSS5YH54Y",
   "channel_name"=>"dev-bot-battleground",
   "user_id"=>"UEX39DX9T",
   "user_name"=>"nate",
   "command"=>"/love",
   "text"=>"the text I sent",
   "response_url"=>
   "https://hooks.slack.com/commands/T04DFV6UT/900072903425/t8itJZJtJIDZpk9tgrQ5Cy2E",
   "trigger_id"=>"909818702004.4457992979.a7563d27a5792363c42f7575fbefdc5c",
   "controller"=>"commands",
   "action"=>"love"}
   ```

   - These params are all accessible in the controller for you to manipulate

9. Update your code and send a message back!
    - Use the Slack ruby client's `chat_postEphemeral` method to send an "only visible to you" message to the user

    ```
    # app/controllers/commands_controller.rb
    client.chat_postEphemeral(channel: params[:channel_id],
                              user:    params[:user_ud],
                              text:    "Hello, I am posting privately to you")

    client.chat_postMessage(channel: params[:channel_id],
                            text:    "Hello, this message posted in the channel")
    ```

### Other notes

- Slack bots have two sets of scopes, for bots and users.
  - When using the bot scopes and the bot access token (like we are above) the bot must be invited to the channel to post to it
