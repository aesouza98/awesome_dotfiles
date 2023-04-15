local awful = require("awful")

local naughty = {}

naughty.config = { presets = { critical = "critical" } }

function naughty.notify(args)
  local urgency = naughty.config.presets[args["preset"]]
  local summary = args["title"]
  local body = args["text"]
  awful.spawn(string.format("notify-send -u %s \"%s\" \"%s\"", urgency, summary, body))
end

return naughty
