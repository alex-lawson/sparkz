function init(args)
  self.detectArea = entity.configParameter("detectArea")
  self.detectAreaOffset = entity.configParameter("detectAreaOffset")
  if type(self.detectArea) == "table" then
    --build rectangle for detection using object position and specified detectAreaOffset
    if type(self.detectAreaOffset) == "table" then
      self.detectArea = {entity.position()[1] + self.detectArea[1] + self.detectAreaOffset[1], entity.position()[2] + self.detectArea[2] + self.detectAreaOffset[2]}
    else
      self.detectArea = {entity.position()[1] + self.detectArea[1], entity.position()[2] + self.detectArea[2]}
    end
  end

  if type(self.detectAreaOffset) == "table" then
    self.detectOrigin = {entity.position()[1] + self.detectAreaOffset[1], entity.position()[2] + self.detectAreaOffset[2]}
  else
    self.detectOrigin = entity.position()
  end

  entity.setAnimationState("switchState", "off")
end

function onDetect(entityId)
  if entityId then
    world.callScriptedEntity(entityId, "entity.heal", 1)
    world.callScriptedEntity(entityId, "player.heal", 1)

    local sample = math.floor(world.entityHealth(entityId)[2])
    send(sample)

    entity.setAnimationState("switchState", "on")
  else
    send(0)

    entity.setAnimationState("switchState", "off")
  end
end

function send(value)
  local entityIds = world.entityLineQuery({entity.position()[1] + 2, entity.position()[2]}, {entity.position()[1] + 2, entity.position()[2] + 10}, {
      callScript = "setCount", callScriptArgs = { value } })
end
  

function firstValidEntity(entityIds)
  local validTypes = {"player", "monster", "npc"}

  for i, entityId in ipairs(entityIds) do
    local entityType = world.entityType(entityIds[i])
    for j, validType in ipairs(validTypes) do
      if entityType == validType then return entityId end
    end
  end
  
  return false
end

function main()
  local entityIds = world.entityQuery(self.detectOrigin, self.detectArea, { notAnObject = true, order = "nearest" })
  local nearestValid = firstValidEntity(entityIds)
  onDetect(nearestValid)
end