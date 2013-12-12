function init(args)
  object.alarmSoundTimer = 0

  if storage.state == nil then
    output(false)
  else
    output(storage.state)
  end
end

function output(state)
  if state ~= storage.state then
    object.alarmSoundTimer = 0

    storage.state = state
    if state then
      object.setAnimationState("alarmState", "on")
    else
      object.setAnimationState("alarmState", "off")
    end
  end
end

function main(args)
  world.logInfo(object.getInboundNodeLevel(0))

  if object.getInboundNodeLevel(0) then
    output(true)

    object.alarmSoundTimer = object.alarmSoundTimer - object.dt()
    if object.alarmSoundTimer <= 0 then
      object.playSound("alertSounds")
      object.alarmSoundTimer = object.configParameter("alertSoundDuration")
    end
  else
    output(false)
  end
end