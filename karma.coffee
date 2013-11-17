# Description
#   Give your colleagues/friends the karma they deserve
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot karma @[user] ++/-- - Give good or bad karma
#   hubot karma @[user]       - Display a users karma
#   hubot karma @[user] reset - Reset a users karma (admin only)
#
# Author:
#   Julian Cohen [julian.cohen@juco.co.uk]

POSITIVE = '++'
NEGATIVE = '--'
positiveMsg = [
  'Hurray'
  'Way to go'
  'Fuck me'
  'On form'
  'Whoa'
  'You da human'
]
negativeMsg = [
  'Oh darn'
  'You suck'
  'Try harder'
  'Suck it'
  'tut tut'
  'Stupid humanoid'
]

class Karma
  constructor: (robot) ->
    @robot = robot

  key: (user) ->
    "karma-#{user}"

  set: (user, karma) ->
    @robot.brain.set(this.key(user), karma)
    karma

  get: (user) ->
    parseInt(@robot.brain.get(this.key(user)), 10) || 0

module.exports = (robot) ->
  karma = new Karma(robot)

  robot.respond /karma @?([a-zA-Z\s]*)\s?(\+\+|--|reset)?/, (msg) ->
    user = msg.match[1].trim

    # Current karama
    unless msg.match[2]
      msg.send "#{user} has a karma of " + karma.get(user)

    # Increment/decrement karma
    if msg.match.length >= 3
      direction = msg.match[2]
      if direction == POSITIVE  or direction == NEGATIVE
        newKarma = karma.get(user) + 1 if direction == POSITIVE
        newKarma = karma.get(user) - 1 if direction == NEGATIVE
        karma.set(user, newKarma)
        msgTxt = positiveMsg[Math.floor(Math.random()*positiveMsg.length)] if newKarma > 0
        msgTxt = negativeMsg[Math.floor(Math.random()*negativeMsg.length)] if newKarma <= 0
        msgTxt += ", Karma for #{user} is now #{newKarma}"
        msg.send msgTxt

      # Reset karma
      else if msg.match[2] == 'reset' and robot.auth.hasRole(msg.envelope.user, 'admin')
        karma.set(user, 0)
        msg.send "Karma reset for #{user}"
