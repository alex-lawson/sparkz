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
      object.setAnimationState("drainState", "on")
    else
      object.setAnimationState("drainState", "off")
    end
  end
end

function main(args)
  if object.getInboundNodeLevel(0) then
    output(true)

    pos = {object.position(), {object.position()[1] + 1, object.position()[2]}, {object.position()[1] - 1, object.position()[2]}}

    if world.liquidAt(pos[1]) then
      world.spawnProjectile("sparkz_drain", pos[2], object.id(), {-1, 0}, false, {})
      world.spawnProjectile("sparkz_drain", pos[3], object.id(), {1, 0}, false, {})
    end
  else
    output(false)
  end
end