# Pravidla projektu (pro Claude)

- Odpovídej česky, stručně a prakticky. Uživatel je Michal (Bolek98), neumí programovat – vysvětluj jednoduše.
- Každý mod: složka `mods/<id>/` s `mod.json`, `extended.mod.json`, `manager.json` (popis nastavení pro Enshrouded Mod Manager) a `src/mod.lua` + `src/config.lua`.
- Id a název: `b98-<něco>`, název začíná `[B98] `. Autor `Bolek98`.
- Nastavení modu patří do `src/config.lua` a jeho popis do `manager.json` (štítek, popis, rozsah/možnosti, předvolby), aby nový mod nepotřeboval nové sestavení Mod Manageru.
- Verze v `mod.json` zvyšuj: oprava +0.0.1, nová funkce +0.1.0.
- Před novou funkcí nebo novým modem nejdřív popiš plán a počkej na souhlas; chyby oprav rovnou a napiš, co bylo špatně.
- Řekni na rovinu, co nebylo vyzkoušené ve hře.
- Cizí mody (sf-*, AZJ-*, XHL-*, cz_translation, world-editor …) sem nepatří – jen vlastní mody a Mod Manager.
- Nikdy nedávej do repozitáře klíče, hesla ani tokeny.
