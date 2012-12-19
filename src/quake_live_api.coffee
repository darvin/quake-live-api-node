# calculator.coffee
request = require('request')


exports.Player = 
class Player

exports.Match = 
class Match
  @fromMatchList: (matchList) ->
    new Match (matchPayload) for matchPayload in matchList.servers
  
  @fetch: (options,
        callback
          
        ) ->
        
    options.arena_type ?= ""
    options.players ?= []
    
    options.filters ?=  {
        "arena": "any", 
        "difficulty": "any", 
        "game_type": "any", 
        "group": "any", 
        "invitation_only": 0, 
        "location": "ALL", 
        "premium_only": 0, 
        "private": 0, 
        "ranked": "any", 
        "state": "any"
      }
    options.game_types ?= []
    options.ig ?= 0
    
    if options.players.length > 0
      options.filters.group = "friends"
      
    
    console.log options
    
    encodedOptions = Buffer(JSON.stringify(options)).toString('base64')
    request.get(
      "http://www.quakelive.com/browser/list?filter=#{encodedOptions}",
      (error, response, body) ->
        matches_json = JSON.parse body
        matches = Match.fromMatchList(matches_json)
        console.log match.toString() for match in matches
        callback matches
    )
    
  
  constructor: ({@public_id,
                 @g_customSettings,
                 @g_instagib,
                 @g_needpass,
                 @game_type,
                 @host_address,
                 @host_name,
                 @location_id,
                 @map,
                 @max_clients,
                 @num_clients,
                 @num_players,
                 @premium,
                 @ranked,
                 @ruleset,
                 @skillDelta,
                 @teamsize,
                 @players,
                 }) ->
    if @players
      @players = for player in @players
        player.name
  
  joinUrl: ->
    "http://www.quakelive.com/#!join/#{@public_id}"
    
  toString: ->
    "Match (#{@num_clients}/#{@max_clients}) @ #{@host_name}"
  
  