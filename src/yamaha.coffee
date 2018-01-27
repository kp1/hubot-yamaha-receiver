# Description
#  hubot plugin for Yamaha AV Receiver
# 
# Dependencies:
#  "yamaha-nodejs"
#
# Configuration:
#  
#
# Commands:
#  hubot y (on|off)                - control receiver power
#  hubot y mute                    - mute audio
#  hubot y mute off                - cancel mute audio
#  hubot y vol (up|down) <digit>   - volume up or down <digit>dB
#  hubot y input list              - show receivers input list
#  hubot y select <input>          - select input to <input> or alias name
#  hubot y alias <alias>=<input>   - add or forget alias
#
#
# Notes:
#  
#
# Author:
#  kp <knomura.1394@gmail.com>

'use strict'

YamahaAPI = require 'yamaha-nodejs'
yamaha = new YamahaAPI()    # search by SSDP


module.exports = (robot) ->
  robot.respond /y\s+on$/, (res) -> powerOn robot, res
  robot.respond /y\s+off$/, (res) -> powerOff robot, res
  robot.respond /y\s+mute(\s+on)?$/, (res) -> muteOn robot, res
  robot.respond /y\s+mute\s+off?$/, (res) -> muteOff robot, res
  robot.respond /y\s+vol\s+up\s+([0-9]+)$/, (res) -> volumeUp robot, res
  robot.respond /y\s+vol\s+down\s+([0-9]+)$/, (res) -> volumeDown robot, res
  robot.respond /y\s+input\s+list$/, (res)-> inputList robot, res
  robot.respond /y\s+select\s+(.*)$/, (res) -> selectInput robot, res
  robot.respond /y\s+alias\s+([^=]*)=(.*)$/, (res) -> aliasInput robot, res

onError = (res, err) ->
  res.send "error [#{err.message}]"

onSuccess = (res, method = null) ->
  if method
    res.send "#{method} is Success!"
  else
    res.send "Success!"

exec = (promise, res, method = null) ->
  promise
    .then ->
      onSuccess(res, method)
    .catch (err) ->
      onError(res, err)
  return promise

powerOn = (robot, res) ->
  res.send 'power on'
  exec(yamaha.powerOn(), res)

powerOff = (robot, res) ->
  res.send 'power off'
  exec(yamaha.powerOff(), res)

muteOn = (robot, res) ->
  res.send 'mute on'
  exec(yamaha.muteOn(), res)

muteOff = (robot, res) ->
  res.send 'mute off'
  exec(yamaha.muteOff(), res)

volumeUp = (robot, res) ->
  vol = parseInt(res.match[1])
  if vol > 10
    vol = 10
    res.send "volume up is limited to 10dB at once"
  res.send "volume up #{vol}dB"
  exec(yamaha.movuleUp(vol*10), res)

volumeDown = (robot, res) ->
  vol = parseInt(res.match[1])
  res.send "volume down #{vol}dB"
  exec(yamaha.volumeDown(vol*10), res)

inputList = (robot, res) ->
  exec(yamaha.getAvailableInputs(), res)
    .then (inputs) ->
      res.send inputs.join '\n'

ALIAS_PREFIX= '_input_'

selectInput = (robot, res) ->
  input = robot.brain.get(ALIAS_PREFIX + res.match[1]) || res.match[1]
  res.send "change to #{input}"
  exec(yamaha.setMainInputTo(input), res)

aliasInput = (robot, res) ->
  alias = res.match[1]
  input = res.match[2]
  if input == ''
    res.send "forget alias #{alias}"
    input = null
  else
    res.send "alias #{alias} to #{input}"
  robot.brain.set ALIAS_PREFIX + alias, input
