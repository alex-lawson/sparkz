function init(virtual)
  if not virtual then
    self.projectile = entity.configParameter("projectile")

    if storage.state == nil then
      output(false)
    else
      output(storage.state)
    end
  end
end

function output(state)
  if state ~= storage.state then
    storage.state = state
    if state then
      entity.setAnimationState("fountainState", "on")
    else
      entity.setAnimationState("fountainState", "off")
    end
  end
end

function main(args)
  if entity.getInboundNodeLevel(0) then
    output(true)

    world.spawnProjectile(self.projectile, {entity.position()[1] + 0.5, entity.position()[2]}, entity.id(), {0, 1}, false, {})
  else
    output(false)
  end
end