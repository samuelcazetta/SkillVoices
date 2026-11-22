-- Mappings.lua
-- Configure spell IDs and their sound files here
-- Find the spell ID by searching its name on Wowhead
-- Structure: [spellId] = { files = { "nome1.ogg", "nome2.ogg" }, chance = 75 }
-- chance = 0..100 (0 never plays, 100 always plays)

SkillVoices_Mappings = {

  -- ---------------- Mage
  
  [30451] = { files = { "stupify2.ogg", "stupify4.ogg", "stupify5.ogg", "stupify6.ogg", "stupify7.ogg"    }, chance = 20 }, -- Arcane Blast
  [153626] = { files = { "expeliarmus1.ogg", "expeliarmus2.ogg", "expeliarmus3.ogg", "expeliarmus4.ogg", "expeliarmus5.ogg", "expeliarmus6.ogg", "expeliarmus7.ogg"   }, chance = 20 }, -- Arcane Orb
  [44425] = { files = { "expulso3.ogg", "expulso4.ogg", "expulso5.ogg", "expulso6.ogg" }, chance = 40  }, -- Arcane Barrage
  [321507] = { files = { "lumos1.ogg", "lumos2.ogg", "lumos3.ogg", "lumos4.ogg", "lumos5.ogg" }, chance = 60  }, -- Touch of Mages
  [1449] = { files = { "letmepass.ogg"    }, chance = 60 }, -- Arcane Explosions
  [2139] = { files = { "impedimenta2.ogg", "impedimenta3.ogg", "impedimenta4.ogg", "impedimenta6.ogg" }, chance = 100 }, -- CounterSpell
  
  -- [365350] = { files = { "tempestatris1.ogg", "tempestatris2.ogg", "tempestatris3.ogg" }, chance = 100 }, -- ArcaneSurge
  -- [5143] = { files = { "ludosdonfatumes1.ogg", "ludosdonfatumes2.ogg", "ludosdonfatumes3.ogg" }, chance = 100 }, -- ArcaneMissiles
  
  
  
  
  -- ---------------- Monk
  
  -- Tiger Palm
  [100780] = { files = {"monkAttack_1.ogg", "monkAttack_2.ogg", "monkAttack_3.ogg", "monkAttack_5.ogg", "monkAttack_6.ogg", "monkAttack_7.ogg", "monkAttack_9.ogg", "monkAttack_11.ogg", "monkAttack_12.ogg", "monkAttack_13.ogg", "monkAttack_14.ogg", "monkAttack_16.ogg", "monkAttack_18.ogg", "monkAttack_19.ogg", "monkAttack_23.ogg", "monkAttack_27.ogg", "monkAttack_29.ogg", "monkAttack_31.ogg", "monkAttack_32.ogg", "monkAttack_33.ogg", "monkAttack_36.ogg"},
  chance = 20 }, 
   
  -- Blackout Kick
  -- [100784]
  [205523] = { files = {"monkAttack_1.ogg", "monkAttack_2.ogg", "monkAttack_3.ogg", "monkAttack_5.ogg", "monkAttack_6.ogg", "monkAttack_7.ogg", "monkAttack_9.ogg", "monkAttack_11.ogg", "monkAttack_12.ogg", "monkAttack_13.ogg", "monkAttack_14.ogg", "monkAttack_16.ogg", "monkAttack_18.ogg", "monkAttack_19.ogg", "monkAttack_23.ogg", "monkAttack_27.ogg", "monkAttack_29.ogg", "monkAttack_31.ogg", "monkAttack_32.ogg", "monkAttack_33.ogg", "monkAttack_36.ogg"},
  chance = 20 },
  
  -- Breath of Fire
  [115181] = { files = {"monkSpecial_0.ogg", "monkSpecial_1.ogg" }, chance = 10 },
  
  -- Disable
  [116095] = {files = {"monkSlow.ogg"}, chance = 100},
  
  -- Spear
  [116705] = {files = {"monkDesactive.ogg"}, chance = 100},
  
  -- [383994] = { files = {"monkSpecial_0", "monkSpecial_1", "monkSpecial_2" }, chance = 100 },
  
  -- Provoke
  -- [115546] = { files = {}, chance 30 },
    
  -- Paralysis
  -- [115078] = { files = {}, chance 30 },
  
  -- Tiger's Lust
  -- [116841] = { files = {}, chance 30 },
  
  -- Torpedo
  -- "monkAttack_30.ogg" "monkAttack_22.ogg", "monkAttack_17.ogg", "monkAttack_15.ogg"
  
  -- spinning crane kick
  [322729] = { files = { "tatsumakisempu.ogg", "tatsumaki.ogg" }, chance = 30 },
  
    
  -- leg sweep
  [119381] = { files = { "tatsumaki.ogg" }, chance = 90 },
  
  -- jade lightning
  [117952] = { files = { "gohadou.ogg" }, chance = 90 },
  
  -- strike of the windlord
  [392983] = { files = { "goshoryu1.ogg", "goshoryu2.ogg" }, chance = 90 }, 
  
   -- touch of death
  [322109] = { files = { "mesatsu1.ogg" }, chance = 100 }
  
  -- flurry strikes (proc abilities dont work anymore)
  -- [450617] = { files = { "isshunSengeki.ogg" }, chance = 70 },

  
  -- [spellId]   = { files = { "filename1.ogg", "filename2.ogg" }, chance = 50 }, -- example: Fireball (ID 133), --chance = 100 = always play
}
