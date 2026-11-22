# SkillVoices

Give your spells a voice! SkillVoices plays a random voice clip when you cast a spell, with an easy editor to make it your own.

Built for **World of Warcraft Retail**, with separate settings for each character.

## What you can do

- Pick the spells that should trigger a voice clip.
- Give each spell a list of sounds and a chance to play.
- Add **Silence** as an option, or repeat a sound to make it more likely.
- Keep things tidy with groups and subgroups.
- Preview sounds before saving.
- Move and resize the editor, and open it from the minimap.

Mage and Monk examples are included to help you get started.

## Install

1. Download the repository and extract it.
2. Rename the extracted folder to **SkillVoices**.
3. Put it inside `World of Warcraft/_retail_/Interface/AddOns/`.
4. Check that `SkillVoices.toc` is directly inside the `SkillVoices` folder.
5. Restart the game and enable SkillVoices in your addon list.

All required libraries are included.

## Make it yours

Click the minimap icon or type `/sv` to open the editor.

Choose a group, then click **+ Add spell**. Enter the spell ID, adjust its chance, and click **Add** to choose sounds from the catalog. You can listen to each sound, remove it, or add **Silence**.

Click **Save** when you are happy with your setup. This saves all pending changes across your groups. Switching groups keeps your edits, but unsaved changes are lost when you reload or leave the game.

To create a subgroup, use a name like `Mage/Arcane`. You can find spell IDs on Wowhead.

### Add your own sounds

Put an `.ogg` or `.mp3` file in the addon's `sounds/` folder. Open the catalog and enter its filename, including the extension, then click **Add**.

The editor cannot import files from your computer. If a new sound does not play, restart the game and try again.

### How the chance works

A spell with a **50% chance** first rolls to decide whether to trigger. If it does, one entry from its sound list is chosen at random.

For example, a list with two sounds and one Silence entry gives each entry an equal chance. Adding the same sound twice makes it twice as likely to be chosen.

## Commands

| Command | What it does |
| --- | --- |
| `/sv` | Open or close the editor |
| `/sv reset` | Reset the window's size and position |
| `/sv minimap` | Show or hide the minimap icon |
| `/sv show <spellId>` | Show the saved sound count and chance for a spell |

You can also right-click the minimap icon to reset and open the window, or drag the icon to move it around the minimap.

## For contributors

- `SkillVoices.lua`: settings and playback.
- `Options.lua`: the editor and minimap launcher.
- `Mappings.lua`: starter spell mappings.
- `Sounds.lua`: the built-in sound catalog.
- `Libs/`: bundled libraries and their source references.

The interface and code comments are in English. Settings are saved per character by the game.
