function init()
  self.projectile = entity.configParameter("projectile")
  self.projectileConfig = entity.configParameter("projectileConfig")
  self.projectileSourcePosition = {entity.position()[1] + 0.5, entity.position()[2] + 0.5}

  self.fireCycle = entity.configParameter("fireCycle")
  self.cooldown = 0

  self.state = false

  --janky workaround for orientations being weird
  if world.pointCollision({entity.position()[1] - 1, entity.position()[2]}, true) then
    self.fireDirection = 1
    
  elseif world.pointCollision({entity.position()[1] + 1, entity.position()[2]}, true) then
    self.fireDirection = -1
  else
    world.logInfo("this shouldn't be here")
  end

  if self.fireDirection * entity.direction() == 1 then
    self.flipStr = ""
  else
    self.flipStr = "flipped."
  end

  updateState()
end

function onInboundNodeChange(args)
  updateState()
end

function onNodeConnectionChange()
  updateState()
end

function updateState()
  if entity.getInboundNodeLevel(0) then
    self.cooldown = 0
    self.state = true
    entity.setAnimationState("trapState", self.flipStr.."on")
  else
    self.state = false
    entity.setAnimationState("trapState", self.flipStr.."off")
  end
end

function fire()
  --pew pew!
  entity.playSound("fireSounds")
  world.spawnProjectile(self.projectile, self.projectileSourcePosition, entity.id(), {self.fireDirection, 0}, false, self.projectileConfig)
end

function main()
  if self.state then
    self.cooldown = self.cooldown - entity.dt()
    if self.cooldown <= 0 then
      self.cooldown = self.cooldown + self.fireCycle
      fire()
    end
  end
end