command: "cat /tmp/pomo"

refreshFrequency: 1000 # ms

render: (output) ->
  """
  <link rel="stylesheet" href="./assets/font-awesome/css/font-awesome.min.css" />
  <div class="pomodoro"
    <span></span>
    <span class="icon"></span>
  </div>
  """

update: (output, el) ->
    secs = output.split(',')[0]
    mode = output.split(',')[1].replace /^\s+|\s+$/g, ""
    time = "#{secs%3600//60}:#{secs%60}"
    $(".pomodoro span:first-child", el).text("  #{time}")
    $icon = $(".pomodoro span.icon", el)
    $icon.removeClass().addClass("icon")
    $icon.addClass("fa #{@icon(mode)}")

icon: (output) =>
  return if output == "b"
    "fa-cloud"
  else
    "fa-bolt"

style: """
  -webkit-font-smoothing: antialiased
  font: 12px Input
  top: 7px
  right: 250px
  color: #d5c4a1
"""
