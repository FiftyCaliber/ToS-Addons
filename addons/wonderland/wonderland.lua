local acutil = require('acutil');
CHAT_SYSTEM('Wonderland loaded!{nl}Open & Close: /wl or /wonderland');

function WONDERLAND_ON_INIT(addon, frame)
	WONDERLAND_LOADSETTINGS();
	acutil.slashCommand('/wonderland',WONDERLAND_CMD);
	acutil.slashCommand('/wl',WONDERLAND_CMD);
	addon:RegisterMsg('TARGET_SET', 'WL_TARGET_UPDATE');
	addon:RegisterMsg('FPS_UPDATE', 'WL_TARGET_UPDATE');
end

local default = {amount = 0, speed = 0};
local settings = {}

function WONDERLAND_LOADSETTINGS()
	local s, err = acutil.loadJSON("../addons/wonderland/settings.json");
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
	WONDERLAND_SAVESETTINGS();
end

function WONDERLAND_SAVESETTINGS()
	acutil.saveJSON("../addons/wonderland/settings.json", settings);
end

function WONDERLAND_CMD(command)
	local cmd = '';
	if #command > 0 then
        cmd = table.remove(command, 1);
    else
		WL_TOGGLE_FRAME();
		return;
    end
	if cmd == 'rotate1' then
		local arg1 = tonumber(table.remove(command, 1));
		if type(arg1) == 'number' then
			if arg1 >= 0 and arg1 <= 359.99 then
				degrees = arg1
				CFSMActor.SetRotate(world.GetActor(session.GetTargetHandle()),degrees);
				CHAT_SYSTEM(info.GetName(session.GetTargetHandle()) .. ' rotated to ' .. degrees .. '° once.');
			else
				CHAT_SYSTEM('Invalid degrees. Minimum is 0 and maximum is 359.99.{nl}Example: /rotate1 157.51');
			end
			return;
		end
	end
	if cmd == 'rotate2' then
		local arg1 = tonumber(table.remove(command, 1));
		if type(arg1) == 'number' then
			if arg1 >= 0 and arg1 <= 359.99 then
				degrees = arg1
				WL_DOUBLE_ROTATE();
				CHAT_SYSTEM(info.GetName(session.GetTargetHandle()) .. ' rotated to ' .. degrees .. '° twice.');
			else
				CHAT_SYSTEM('Invalid degrees. Minimum is 0 and maximum is 359.99.{nl}Example: /rotate2 20.93');
			end
			return;
		end
	end
	CHAT_SYSTEM('Invalid command. Available commands:{nl}/wonderland{nl}/wonderland rotate1 <num°>{nl}/wonderland rotate2 <num°>{nl}/wl{nl}/wl rotate1 <num°>{nl}/wl rotate2 <num°>');
end

function WL_CREATE_FRAME()
--	[FRAME]
	wonderlandFrame = ui.GetFrame('wonderlandFrame');
	wonderlandFrame = ui.CreateNewFrame('wonderland','wonderlandFrame');
	wonderlandFrame:SetGravity(ui.CENTER_HORZ,ui.CENTER_VERT);
	wonderlandFrame:Resize(600,330);
	wonderlandFrame:SetLayerLevel(99);
	wonderlandFrame:SetEventScript(ui.RBUTTONDBLCLICK,'WL_TOGGLE_PAGE');

	-- book image
	wlBook = wonderlandFrame:CreateOrGetControl('picture','wlBook',0,-10,600,340);
	wlBook = tolua.cast(wlBook,'ui::CPicture');
	wlBook:SetImage('book_img');
	wlBook:SetEnableStretch(1);
	wlBook:EnableHitTest(0);

	-- button to close book
	closeBook = wonderlandFrame:CreateOrGetControl('button','closeBook',0,0,0,0);
	closeBook = tolua.cast(closeBook,'ui::CButton');
	closeBook:SetGravity(ui.RIGHT,ui.TOP);
	closeBook:SetImage('testclose_button');
	closeBook:SetClickSound('button_click_big');
	closeBook:SetOverSound('button_over');
	closeBook:Resize(25,25);
	closeBook:SetOffset(1,1);
	closeBook:SetTextTooltip('{s18}Close Wonderland{/}');
	closeBook:SetEventScript(ui.LBUTTONDOWN,'WL_TOGGLE_FRAME');
	
	-- edit for amount
	editAMT = wonderlandFrame:CreateOrGetControl('edit','editAMT', 0,0,0,0);
	editAMT = tolua.cast(editAMT,'ui::CEditControl');
	editAMT:SetTextAlign('center', 'center');
	editAMT:SetSkinName('test_weight_skin');
	editAMT:SetFontName('bookfont');
	editAMT:Resize(42,30);
	editAMT:EnableResizeHeightLock(1);
	editAMT:SetNumberMode(1);
	editAMT:SetMaxNumber(100);
	editAMT:SetOffset(142,195);
	editAMT:SetText(settings.amount);
	editAMT:SetFontName('bookfont');

	-- edit for speed
	editSPD = wonderlandFrame:CreateOrGetControl('edit','editSPD', 0,0,0,0);
	editSPD = tolua.cast(editSPD,'ui::CEditControl');
	editSPD:SetTextAlign('center', 'center');
	editSPD:SetSkinName('test_weight_skin');
	editSPD:SetFontName('bookfont');
	editSPD:Resize(42,30);
	editSPD:EnableResizeHeightLock(1);
	editSPD:SetNumberMode(1);
	editSPD:SetMaxNumber(10);
	editSPD:SetOffset(142,249);
	editSPD:SetText(settings.speed);
	editSPD:SetFontName('bookfont');
	
	-- button to save amount
	btnAMT = wonderlandFrame:CreateOrGetControl('button','btnAMT',194,192,70,37);
	btnAMT = tolua.cast(btnAMT,'ui::CButton');
	btnAMT:SetClickSound('button_click_stats_up');
	btnAMT:SetOverSound('button_over');
	btnAMT:SetSkinName('test_pvp_btn');
	btnAMT:SetTextTooltip('{s18}Set Current Percent{/}');
	btnAMT:SetEventScript(ui.LBUTTONDOWN,'WL_SET_AMOUNT');

	txtAMT = btnAMT:CreateOrGetControl('richtext','txtAMT',24,5,0,0);
	txtAMT = tolua.cast(txtAMT,'ui::CRichText');
	txtAMT:SetText('{@st41c}{#415b71}{s20}%{/}{/}{/}');
	txtAMT:EnableHitTest(0);

	-- button to save speed
	btnSPD = wonderlandFrame:CreateOrGetControl('button','btnSPD',194,246,70,37);
	btnSPD = tolua.cast(btnSPD,'ui::CButton');
	btnSPD:SetClickSound('button_click_stats_up');
	btnSPD:SetOverSound('button_over');
	btnSPD:SetSkinName('test_pvp_btn');
	btnSPD:SetTextTooltip('{s18}Set Current Speed{/}');
	btnSPD:SetEventScript(ui.LBUTTONDOWN,'WL_SET_SPEED');

	txtSPD = btnSPD:CreateOrGetControl('richtext','txtSPD',6,4,0,0);
	txtSPD = tolua.cast(txtSPD,'ui::CRichText');
	txtSPD:SetText('{@st41c}{#415b71}{s20}Speed{/}{/}{/}');
	txtSPD:EnableHitTest(0);

	-- question mark picture
	picHELP = wonderlandFrame:CreateOrGetControl('picture','picHELP',54,201,70,70);
	picHELP = tolua.cast(picHELP,'ui::CPicture');
	picHELP:SetImage('icon_item_nothing');
	picHELP:SetEnableStretch(1);
	picHELP:EnableHitTest(1);
	picHELP:SetTextTooltip('{s20}{b}Percent (%) {/}{/}{s18}controls the amount that you increase/decrease the size of yourself or your target.{nl}For example, if you set it to 50% and click the "Eat Me" button on the self page you will grow 50%{nl}larger. Keep in mind that if you decrease yourself or your target by 100% then you/they/it will{nl}disappear leaving nothing to increase or decrease in size. Go through any loading screen to fix{nl}this and reset other changes.{nl} {nl}{/}{s20}{b}Speed {/}{/}{s18}controls the speed at which size changes occur. Speed 0 being instantaneous and speed{nl}10 being slowest.{nl} {nl}Switch between self and target pages by using the next and previous page buttons or by double{nl}right clicking the book.{nl} {nl}Need to rotate the direction a target is facing? Use slash commands {b}/wl rotate1 <num°> {/}and {b}/wl{nl}rotate2 <num°>{/}. The difference between the two commands is rotate1 rotates the target once{nl}while rotate2 rotates it twice. For more information about this check out my README on GitHub{nl}which you can find easily by hitting the "Website" button on the Addon Manager.{/}');
	
--	[SELF]
	-- button to move from self page to target page
	nextPage = wonderlandFrame:CreateOrGetControl('button','nextPage',0,0,0,0);
	nextPage = tolua.cast(nextPage,'ui::CButton');
	nextPage:SetGravity(ui.RIGHT,ui.CENTER_VERT);
	nextPage:SetImage('nextBtn');
	nextPage:SetClickSound('button_click_2');
	nextPage:SetOverSound('button_over');
	nextPage:Resize(27,27);
	nextPage:SetTextTooltip('{s18}Target Page{/}');
	nextPage:SetEventScript(ui.LBUTTONDOWN,'WL_TOGGLE_PAGE');
	
	-- eat me button self
	btnEMs = wonderlandFrame:CreateOrGetControl('button','btnEMs',368,69,130,72);
	btnEMs = tolua.cast(btnEMs,'ui::CButton');
	btnEMs:SetClickSound('travel_diary_1');
	btnEMs:SetOverSound('button_over');
	btnEMs:SetSkinName('test_pvp_btn');
	btnEMs:SetTextTooltip('{s18}Increase Size{/}');
	btnEMs:SetEventScript(ui.LBUTTONDOWN,'WL_SELF_EAT_ME');

	txtEMs1 = btnEMs:CreateOrGetControl('richtext','txtEMs1',69,10,0,0);
	txtEMs1 = tolua.cast(txtEMs1,'ui::CRichText');
	txtEMs1:SetText('{@st41c}{#415b71}{s25}Eat{/}{/}{/}');
	txtEMs1:EnableHitTest(0);

	txtEMs2 = btnEMs:CreateOrGetControl('richtext','txtEMs2',69,33,0,0);
	txtEMs2 = tolua.cast(txtEMs2,'ui::CRichText');
	txtEMs2:SetText('{@st41c}{#415b71}{s25}Me{/}{/}{/}');
	txtEMs2:EnableHitTest(0);

	picCAKEs = btnEMs:CreateOrGetControl('picture','picCAKEs',-15,-15,100,100);
	picCAKEs = tolua.cast(picCAKEs,'ui::CPicture');
	picCAKEs:SetImage('hairacc_87_cupcake2');
	picCAKEs:SetEnableStretch(1);
	picCAKEs:EnableHitTest(0);
	
	-- drink me button self
	btnDMs = wonderlandFrame:CreateOrGetControl('button','btnDMs',368,190,130,72);
	btnDMs = tolua.cast(btnDMs,'ui::CButton');
	btnDMs:SetClickSound('travel_diary_1');
	btnDMs:SetOverSound('button_over');
	btnDMs:SetSkinName('test_pvp_btn');
	btnDMs:SetTextTooltip('{s18}Decrease Size{/}');
	btnDMs:SetEventScript(ui.LBUTTONDOWN,'WL_SELF_DRINK_ME');

	txtDMs1 = btnDMs:CreateOrGetControl('richtext','txtDMs1',53,10,0,0);
	txtDMs1 = tolua.cast(txtDMs1,'ui::CRichText');
	txtDMs1:SetText('{@st41c}{#415b71}{s25}Drink{/}{/}{/}');
	txtDMs1:EnableHitTest(0);

	txtDMs2 = btnDMs:CreateOrGetControl('richtext','txtDMs2',69,33,0,0);
	txtDMs2 = tolua.cast(txtDMs2,'ui::CRichText');
	txtDMs2:SetText('{@st41c}{#415b71}{s25}Me{/}{/}{/}');
	txtDMs2:EnableHitTest(0);

	picPOTIONs = btnDMs:CreateOrGetControl('picture','picPOTIONs',3,5,60,60);
	picPOTIONs = tolua.cast(picPOTIONs,'ui::CPicture');
	picPOTIONs:SetImage('icon_item_statReset');
	picPOTIONs:SetEnableStretch(1);
	picPOTIONs:EnableHitTest(0);

	-- text self
	txtS = wonderlandFrame:CreateOrGetControl('richtext','txtS',0,0,0,0);
	txtS = tolua.cast(txtS,'ui::CRichText');
	txtS:SetFontName('bookfont');
	txtS:SetText('{s99}S{/}');
	txtS:SetScale(1.4,1.8);
	txtS:SetOffset(43,-6);
	txtS:EnableHitTest(0);

	txtELF = wonderlandFrame:CreateOrGetControl('richtext','txtELF',0,0,0,0);
	txtELF = tolua.cast(txtELF,'ui::CRichText');
	txtELF:SetFontName('bookfont');
	txtELF:SetText('{s33}elf{/}');
	txtELF:SetScale(1.4,1.8);
	txtELF:SetOffset(116,42);
	txtELF:EnableHitTest(0);
	
	-- box & text for self name
	boxNameSELF = wonderlandFrame:CreateOrGetControl('groupbox','boxNameSELF',0,0,0,0);
	boxNameSELF = tolua.cast(boxNameSELF,'ui::CGroupBox');
	boxNameSELF:Resize(163,60);
	boxNameSELF:SetOffset(119,111);
	boxNameSELF:SetSkinName('none');
	boxNameSELF:EnableHitTest(0);

	txtNameSELF1 = boxNameSELF:CreateOrGetControl('richtext','txtNameSELF1',0,0,0,0);
	txtNameSELF1 = tolua.cast(txtNameSELF1,'ui::CRichText');
	txtNameSELF1:SetGravity(ui.CENTER_HORZ,ui.CENTER_VERT);
	txtNameSELF1:SetFontName('bookfont');
	local selfNAME1 = info.GetName(session.GetMyHandle());
	txtNameSELF1:SetMaxWidth(999);
	txtNameSELF1:SetText(selfNAME1);
	for i=19,13,-1 do
		if txtNameSELF1:GetTextWidth() > 163 then
			txtNameSELF1:SetText('{s'..i..'}'..selfNAME1..'{/}');
		end
	end
	if txtNameSELF1:GetTextWidth() > 163 then
		txtNameSELF1:SetMaxWidth(163);
		txtNameSELF1:SetText('{s12}'..selfNAME1..'{/}');
	end
	txtNameSELF1:EnableHitTest(0);
	txtNameSELF1:SetOffset(0,-13);
	
	txtNameSELF2 = boxNameSELF:CreateOrGetControl('richtext','txtNameSELF2',0,0,0,0);
	txtNameSELF2 = tolua.cast(txtNameSELF2,'ui::CRichText');
	txtNameSELF2:SetGravity(ui.CENTER_HORZ,ui.CENTER_VERT);
	txtNameSELF2:SetFontName('bookfont');
	local selfNAME2 = info.GetFamilyName(session.GetMyHandle());
	txtNameSELF2:SetMaxWidth(999);
	txtNameSELF2:SetText(selfNAME2);
	for i=19,13,-1 do
		if txtNameSELF2:GetTextWidth() > 163 then
			txtNameSELF2:SetText('{s'..i..'}'..selfNAME2..'{/}');
		end
	end
	if txtNameSELF2:GetTextWidth() > 163 then
		txtNameSELF2:SetMaxWidth(163);
		txtNameSELF2:SetText('{s12}'..selfNAME2..'{/}');
	end
	txtNameSELF2:EnableHitTest(0);
	txtNameSELF2:SetOffset(0,13);
	
--	[TARGET]
	-- button to move from target page to self page
	prevPage = wonderlandFrame:CreateOrGetControl('button','prevPage',0,0,0,0);
	prevPage = tolua.cast(prevPage,'ui::CButton');
	prevPage:SetGravity(ui.LEFT,ui.CENTER_VERT);
	prevPage:SetImage('prevBtn');
	prevPage:SetClickSound('button_click_2');
	prevPage:SetOverSound('button_over');
	prevPage:Resize(27,27);
	prevPage:SetTextTooltip('{s18}Self Page{/}');
	prevPage:SetEventScript(ui.LBUTTONDOWN,'WL_TOGGLE_PAGE');

	-- eat me button target
	btnEMt = wonderlandFrame:CreateOrGetControl('button','btnEMt',368,69,130,72);
	btnEMt = tolua.cast(btnEMt,'ui::CButton');
	btnEMt:SetClickSound('travel_diary_1');
	btnEMt:SetOverSound('button_over');
	btnEMt:SetSkinName('test_pvp_btn');
	btnEMt:SetTextTooltip('{s18}Increase Size{/}');
	btnEMt:SetEventScript(ui.LBUTTONDOWN,'WL_TARGET_EAT_ME');

	txtEMt1 = btnEMt:CreateOrGetControl('richtext','txtEMt1',69,10,0,0);
	txtEMt1 = tolua.cast(txtEMt1,'ui::CRichText');
	txtEMt1:SetText('{@st41c}{#415b71}{s25}Eat{/}{/}{/}');
	txtEMt1:EnableHitTest(0);

	txtEMt2 = btnEMt:CreateOrGetControl('richtext','txtEMt2',69,33,0,0);
	txtEMt2 = tolua.cast(txtEMt2,'ui::CRichText');
	txtEMt2:SetText('{@st41c}{#415b71}{s25}Me{/}{/}{/}');
	txtEMt2:EnableHitTest(0);

	picCAKEt = btnEMt:CreateOrGetControl('picture','picCAKEt',-15,-15,100,100);
	picCAKEt = tolua.cast(picCAKEt,'ui::CPicture');
	picCAKEt:SetImage('hairacc_86_cupcake1');
	picCAKEt:SetEnableStretch(1);
	picCAKEt:EnableHitTest(0);

	-- drink me button target
	btnDMt = wonderlandFrame:CreateOrGetControl('button','btnDMt',368,190,130,72);
	btnDMt = tolua.cast(btnDMt,'ui::CButton');
	btnDMt:SetClickSound('travel_diary_1');
	btnDMt:SetOverSound('button_over');
	btnDMt:SetSkinName('test_pvp_btn');
	btnDMt:SetTextTooltip('{s18}Decrease Size{/}');
	btnDMt:SetEventScript(ui.LBUTTONDOWN,'WL_TARGET_DRINK_ME');

	txtDMt1 = btnDMt:CreateOrGetControl('richtext','txtDMt1',53,10,0,0);
	txtDMt1 = tolua.cast(txtDMt1,'ui::CRichText');
	txtDMt1:SetText('{@st41c}{#415b71}{s25}Drink{/}{/}{/}');
	txtDMt1:EnableHitTest(0);

	txtDMt2 = btnDMt:CreateOrGetControl('richtext','txtDMt2',69,33,0,0);
	txtDMt2 = tolua.cast(txtDMt2,'ui::CRichText');
	txtDMt2:SetText('{@st41c}{#415b71}{s25}Me{/}{/}{/}');
	txtDMt2:EnableHitTest(0);

	picPOTIONt = btnDMt:CreateOrGetControl('picture','picPOTIONt',3,5,60,60);
	picPOTIONt = tolua.cast(picPOTIONt,'ui::CPicture');
	picPOTIONt:SetImage('icon_item_potion_resetSkill');
	picPOTIONt:SetEnableStretch(1);
	picPOTIONt:EnableHitTest(0);

	-- text target
	txtT = wonderlandFrame:CreateOrGetControl('richtext','txtT',0,0,0,0);
	txtT = tolua.cast(txtT,'ui::CRichText');
	txtT:SetFontName('bookfont');
	txtT:SetText('{s99}T{/}');
	txtT:SetScale(1.4,1.8);
	txtT:SetOffset(48,-6);
	txtT:EnableHitTest(0);

	txtARGET = wonderlandFrame:CreateOrGetControl('richtext','txtARGET',0,0,0,0);
	txtARGET = tolua.cast(txtARGET,'ui::CRichText');
	txtARGET:SetFontName('bookfont');
	txtARGET:SetText('{s33}arget{/}');
	txtARGET:SetScale(1.4,1.8);
	txtARGET:SetOffset(130,42);
	txtARGET:EnableHitTest(0);

	-- box & text for target name
	boxNameTARGET = wonderlandFrame:CreateOrGetControl('groupbox','boxNameTARGET',0,0,0,0);
	boxNameTARGET = tolua.cast(boxNameTARGET,'ui::CGroupBox');
	boxNameTARGET:Resize(163,60);
	boxNameTARGET:SetOffset(119,111);
	boxNameTARGET:SetSkinName('none');
	boxNameTARGET:EnableHitTest(0);

	txtNameTARGET1 = boxNameTARGET:CreateOrGetControl('richtext','txtNameTARGET1',0,0,0,0);
	txtNameTARGET1 = tolua.cast(txtNameTARGET1,'ui::CRichText');
	txtNameTARGET1:SetGravity(ui.CENTER_HORZ,ui.CENTER_VERT);
	txtNameTARGET1:SetFontName('bookfont');
	WL_TARGET_UPDATE();

	prevPage:ShowWindow(0);
	btnEMt:ShowWindow(0);
	btnDMt:ShowWindow(0);
	txtT:ShowWindow(0);
	txtARGET:ShowWindow(0);
	boxNameTARGET:ShowWindow(0);
end

function WL_SET_AMOUNT()
	settings.amount = editAMT:GetText();
	if settings.amount == '' then
		settings.amount = 0;
		WONDERLAND_SAVESETTINGS();
		editAMT:SetText(settings.amount);
		editAMT:SetFontName('bookfont');
		editAMT:ReleaseFocus();
		return;
	end
	WONDERLAND_SAVESETTINGS();
	editAMT:SetText(settings.amount);
	editAMT:SetFontName('bookfont');
	editAMT:ReleaseFocus();
end

function WL_SET_SPEED()
	settings.speed = editSPD:GetText();
	if settings.speed == '' then
		settings.speed = 0;
		WONDERLAND_SAVESETTINGS();
		editSPD:SetText(settings.speed);
		editSPD:SetFontName('bookfont');
		editSPD:ReleaseFocus();
		return;
	end
	WONDERLAND_SAVESETTINGS();
	editSPD:SetText(settings.speed);
	editSPD:SetFontName('bookfont');
	editSPD:ReleaseFocus();
end

function WL_TOGGLE_PAGE()
	if prevPage:IsVisible() == 1 then
		prevPage:ShowWindow(0);
		btnEMt:ShowWindow(0);
		btnDMt:ShowWindow(0);
		txtT:ShowWindow(0);
		txtARGET:ShowWindow(0);
		boxNameTARGET:ShowWindow(0);
	
		nextPage:ShowWindow(1);
		btnEMs:ShowWindow(1);
		btnDMs:ShowWindow(1);
		txtS:ShowWindow(1);
		txtELF:ShowWindow(1);
		boxNameSELF:ShowWindow(1);
	else
		nextPage:ShowWindow(0);
		btnEMs:ShowWindow(0);
		btnDMs:ShowWindow(0);
		txtS:ShowWindow(0);
		txtELF:ShowWindow(0);
		boxNameSELF:ShowWindow(0);
	
		prevPage:ShowWindow(1);
		btnEMt:ShowWindow(1);
		btnDMt:ShowWindow(1);
		txtT:ShowWindow(1);
		txtARGET:ShowWindow(1);
		boxNameTARGET:ShowWindow(1);
	end
end

function WL_TOGGLE_FRAME()
	wonderlandFrame = ui.GetFrame('wonderlandFrame');
	if wonderlandFrame == nil then
		WL_CREATE_FRAME();
	elseif wonderlandFrame:IsVisible() == 1 then
		wonderlandFrame:ShowWindow(0);
    end
end

function WL_TARGET_UPDATE()
	wonderlandFrame = ui.GetFrame('wonderlandFrame');
	if wonderlandFrame:IsVisible() == 1 then
		local tgtNAME1 = info.GetName(session.GetTargetHandle());
		txtNameTARGET1:SetMaxWidth(999);
		txtNameTARGET1:SetText(tgtNAME1);
		for i=19,13,-1 do
			if txtNameTARGET1:GetTextWidth() > 163 then
				txtNameTARGET1:SetText('{s'..i..'}'..tgtNAME1..'{/}');
			end
		end
		if txtNameTARGET1:GetTextWidth() > 163 then
			txtNameTARGET1:SetMaxWidth(163);
			txtNameTARGET1:SetText('{s12}'..tgtNAME1..'{/}');
		end
		txtNameTARGET1:EnableHitTest(0);
		if info.IsPC(session.GetTargetHandle()) == 1 then
			txtNameTARGET1:SetOffset(0,-13);
			if txtNameTARGET2:IsVisible() == 0 then
				txtNameTARGET2:ShowWindow(1);
			end
			txtNameTARGET2 = boxNameTARGET:CreateOrGetControl('richtext','txtNameTARGET2',0,0,0,0);
			txtNameTARGET2 = tolua.cast(txtNameTARGET2,'ui::CRichText');
			txtNameTARGET2:SetGravity(ui.CENTER_HORZ,ui.CENTER_VERT);
			txtNameTARGET2:SetFontName('bookfont');
			local tgtNAME2 = info.GetFamilyName(session.GetTargetHandle());
			txtNameTARGET2:SetMaxWidth(999);
			txtNameTARGET2:SetText(tgtNAME2);
			for i=19,13,-1 do
				if txtNameTARGET2:GetTextWidth() > 163 then
					txtNameTARGET2:SetText('{s'..i..'}'..tgtNAME2..'{/}');
				end
			end
			if txtNameTARGET2:GetTextWidth() > 163 then
				txtNameTARGET2:SetMaxWidth(163);
				txtNameTARGET2:SetText('{s12}'..tgtNAME2..'{/}');
			end		
			txtNameTARGET2:EnableHitTest(0);
			txtNameTARGET2:SetOffset(0,13);
		else
			txtNameTARGET1:SetOffset(0,0);
			if txtNameTARGET2 ~= nil then
				txtNameTARGET2:ShowWindow(0);
			end
		end
	end
end

function WL_SELF_EAT_ME()
	CFSMActor.ChangeScale(GetMyActor(), (settings.amount / 100) + 1, settings.speed);
end

function WL_SELF_DRINK_ME()
	CFSMActor.ChangeScale(GetMyActor(), 1 - (settings.amount / 100), settings.speed);
end

function WL_TARGET_EAT_ME()
	CFSMActor.ChangeScale(world.GetActor(session.GetTargetHandle()), (settings.amount / 100) + 1, settings.speed);
end

function WL_TARGET_DRINK_ME()
	CFSMActor.ChangeScale(world.GetActor(session.GetTargetHandle()), 1 - (settings.amount / 100), settings.speed);
end

function WL_DOUBLE_ROTATE()
	CFSMActor.SetRotate(world.GetActor(session.GetTargetHandle()),degrees);
	ReserveScript('WL_DOUBLE_ROTATE()',.25);
	CFSMActor.SetRotate(world.GetActor(session.GetTargetHandle()),degrees);
end
