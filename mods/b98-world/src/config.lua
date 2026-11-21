-- [B98] Rozšířené nastavení světa – jak daleko půjdou posuvníky v Nastavení světa
-- Změny se projeví po restartu hry. Hodnoty pak nastavíš ve hře v Nastavení světa.
return {
  -- "doporuceny" = rozumné limity, "velky" = hodně volné limity, "vlastni" = hodnoty níže
  rozsah = "vlastni",

  max_rychlost = 10.0,       -- růst rostlin, výroba ve stanicích, těžba, množství surovin, XP (max násobič)
  max_sila_hrace = 5.0,      -- zdraví, mana, výdrž, teplo, potápění hráče (max násobič)
  min_sila_hrace = 0.25,     -- (min násobič)
  max_sila_nepratel = 5.0,   -- zdraví, poškození, výdrž a vnímání nepřátel a bossů (max násobič)
  min_sila_nepratel = 0.1,   -- (min násobič)
  max_zavoj_a_jidlo = 20.0,  -- čas v Závoji a trvání jídla (max násobič)
  rozsah_den = 4.0,          -- délka dne: původní min ÷ tohle, původní max × tohle
  rozsah_noc = 2.0,          -- délka noci: původní min ÷ tohle, původní max × tohle
  rozsah_hladoveni = 2.0,    -- čas do hladovění: původní min ÷ tohle, původní max × tohle
}
