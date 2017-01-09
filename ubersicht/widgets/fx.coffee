command: """ curl -s 'http://api.fixer.io/latest?base=USD&symbols=CAD' | sed -e 's/.*"CAD"://g' | sed -e 's/}}//g' """

refreshFrequency: 60000 # ms

render: (output) ->
  """
  <link rel="stylesheet" href="./assets/font-awesome/css/font-awesome.min.css" />
  <div class="fx"
    <span>USD</span>
    <span class="icon">CAD</span>
  </div>
  """

update: (output, el) ->
    $(".fx span:first-child", el).text("  #{output}")
    $icon = $(".fx span.icon", el)
    $icon.removeClass().addClass("icon")
    $icon.addClass("fa fa-exchange")

style: """
  -webkit-font-smoothing: antialiased
  font: 12px Input
  top: 7px
  right: 300px
  color: #d5c4a1
"""
