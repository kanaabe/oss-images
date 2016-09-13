#
# The client-side code for the commits page.
#
# [Browserify](https://github.com/substack/node-browserify) lets us write this
# code as a common.js module, which means requiring dependecies instead of
# relying on globals. This module exports the Backbone view and an init
# function that gets used in /assets/commits.coffee. Doing this allows us to
# easily unit test these components, and makes the code more modular and
# composable in general.
#

Backbone = require "backbone"
$ = require 'jquery'
Backbone.$ = $
sd = require("sharify").data
listTemplate = -> require("./templates/list.jade") arguments...
request = require 'superagent'

module.exports.CommitsView = class CommitsView extends Backbone.View

  render: =>
    @$("#commits-list").html listTemplate(list: @list)

  events:
    "change .search-input": "changeSearch"
    'click button': 'showMore'

  changeSearch: (e) ->
    q = $(e.target).val()
    @params = { offset: 0 }
    request
      .get("#{sd.API_URL}/artworks?gene_id=#{q}&size=10")
      .set({ 'X-XAPP-TOKEN' : sd.XAPP })
      .end (err, res) =>
        @list = res.body._embedded?.artworks or []
        @params.offset = 10
        @params.q = q
        @render()

  showMore: ->
    request
      .get("#{sd.API_URL}/artworks?gene_id=#{@params.q}&size=10&offset=#{@params.offset}")
      .set({ 'X-XAPP-TOKEN' : sd.XAPP })
      .end (err, res) =>
        @list = res.body._embedded?.artworks or []
        @params.offset = @params.offset + 10
        @$("#commits-list").append listTemplate(list: @list)

module.exports.init = ->
  new CommitsView
    el: $ "body"