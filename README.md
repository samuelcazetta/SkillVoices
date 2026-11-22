# SkillVoices

A standalone World of Warcraft Retail addon that plays custom voice clips when your character casts configured spells. No AddsSam installation is required.

## Installation

Copy this folder to `_retail_/Interface/AddOns/SkillVoices`. The folder must contain `SkillVoices.toc` directly. Restart the game after installation.

Do not enable the original AddsSam_SkillVoices addon at the same time: both editions use `/sv` and the same per-character saved-variable name.

## Usage

- `/sv`: toggle the editor.
- `/sv reset`: reset window position and size.
- `/sv minimap`: toggle the minimap icon.
- `/sv show <spellId>`: inspect a saved spell mapping.

Use the minimap icon to open the movable, resizable editor. Right-click the icon to reset its position and size. Groups and subgroups organize spell cards, each with an ID, activation chance, and weighted sound list. The sound catalog supports previews and Silence entries. Click **Save** to apply all pending edits.

Place additional `.ogg` or `.mp3` files in `sounds/`, then enter their names in the catalog. The game cannot browse or import files from your computer. Restart the game if newly added audio is not available.

Settings, window geometry, and minimap preferences are saved per character. The existing Mage and Monk mappings are copied on first use. The independent addon does not automatically import the AddsSam edition's saved settings.

## Development

`SkillVoices.lua` handles initialization and playback; `Options.lua` implements the editor. `Mappings.lua` contains initial mappings and `Sounds.lua` lists catalog entries. Bundled libraries and source references are in `Libs/`.
