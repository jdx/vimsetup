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

app.get '/' (req, res) ->
  res.send('hello world')

app.listen(port)

logger.log 'info', 'vimsetup listening on port', port
