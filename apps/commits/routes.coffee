#
# Routes file that exports route handlers for ease of testing.
#
request = require 'superagent'

@index = (req, res, next) ->
  res.header("Access-Control-Allow-Origin", "*")
  res.header("Access-Control-Allow-Headers", "X-Requested-With")
  clientID = ''
  clientSecret = ''
  apiUrl = 'https://api.artsy.net/api/tokens/xapp_token'

  request
    .post(apiUrl)
    .send({ client_id: clientID, client_secret: clientSecret })
    .end (err, response) ->
      xappToken = response.body.token
      res.locals.sd.XAPP = xappToken
      res.render 'index', list: []
