# calculatorSpec.coffee
fs               = require 'fs'
{Match} = require '../src/quake_live_api'

jasmine.Matchers.prototype.toBeInstanceOf = (klass) ->
  this.actual instanceof klass


loadFixture = (name) ->
  JSON.parse fs.readFileSync("spec/fixtures/#{name}.json")
  

describe 'Match', ->

	it 'should be initialized properly from json object', ->
		match_data = 
      "g_customSettings": "0", 
      "g_instagib": 0, 
      "g_needpass": 0, 
      "game_type": 4, 
      "host_address": "76.74.236.91:27068", 
      "host_name": "CA", 
      "location_id": 25, 
      "map": "hiddenfortress", 
      "max_clients": 16, 
      "num_clients": 9, 
      "num_players": 9, 
      "premium": false, 
      "public_id": 688811, 
      "ranked": 1, 
      "ruleset": "1", 
      "skillDelta": 1, 
      "teamsize": 5
    match = new Match(match_data)
    expect(match).toBeDefined()
    expect(match.joinUrl()).toBe "http://www.quakelive.com/#!join/688811"
    match_str = "#{match}"
    expect(match_str).toBeDefined()
    
    expect(match_str).toContain 16
    expect(match_str).toContain 9
	it 'should be initialized properly json with payload of multiple matches', ->
    fixture = loadFixture("match_list")
    matches = Match.fromMatchList fixture
    expect(matches.length).toBeGreaterThan 5
    for match in matches
      expect(match).toBeInstanceOf Match
    
  it 'should be initialized properly from json with details payload', ->
    fixture = loadFixture("match_details")
    numPlayers = 10
    match = new Match (fixture)
    expect(match).toBeDefined()
    expect(match.joinUrl()).toBe "http://www.quakelive.com/#!join/688917"
    match_str = "#{match}"
    expect(match_str).toContain 16
    expect(match_str).toContain numPlayers
    expect(match.players).toBeDefined()
    expect(match.players.length).toBe numPlayers
    expect(match.players).toContain "darvin_s_k_2"
    
  it 'should fetch all matches from quake live server', ->
    matches = null
    
    Match.fetch({}, (fetchedMatches) ->
      matches = fetchedMatches
    )
    
    waitsFor ->
      matches

    runs ->
      expect(matches).toBeDefined()
      expect(matches.length).toBeGreaterThan 3
      for match in matches
        expect(match).toBeInstanceOf Match
        
  it 'should not fetch matches from quake live server if non-existing player specified', ->
    matches = null
    
    Match.fetch({"players":["Some_strange_user"]}, (fetchedMatches) ->
      matches = fetchedMatches
    )
    
    waitsFor ->
      matches

    runs ->
      expect(matches).toBeDefined()
      expect(matches.length).toBe 0


  xit 'should fetch match from quake live server if im online', ->
    matches = null
    
    Match.fetch({"players":["darvin_S_K"]}, (fetchedMatches) ->
      matches = fetchedMatches
    )
    
    waitsFor ->
      matches

    runs ->
      expect(matches).toBeDefined()
      expect(matches.length).toBe 1
      expect(matches[0]).toBeInstanceOf Match
      console.log matches[0].toString()
      

	