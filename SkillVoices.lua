-- Runtime and character-local configuration. Empty strings are weighted silence entries.
local addonName = ...
SkillVoices = {}
local SV = SkillVoices

function SV.Initialize()
  if type(SkillVoicesCharacterDB) ~= "table" then
    local db = { version = 1, mappings = {}, groups = { "Mage", "Monk" } }
    local mage = { [30451]=true, [153626]=true, [44425]=true, [321507]=true, [1449]=true, [2139]=true }
    for id, entry in pairs(SkillVoices_Mappings or {}) do
      local files = {}
      for i, file in ipairs(entry.files or {}) do files[i] = file end
      db.mappings[id] = { files = files, chance = entry.chance or 100,
        group = mage[id] and "Mage" or "Monk" }
    end
    SkillVoicesCharacterDB = db
  end
  SV.db = SkillVoicesCharacterDB
  SV.db.mappings = SV.db.mappings or {}
  SV.db.groups = SV.db.groups or {}
end

function SV.Play(file)
  if not file or file == "" then return true end
  local ok, played = pcall(PlaySoundFile,
    "Interface\\AddOns\\SkillVoices\\sounds\\" .. file, "Master")
  if not ok or not played then
    print("SkillVoices: unable to play " .. file)
    return false
  end
  return true
end

function SV.HandleSpell(id)
  if not SV.db then return end
  local entry = SV.db.mappings[id]
  if not entry then return end
  local chance = math.max(0, math.min(100, tonumber(entry.chance) or 100))
  if chance <= 0 or (chance < 100 and math.random(100) > chance) then return end
  if #entry.files > 0 then SV.Play(entry.files[math.random(#entry.files)]) end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
frame:SetScript("OnEvent", function(_, event, ...)
  if event == "ADDON_LOADED" then
    if ... ~= addonName then return end
    SV.Initialize()
    SV.CreateOptions()
    frame:UnregisterEvent("ADDON_LOADED")
  else
    local unit, _, id = ...
    if unit == "player" and id then
      -- Retail can restrict event values in some contexts. Never let them break the event handler.
      pcall(SV.HandleSpell, id)
    end
  end
end)

SLASH_SKILLVOICES1 = "/sv"
SlashCmdList.SKILLVOICES = function(msg)
  local id = tonumber((msg or ""):match("^%s*show%s+(%d+)"))
  if id then
    local e = SV.db and SV.db.mappings[id]
    print(e and ("SkillVoices: " .. id .. " -> files=" .. #e.files .. " chance=" .. e.chance)
      or ("SkillVoices: no mapping for " .. id))
  elseif SV.ToggleWindow then
    if (msg or ""):match("^%s*reset%s*$") then SV.ResetWindow()
    elseif (msg or ""):match("^%s*minimap%s*$") then SV.ToggleMinimap()
    else SV.ToggleWindow() end
  end
end
