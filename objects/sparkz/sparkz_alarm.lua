function init(args)
  object.alarmSoundTimer = 0

  if storage.alarmSoundDuration == nil then
    storage.alarmSoundDuration = object.configParameter("alertSoundDuration")
  end

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
  if object.getInboundNodeLevel(0) then
    output(true)

    object.alarmSoundTimer = object.alarmSoundTimer - object.dt()
    if object.alarmSoundTimer <= 0 then
      object.playSound("alertSounds")
      object.alarmSoundTimer = storage.alarmSoundDuration
    end
  else
    output(false)
  end
end