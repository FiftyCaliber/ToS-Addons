local acutil = require('acutil');
local saviorMode = {'{#2D9B27}{ol}High','{#284B7E}{ol}Low','{#532881}{ol}Super Low'};
CHAT_SYSTEM('FPS Savior loaded! Toggle: /fpssavior');

function FPSSAVIOR_ON_INIT(addon, frame)
	frame:ShowWindow(1);
	acutil.slashCommand('/fpssavior',FPSSAVIOR_TOGGLE);
	addon:RegisterMsg('FPS_UPDATE', 'FPSSAVIOR_UPDATE');
	FPSSAVIOR_LOADSETTINGS();
end

local default = {saviorToggle = 1;}
local settings = {}

function FPSSAVIOR_LOADSETTINGS()
	local s, err = acutil.loadJSON("../addons/fpssavior/settings.json");
	if err then
		settings = default
	else
		settings = s
		for k,v in pairs(default) do
			if s[k] == nil then
				settings[k] = v
			end
		end
	end
	FPSSAVIOR_SAVESETTINGS()
end

function FPSSAVIOR_SAVESETTINGS()
	acutil.saveJSON("../addons/fpssavior/settings.json", settings);
end

function FPSSAVIOR_UPDATE(frame, msg, argStr, argNum)
	saviorFrame = ui.GetFrame('fpssaviorframe');
	if saviorFrame == nil then
		saviorFrame = ui.CreateNewFrame('bandicam','fpssaviorframe');
		saviorFrame:SetBorder(0, 0, 0, 0);
		saviorFrame:Resize(100,20)
		saviorFrame:SetOffset(510,860)
		saviorText = saviorFrame:CreateOrGetControl('richtext','saviortext',0,0,0,0);
		saviorText = tolua.cast(saviorText,'ui::CRichText');
		saviorText:SetGravity(ui.LEFT,ui.CENTER_VERT);
		saviorText:SetText('{s16}'..saviorMode[settings.saviorToggle]);
		saviorText:ShowWindow(1);
	end
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
