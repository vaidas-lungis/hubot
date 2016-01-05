# Description:
#   Receive event data from Github Gollum Notifier
#
# Dependencies:
#   "hubot-pubsub": "1.0.0"
#
# URLS:
#   POST /hubot/github-wiki/:event
#

module.exports = (robot) ->
  robot.router.post '/hubot/github-wiki/:event', (req, res) ->
    res.end('')
    event = req.params.event
    try
      payload = req.body
      author = payload.sender.login
      page_name = payload.pages[0].title
      html_url = payload.pages[0].html_url
      robot.emit 'pubsub:publish', event, "Wiki page #{page_name} updated by #{author} (#{html_url}/_history)"
    catch error
      console.log "github-wiki error: #{error}. Payload: #{req.body}"
