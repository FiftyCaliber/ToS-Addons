_G["SWAPIT"] = {};
local acutil = require("acutil");
CHAT_SYSTEM("Swapit loaded! Help: /swapit help");

function SWAPIT_ON_INIT(addon, frame)
	acutil.slashCommand("/swapit",SWAPIT_CMD);
	acutil.slashCommand("/si",SWAPIT_CMD);
	addon:RegisterMsg("WEAPONSWAP","WS_SWAP_UPDATE");
	addon:RegisterMsg("WEAPONSWAP_FAIL","WS_FAIL");
	addon:RegisterMsg("WEAPONSWAP_SUCCESS","WS_SLOT_SUCCESS");
	addon:RegisterMsg("ABILITY_LIST_GET","SWAPIT_SHOW_UI");
	addon:RegisterMsg("GAME_START_3SEC", "REMOVEOLDWS_3SEC");
	
	SWAPIT_LOADSETTINGS();
	SWAPIT_CREATE_FRAME();
end

function SWAPIT_LOADSETTINGS()
	local settings, error = acutil.loadJSON("../addons/swapit/settings.json");
	if error then
		SWAPIT_SAVESETTINGS();
	else
		_G["SWAPIT"]["settings"] = settings;
	end
	local charID = info.GetCID(session.GetMyHandle());
	local data, error = acutil.loadJSON("../addons/swapit/" .. charID .. ".json");
	if error then
		SWAPIT_SAVESETTINGS();
	else
		_G["SWAPIT"]["slots"] = data;
	end
end

function SWAPIT_SAVESETTINGS()
	if _G["SWAPIT"]["settings"] == nil then
		_G["SWAPIT"]["settings"] = {
			displayX = 505;
			displayY = 955;
			lock = 1;
		};
	end
	acutil.saveJSON("../addons/swapit/settings.json", _G["SWAPIT"]["settings"]);
	if _G["SWAPIT"]["slots"] == nil then
		_G["SWAPIT"]["slots"] = {
			swapitSlot4 = "0";
			swapitSlot5 = "0";
			swapitSlot6 = "0";
			swapitSlot7 = "0";
			swapitLine = 1;
		};
	end
	local charID = info.GetCID(session.GetMyHandle());
	acutil.saveJSON("../addons/swapit/" .. charID .. ".json", _G["SWAPIT"]["slots"]);
end

function SWAPIT_CMD(command)
	if swapitFrame:IsVisible() == 0 then
		CHAT_SYSTEM("You must have the 'Weapon Swap' attribute to use Swapit.");
		return;
	end
	
	local cmd = "";
	if #command > 0 then
        cmd = table.remove(command, 1);
    else
		SWAPIT_TOGGLE_SWAP();
		return;
    end
	if cmd == "help" then
		CHAT_SYSTEM("Swapit Help:{nl}'/swapit' to swap your left side weapons. Highly recommended to put this on an ingame macro (F8) so you can assign it to any key binding you like.{nl}'/swapit lock' to unlock/lock the Swapit display in order to move it around. Be sure to lock it again when you have it where you like, otherwise you can't interact with the slots.{nl}'/swapit default' to restore Swapit display to its default location.");
		return;
	end
	if cmd == "lock" then
		if _G["SWAPIT"]["settings"].lock == 1 then
			_G["SWAPIT"]["settings"].lock = 0;
			swapitFrame:EnableMove(1);
			txtUnlocked:ShowWindow(1);
			boxB1:EnableHitTest(0);
			boxB2:EnableHitTest(0);
			boxA1:EnableHitTest(0);
			boxA2:EnableHitTest(0);
			picLeft:EnableHitTest(0);
			picRight:EnableHitTest(0);
			SWAPIT_SAVESETTINGS();
		else
			_G["SWAPIT"]["settings"].lock = 1;
			swapitFrame:EnableMove(0);
			txtUnlocked:ShowWindow(0);
			boxB1:EnableHitTest(1);
			boxB2:EnableHitTest(1);
			boxA1:EnableHitTest(1);
			boxA2:EnableHitTest(1);
			picLeft:EnableHitTest(1);
			picRight:EnableHitTest(1);
			SWAPIT_SAVESETTINGS();
		end
		return;
	end
	if cmd == "default" then
		_G["SWAPIT"]["settings"].displayX = 505;
		_G["SWAPIT"]["settings"].displayY = 955;
		swapitFrame:SetOffset(_G["SWAPIT"]["settings"].displayX, _G["SWAPIT"]["settings"].displayY);
		_G["SWAPIT"]["settings"].lock = 1;
		swapitFrame:EnableMove(0);
		txtUnlocked:ShowWindow(0);
		boxB1:EnableHitTest(1);
		boxB2:EnableHitTest(1);
		boxA1:EnableHitTest(1);
		boxA2:EnableHitTest(1);
		picLeft:EnableHitTest(1);
		picRight:EnableHitTest(1);
		SWAPIT_SAVESETTINGS();
		return;
	end
	CHAT_SYSTEM("Invalid command. Available commands:{nl}/swapit{nl}/swapit lock{nl}/swapit default");
end


function SWAPIT_CREATE_FRAME()
--	[Frame]
	swapitFrame = ui.GetFrame("swapit");
	swapitFrame:EnableHitTest(1);
	swapitFrame:SetOffset(_G["SWAPIT"]["settings"].displayX, _G["SWAPIT"]["settings"].displayY);
	swapitFrame.isDragging = false;
	swapitFrame:SetEventScript(ui.LBUTTONDOWN, "SWAPIT_START_DRAG");
	swapitFrame:SetEventScript(ui.LBUTTONUP, "SWAPIT_END_DRAG");

--	[Right]
	boxB1 = swapitFrame:GetChild("b1");
	local slotLine = session.GetWeaponCurrentSlotLine();
	if slotLine == 0 then
		boxB1:SetOffset(94,0);
	else 
		boxB1:SetOffset(94,47);
	end
	slotB1L = boxB1:GetChild("slot0");
	slotB1R = boxB1:GetChild("slot1");
	slotB1R:SetOffset(42,0);

	boxB2 = swapitFrame:GetChild("b2");
	if slotLine == 0 then
		boxB2:SetOffset(94,47);
	else
		boxB2:SetOffset(94,0);
	end
	slotB2L = boxB2:GetChild("slot2");
	slotB2R = boxB2:GetChild("slot3");
	slotB2R:SetOffset(42,0);

--	[Left]
	boxA1 = swapitFrame:GetChild("a1");
	if _G["SWAPIT"]["slots"].swapitLine == 0 then
		boxA1:SetOffset(0,0);
	else
		boxA1:SetOffset(0,47);
	end
	slotA1L = boxA1:GetChild("slot4");
	slotA1R = boxA1:GetChild("slot5");
	slotA1R:SetOffset(42,0);

	boxA2 = swapitFrame:GetChild("a2");
	if _G["SWAPIT"]["slots"].swapitLine == 0 then
		boxA2:SetOffset(0,47);
	else
		boxA2:SetOffset(0,0);
	end
	slotA2L = boxA2:GetChild("slot6");
	slotA2R = boxA2:GetChild("slot7");
	slotA2R:SetOffset(42,0);

--	[Picture Fade]	
	fadeB = swapitFrame:CreateOrGetControl("groupbox", "fadeB",0,0,0,0);
	fadeB = tolua.cast(fadeB,"ui::CGroupBox");
	fadeB:SetOffset(94,0);
	fadeB:Resize(84,42);
	fadeB:SetSkinName("textview")
	fadeB:EnableHitTest(0);
	
	fadeA = swapitFrame:CreateOrGetControl("groupbox", "fadeA",0,0,0,0);
	fadeA = tolua.cast(fadeA,"ui::CGroupBox");
	fadeA:SetOffset(0,0);
	fadeA:Resize(84,42);
	fadeA:SetSkinName("textview")
	fadeA:EnableHitTest(0);
	
--	[Picture Left] (Swapit)
	picLeft = swapitFrame:CreateOrGetControl("picture", "picLeft",0,0,0,0);
	picLeft = tolua.cast(picLeft,"ui::CPicture");
	picLeft:SetOffset(27,30);
	picLeft:Resize(29,29);
	picLeft:SetImage("weaponswap_mark")
	picLeft:SetEnableStretch(1);
	picLeft:SetTextTooltip("{@st59}Use '/swapit' to swap weapons.{/}");

--	[Picture Right] (Original)
	picRight = swapitFrame:CreateOrGetControl("picture", "picRight",0,0,0,0);
	picRight = tolua.cast(picRight,"ui::CPicture");
	picRight:SetOffset(122,30);
	picRight:Resize(29,29);
	picRight:SetImage("weaponswap_mark")
	picRight:SetEnableStretch(1);
	picRight:SetTextTooltip("{@st59}This is your normal weapon swap.{/}");
	
--	[Unlocked Text]
	txtUnlocked = swapitFrame:CreateOrGetControl("richtext", "txtUnlocked",0,0,0,0);
	txtUnlocked = tolua.cast(txtUnlocked,"ui::CRichText");
	txtUnlocked:SetText("{@st44}{#FFFFFF}{s30}{b}Unlocked{/}{/}{/}{/}")
	txtUnlocked:SetGravity(ui.CENTER_HORZ,ui.CENTER_VERT);
	txtUnlocked:EnableHitTest(0);
	
--	[Show UI Check]
	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end
	
	local abil = GetAbility(pc, "SwapWeapon");
	if abil ~= nil then
		swapitFrame:ShowWindow(1);
	else
		swapitFrame:ShowWindow(0);
	end
	
--	[Update Swapit Icons]
	SWAPIT_UPDATE()
	
--	[Lock Check]
	if _G["SWAPIT"]["settings"].lock == 0 then
		swapitFrame:EnableMove(1);
		txtUnlocked:ShowWindow(1);
		boxB1:EnableHitTest(0);
		boxB2:EnableHitTest(0);
		boxA1:EnableHitTest(0);
		boxA2:EnableHitTest(0);
		picLeft:EnableHitTest(0);
		picRight:EnableHitTest(0);
	else
		swapitFrame:EnableMove(0);
		txtUnlocked:ShowWindow(0);
		boxB1:EnableHitTest(1);
		boxB2:EnableHitTest(1);
		boxA1:EnableHitTest(1);
		boxA2:EnableHitTest(1);
		picLeft:EnableHitTest(1);
		picRight:EnableHitTest(1);
	end
end

function SWAPIT_ITEM_DROP(parent, ctrl, argStr, argNum)
	local liftIcon = ui.GetLiftIcon();
	if liftIcon == nil then
		return;
	end
	
	local iconInfo = liftIcon:GetInfo();
	if iconInfo == nil then
		return;
	end
	
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	if invItem == nil then
		return;
	end
	
	local slot = tolua.cast(ctrl, "ui::CSlot");
	if nil == slot then
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if	obj.DefaultEqpSlot ~= "RH" and obj.DefaultEqpSlot ~= "LH" then
		return
	end
	
	local slotIndex = slot:GetSlotIndex();
	if slotIndex % 2 == 0 and
		obj.DefaultEqpSlot ~= "RH" then
		return;
	end
	if slotIndex % 2 == 1 and
		obj.DefaultEqpSlot ~= "LH" then
		return;
	end
	
	local swapitFrame = ui.GetFrame("swapit");
	if swapitFrame == nil then
		return;
	end

	SWAPIT_2H_WEAPON_CHECK(obj, swapitFrame, slotIndex);
	if slotIndex <= 3 then
		session.SetWeaponQuicSlot(slotIndex, invItem:GetIESID());
	else
		_G["SWAPIT"]["slots"]["swapitSlot" .. slotIndex] = invItem:GetIESID();
		SWAPIT_SAVESETTINGS();
	end
	SET_SLOT_ITEM_IMANGE(slot, invItem);
end

function SWAPIT_ITEM_POP(parent, ctrl)
	local slot 	= tolua.cast(ctrl, "ui::CSlot");
	slot:ClearIcon();
	
	local slotIndex = slot:GetSlotIndex();
	if slotIndex <= 3 then
		session.SetWeaponQuicSlot(slotIndex, "");
	else
		_G["SWAPIT"]["slots"]["swapitSlot" .. slotIndex] = "0";
		SWAPIT_SAVESETTINGS();
	end
end

function SWAPIT_2H_WEAPON_CHECK(obj, swapitFrame, slotIndex)
	if obj == nil then
		return;
	end
	if slotIndex % 2 == 0 then
		if obj.EquipGroup ~= "THWeapon" then
			return;
		end
		
		if slotIndex == 0 then
			etcSlot = boxB1:GetChild("slot1");
		elseif slotIndex == 2 then
			etcSlot = boxB2:GetChild("slot3");
		elseif slotIndex == 4 then
			etcSlot = boxA1:GetChild("slot5");
		elseif slotIndex == 6 then
			etcSlot = boxA2:GetChild("slot7");
		else
			return;
		end
		
		etcSlot = tolua.cast(etcSlot, "ui::CSlot")
		etcSlot:ClearIcon();
		
		if slotIndex <= 3 then
			session.SetWeaponQuicSlot(etcSlot:GetSlotIndex(), "");
		else
			_G["SWAPIT"]["slots"]["swapitSlot" .. etcSlot:GetSlotIndex()] = "0";
			SWAPIT_SAVESETTINGS();
		end
	else
		slotIndex = slotIndex - 1
		if slotIndex == 0 then
			etcSlot = boxB1:GetChild("slot0");
		elseif slotIndex == 2 then
			etcSlot = boxB2:GetChild("slot2");
		elseif slotIndex == 4 then
			etcSlot = boxA1:GetChild("slot4");
		elseif slotIndex == 6 then
			etcSlot = boxA2:GetChild("slot6");
		else
			return;
		end
		
		if nil == etcSlot then
			return;
		end
		etcSlot = tolua.cast(etcSlot, "ui::CSlot")
		local icon = etcSlot:GetIcon();
		if nil == icon then
			return;
		end
		
		local iconInfo = icon:GetInfo();
		local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
		
		if nil == invItem then
			return;
		end

		local itemObj = GetIES(invItem:GetObject());
		if itemObj.EquipGroup ~= "THWeapon" then
			return;
		end

		etcSlot:ClearIcon();
		if slotIndex <= 3 then
			session.SetWeaponQuicSlot(etcSlot:GetSlotIndex(), "");
		else
			_G["SWAPIT"]["slots"]["swapitSlot" .. etcSlot:GetSlotIndex()] = "0";
			SWAPIT_SAVESETTINGS();
		end
	end
end

function SWAPIT_UPDATE()
	local swapitFrame = ui.GetFrame("swapit");
	local boxA1 = swapitFrame:GetChild("a1");
	local boxA2 = swapitFrame:GetChild("a2");
	for i=4, 7 do
		if i <= 5 then
			local etcSlot = boxA1:GetChild("slot"..i);
			if etcSlot == nil then
				return;
			end
			etcSlot = tolua.cast(etcSlot, "ui::CSlot");
			
			local guid = _G["SWAPIT"]["slots"]["swapitSlot" .. i];
			if guid ~= "0" then 
				local item = GET_ITEM_BY_GUID(guid, 1);
				if item ~= nil then
					SET_SLOT_ITEM_IMANGE(etcSlot, item);
				else
					etcSlot:ClearIcon();
				end
			else
				etcSlot:ClearIcon();
			end
		elseif i >= 6 then
			local etcSlot = boxA2:GetChild("slot"..i);
			if etcSlot == nil then
				return;
			end
			etcSlot = tolua.cast(etcSlot, "ui::CSlot");
			
			local guid = _G["SWAPIT"]["slots"]["swapitSlot" .. i];
			if guid ~= "0" then 
				local item = GET_ITEM_BY_GUID(guid, 1);
				if item ~= nil then
					SET_SLOT_ITEM_IMANGE(etcSlot, item);
				else
					etcSlot:ClearIcon();
				end
			else
				etcSlot:ClearIcon();
			end
		end
	end
end

function SWAPIT_TOGGLE_SWAP()
	local swapitFrame = ui.GetFrame("swapit");
	if swapitFrame == nil then
		return;
	end
	
	local boxA1 = swapitFrame:GetChild("a1");
	local boxA2 = swapitFrame:GetChild("a2");
	if boxA1 == nil or boxA2 == nil then
		return;
	end
	
	if GetCraftState() == 1 then
		ui.SysMsg(ClMsg("prosessItemCraft"));
		return;
	end
	
	if _G["SWAPIT"]["slots"].swapitLine == 1 then
		_G["SWAPIT"]["slots"].swapitLine = 0;
		SWAPIT_SAVESETTINGS();
		
		boxA1:SetOffset(0,0);
		boxA2:SetOffset(0,47);
		
--		[Equip A2] (aka slots 6 & 7)
		if _G["SWAPIT"]["slots"].swapitSlot6 == "0" then
			local equipItem = session.GetEquipItemBySpot(8);
			if equipItem:GetIESID() ~= "0" then
				item.UnEquip(8);
			end
		else
			for i=1,3 do
				ITEM_EQUIP_MSG(session.GetInvItemByGuid(_G["SWAPIT"]["slots"].swapitSlot6),"RH");
			end
		end
		ReserveScript("SWAPIT_DELAYED_A2()",.25);
		imcSound.PlaySoundEvent("sys_weapon_swap");
	else
		_G["SWAPIT"]["slots"].swapitLine = 1;
		SWAPIT_SAVESETTINGS();
		
		boxA1:SetOffset(0,47);
		boxA2:SetOffset(0,0);
		
--		[Equip A1] (aka slots 4 & 5)
		if _G["SWAPIT"]["slots"].swapitSlot4 == "0" then
			local equipItem = session.GetEquipItemBySpot(8);
			if equipItem:GetIESID() ~= "0" then
				item.UnEquip(8);
			end
		else
			for i=1,3 do
				ITEM_EQUIP_MSG(session.GetInvItemByGuid(_G["SWAPIT"]["slots"].swapitSlot4),"RH");
			end
		end
		ReserveScript("SWAPIT_DELAYED_A1()",.25);
		imcSound.PlaySoundEvent("sys_weapon_swap");
	end
end

function WS_FAIL()
	ui.SysMsg(ClMsg("TryLater"));
	session.SetWeaponSwap(0);
	WS_SLOT_UPDATE();
end

function WS_SLOT_SUCCESS()
	imcSound.PlaySoundEvent("sys_weapon_swap");
	WS_SLOT_UPDATE()
end

function WS_SWAP_UPDATE()
	local swapitFrame = ui.GetFrame("swapit");
	local boxB1 = swapitFrame:GetChild("b1");
	local boxB2 = swapitFrame:GetChild("b2");
	for i=0, 3 do
		if i <= 1 then
			local etcSlot = boxB1:GetChild("slot"..i);
			if etcSlot == nil then
				return;
			end
			etcSlot = tolua.cast(etcSlot, "ui::CSlot");
			local guid = session.GetWeaponQuicSlot(i);
			if guid ~= nil then 
				local item = GET_ITEM_BY_GUID(guid, 1);
				if item ~= nil then
					SET_SLOT_ITEM_IMANGE(etcSlot, item);
				else
					etcSlot:ClearIcon();
				end
			else
				etcSlot:ClearIcon();
			end
		elseif i >= 2 then
			local etcSlot = boxB2:GetChild("slot"..i);
			if etcSlot == nil then
				return;
			end
			etcSlot = tolua.cast(etcSlot, "ui::CSlot");
			local guid = session.GetWeaponQuicSlot(i);
			if guid ~= nil then 
				local item = GET_ITEM_BY_GUID(guid, 1);
				if item ~= nil then
					SET_SLOT_ITEM_IMANGE(etcSlot, item);
				else
					etcSlot:ClearIcon();
				end
			else
				etcSlot:ClearIcon();
			end
		end
	end
	WS_CRAFTSTATE();
end

function WS_CRAFTSTATE()
	if GetCraftState() == 1 then
		ui.SysMsg(ClMsg("prosessItemCraft"));
		return;
	end
	WS_SLOT_UPDATE();
end

function WS_SLOT_UPDATE()
	local swapitFrame = ui.GetFrame("swapit");
	if swapitFrame == nil then
		return;
	end
	
	local boxB1 = swapitFrame:GetChild("b1");
	local boxB2 = swapitFrame:GetChild("b2");
	if boxB1 == nil or boxB2 == nil then
		return;
	end
	
	local slotLine = session.GetWeaponCurrentSlotLine();
	if slotLine == 0 then
		boxB1:SetOffset(94,0);
		boxB2:SetOffset(94,47);
	else 
		boxB1:SetOffset(94,47);
		boxB2:SetOffset(94,0);
	end
end

function SWAPIT_SHOW_UI()
	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end
	
	local abil = GetAbility(pc, "SwapWeapon");
	if abil ~= nil then
		swapitFrame:ShowWindow(1);
	else
		swapitFrame:ShowWindow(0);
	end
	ui.CloseFrame("weaponswap");
end

function SWAPIT_DELAYED_A2()
	if _G["SWAPIT"]["slots"].swapitSlot7 == "0" then
		local equipItem = session.GetEquipItemBySpot(9);
		if equipItem:GetIESID() ~= "0" then
			item.UnEquip(9);
		end
	else
		for i=1,3 do
			ITEM_EQUIP_MSG(session.GetInvItemByGuid(_G["SWAPIT"]["slots"].swapitSlot7),"LH");
		end
	end
end

function SWAPIT_DELAYED_A1()
	if _G["SWAPIT"]["slots"].swapitSlot5 == "0" then
		local equipItem = session.GetEquipItemBySpot(9);
		if equipItem:GetIESID() ~= "0" then
			item.UnEquip(9);
		end
	else
		for i=1,3 do
			ITEM_EQUIP_MSG(session.GetInvItemByGuid(_G["SWAPIT"]["slots"].swapitSlot5),"LH");
		end
	end	
end

function SWAPIT_START_DRAG()
	swapitFrame.isDragging = true;
end

function SWAPIT_END_DRAG()
	_G["SWAPIT"]["settings"].displayX = swapitFrame:GetX();
	_G["SWAPIT"]["settings"].displayY = swapitFrame:GetY();
	SWAPIT_SAVESETTINGS();
	swapitFrame.isDragging = false;
end

function REMOVEOLDWS_3SEC()
	ui.CloseFrame("weaponswap");
	ReserveScript('ui.CloseFrame("weaponswap");', 1);
end
