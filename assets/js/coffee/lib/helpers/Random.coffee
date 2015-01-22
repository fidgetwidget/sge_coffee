
class @Random

  @between: (min, max) =>
    return (Math.random() * (max - min)) + min

  @intBetween: (min, max) =>
    return Math.floor(Math.random() * (max - min)) + min
