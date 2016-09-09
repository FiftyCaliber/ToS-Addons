CHAT_SYSTEM("The Bigger They Are {s8}The Harder They Fall...{/} loaded!");

function THEBIGGERTHEYARE_ON_INIT(addon, frame)
	addon:RegisterMsg("FPS_UPDATE", "TBTA_CREATEFRAME");
end

function TBTA_CREATEFRAME()
	tbtaFrame = ui.GetFrame("tbtaFrame");
	if tbtaFrame == nil then
		tbtaFrame = ui.CreateNewFrame("thebiggertheyare","tbtaFrame");
		tbtaUpdate = tbtaFrame:CreateOrGetControl("timer","tbtaUpdate",0,0,0,0);
		tbtaUpdate = tolua.cast(tbtaUpdate,"ui::CAddOnTimer");
		tbtaUpdate:ShowWindow(1);
		tbtaUpdate:SetUpdateScript("TBTA_UPDATE");
		tbtaUpdate:EnableHideUpdate(1);
		tbtaUpdate:Stop();
		tbtaUpdate:Start(0.1);
	else
		if tbtaFrame:IsVisible() == 0 then
			tbtaFrame:ShowWindow(1);
		end
	end
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
			local actor = world.GetActor(handle);
			local petType = CFSMActor.GetType(actor);
			local petList, petCount = GetClassList("Monster");
			local petClass = GetClassByTypeFromList(petList, petType);
			CHAT_SYSTEM(info.GetName(owner) .. " " .. info.GetFamilyName(owner) .. "'s " .. petClass.Name .. " (" .. info.GetName(handle) .. ") has been hidden.");
			world.GetActor(owner):SetNodeScale("Bip01 Head", 3);
			world.Leave(handle, 0);
		end
		if monsterName == companionClass.ClassName and amIOwner == 0 and ownerState == false then
			world.GetActor(owner):SetNodeScale("Bip01 Head", 1);
			-- add something to bring companion back?
		end
	end
	if isTgtPC == 1 and targetState == true then
		world.GetActor(handle):SetNodeScale("Bip01 Head", 3);
	end
	if isTgtPC == 1 and targetState == false then
		world.GetActor(handle):SetNodeScale("Bip01 Head", 1);
	end
end
