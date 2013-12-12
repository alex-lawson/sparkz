function init(args)
  if storage.state == nil then
    output(false)
  else
    output(storage.state)
  end

  object.waterCooldown = 0
end

function output(state)
  if state ~= storage.state then
    storage.state = state
    if state then
      object.setAnimationState("fountainState", "on")
    else
      object.setAnimationState("fountainState", "off")
    end
  end
end

function main(args)
  if object.getInboundNodeLevel(0) then
    output(true)

    object.waterCooldown = object.waterCooldown - object.dt()
    if object.waterCooldown <= 0 then
      object.waterCooldown = object.configParameter("interval")
      world.spawnProjectile("sparkz_water", {object.position()[1] + 1, object.position()[2] - 1}, object.id(), {0, 1}, false, {})
    end
  else
    output(false)
  end
end