local acutil = require('acutil');
local saviorMode = {'{#2D9B27}{ol}High','{#284B7E}{ol}Low','{#532881}{ol}Super Low'};
CHAT_SYSTEM('FPS Savior loaded! Help: /fpssavior help');

function FPSSAVIOR_ON_INIT(addon, frame)
	frame:ShowWindow(1);
	acutil.slashCommand('/fpssavior',FPSSAVIOR_CMD);
	addon:RegisterMsg('FPS_UPDATE', 'FPSSAVIOR_UPDATE');
	FPSSAVIOR_LOADSETTINGS();
end

local default = {saviorToggle = 1, displayX = 510, displayY = 860, lock = 1};
local settings = {};

function FPSSAVIOR_LOADSETTINGS()
	local s, err = acutil.loadJSON("../addons/fpssavior/settings.json");
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
	FPSSAVIOR_SAVESETTINGS();
end

function FPSSAVIOR_SAVESETTINGS()
	acutil.saveJSON("../addons/fpssavior/settings.json", settings);
end

function FPSSAVIOR_START_DRAG()
	saviorFrame.isDragging = true;
end

function FPSSAVIOR_END_DRAG()
	settings.displayX = saviorFrame:GetX();
	settings.displayY = saviorFrame:GetY();
	FPSSAVIOR_SAVESETTINGS();
	saviorFrame.isDragging = false;
end

function FPSSAVIOR_UPDATE(frame, msg, argStr, argNum)
	saviorFrame = ui.GetFrame('fpssaviorframe');
	if saviorFrame == nil then
		saviorFrame = ui.CreateNewFrame('bandicam','fpssaviorframe');
		saviorFrame:SetBorder(0, 0, 0, 0);
		saviorFrame:Resize(100,20)
		saviorFrame:SetOffset(settings.displayX, settings.displayY);
		saviorFrame:ShowWindow(1);
		saviorFrame:SetLayerLevel(61);
		saviorFrame.isDragging = false;
		saviorFrame:SetEventScript(ui.LBUTTONDOWN, "FPSSAVIOR_START_DRAG");
		saviorFrame:SetEventScript(ui.LBUTTONUP, "FPSSAVIOR_END_DRAG");
		saviorFrame:EnableHitTest(0);
		saviorFrame:EnableMove(0);
		saviorFrame.EnableHittestFrame(saviorFrame, 0);
		settings.lock = 1;
		FPSSAVIOR_SAVESETTINGS();
		
		saviorText = saviorFrame:CreateOrGetControl('richtext','saviortext',0,0,0,0);
		saviorText = tolua.cast(saviorText,'ui::CRichText');
		saviorText:SetGravity(ui.LEFT,ui.CENTER_VERT);
		saviorText:SetText('{s16}'..saviorMode[settings.saviorToggle]);
	end
	if not saviorFrame.isDragging then
		saviorFrame:SetOffset(settings.displayX, settings.displayY);
	end
	if tonumber(config.GetAutoAdjustLowLevel()) ~= 2 then
		config.SetAutoAdjustLowLevel(2);
		config.SaveConfig();
	end
end

function FPSSAVIOR_CMD(command)
	local cmd = '';
	if #command > 0 then
        cmd = table.remove(command, 1);
    else
		FPSSAVIOR_TOGGLE();
        return;
    end
	if cmd == 'help' then
		CHAT_SYSTEM('FPS Savior Help:{nl}"/fpssavior" to toggle between 3 predefined settings High, Low, and Super Low.{nl}"/fpssavior lock" to unlock/lock the settings display in order to move it around.{nl}"/fpssavior default" to restore the settings display to its default location.');
		return;
	end
	if cmd == 'lock' then
		if settings.lock == 1 then
			settings.lock = 0;
			saviorFrame:EnableHitTest(1);
			saviorText:EnableHitTest(0);
			saviorFrame:EnableMove(1);
			saviorFrame.EnableHittestFrame(saviorFrame, 1);
			CHAT_SYSTEM('Settings display unlocked.');
			FPSSAVIOR_SAVESETTINGS();
		else
			settings.lock = 1;
			saviorFrame:EnableHitTest(0);
			saviorFrame:EnableMove(0);
			saviorFrame.EnableHittestFrame(saviorFrame, 0);
			CHAT_SYSTEM('Settings display locked.');
			FPSSAVIOR_SAVESETTINGS();
		end
		return;
	end
	if cmd == 'default' then
		settings.displayX = 510;
		settings.displayY = 860;
		settings.lock = 1;
		saviorFrame:SetOffset(settings.displayX, settings.displayY);
		saviorFrame:EnableHitTest(0);
		saviorFrame:EnableMove(0);
		saviorFrame.EnableHittestFrame(saviorFrame, 0);
		FPSSAVIOR_SAVESETTINGS();
		return;
	end
	CHAT_SYSTEM('Invalid command. Available commands:{nl}/fpssavior{nl}/fpssavior lock{nl}/fpssavior default');
	return;
end

function FPSSAVIOR_SETTEXT()
	if saviorFrame ~= nil then
		saviorText:SetText('{s16}'..saviorMode[settings.saviorToggle]);
	end
end


function FPSSAVIOR_DEFAULT()
	settings.saviorToggle = 1;

	graphic.SetDrawActor(100);
	graphic.SetDrawMonster(100);
	graphic.EnableFastLoading(1);
	graphic.EnableBlur(0);
	graphic.EnableBloom(1);
	graphic.EnableCharEdge(1);
	graphic.EnableDepth(1);
	graphic.EnableFXAA(1);
	graphic.EnableGlow(1);
	graphic.EnableHighTexture(1);
	graphic.EnableSharp(1);
	graphic.EnableSoftParticle(1);
	graphic.EnableStencil(1);
	graphic.EnableWater(1);
	graphic.EnableHighTexture(1);  
	imcperfOnOff.EnableIMCEffect(1);
	imcperfOnOff.EnableEffect(1);
	imcperfOnOff.EnableDeadParts(1);
	
	FPSSAVIOR_SETTEXT();
	FPSSAVIOR_SAVESETTINGS();
end

function FPSSAVIOR_TOGGLE()
	if settings.saviorToggle == 1 then
		settings.saviorToggle = 2;

		graphic.SetDrawActor(15);
		graphic.SetDrawMonster(30);
		graphic.EnableFastLoading(1);
		graphic.EnableBlur(0);
		graphic.EnableBloom(0);
		graphic.EnableCharEdge(0);
		graphic.EnableDepth(0);
		graphic.EnableFXAA(0);
		graphic.EnableGlow(0);
		graphic.EnableHighTexture(0);
		graphic.EnableSharp(0);
		graphic.EnableSoftParticle(0);
		graphic.EnableStencil(0);
		graphic.EnableWater(0);
		graphic.EnableHighTexture(0);  
		imcperfOnOff.EnableIMCEffect(1);
		imcperfOnOff.EnableEffect(1);
		imcperfOnOff.EnableDeadParts(0);
		
		FPSSAVIOR_SETTEXT();
		FPSSAVIOR_SAVESETTINGS()
	elseif settings.saviorToggle == 2 then
		settings.saviorToggle = 3;
		
		graphic.SetDrawActor(0);
		graphic.SetDrawMonster(5);
		graphic.EnableFastLoading(1);
		graphic.EnableBlur(0);
		graphic.EnableBloom(0);
		graphic.EnableCharEdge(0);
		graphic.EnableDepth(0);
		graphic.EnableFXAA(0);
		graphic.EnableGlow(0);
		graphic.EnableHighTexture(0);
		graphic.EnableSharp(0);
		graphic.EnableSoftParticle(0);
		graphic.EnableStencil(0);
		graphic.EnableWater(0);
		graphic.EnableHighTexture(0);  
		imcperfOnOff.EnableIMCEffect(0);
		imcperfOnOff.EnableEffect(1);
		imcperfOnOff.EnableDeadParts(0);
		
		FPSSAVIOR_SETTEXT();
		FPSSAVIOR_SAVESETTINGS()
	else
		FPSSAVIOR_DEFAULT();
	end
end
