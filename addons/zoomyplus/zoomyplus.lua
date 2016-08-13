-- Functions ZOOMY_CLAMP(), ZOOMY_IN(), ZOOMY_OUT(), and the 'Zoomy' name are taken from Excrulon's Zoomy v1.0.0 addon.
local acutil = require('acutil');
local settings = {}
local zplusTimer = imcTime.GetAppTime()
local zplusTimeElapsed = 0
local zplusSwitch = 1
CHAT_SYSTEM('Zoomy Plus loaded! Help: /zplus help');

function ZOOMYPLUS_ON_INIT(addon, frame)
	frame:ShowWindow(1);
	acutil.slashCommand('/zplus',ZOOMYPLUS_CMD);
	frame:RunUpdateScript("ZOOMY_KEYPRESS", 0, 0, 0, 1);
	addon:RegisterMsg('FPS_UPDATE', 'ZOOMYPLUS_UPDATE');
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
		CHAT_SYSTEM('Invalid command. Available commands:{nl}/zplus help{nl}/zplus zoom <num>{nl}/zplus swap <num1> <num2>{nl}/zplus rotate <x> <y>{nl}/zplus reset');
        return;
    end
	if cmd == 'help' then
		CHAT_SYSTEM('Zoomy Plus Help:{nl}Page Up to zoom in and Page Down to zoom out. Hold Left Ctrl to zoom in and out 5 times faster. Also while holding Left Ctrl you can hold Right Click and move the mouse to rotate the camera!{nl}/zplus zoom <num> for specific zoom amount anywhere between 50 and 1500!{nl}Example: /zplus zoom 800{nl}/zplus swap <num1> <num2> to swap between two zoom amounts!{nl}Example: /zplus swap 350 500{nl}/zplus rotate <x> <y> to rotate camera to specific coordinates between 0 and 359!{nl}Example: /zplus rotate 90 10{nl}/zplus reset to restore default positioning.');
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
				CHAT_SYSTEM('Invalid zoom amount. Minimum is 50 and maximum is 1500.');
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
				CHAT_SYSTEM('Invalid zoom amount. Minimum is 50 and maximum is 1500.');
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
				currentZoom = 236;
				ZOOMYPLUS_SETTEXT();
			else
				CHAT_SYSTEM('Invalid x y values. Minimum for both is 0 and maximum for both is 359.');
			end
		end
		return;
	end
	if cmd == 'reset' then
		currentX = 45;
		currentY = 38;
		camera.CamRotate(38, 45);
		currentZoom = 236;
		ZOOMYPLUS_SETTEXT();
		return;
	end
	CHAT_SYSTEM('Invalid command. Available commands:{nl}/zplus help{nl}/zplus zoom <num>{nl}/zplus swap <num1> <num2>{nl}/zplus rotate <x> <y>{nl}/zplus reset');
	return;
end

function ZOOMYPLUS_UPDATE(frame, msg, argStr, argNum)
	zoomyplusFrame = ui.GetFrame('zplusframe');
	if zoomyplusFrame == nil then
		zoomyplusFrame = ui.CreateNewFrame('bandicam','zplusframe');
		zoomyplusFrame:SetBorder(0, 0, 0, 0);
		zoomyplusFrame:Resize(100,60);
		zoomyplusFrame:SetOffset(510,880);
	
		zoomyplusZText = zoomyplusFrame:CreateOrGetControl('richtext','zoomyplusZText',0,-20,0,0);
		zoomyplusZText = tolua.cast(zoomyplusZText,'ui::CRichText');
		zoomyplusZText:SetGravity(ui.LEFT,ui.CENTER_VERT);
		zoomyplusZText:SetText('{s16}{#B81313}{ol}Z : ' .. tonumber(currentZoom));
		zoomyplusZText:ShowWindow(1);
	
		zoomyplusXText = zoomyplusFrame:CreateOrGetControl('richtext','zoomyplusXText',0,0,0,0);
		zoomyplusXText = tolua.cast(zoomyplusXText,'ui::CRichText');
		zoomyplusXText:SetGravity(ui.LEFT,ui.CENTER_VERT);
		zoomyplusXText:SetText('{s16}{#B81313}{ol}X : ' .. tonumber(currentX));
		zoomyplusXText:ShowWindow(1);
	
		zoomyplusYText = zoomyplusFrame:CreateOrGetControl('richtext','zoomyplusYText',0,20,0,0);
		zoomyplusYText = tolua.cast(zoomyplusYText,'ui::CRichText');
		zoomyplusYText:SetGravity(ui.LEFT,ui.CENTER_VERT);
		zoomyplusYText:SetText('{s16}{#B81313}{ol}Y : ' .. tonumber(currentY));
		zoomyplusYText:ShowWindow(1);
		
		currentZoom = 236;
	end
end

function ZOOMYPLUS_SETTEXT()
	if zoomyplusFrame ~= nil then
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
		currentX = currentX + rightX2;
	end
	if mouseX > mouseX2 then
		leftX = mouseX - mouseX2;
		leftX2 = math.ceil(leftX / 5);
		currentX = currentX - leftX2;
	end
	if mouseY > mouseY2 then
		upY = mouseY - mouseY2;
		upY2 = math.ceil(upY / 5);
		currentY = currentY + upY2;
	end
	if mouseY < mouseY2 then
		downY = mouseY2 - mouseY;
		downY2 = math.ceil(downY / 5);
		currentY = currentY - downY2;
	end
	XY_CLAMP();

	camera.CamRotate(currentY, currentX);
	currentZoom = 236;
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