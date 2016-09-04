_G["MOUNT'ERGOOD"] = {};
_G["MOUNT'ERGOOD"].noPet = 0;
_G["MOUNT'ERGOOD"].timer = imcTime.GetAppTime();
_G["MOUNT'ERGOOD"].timeElapsed = 0;
_G["MOUNT'ERGOOD"].nilSwitch = 0;
CHAT_SYSTEM("Mount 'er Good Loaded! Use: '/nopet' if you need to deactivate your companion.");

function MOUNTERGOOD_ON_INIT(addon, frame)
	local acutil = require("acutil");
	acutil.setupHook(MOUNTERGOOD_HOOKED, "ON_RIDING_VEHICLE");
	acutil.slashCommand("/nopet", MOUNTERGOOD_NOPET_TOGGLE);
	addon:RegisterMsg("FPS_UPDATE", "MOUNTERGOOD_UPDATE");
	
	_G["MOUNT'ERGOOD"].brokenPet = 0;
end

function MOUNTERGOOD_HOOKED(mountType)
	if mountType == 1 then
		if GetMyActor():GetVehicleState() == true then
			return;
		else
			if control.HaveNearCompanionToRide() == true then
				control.RideCompanion(1);
			else
				if control.GetMyCompanionActor() ~= nil then
					control.GetMyCompanionActor():SetPos(GetMyActor():GetPos());
					control.RideCompanion(1);
				end
			end
		end
	else
		control.RideCompanion(0);
	end
end

function MOUNTERGOOD_UPDATE()
	local petFrame = ui.GetFrame("pet_info");
	local petGuid = petFrame:GetUserValue("PET_GUID");
	if petGuid == "None" then
		UI_TOGGLE_PETLIST();
		petFrame:ShowWindow(0);
		return MOUNTERGOOD_UPDATE();
	end
	local petInfo = session.pet.GetPetByGUID(petGuid);
	local petObj = GetIES(petInfo:GetObject());
	local petActive = petObj.IsActivated;
	if petActive == 1 then
		if control.GetMyCompanionActor() == nil then
			if _G["MOUNT'ERGOOD"].nilSwitch == 0 and _G["MOUNT'ERGOOD"].brokenPet == 0 then
				_G["MOUNT'ERGOOD"].nilSwitch = 1;
				ReserveScript("MOUNTERGOOD_BROKEN_TEST()",6);
			end
			if _G["MOUNT'ERGOOD"].brokenPet == 1 then
				control.CustomCommand("PET_ACTIVATE", 0);
				_G["MOUNT'ERGOOD"].timeElapsed = 0;
			end
		else
			_G["MOUNT'ERGOOD"].nilSwitch = 0;
		end
	end
	if petActive == 0 and _G["MOUNT'ERGOOD"].noPet == 0 then
		control.CustomCommand("PET_ACTIVATE", 0);
		_G["MOUNT'ERGOOD"].timeElapsed = 0;
	end
end

function MOUNTERGOOD_BROKEN_TEST()
	if control.GetMyCompanionActor() == nil and _G["MOUNT'ERGOOD"].nilSwitch == 1 then
		_G["MOUNT'ERGOOD"].brokenPet = 1;
		CHAT_SYSTEM("Your poor companion is broken. Until you go through a loading screen (which fixes the companion) your companion will be deactivated when it is too far away to teleport/mount and then reactivated 6 seconds later.");
	end
	_G["MOUNT'ERGOOD"].nilSwitch = 0;
end

function MOUNTERGOOD_NOPET_TOGGLE()
	local petFrame = ui.GetFrame("pet_info");
	local petGuid = petFrame:GetUserValue("PET_GUID");
	if petGuid == "None" then
		UI_TOGGLE_PETLIST();
		petFrame:ShowWindow(0);
		return MOUNTERGOOD_NOPET_TOGGLE();
	end
	local petInfo = session.pet.GetPetByGUID(petGuid);
	local petObj = GetIES(petInfo:GetObject());
	local petActive = petObj.IsActivated;
	if _G["MOUNT'ERGOOD"].noPet == 0 then
		if petActive == 1 then
			if GetMyActor():GetVehicleState() == true then
				CHAT_SYSTEM("Please dismount your companion before deactivating it.");
				return;
			end
			_G["MOUNT'ERGOOD"].timeElapsed = _G["MOUNT'ERGOOD"].timeElapsed + (imcTime.GetAppTime() - _G["MOUNT'ERGOOD"].timer);
			_G["MOUNT'ERGOOD"].timer = imcTime.GetAppTime();
			if _G["MOUNT'ERGOOD"].timeElapsed > 6 then
				control.CustomCommand("PET_ACTIVATE", 0);
				_G["MOUNT'ERGOOD"].timeElapsed = 0;
			else
				local cdPet = math.ceil(6 - _G["MOUNT'ERGOOD"].timeElapsed);
				CHAT_SYSTEM("Not enough time has passed to deactivate your companion. Try again in "..cdPet.." seconds.");
				return;
			end
		end
		_G["MOUNT'ERGOOD"].noPet = 1;
		CHAT_SYSTEM("Companion turned off.");
	else
		if petActive == 0 then
			_G["MOUNT'ERGOOD"].timeElapsed = _G["MOUNT'ERGOOD"].timeElapsed + (imcTime.GetAppTime() - _G["MOUNT'ERGOOD"].timer);
			_G["MOUNT'ERGOOD"].timer = imcTime.GetAppTime();
			if _G["MOUNT'ERGOOD"].timeElapsed > 6 then
				control.CustomCommand("PET_ACTIVATE", 0);
				_G["MOUNT'ERGOOD"].timeElapsed = 0;
			else
				local cdPet = math.ceil(6 - _G["MOUNT'ERGOOD"].timeElapsed);
				CHAT_SYSTEM("Not enough time has passed to activate your companion. Try again in "..cdPet.." seconds.");
				return;
			end
		end
		_G["MOUNT'ERGOOD"].noPet = 0;
		CHAT_SYSTEM("Companion turned on.");
	end
end