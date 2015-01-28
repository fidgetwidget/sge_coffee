
class @SceneManager

  scenes: undefined
  active_scenes: undefined
  scale: undefined

  constructor: () ->
    # build the scene SceneManager
    @scenes        = {}
    @active_scenes = []
    @scale = { x: 1, y: 1 }


  add: (scene) =>
    @scenes[scene.name] = scene


  ready: (sceneName) =>
    return console.warn("scene: '#{sceneName}' not found.") if @scenes[sceneName] is undefined
    current = @scenes[sceneName]
    current.scale.x = @scale.x
    current.scale.y = @scale.y
    current.load()
    @active_scenes.push(current)
    return current


  remove: (sceneName) =>
    return console.warn("scene: '#{sceneName}' not found.") if @scenes[sceneName] is undefined
    current = @scenes[sceneName]
    current.unload()
    i = @active_scenes.indexOf(current)
    @active_scenes.splice(i, 1)


  update: () =>
    for scene in @active_scenes
      scene.update()


  render: () =>
    for scene in @active_scenes
      scene.render()

  