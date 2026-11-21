-- [B98] Víc XP a skill pointů (EML mod)
local TAG = "[B98 XP] "

local DEFAULTS = {
  xp_boj = 2.0, xp_tezba = 2.0, xp_pruzkum = 2.0, xp_questy = 2.0,
  skill_pointy_za_level = 2, multiplayer_bez_postihu = true,
}

local ok, cfg = pcall(require, "config")
if not ok or type(cfg) ~= "table" then
  print(TAG .. "config.lua nejde načíst, používám doporučené nastavení")
  cfg = { doporucene = true }
end
if cfg.doporucene ~= false then
  for k, v in pairs(DEFAULTS) do cfg[k] = v end
else
  for k, v in pairs(DEFAULTS) do if cfg[k] == nil then cfg[k] = v end end
end

local function num(v, lo, hi)
  v = tonumber(v) or 1
  if v < lo then v = lo end
  if v > hi then v = hi end
  return v
end
local f_boj, f_tezba = num(cfg.xp_boj, 0.1, 100), num(cfg.xp_tezba, 0.1, 100)
local f_pruzkum, f_questy = num(cfg.xp_pruzkum, 0.1, 100), num(cfg.xp_questy, 0.1, 100)
local sp = math.floor(num(cfg.skill_pointy_za_level, 1, 50))

local factor_by_source = {
  Combat = f_boj, Mining = f_tezba,
  Exploration = f_pruzkum, Lore = f_pruzkum, ItemSetCompleted = f_pruzkum,
  Quest = f_questy,
}

local function apply(tbl)
  -- skill pointy
  local old_sp = tbl.skillPointsPerLevel
  tbl.skillPointsPerLevel = sp
  print(TAG .. "skill pointy za level: " .. tostring(old_sp) .. " -> " .. sp)

  -- XP podle zdroje
  local seen = {}
  if tbl.experienceValues then
    for _, ev in ipairs(tbl.experienceValues) do
      local src = tostring(ev.source)
      local f = factor_by_source[src]
      if f and f ~= 1 then
        local old = ev.experienceGain
        local new = math.floor(old * f + 0.5)
        if old > 0 and new < 1 then new = 1 end
        if new > 4000000000 then new = 4000000000 end
        ev.experienceGain = new
        seen[src] = (seen[src] or 0) + 1
      end
    end
  end
  for src, n in pairs(seen) do print(TAG .. "XP " .. src .. ": upraveno " .. n .. " hodnot") end

  -- XP za boj: pokud ho hra počítá z počtu zabití na level, sníží se potřebný počet zabití
  if not seen["Combat"] and f_boj ~= 1 and tbl.killToLevelUPStart then
    local s, e = tbl.killToLevelUPStart, tbl.killToLevelUPEnd
    tbl.killToLevelUPStart = math.max(1, math.floor(s / f_boj + 0.5))
    tbl.killToLevelUPEnd = math.max(1, math.floor(e / f_boj + 0.5))
    print(TAG .. "zabití na level: " .. s .. "-" .. e .. " -> " .. tbl.killToLevelUPStart .. "-" .. tbl.killToLevelUPEnd)
  end

  -- skupina
  if cfg.multiplayer_bez_postihu then
    print(TAG .. "skupina: groupSizeXpDamper=" .. tostring(tbl.groupSizeXpDamper) .. ", modMin=" .. tostring(tbl.groupSizeXpDamperModMin) ..
          ", xpSharedOther=" .. tostring(tbl.xpSharedOther))
    if tbl.groupSizeXpDamperModMin and tbl.groupSizeXpDamperModMin < 1 then tbl.groupSizeXpDamperModMin = 1.0 end
    if tbl.xpSharedOther and tbl.xpSharedOther < 1 then tbl.xpSharedOther = 1.0 end
  end
end

local ok2, err = pcall(function()
  local res = game.assets.get_resources_by_type("keen::BalancingTable")
  if #res == 0 then
    print(TAG .. "VAROVÁNÍ: BalancingTable nenalezena – mod nic nezměnil")
    return
  end
  for _, r in ipairs(res) do apply(r.data) end
  print(TAG .. string.format("hotovo – XP boj x%.1f, těžba x%.1f, průzkum x%.1f, questy x%.1f, %d SP/level (%d tabulek)",
    f_boj, f_tezba, f_pruzkum, f_questy, sp, #res))
end)
if not ok2 then print(TAG .. "CHYBA (mod se přeskočil, hra pojede normálně): " .. tostring(err)) end
