
class @EntityManager

  entities: {}
  toUpdate: []

  constructor: () ->
    # init the entities hash and the toUpdate list
    @entities = {}
    @toUpdate = []

  update: () =>
    # update the toUpdate entities


  render: () =>
    # render stuff here?


  saveEntities: (to) ->
    # save the entitiy states to the given desitination

  loadEntities: (from) ->
    # load the entitiy states from the given source

