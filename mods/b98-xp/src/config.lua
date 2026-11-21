-- [B98] Víc XP a skill pointů – nastavení
-- Změny se projeví po restartu hry.
return {
  -- true = Doporučené nastavení (XP ×2 všude, 2 skill pointy za level, skupina bez postihu)
  -- false = použijí se hodnoty níže
  doporucene = false,

  xp_boj     = 2.0,   -- zkušenosti za zabití nepřátel (1.0 = jako ve hře, 2.0 = dvojnásobek)
  xp_tezba   = 2.0,   -- zkušenosti za těžbu
  xp_pruzkum = 2.0,   -- zkušenosti za průzkum, lore a sbírky
  xp_questy  = 2.0,   -- zkušenosti za questy

  skill_pointy_za_level = 4,          -- kolik skill pointů dostaneš za každý level
  multiplayer_bez_postihu = true,     -- ve skupině se XP nesnižuje a ostatní dostávají plný podíl
}
