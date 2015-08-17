# Description:
#   Interact with Hostinger API server
#
# Dependencies:
#   none
#
# Configuration:
#   HUBOT_RABBITMQ_API_URL
#   HUBOT_HOSTINGER_API_USERNAME
#   HUBOT_HOSTINGER_API_PASSWORD
#
# Commands:
#   hubot hostinger backup list <username> - List backups for username.
#   hubot hostinger backup move <username> - move backup to /home/<username>/public_html
#
# Author:
#   fordnox

merge = (xs...) ->
  if xs?.length > 0
    tap {}, (m) -> m[k] = v for k, v of x for x in xs

tap = (o, fn) -> fn(o); o

module.exports = (robot) ->

  rabbitApi = (p, cb) ->
    auth = {
      auth_user: process.env.HUBOT_HOSTINGER_API_USERNAME,
      auth_pass: process.env.HUBOT_HOSTINGER_API_PASSWORD,
    }
    data = JSON.stringify({
      properties: {
        type: "rest_api",
        reply_to: "hubot",
        app_id: "hubot"
      },
      routing_key: "api",
      payload: JSON.stringify(merge p, auth),
      payload_encoding: "string"
    })

    robot.http(process.env.HUBOT_RABBITMQ_API_URL)
      .header('Content-Type', 'application/json')
      .post(data) cb




  robot.respond /h(?:ostinger)? ping/i, (msg) ->
    rabbitApi {
      uri: '/ping',
      method: 'get',
    }

  robot.respond /h(?:ostinger)? backup list ([a-z0-9]+)/i, (msg) ->
    username = msg.match[1]
    rabbitApi {
      uri: '/admin/backup/account/backups',
      username: username,
      method: 'post',
    }

  robot.respond /h(?:ostinger)? backup move ([a-z0-9]+)/i, (msg) ->
    username = msg.match[1]
    rabbitApi {
      uri: '/admin/backups/move',
      username: username,
      method: 'post',
    }

  robot.respond /h(?:ostinger)? hosted ([\S]+)/i, (msg) ->
    domain = msg.match[1]
    rabbitApi {
      uri: '/admin/reseller/client/order/is_domain_hosted',
      domain: domain,
      method: 'post',
    }
