require! {
  'caterpillar'
  'caterpillar-human'
  'prerender-node'
  'express'
}

port = 5000
app = express!
logger = caterpillar.createLogger!
human = caterpillar-human.createHuman!
logger.pipe(human).pipe(process.stdout)

app.use(express.logger!)
app.use(prerender-node)
app.use(express.static(__dirname + '/public'))

app.get '/plugins.json' (req, res) ->
  res.json []

app.get '*' (req, res) ->
  res.render 'index.html.ejs'

app.listen(port)

logger.log 'info', 'vimsetup listening on port', port
