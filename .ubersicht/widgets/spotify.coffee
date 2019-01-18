command: "sh ./scripts/spotify.sh"

refreshFrequency: 10000

render: (output) ->
  """
    <link rel="stylesheet" type="text/css" href="./assets/colors.css">
    <link rel="stylesheet" type="text/css" href="./assets/fontawesome-all.min.css">
    <link rel="stylesheet" type="text/css" href="/nerdbar.widget/colors.css" />
    <div class='spotify'></div>
  """

style: """
  width: 100%
  position: absolute
  margin: 0 auto
  margin-top: 6px
  text-align: center
  font: 14px "HelveticaNeue-Light", "Helvetica Neue Light", "Helvetica Neue", Helvetica, Arial, "Lucida Grande", sans-serif
  color: #a5a5a5
  font-weight: 700
"""

cutWhiteSpace: (text) ->
  text.replace /^\s+|\s+$/g, ""

update: (output, domEl) ->

   values = output.split('@')
   artist = @cutWhiteSpace(values[0])
   song = @cutWhiteSpace(values[1])
   total = values[3]
   status = @cutWhiteSpace(values[4])

   if artist.length >= 30
     artist = artist.substring(0,29)
     artist = @cutWhiteSpace(artist)
     song = song + "…"

   if song.length >= 30
     song = song.substring(0,29)
     song = @cutWhiteSpace(song)
     song = song + "…"

   totalValues = total.split(':')

   # Create mpdHtmlString
   mpdHtmlString = "<img height=\"12\" width=\"12\" style=\"margin-top:px;\" src=\"assets/icons/spotify.png\"></img><span class='white'>  #{artist} - #{song}&nbsp</span>"

   $(domEl).find('.spotify').html(mpdHtmlString)
