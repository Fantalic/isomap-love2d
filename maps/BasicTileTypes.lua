local types = {}

types.grass = {
  movementSpeed = 0.8,
  movementNoise = 0.7,
  movementAnim = "default",
}
types.road = {
  movementSpeed = 1.2,
  movementNoise = 1.5,
  movementAnim = "default"
}
types.water = {
  movementSpeed = 0.4,
  movementAnim = "swimming",
  movemntNoise = 2
}

return types
