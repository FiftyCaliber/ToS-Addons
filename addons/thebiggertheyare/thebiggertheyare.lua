function THEBIGGERTHEYARE_ON_INIT(addon, frame)
	addon:RegisterMsg("FPS_UPDATE", "TBTA_UPDATE");
	addon:RegisterMsg("TARGET_SET", "TBTA_UPDATE");
end

function TBTA_UPDATE()
	local handle = session.GetTargetHandle();
	local monsterName = info.GetMonsterClassName(handle);
	local owner = info.GetOwner(handle);
	local amIOwner = CFSMActor.IsMyPC(world.GetActor(owner));
	local ownerState = world.GetActor(owner):GetVehicleState();
	local targetState = world.GetActor(handle):GetVehicleState();
	local isTgtPC = info.IsPC(handle)
	local companionList, companionCount = GetClassList("Companion");
	for i = 0, companionCount-1 do
		local companionClass = GetClassByIndexFromList(companionList, i);
		if monsterName == companionClass.ClassName and amIOwner == 0 and ownerState == true then
			world.GetActor(owner):SetNodeScale("Bip01 Head", 3);
		end
		if monsterName == companionClass.ClassName and amIOwner == 0 and ownerState == false then
			world.GetActor(owner):SetNodeScale("Bip01 Head", 1);
		end
	end
	if isTgtPC == 1 and targetState == true then
		world.GetActor(handle):SetNodeScale("Bip01 Head", 3);
	end
	if isTgtPC == 1 and targetState == false then
		world.GetActor(handle):SetNodeScale("Bip01 Head", 1);
	end
end