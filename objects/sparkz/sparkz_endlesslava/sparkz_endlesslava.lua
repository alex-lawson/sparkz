function init(args)
  if storage.state == nil then
    output(false)
  else
    output(storage.state)
  end
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

    world.spawnProjectile("sparkz_lava", {object.position()[1] + 0.5, object.position()[2]}, object.id(), {0, 1}, false, {})
  else
    output(false)
  end
end