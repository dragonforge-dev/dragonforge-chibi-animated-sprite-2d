[![Static Badge](https://img.shields.io/badge/Godot%20Engine-4.5.stable-blue?style=plastic&logo=godotengine)](https://godotengine.org/)

# Dragonforge Chibi Animated Sprite 2D
A custom node for loading CraftPix.net Chibi Characters as an AnimatedSprite2D.

# Version 1.0
For use with **Godot 4.5.1.stable** and later.

# Installation Instructions
1. Copy all the `dragonforge_animated_sprite_2d` folder from the `addons` folder into your project's `addons` folder.
2. Save your project.

# Usage Instructions
There is an example folder that contains an example of a **ChibiAnimatedSprite2D** in use. It uses the [FREE Chibi Valkyrie Sprites](https://craftpix.net/freebies/free-chibi-valkyrie-character-sprites/).

1. Download [Chibi Sprites from CraftPix.net](https://craftpix.net/sets/chibi-game-character-sprites-collection/)
2. Open the zip file.
3. Browse to one of the three character folders.
4. Open the `PNG` folder
5. Open the `PNG Sequences` folder
6. **In your project** create a folder to store the character. (Recommended: `res://assets/textures/characters/character_name`) **NOTE: All the folder names must be in snake_case - NO uppercase lettes in the folder names!**
7. Drag and drop all the folders from the zipfile into the `character_name` folder in **FileSystem**. (Each folder represents an animation, so any animations you don't want can be elimintaed by removing the folders.)
8. Click on Godot (if you are not already in it) and wait for the files to import.
9. Create a **ChibAnimatedSprite** node.
10. Select the **Output** tab at the bottom of the editor.
11. Select the **ChibAnimatedSprite** node.
12. Click the file button next to **Sprite Root Folder**.
13. In the dialog that appears, browse to the `character_name` folder.
14. Click the **Select Current Folder** button.
15. Wait for the files to load. (The message "**SpriteFrames** Loading Complete!" will appear in the **Output** window.)
16. If you get errors, save and reload the project.

All the animations will be loaded correctly and all error messages will be gone. Additionally all folder and filenames will be lowercase in case of Windows export.

The reason all folder names must be in lowercase is because if you do a Windows export, any file names or file paths that have an uppercase letter in them will not load. So since CraftPix puts lots of uppercase letters in their filenames, we just convert them all. This conversion causes some weird things to happen with UIDs with filenames that have spaces in them - hence the need for a reboot.
