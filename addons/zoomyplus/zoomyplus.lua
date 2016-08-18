-- Functions ZOOMY_CLAMP(), ZOOMY_IN(), ZOOMY_OUT(), and the 'Zoomy' name are taken from Excrulon's Zoomy v1.0.0 addon.
local acutil = require('acutil');
local settings = {}
local zplusTimer = imcTime.GetAppTime()
local zplusTimeElapsed = 0
local zplusSwitch = 1
CHAT_SYSTEM('Zoomy Plus loaded! Help: /zplus help');

function ZOOMYPLUS_ON_INIT(addon, frame)
	ZOOMYPLUS_LOADSETTINGS();
	frame:ShowWindow(1);
	frame:RunUpdateScript("ZOOMY_KEYPRESS", 0, 0, 0, 1);
	addon:RegisterMsg('FPS_UPDATE', 'ZOOMYPLUS_UPDATE');
	acutil.slashCommand('/zplus',ZOOMYPLUS_CMD);
	if currentZoom == nil or currentZoom == '' then
		currentZoom = 236;
	end
	if currentX == nil or currentX == '' then
		currentX = 45;
	end
	if currentY == nil or currentY == '' then
		currentY = 38;
	end
end

local default = {display = 1, displayX = 510, displayY = 880, lock = 1};
local settings = {};

function ZOOMYPLUS_LOADSETTINGS()
	local s, err = acutil.loadJSON("../addons/zoomyplus/settings.json");
	if err then
		settings = default;
	else
		settings = s;
		for k,v in pairs(default) do
			if s[k] == nil then
				settings[k] = v;
			end
		end
	end
	ZOOMYPLUS_SAVESETTINGS();
end

function ZOOMYPLUS_SAVESETTINGS()
	acutil.saveJSON("../addons/zoomyplus/settings.json", settings);
end

local ZOOM_AMOUNT = 2;
local ZOOM_AMOUNT2 = 10;
local MINIMUM_ZOOM = 50;
local MAXIMUM_ZOOM = 1500;
local MINIMUM_XY = 0;
local MAXIMUM_XY = 359;

function ZOOMYPLUS_CMD(command)
	local cmd = '';
	if #command > 0 then
        cmd = table.remove(command, 1);
    else
		CHAT_SYSTEM('Invalid command. Available commands:{nl}/zplus help{nl}/zplus zoom <num>{nl}/zplus swap <num1> <num2>{nl}/zplus rotate <x> <y>{nl}/zplus reset{nl}/zplus reset xy{nl}/zplus display{nl}/zplus lock{nl}/zplus default');
        return;
    end
	if cmd == 'help' then
		CHAT_SYSTEM('Zoomy Plus Help:{nl}Use Page Up to zoom in and Page Down to zoom out. Doing so while holding Left Ctrl makes zooming in and out 5 times faster. Also while holding Left Ctrl you can press and hold Right Click to rotate the camera by moving the mouse!{nl}"/zplus zoom <num>" to go to a specific zoom level anywhere between 50 and 1500!{nl}Example: /zplus zoom 800{nl}"/zplus swap <num1> <num2>" to swap between two zoom levels!{nl}Example: /zplus swap 350 500{nl}"/zplus rotate <x> <y>" to rotate camera to specific coordinates between 0 and 359!{nl}Example: /zplus rotate 90 10{nl}"/zplus reset" to restore default xy positioning and zoom level.{nl}"/zplus reset xy" to restore default positioning to xy only.{nl}"/zplus display" to show/hide the coordinate display.{nl}"/zplus lock" to unlock/lock the coordinate display in order to move it around.{nl}"/zplus default" to restore coordinate display to its default location.');
		return;
	end
	if cmd == 'zoom' then
		local zoom1 = tonumber(table.remove(command, 1));
		if type(zoom1) == 'number' then
			if zoom1 >= MINIMUM_ZOOM and zoom1 <= MAXIMUM_ZOOM then
				currentZoom = zoom1;
				camera.CustomZoom(currentZoom);
				ZOOMYPLUS_SETTEXT();
			else
				CHAT_SYSTEM('Invalid zoom level. Minimum is 50 and maximum is 1500.');
			end
		end
		return;
	end
	if cmd == 'swap' then
		local swap1 = tonumber(table.remove(command, 1));
		local swap2 = tonumber(table.remove(command, 1));
		if type(swap1) == 'number' and type(swap2) == 'number' then
			if swap1 >= MINIMUM_ZOOM and swap1 <= MAXIMUM_ZOOM and swap2 >= MINIMUM_ZOOM and swap2 <= MAXIMUM_ZOOM then
				if currentZoom == swap1 then
					currentZoom = swap2;
					camera.CustomZoom(currentZoom);
					ZOOMYPLUS_SETTEXT();
				else
					currentZoom = swap1;
					camera.CustomZoom(currentZoom);
					ZOOMYPLUS_SETTEXT();
				end
			else
				CHAT_SYSTEM('Invalid zoom level. Minimum is 50 and maximum is 1500.');
			end
		end
		return;
	end
	if cmd == 'rotate' then
		local x1 = tonumber(table.remove(command, 1));
		local y1 = tonumber(table.remove(command, 1));
		if type(x1) == 'number' and type(y1) == 'number' then
			if x1 >= MINIMUM_XY and x1 <= MAXIMUM_XY and y1 >= MINIMUM_XY and y1 <= MAXIMUM_XY then
				currentX = x1;
				currentY = y1;
				camera.CamRotate(currentY, currentX);
				camera.CustomZoom(currentZoom);
				ZOOMYPLUS_SETTEXT();
			else
				CHAT_SYSTEM('Invalid x y values. Minimum for both is 0 and maximum for both is 359.');
			end
		end
		return;
	end
	if cmd == 'reset' then
		local resetcmd = '';
		if #command > 0 then
			resetcmd = table.remove(command, 1);			
		else
			currentX = 45;
			currentY = 38;
			camera.CamRotate(38, 45);
			currentZoom = 236;
			ZOOMYPLUS_SETTEXT();
			return;
		end
		if resetcmd == 'xy' then
			currentX = 45;
			currentY = 38;
			camera.CamRotate(38, 45);
			camera.CustomZoom(currentZoom);
			ZOOMYPLUS_SETTEXT();
			return;
		end
	end
	if cmd == 'display' then
		if settings.display == 1 then
			settings.display = 0;
			settings.lock = 1;
			zoomyplusFrame:EnableHitTest(0);
			zoomyplusFrame:EnableMove(0);
			zoomyplusFrame.EnableHittestFrame(zoomyplusFrame, 0);
			zoomyplusFrame:ShowWindow(0)
			ZOOMYPLUS_SAVESETTINGS();
			return;
		else
			settings.display = 1;
			zoomyplusFrame:ShowWindow(1)
			ZOOMYPLUS_SAVESETTINGS();
			return;
		end
	end
	if cmd == 'lock' then
		if settings.lock == 1 then
			settings.lock = 0;
			zoomyplusFrame:EnableHitTest(1);
			zoomyplusZText:EnableHitTest(0);
			zoomyplusXText:EnableHitTest(0);
			zoomyplusYText:EnableHitTest(0);
			zoomyplusFrame:EnableMove(1);
			zoomyplusFrame.EnableHittestFrame(zoomyplusFrame, 1);
			CHAT_SYSTEM('Coordinate display unlocked.');
			ZOOMYPLUS_SAVESETTINGS();
		else
			settings.lock = 1;
			zoomyplusFrame:EnableHitTest(0);
			zoomyplusFrame:EnableMove(0);
			zoomyplusFrame.EnableHittestFrame(zoomyplusFrame, 0);
			CHAT_SYSTEM('Coordinate display locked.');
			ZOOMYPLUS_SAVESETTINGS();
		end
		return;
	end
	if cmd == 'default' then
		settings.displayX = 510;
		settings.displayY = 880;
		settings.display = 1;
		settings.lock = 1;
		zoomyplusFrame:SetOffset(settings.displayX, settings.displayY);
		zoomyplusFrame:EnableHitTest(0);
		zoomyplusFrame:EnableMove(0);
		zoomyplusFrame.EnableHittestFrame(zoomyplusFrame, 0);
		zoomyplusFrame:ShowWindow(1)
		ZOOMYPLUS_SAVESETTINGS();
		return;
	end
	CHAT_SYSTEM('Invalid command. Available commands:{nl}/zplus help{nl}/zplus zoom <num>{nl}/zplus swap <num1> <num2>{nl}/zplus rotate <x> <y>{nl}/zplus reset{nl}/zplus reset xy{nl}/zplus display{nl}/zplus lock{nl}/zplus default');
	return;
end

function ZOOMYPLUS_UPDATE(frame, msg, argStr, argNum)
	if frame:IsVisible() == 0 then
		frame:ShowWindow(1);
	end
	
	zoomyplusFrame = ui.GetFrame('zplusframe');
	if zoomyplusFrame == nil and settings.display == 1 then
		zoomyplusFrame = ui.CreateNewFrame('bandicam','zplusframe');
		zoomyplusFrame:SetBorder(0, 0, 0, 0);
		zoomyplusFrame:Resize(60,60);
		zoomyplusFrame:SetOffset(settings.displayX, settings.displayY);
		zoomyplusFrame:ShowWindow(1)
		zoomyplusFrame:SetLayerLevel(61);
		zoomyplusFrame.isDragging = false;
		zoomyplusFrame:SetEventScript(ui.LBUTTONDOWN, "ZOOMYPLUS_START_DRAG");
		zoomyplusFrame:SetEventScript(ui.LBUTTONUP, "ZOOMYPLUS_END_DRAG");
		zoomyplusFrame:EnableHitTest(0);
		zoomyplusFrame:EnableMove(0);
		zoomyplusFrame.EnableHittestFrame(zoomyplusFrame, 0);
		settings.lock = 1;
		ZOOMYPLUS_SAVESETTINGS();
		
		zoomyplusZText = zoomyplusFrame:CreateOrGetControl('richtext','zoomyplusZText',0,-20,0,0);
		zoomyplusZText = tolua.cast(zoomyplusZText,'ui::CRichText');
		zoomyplusZText:SetGravity(ui.LEFT,ui.CENTER_VERT);
		zoomyplusZText:SetText('{s16}{#B81313}{ol}Z : ' .. tonumber(currentZoom));

		zoomyplusXText = zoomyplusFrame:CreateOrGetControl('richtext','zoomyplusXText',0,0,0,0);
		zoomyplusXText = tolua.cast(zoomyplusXText,'ui::CRichText');
		zoomyplusXText:SetGravity(ui.LEFT,ui.CENTER_VERT);
		zoomyplusXText:SetText('{s16}{#B81313}{ol}X : ' .. tonumber(currentX));

		zoomyplusYText = zoomyplusFrame:CreateOrGetControl('richtext','zoomyplusYText',0,20,0,0);
		zoomyplusYText = tolua.cast(zoomyplusYText,'ui::CRichText');
		zoomyplusYText:SetGravity(ui.LEFT,ui.CENTER_VERT);
		zoomyplusYText:SetText('{s16}{#B81313}{ol}Y : ' .. tonumber(currentY));
	end
	if settings.display == 1 and not zoomyplusFrame.isDragging then
		zoomyplusFrame:SetOffset(settings.displayX, settings.displayY);
	end
	cameraFrame = ui.GetFrame('cameraframe');
	if cameraFrame == nil then
		cameraFrame = ui.CreateNewFrame('bandicam','cameraframe');
		camera.CamRotate(currentY, currentX);
		camera.CustomZoom(currentZoom);
	end
end

function ZOOMYPLUS_START_DRAG()
	zoomyplusFrame.isDragging = true;
end

function ZOOMYPLUS_END_DRAG()
	settings.displayX = zoomyplusFrame:GetX();
	settings.displayY = zoomyplusFrame:GetY();
	ZOOMYPLUS_SAVESETTINGS();
	zoomyplusFrame.isDragging = false;
end

function ZOOMYPLUS_SETTEXT()
	if zoomyplusFrame ~= nil and settings.display == 1 then
		zoomyplusZText:SetText('{s16}{#B81313}{ol}Z : ' .. tonumber(currentZoom));
		zoomyplusXText:SetText('{s16}{#B81313}{ol}X : ' .. tonumber(currentX));
		zoomyplusYText:SetText('{s16}{#B81313}{ol}Y : ' .. tonumber(currentY));
	end
end

function ZOOMY_IN()
	currentZoom = currentZoom - ZOOM_AMOUNT;

	ZOOMY_CLAMP();

	camera.CustomZoom(currentZoom);
	ZOOMYPLUS_SETTEXT();
end

function ZOOMY_OUT()
	currentZoom = currentZoom + ZOOM_AMOUNT;

	ZOOMY_CLAMP();

	camera.CustomZoom(currentZoom);
	ZOOMYPLUS_SETTEXT();
end

function ZOOMY_IN2()
	currentZoom = currentZoom - ZOOM_AMOUNT2;

	ZOOMY_CLAMP();

	camera.CustomZoom(currentZoom);
	ZOOMYPLUS_SETTEXT();
end

function ZOOMY_OUT2()
	currentZoom = currentZoom + ZOOM_AMOUNT2;

	ZOOMY_CLAMP();

	camera.CustomZoom(currentZoom);
	ZOOMYPLUS_SETTEXT();
end

function ZOOMY_CLAMP()
	if currentZoom < MINIMUM_ZOOM then
		currentZoom = MINIMUM_ZOOM;
	elseif currentZoom > MAXIMUM_ZOOM then
		currentZoom = MAXIMUM_ZOOM;
	end
end

function XY_CLAMP()
	if currentX < MINIMUM_XY then
		currentX = MAXIMUM_XY;
	elseif currentX > MAXIMUM_XY then
		currentX = MINIMUM_XY;
	elseif currentY < MINIMUM_XY then
		currentY = MAXIMUM_XY;
	elseif currentY > MAXIMUM_XY then
		currentY = MINIMUM_XY;
	end
end

function ZOOMYPLUS_XY()
	zplusTimeElapsed = imcTime.GetAppTime() - zplusTimer
	if zplusTimeElapsed >= 0.05 and zplusSwitch == 1 then
		mouseX = mouse.GetX();
		mouseY = mouse.GetY();
		mouseX2 = mouse.GetX();
		mouseY2 = mouse.GetY();
		zplusTimeElapsed = 0;
		zplusSwitch = 2;
	end
	if zplusTimeElapsed >= 0.05 and zplusSwitch == 2 then
		mouseX2 = mouse.GetX();
		mouseY2 = mouse.GetY();
		zplusTimeElapsed = 0;
		zplusSwitch = 1;
	end
	if mouseX < mouseX2 then
		rightX = mouseX2 - mouseX;
		rightX2 = math.ceil(rightX / 5);
		currentX = currentX - rightX2;
	end
	if mouseX > mouseX2 then
		leftX = mouseX - mouseX2;
		leftX2 = math.ceil(leftX / 5);
		currentX = currentX + leftX2;
	end
	if mouseY > mouseY2 then
		upY = mouseY - mouseY2;
		upY2 = math.ceil(upY / 5);
		currentY = currentY - upY2;
	end
	if mouseY < mouseY2 then
		downY = mouseY2 - mouseY;
		downY2 = math.ceil(downY / 5);
		currentY = currentY + downY2;
	end
	XY_CLAMP();

	camera.CamRotate(currentY, currentX);
	camera.CustomZoom(currentZoom);
	ZOOMYPLUS_SETTEXT();
end

function ZOOMY_KEYPRESS(frame)
	if keyboard.IsKeyPressed("NEXT") == 1 then
		ZOOMY_OUT();
	elseif keyboard.IsKeyPressed("PRIOR") == 1 then
		ZOOMY_IN();
	end
	if keyboard.IsKeyPressed("LCTRL") == 1 then
		if keyboard.IsKeyPressed("NEXT") == 1 then
		ZOOMY_OUT2();
		elseif keyboard.IsKeyPressed("PRIOR") == 1 then
		ZOOMY_IN2();
		end
	end
	if keyboard.IsKeyPressed("LCTRL") == 1 then
		if mouse.IsRBtnPressed() == 1 then
			ZOOMYPLUS_XY();
		else
			mouseX = nil;
			mouseY = nil;
			mouseX2 = nil;
			mouseY2 = nil;
		end
	end
	return 1;
end
