
class @SceneManager

  scenes:         {}
  active_scenes:  []

  constructor: () ->
    # build the scene SceneManager
    @scenes        = {}
    @active_scenes = []


  add: (scene) =>
    @scenes[scene.name] = scene


  ready: (sceneName) =>
    return console.warn("scene: '#{sceneName}' not found.") if @scenes[sceneName] is undefined
    current = @scenes[sceneName]
    current.load()
    @active_scenes.push(current)


  remove: (sceneName) =>
    return console.warn("scene: '#{sceneName}' not found.") if @scenes[sceneName] is undefined
    current = @scenes[sceneName]
    current.unload()
    i = @active_scenes.indexOf(current)
    @active_scenes.splice(i, 1)


  update: (delta) =>
    for scene in @active_scenes
      scene.update(delta)


  render: () =>
    for scene in @active_scenes
      scene.render()

  