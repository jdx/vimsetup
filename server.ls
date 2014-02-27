require! {
  'caterpillar'
  'caterpillar-human'
  'prerender-node'
  'express'
  'mongodb'
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
  mongodb.MongoClient.connect 'mongodb://127.0.0.1:27017/vimsetup', (err, db) ->
    if err
      throw err
    collection = db.collection 'plugins'
    collection.find().toArray (err, plugins) ->
      if err
        throw err
      res.json plugins

app.get '*' (req, res) ->
  res.render 'index.html.ejs'

app.listen(port)

logger.log 'info', 'vimsetup listening on port', port
