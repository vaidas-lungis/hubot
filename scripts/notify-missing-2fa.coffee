# Description:
#   Shows users with Github 2FA disabled.
#   You can pass:
#   ASK_REGEX to define the pattern to start the script
#   ROOM to set the room in which the message will be shown
#   EMPTY_ANSWER to set the answer in case, all users have 2fa enabled
# Commands:
#   hubot 2fa
#TODO: Run the script every day at a defined hour

_  = require("underscore")
DEFAULT_ASK_REGEX = /2fa\s*/i;
DEFAULT_SEC_FA_SERVICE = 'https://api.github.com/orgs/hostinger/members?filter=2fa_disabled'
DEFAULT_ROOM = 'general'
DEFAULT_EMPTY_ANSWER = 'Everybody is using 2FA on Github...:beer:!'
module.exports = (robot) ->
  github = require("githubot")(robot)
  users = process.env.USERS
    
  regex = process.env.ASK_REGEX
  if !regex
    regex = DEFAULT_ASK_REGEX

  secFAService = process.env.SEC_FA_SERVICE
  if !secFAService
    secFAService = DEFAULT_SEC_FA_SERVICE
  
  room = process.env.ROOM
  if !room
    room = DEFAULT_ROOM
  
  emptyAnswer = process.env.EMPTY_ANSWER
  if !emptyAnswer
    emptyAnswer = DEFAULT_EMPTY_ANSWER

  namesList = []
  robot.respond regex, (msg) ->    
    github.get secFAService, {}, (users) ->
      if !_.isEmpty users
        namesList.push user.login for user in users          
        robot.messageRoom(room, namesList.join(', '))
      else
        robot.messageRoom(room, emptyAnswer)   