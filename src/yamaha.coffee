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
#  hubot y (on|off)              - control receiver power
#  hubot y mute                  - mute audio
#  hubot y mute                  - cancel mute audio
#  hubot y vol (up|down) <digit> - volume up or down <digit>dB
#  hubot y input list            - show receivers input list
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
  robot.respond /y\s+off$/, (res) -> pwerOff robot, res
  robot.respond /y\s+mute(\s+on)?$/, (res) -> muteOn robot, res
  robot.respond /y\s+mute\s+off?$/, (res) -> muteOff robot, res
  robot.respond /y\s+vol\s+up\s+([0-9]+)$/, (res) -> volumeUp robot, res
  robot.respond /y\s+vol\s+down\s+([0-9]+)$/, (res) -> volumeDown robot, res
  robot.respond /y\s+input\s+list$/, (res)-> inputList robot, res


onError = (res, err) ->
  res.send "error [#{err.message}]"

onSuccess = (res, method = null) ->
  if method
    res.send "#{method} is Success!"
  else
    res.send "Success!"

powerOn = (robot, res) ->
  res.send 'power on'
  yamaha.powerOn()
    .catch (err) ->

powerOff = (robot, res) ->
  res.send 'power off'
  yamaha.powerOff()
    .catch (err) ->
      onError(res, err)


muteOn = (robot, res) ->
  res.send 'mute on!'
  yamaha.muteOn()
    .catch (err) ->


muteOff = (robot, res) ->
  res.send 'mute off!'
  yamaha.muteOff()
    .catch (err) ->

volumeUp = (robot, res) ->
  vol = parseInt(res.match[1])
  if vol > 10
    vol = 10
    res.send "volume up is limited to 10dB at once"
  res.send "volume up #{vol}dB"
  yamaha.volumeUp(vol)
    .catch (err) ->


volumeDown = (robot, res) ->
  vol = parseInt(res.match[1])
  res.send "volume down #{vol}dB"
  yamaha.volumeDown(vol)
    .catch (err) ->

inputList = (robot, res) ->
  yamaha.getAvailableInputs()
    .then (inputs) ->
      res.send inputs.join '\n'
    , (err) ->
      onError(res, err)


