# LÖVE 2D Auto exe packager

A simple batch script to build distributable Windows executables from your LÖVE2D games.

## What This Does

This script will:
1. Package your game folder into a `.love` file
2. Fuse it with `love.exe` to create a standalone `.exe`
3. Apply a custom icon (if you have a `.ico` file in your game folder)
4. Bundle everything with required DLLs into a `.zip` file ready for distribution

## Prerequisites

You need to install these programs before using the script:

### 1. LÖVE2D
Download and install LÖVE from: https://love2d.org/

**Default installation path:** `C:\Program Files\LOVE`

If you install it elsewhere, you'll need to edit the script or enter the path when prompted.

### 2. Resource Hacker (for custom icons)
Download and install Resource Hacker from: https://www.angusj.com/resourcehacker/

**Default installation path:** `C:\Program Files (x86)\Resource Hacker`

If you install it elsewhere, you'll need to edit the script or enter the path when prompted.

> **Note:** Resource Hacker is only needed if you want custom icons. The script will still work without it.

## Setup

1. Download `build.bat` from this repository
2. **Edit the paths in the script** (optional but recommended):
   - Open `build.bat` in a text editor
   - Look for lines marked with `:: EDIT THIS:`
   - Update the paths to match your system:
     ```bat
     set "LoveDir=C:\Program Files\LOVE"
     set "ResourceHacker=C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe"
     set "OutDownloads=C:\Users\YourUsername\Downloads"
     ```

## How to Use

1. **Double-click `build.bat`** to run it

2. **Enter your game folder path** when prompted:
   ```
   Game root path: C:\Users\YourName\Documents\MyGame
   ```
   This should be the folder containing your `main.lua` file.

3. **Enter an output name** when prompted:
   ```
   Output name: MyAwesomeGame
   ```
   Don't include file extensions - just the name.

4. The script will build your game and output:
   ```
   MyAwesomeGame_Windows.zip
   ```
   in your Downloads folder (or wherever you set `OutDownloads`).

## Custom Icon (Optional)

To add a custom icon to your game's `.exe`:

1. Create or convert your icon to `.ico` format
2. Place the `.ico` file in your game's root folder (same folder as `main.lua`)
3. The script will automatically find and use it

If no `.ico` file is found, your game will use the default LÖVE icon.

## Output

The final `.zip` file will contain:
- `YourGame.exe` - Standalone executable
- All required `.dll` files from LÖVE
- `license.txt` (LÖVE license)

Users can extract this `.zip` and run `YourGame.exe` without installing LÖVE.

## Troubleshooting

**"ERROR: Failed to create .love file"**
- Make sure the game folder path is correct
- Verify the folder contains `main.lua`

**"Path to LOVE folder" prompt appears**
- LÖVE is not installed at the default location
- Enter the full path to your LÖVE installation folder

**"Path to ResourceHacker.exe" prompt appears**
- Resource Hacker is not installed at the default location
- Enter the full path to `ResourceHacker.exe`
- Or skip this if you don't need custom icons

**Icon doesn't change**
- Make sure your `.ico` file is in the game's root folder
- Verify Resource Hacker is installed correctly
- The `.ico` file must be a valid Windows icon format

## Issues

Please use the [issues tab in github](https://github.com/NasaBoi1234/LOVE-2D-Auto-exe-packager/issues/new) to report it and explain how to recreate it

## License

This script is provided as-is. Use it freely for your LÖVE2D projects.
