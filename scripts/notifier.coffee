# Description:
#   Send alert message to subscribers using HTTP POST
#
# URLS:
#   POST /hubot/notify/<alert> (message=<message>)

module.exports = (robot) ->
  robot.router.post '/hubot/notify/:alert', (req, res) ->
    alert = req.params.alert
    message = req.body.message
    res.end()
    robot.emit 'pubsub:publish', alert, message
