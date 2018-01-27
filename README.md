# hubot-yamaha-receiver

hubot plugin for YAMAHA AV Reciever.

## How to use
In hubot project repo, run:

    npm install --save kp1/hubot-yamaha-receiver

and add hubot-yamaha-receiver to external-scripts.json:

    [
      "hubot-yamaha-receiver"
    ]

## Usage

    > hubot y (on|off)                - control receiver power
    > hubot y mute                    - mute audio
    > hubot y mute off                - cancel mute audio
    > hubot y vol (up|down) <digit>   - volume up or down <digit>dB
    > hubot y input list              - show receivers input list
    > hubot y select <input>          - select input to <input> or alias name
    > hubot y alias <alias>=<input>   - add or forget alias