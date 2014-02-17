require! {
  'http'
  'caterpillar'
  'caterpillar-human'
  'prerender-node'
  'node-static'
}

logger = caterpillar.createLogger!
human = caterpillar-human.createHuman!
logger.pipe(human).pipe(process.stdout)

public-files = new Server('./public', cache: 7200 gzip: true )

exports.server = http.createServer (request, response) ->
  listener = request.addListener 'end', ->
    public-files.serve request, response, (err, result) ->
      if (err)
        logger.log 'error' error: err.message, url: request.url
        response.writeHead(err.status, err.headers)
        response.end()
      else
        logger.log 'info' status: response.statusCode, url: request.url
  listener.resume!
