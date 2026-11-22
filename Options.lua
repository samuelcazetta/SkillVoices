local SV = SkillVoices
local function copy(value)
  if type(value) ~= "table" then return value end
  local result = {}; for k, v in pairs(value) do result[k] = copy(v) end
  return result
end
local function trim(s) return (s or ""):match("^%s*(.-)%s*$") end
local function text(parent, value, x, y, width)
  local f = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  f:SetPoint("TOPLEFT", x, y); f:SetWidth(width or 300); f:SetJustifyH("LEFT"); f:SetText(value)
  return f
end
local function button(parent, value, x, y, width, callback)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetPoint("TOPLEFT", x, y); b:SetSize(width, 24); b:SetText(value); b:SetScript("OnClick", callback)
  b:SetNormalTexture("Interface\\Buttons\\WHITE8X8")
  b:GetNormalTexture():SetVertexColor(.13, .105, .20, 1)
  b:SetPushedTexture("Interface\\Buttons\\WHITE8X8")
  b:GetPushedTexture():SetVertexColor(.28, .16, .44, 1)
  b:SetHighlightTexture("Interface\\Buttons\\WHITE8X8")
  b:GetHighlightTexture():SetVertexColor(.42, .29, .64, .25)
  if value == "Save" or value == "+ Add spell" then
    b:GetNormalTexture():SetVertexColor(.32, .15, .54, 1)
  end
  return b
end
local function edit(parent, x, y, width)
  local e = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
  e:SetPoint("TOPLEFT", x, y); e:SetSize(width, 24); e:SetAutoFocus(false)
  e:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
  return e
end
local function scroll(parent, x, y, width, height)
  local s = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
  s:SetPoint("TOPLEFT", x, y); s:SetSize(width, height)
  local content = CreateFrame("Frame", nil, s); content:SetSize(width, height); s:SetScrollChild(content)
  return s, content
end
local function background(frame, shade)
  local t = frame:CreateTexture(nil, "BACKGROUND"); t:SetAllPoints(); t:SetColorTexture(shade * .78, shade * .86, shade + .025, .98)
  local accent = frame:CreateTexture(nil, "BORDER")
  accent:SetPoint("TOPLEFT"); accent:SetPoint("TOPRIGHT"); accent:SetHeight(2)
  accent:SetColorTexture(.48, .28, .85, .7)
end
local function within(path, root) return path == root or path:sub(1, #root + 1) == root .. "/" end

function SV.CreateOptions()
  local draft = { groups = copy(SV.db.groups), entries = {} }
  for id, e in pairs(SV.db.mappings) do
    local item = copy(e); item.id = tostring(id); item.group = item.group or "Geral"
    draft.entries[#draft.entries + 1] = item
  end
  table.sort(draft.entries, function(a,b) return tonumber(a.id) < tonumber(b.id) end)
  local function ensureGroup(path)
    local prefix = ""
    for part in path:gmatch("[^/]+") do
      prefix = prefix == "" and part or prefix .. "/" .. part
      local found = false
      for _, group in ipairs(draft.groups) do if group == prefix then found = true end end
      if not found then draft.groups[#draft.groups + 1] = prefix end
    end
  end
  for _, e in ipairs(draft.entries) do ensureGroup(e.group) end
  table.sort(draft.groups)
  local selected = draft.groups[1]
  SV.db.window = SV.db.window or {}
  SV.db.minimap = SV.db.minimap or { hide = false }
  local geometry = SV.db.window
  local panel = CreateFrame("Frame", "SkillVoicesWindow", UIParent, "BackdropTemplate")
  SV.window = panel
  panel:SetFrameStrata("DIALOG"); panel:SetToplevel(true)
  panel:SetClampedToScreen(true); panel:SetMovable(true); panel:SetResizable(true)
  panel:SetResizeBounds(780, 660, 1600, 1200)
  panel:EnableMouse(true)
  panel:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="Interface\\Buttons\\WHITE8X8", edgeSize=1})
  panel:SetBackdropColor(.035,.04,.065,.98); panel:SetBackdropBorderColor(.33,.22,.53,1)
  local titlebar = CreateFrame("Frame", nil, panel)
  titlebar:SetPoint("TOPLEFT", 1, -1); titlebar:SetPoint("TOPRIGHT", -1, -1); titlebar:SetHeight(38)
  background(titlebar, .09); titlebar:EnableMouse(true); titlebar:RegisterForDrag("LeftButton")
  text(titlebar, "SKILLVOICES  |  Voice editor", 16, -11, 500)
  local function saveGeometry()
    geometry.width, geometry.height = panel:GetWidth(), panel:GetHeight()
    geometry.x, geometry.y = panel:GetCenter()
  end
  titlebar:SetScript("OnDragStart", function() panel:StartMoving() end)
  titlebar:SetScript("OnDragStop", function() panel:StopMovingOrSizing(); saveGeometry() end)
  local close = CreateFrame("Button", nil, panel, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", -3, -3); close:SetScript("OnClick", function() panel:Hide() end)
  local canvas = CreateFrame("Frame", nil, panel); canvas:SetSize(760, 590); canvas:SetPoint("TOPLEFT", 10, -42)
  local function fit()
    local w,h=panel:GetWidth(),panel:GetHeight()
    if w > 0 and h > 0 then canvas:SetScale(math.min((w-20)/760,(h-64)/590)) end
  end
  panel:SetScript("OnSizeChanged", fit)
  local grip = CreateFrame("Button", nil, panel)
  grip:SetPoint("BOTTOMRIGHT", -2, 2); grip:SetSize(24,24)
  grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
  grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
  grip:SetScript("OnMouseDown", function(_, mouse) if mouse=="LeftButton" then panel:StartSizing("BOTTOMRIGHT") end end)
  grip:SetScript("OnMouseUp", function() panel:StopMovingOrSizing(); saveGeometry() end)
  function SV.ResetWindow()
    geometry.x,geometry.y=nil,nil
    panel:ClearAllPoints(); panel:SetSize(900,760); panel:SetPoint("CENTER"); fit(); saveGeometry()
  end
  panel:SetSize(math.max(780,math.min(1600,tonumber(geometry.width) or 900)), math.max(660,math.min(1200,tonumber(geometry.height) or 760)))
  if type(geometry.x)=="number" and type(geometry.y)=="number" then
    panel:SetPoint("CENTER", UIParent, "BOTTOMLEFT", geometry.x, geometry.y)
  else panel:SetPoint("CENTER") end
  fit()
  function SV.ToggleWindow() panel:SetShown(not panel:IsShown()) end
  UISpecialFrames[#UISpecialFrames+1]="SkillVoicesWindow"
  text(canvas, "SkillVoices — " .. UnitName("player") .. " / " .. GetRealmName(), 16, -16, 720)
  local status = text(canvas, "Edit the cards and click Save. Switching groups keeps pending changes.", 16, -90, 720)
  local function message(s) status:SetText(s) end
  local function dirty() message("Unsaved changes. Click Save to apply them to this character.") end
  local dropdown = CreateFrame("DropdownButton", nil, canvas, "WowStyle1DropdownTemplate")
  dropdown:SetPoint("TOPLEFT", 16, -48); dropdown:SetSize(240, 26)
  local refresh
  local outer, content = scroll(canvas, 16, -128, 704, 405)
  local cards = {}
  local previewHandle
  local function stop()
    if previewHandle then StopSound(previewHandle); previewHandle = nil end
  end
  panel:SetScript("OnHide", stop)
  local function preview(file)
    stop()
    if not file or file == "" then message("Silence selected: no audio played."); return end
    local ok, played, handle = pcall(PlaySoundFile, "Interface\\AddOns\\SkillVoices\\sounds\\" .. file, "Master")
    if ok and played then previewHandle = handle; message("Playing: " .. file)
    else message("Unable to play: " .. file .. ". Check the file in the sounds folder.") end
  end

  -- Shared modal for creation and renaming; slash-separated paths create subgroups.
  local dialog = CreateFrame("Frame", "SkillVoicesGroupDialog", panel, "BasicFrameTemplateWithInset")
  dialog:SetSize(440, 155); dialog:SetPoint("CENTER"); dialog:SetFrameStrata("FULLSCREEN_DIALOG"); background(dialog, .12)
  -- Keep group creation and renaming above the editor and its child controls.
  dialog:SetToplevel(true); dialog:EnableMouse(true)
  dialog:SetScript("OnShow", function(self) self:Raise() end)
  dialog.TitleText:SetText("Group / subgroup")
  text(dialog, "Use / for subgroups. Example: Mage/Arcane", 16, -38, 405)
  local groupInput = edit(dialog, 22, -66, 390)
  local renaming
  local function submitGroup()
    local parts = {}
    for part in groupInput:GetText():gmatch("[^/]+") do
      part = trim(part); if part ~= "" then parts[#parts + 1] = part end
    end
    local path = table.concat(parts, "/")
    if path == "" then message("Enter a group name."); return end
    for _, g in ipairs(draft.groups) do
      if g == path and path ~= renaming then message("This group already exists."); return end
    end
    if renaming then
      if path ~= renaming and within(path, renaming) then message("A group cannot become its own subgroup."); return end
      for i,g in ipairs(draft.groups) do if within(g, renaming) then draft.groups[i] = path .. g:sub(#renaming + 1) end end
      for _,e in ipairs(draft.entries) do if within(e.group, renaming) then e.group = path .. e.group:sub(#renaming + 1) end end
    end
    ensureGroup(path); selected = path; dialog:Hide(); refresh(); dirty()
  end
  button(dialog, "Confirm", 206, -108, 100, submitGroup)
  button(dialog, "Cancel", 316, -108, 100, function() dialog:Hide() end)
  groupInput:SetScript("OnEnterPressed", submitGroup)
  dialog:Hide(); UISpecialFrames[#UISpecialFrames + 1] = "SkillVoicesGroupDialog"

  -- Catalog adds one weighted entry at a time, including repeated sounds or silence.
  local catalog = CreateFrame("Frame", "SkillVoicesCatalog", panel, "BasicFrameTemplateWithInset")
  catalog:SetSize(480, 475); catalog:SetPoint("CENTER"); catalog:SetFrameStrata("FULLSCREEN_DIALOG"); background(catalog, .12)
  -- Keep the sound catalog above the editor on every open.
  catalog:SetToplevel(true); catalog:EnableMouse(true)
  catalog:SetScript("OnShow", function(self) self:Raise() end)
  catalog.TitleText:SetText("Add sound")
  local target, chosen, catalogRows = nil, nil, {}
  text(catalog, "Select a sound or enter a file from the sounds folder.", 16, -38, 440)
  local listScroll, listContent = scroll(catalog, 16, -66, 418, 270)
  local fileInput = edit(catalog, 22, -358, 410)
  local available = { "" }; local known = { [""] = true }
  for _, file in ipairs(SkillVoices_Sounds or {}) do if not known[file] then available[#available + 1] = file; known[file] = true end end
  for _,e in ipairs(draft.entries) do for _,file in ipairs(e.files) do if not known[file] then available[#available+1]=file; known[file]=true end end end
  table.sort(available)
  local function selectCatalog(index)
    chosen = available[index]; fileInput:SetText(chosen == "" and "<silence>" or chosen)
    for i,b in ipairs(catalogRows) do b:SetText((i == index and "|cffffd100" or "") .. (available[i] == "" and "[Silence]" or available[i]) .. "|r") end
  end
  for i,file in ipairs(available) do
    local index = i
    catalogRows[i] = button(listContent, file == "" and "[Silence]" or file, 0, -(i-1)*26, 410, function() selectCatalog(index) end)
  end
  listContent:SetHeight(math.max(270, #available*26))
  button(catalog, "Listen", 16, -402, 85, function() local f=trim(fileInput:GetText()); preview(f == "<silence>" and "" or f) end)
  button(catalog, "Stop", 109, -402, 85, stop)
  button(catalog, "Add", 218, -402, 110, function()
    if not target then return end
    local file = trim(fileInput:GetText())
    if file == "<silence>" then file = "" end
    if file ~= "" and not file:lower():match("%.ogg$") and not file:lower():match("%.mp3$") then message("Enter an .ogg or .mp3 file, or select Silence."); return end
    target.files[#target.files+1] = file; target.selection = #target.files
    catalog:Hide(); stop(); refresh(); dirty()
  end)
  button(catalog, "Close", 338, -402, 110, function() catalog:Hide(); stop() end)
  text(catalog, "Repeated entries increase their selection weight.", 16, -442, 440)
  catalog:SetScript("OnHide", stop); catalog:Hide()
  UISpecialFrames[#UISpecialFrames + 1] = "SkillVoicesCatalog"

  local function buildCard()
    local card = CreateFrame("Frame", nil, content); card:SetSize(700, 176); background(card, .08)
    card.icon = card:CreateTexture(nil, "ARTWORK"); card.icon:SetPoint("TOPLEFT", 12, -39); card.icon:SetSize(40,40)
    card.name = text(card, "", 12, -12, 210)
    text(card, "Spell ID", 62, -40, 110)
    card.id = edit(card, 66, -61, 135); card.id:SetNumeric(true)
    card.id:SetScript("OnTextChanged", function(self, user)
      if user and card.entry then card.entry.id = self:GetText(); card:updateSpell(); dirty() end
    end)
    card.chanceLabel = text(card, "", 232, -45, 110)
    card.slider = CreateFrame("Slider", nil, card, "OptionsSliderTemplate")
    card.slider:SetPoint("TOPLEFT", 232, -77); card.slider:SetSize(110, 16)
    card.slider:SetMinMaxValues(0,100); card.slider:SetValueStep(1); card.slider:SetObeyStepOnDrag(true)
    card.slider:SetScript("OnValueChanged", function(_, value)
      if card.entry and not card.loading then card.entry.chance = math.floor(value + .5); card.chanceLabel:SetText("Chance: " .. card.entry.chance .. "%"); dirty() end
    end)
    card.listScroll, card.list = scroll(card, 363, -17, 190, 139)
    card.soundRows = {}
    function card:updateSpell()
      local id = tonumber(self.entry.id)
      -- Invalid or oversized IDs must not abort UI refresh while typing.
      local ok, info
      if id and id > 0 then ok, info = pcall(C_Spell.GetSpellInfo, id) end
      if not ok then info = nil end
      self.name:SetText(info and info.name or "New spell / unknown ID")
      self.icon:SetTexture(info and info.iconID or "Interface\\Icons\\INV_Misc_QuestionMark")
    end
    function card:render()
      self.loading = true; self.id:SetText(self.entry.id); self:updateSpell()
      self.chanceLabel:SetText("Chance: " .. self.entry.chance .. "%"); self.slider:SetValue(self.entry.chance)
      for _,b in ipairs(self.soundRows) do b:Hide() end
      for i,file in ipairs(self.entry.files) do
        local index = i; local b = self.soundRows[i]
        if not b then b=button(self.list, "", 0, -(i-1)*25, 185, function() end); self.soundRows[i]=b end
        b:SetText((self.entry.selection == i and "|cffffd100" or "") .. (file == "" and "[Silence]" or file) .. "|r")
        b:SetScript("OnClick", function() self.entry.selection=index; self:render() end); b:Show()
      end
      self.list:SetHeight(math.max(139, #self.entry.files*25)); self.listScroll:UpdateScrollChildRect(); self.loading=false
    end
    button(card, "Add", 585, -18, 100, function() target=card.entry; selectCatalog(1); catalog:Show() end)
    button(card, "Remove", 585, -49, 100, function()
      local e=card.entry; if not e.selection then message("Select a sound in the list."); return end
      table.remove(e.files,e.selection); e.selection=nil; card:render(); dirty()
    end)
    button(card, "Play", 585, -80, 48, function()
      local e=card.entry; if not e.selection then message("Select a sound in the list."); return end
      preview(e.files[e.selection])
    end)
    button(card, "Stop", 637, -80, 48, stop)
    button(card, "Delete spell", 585, -128, 100, function()
      for i,e in ipairs(draft.entries) do if e==card.entry then table.remove(draft.entries,i); break end end
      catalog:Hide(); refresh(); dirty()
    end)
    return card
  end
  refresh = function()
    table.sort(draft.groups)
    dropdown:SetText(selected or "Select / create a group")
    dropdown:SetupMenu(function(_, root)
      for _,group in ipairs(draft.groups) do
        local path=group; local _,depth=path:gsub("/", "")
        root:CreateRadio(string.rep("   ",depth) .. path:match("[^/]+$"), function() return selected==path end,
          function() selected=path; outer:SetVerticalScroll(0); catalog:Hide(); stop(); refresh() end)
      end
    end)
    for _,card in ipairs(cards) do card:Hide() end
    local n=0
    for _,entry in ipairs(draft.entries) do
      if entry.group==selected then
        n=n+1; if not cards[n] then cards[n]=buildCard() end
        local card=cards[n]; if card.entry ~= entry then card.listScroll:SetVerticalScroll(0) end; card.entry=entry; card:SetPoint("TOPLEFT",0,-(n-1)*188); card:render(); card:Show()
      end
    end
    content:SetHeight(math.max(405,n*188)); outer:UpdateScrollChildRect()
  end
  button(canvas, "New", 274, -48, 100, function() renaming=nil; groupInput:SetText(selected and selected .. "/" or ""); dialog:Show(); groupInput:SetFocus() end)
  button(canvas, "Rename", 382, -48, 100, function()
    if not selected then return end
    renaming=selected; groupInput:SetText(selected); dialog:Show(); groupInput:SetFocus()
  end)
  button(canvas, "Save", 490, -48, 100, function()
    local mappings={}
    for _,e in ipairs(draft.entries) do
      local id=tonumber(e.id)
      if not id or id<1 or id~=math.floor(id) then message("Fix the spell ID in group " .. e.group .. "."); return end
      if mappings[id] then message("Duplicate spell ID: " .. id .. ". Each spell must belong to a single group."); return end
      if #e.files==0 then message("Add a sound or Silence to spell " .. id .. "."); return end
      mappings[id]={group=e.group,chance=e.chance,files=copy(e.files)}
    end
    SV.db.mappings=mappings; SV.db.groups=copy(draft.groups)
    message("All changes saved for this character.")
  end)
  button(canvas, "Delete", 598, -48, 100, function()
    if not selected then return end
    for _,e in ipairs(draft.entries) do if within(e.group,selected) then message("Remove spells from this group and its subgroups before deleting it."); return end end
    for i=#draft.groups,1,-1 do if within(draft.groups[i],selected) then table.remove(draft.groups,i) end end
    selected=draft.groups[1]; refresh(); dirty()
  end)
  button(canvas, "+ Add spell", 16, -551, 180, function()
    if not selected then message("Create a group first."); return end
    draft.entries[#draft.entries+1]={id="",group=selected,chance=100,files={}}
    refresh(); outer:SetVerticalScroll(math.max(0,content:GetHeight()-405)); dirty()
  end)
  text(canvas, "Silence has the same weight as a file. Save applies all edited groups.", 212, -558, 530)
  panel:SetScript("OnHide", function() panel:StopMovingOrSizing(); stop(); catalog:Hide(); dialog:Hide(); saveGeometry() end)
  local icon = LibStub("LibDBIcon-1.0")
  local broker = LibStub("LibDataBroker-1.1"):NewDataObject("SkillVoices", {
    type="launcher", text="SkillVoices", icon="Interface\\Icons\\Spell_Arcane_Arcane01",
    OnClick=function(_, mouse)
      if mouse=="RightButton" then SV.ResetWindow(); panel:Show() else SV.ToggleWindow() end
    end,
    OnTooltipShow=function(tooltip)
      tooltip:AddLine("SkillVoices")
      tooltip:AddLine("Click: open / close",1,1,1)
      tooltip:AddLine("Right-click: reset window",1,1,1)
      tooltip:AddLine("Drag the icon to reposition",.7,.7,.7)
    end,
  })
  icon:Register("SkillVoices",broker,SV.db.minimap)
  local options=CreateFrame("Frame")
  text(options,"SkillVoices",16,-16,500)
  text(options,"Standalone voice editor per character. Use the minimap icon or /sv.",16,-50,580)
  button(options,"Open SkillVoices",16,-90,200,function()
    if SettingsPanel then SettingsPanel:Hide() end
    panel:Show()
  end)
  local minimap=CreateFrame("CheckButton",nil,options,"UICheckButtonTemplate")
  minimap:SetPoint("TOPLEFT",16,-132)
  text(options,"Show minimap icon",50,-140,400)
  function SV.ToggleMinimap()
    SV.db.minimap.hide=not SV.db.minimap.hide
    if SV.db.minimap.hide then icon:Hide("SkillVoices") else icon:Show("SkillVoices") end
    minimap:SetChecked(not SV.db.minimap.hide)
  end
  minimap:SetChecked(not SV.db.minimap.hide); minimap:SetScript("OnClick",SV.ToggleMinimap)
  text(options,"/sv reset resets the window. /sv minimap toggles the icon.",16,-186,580)
  options:SetScript("OnShow",function() minimap:SetChecked(not SV.db.minimap.hide) end)
  SV.category=Settings.RegisterCanvasLayoutCategory(options,"SkillVoices")
  Settings.RegisterAddOnCategory(SV.category)
  refresh(); panel:Hide()
end
