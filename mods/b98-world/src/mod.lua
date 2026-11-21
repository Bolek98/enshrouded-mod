-- [B98] Rozšířené nastavení světa (EML mod)
local TAG = "[B98 Svět] "

local PRESETS = {
  doporuceny = { max_rychlost = 10, max_sila_hrace = 5, min_sila_hrace = 0.25, max_sila_nepratel = 5,
                 min_sila_nepratel = 0.1, max_zavoj_a_jidlo = 10, rozsah_den = 4, rozsah_noc = 4, rozsah_hladoveni = 4 },
  velky      = { max_rychlost = 25, max_sila_hrace = 10, min_sila_hrace = 0.1, max_sila_nepratel = 10,
                 min_sila_nepratel = 0.05, max_zavoj_a_jidlo = 25, rozsah_den = 10, rozsah_noc = 10, rozsah_hladoveni = 10 },
}

local ok, cfg = pcall(require, "config")
if not ok or type(cfg) ~= "table" then cfg = { rozsah = "doporuceny" } end
local c = PRESETS[cfg.rozsah or "doporuceny"]
if not c then
  c = {}
  for k, v in pairs(PRESETS.doporuceny) do c[k] = tonumber(cfg[k]) or tonumber(cfg.rozsah_dne) and k:find("^rozsah_") and tonumber(cfg.rozsah_dne) or v end
end

local function clamp(v, lo, hi) if v < lo then return lo elseif v > hi then return hi end return v end
c.max_rychlost = clamp(c.max_rychlost, 1, 100)
c.max_sila_hrace = clamp(c.max_sila_hrace, 1, 100)
c.min_sila_hrace = clamp(c.min_sila_hrace, 0.01, 1)
c.max_sila_nepratel = clamp(c.max_sila_nepratel, 1, 100)
c.min_sila_nepratel = clamp(c.min_sila_nepratel, 0.01, 1)
c.max_zavoj_a_jidlo = clamp(c.max_zavoj_a_jidlo, 1, 100)
c.rozsah_den = clamp(c.rozsah_den, 1, 50)
c.rozsah_noc = clamp(c.rozsah_noc, 1, 50)
c.rozsah_hladoveni = clamp(c.rozsah_hladoveni, 1, 50)

-- skupiny nastavení: { pole, min, max }   (nil = nechat původní)
local GROUPS = {
  { { "plantGrowthSpeedFactor", "factoryProductionSpeedFactor", "miningDamageFactor", "resourceDropStackAmountFactor",
      "experienceCombatFactor", "experienceMiningFactor", "experienceExplorationQuestsFactor" }, nil, c.max_rychlost },
  { { "playerHealthFactor", "playerManaFactor", "playerStaminaFactor", "playerBodyHeatFactor", "playerDivingTimeFactor" },
    c.min_sila_hrace, c.max_sila_hrace },
  { { "enemyDamageFactor", "enemyHealthFactor", "enemyStaminaFactor", "enemyPerceptionRangeFactor",
      "bossDamageFactor", "bossHealthFactor" }, c.min_sila_nepratel, c.max_sila_nepratel },
  { { "shroudTimeFactor", "foodBuffDurationFactor" }, c.min_sila_hrace, c.max_zavoj_a_jidlo },
}
local TIMES = { { "dayTimeDuration", "rozsah_den" }, { "nightTimeDuration", "rozsah_noc" }, { "fromHungerToStarving", "rozsah_hladoveni" } }

local function fmt(v) return string.format("%.3g", v) end

local function widen(minv, maxv)
  local changed = 0
  for _, g in ipairs(GROUPS) do
    local fields, lo, hi = g[1], g[2], g[3]
    for _, f in ipairs(fields) do
      local a, b = minv[f], maxv[f]
      if type(a) == "number" and type(b) == "number" then
        local na, nb = a, b
        if lo and lo < a then na = lo end
        if hi and hi > b then nb = hi end
        if na ~= a or nb ~= b then
          minv[f] = na; maxv[f] = nb; changed = changed + 1
          print(TAG .. f .. ": " .. fmt(a) .. "–" .. fmt(b) .. "  ->  " .. fmt(na) .. "–" .. fmt(nb))
        else
          print(TAG .. f .. ": " .. fmt(a) .. "–" .. fmt(b) .. " (beze změny)")
        end
      end
    end
  end
  for _, t in ipairs(TIMES) do
    local f, k = t[1], c[t[2]]
    local a, b = minv[f], maxv[f]
    if a and b and type(a.value) == "number" and type(b.value) == "number" then
      local na = math.max(1, math.floor(a.value / k))
      local nb = math.floor(b.value * k)
      print(TAG .. f .. " (x" .. fmt(k) .. "): " .. tostring(a.value) .. "–" .. tostring(b.value) .. "  ->  " .. na .. "–" .. nb)
      a.value = na; b.value = nb; changed = changed + 1
    end
  end
  return changed
end

local ok2, err = pcall(function()
  local res = game.assets.get_resources_by_type("keen::GameSettingsPresetsResource")
  if #res == 0 then print(TAG .. "VAROVÁNÍ: GameSettingsPresetsResource nenalezen – nic se nezměnilo"); return end
  local total = 0
  for _, r in ipairs(res) do
    local d = r.data
    total = total + widen(d.minValues, d.maxValues)
  end
  print(TAG .. "hotovo – rozsah '" .. tostring(cfg.rozsah) .. "', rozšířeno " .. total .. " posuvníků")
end)
if not ok2 then print(TAG .. "CHYBA (mod se přeskočil, hra pojede normálně): " .. tostring(err)) end
