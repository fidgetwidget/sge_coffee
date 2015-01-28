
class @Random

  @between: (min, max) =>
    return (Math.random() * (max - min)) + min

  @intBetween: (min, max) =>
    return Math.floor(Math.random() * (max - min)) + min

  @arrayIndex: (array) =>
    return @intBetween(0, array.length)

  @inArray: (array) =>
    return array[@arrayIndex(array)]


  @hashKey: (hash) =>
    i = @intBetween(0, Object.keys(hash).length)
    return Object.keys(hash)[i]

  @inHash: (hash) =>
    return hash[@hashKey(hash)]