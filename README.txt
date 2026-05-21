# LÖVE 2D Game Packager

Two batch scripts to build distributable packages from your LÖVE 2D games — one for **Windows executables** and one for **web/HTML5**.

---

## Scripts

| Script | Output | Requirements |
|---|---|---|
| `love2dPackager.bat` | Windows `.zip` with standalone `.exe` | LÖVE 2D, Resource Hacker |
| `love2dWebPackager.bat` | Web/HTML5 folder (+ optional `.zip`) | Node.js, love.js (auto-installed) |

---

## love2dPackager.bat — Windows Executable

### What It Does

1. Packages your game folder into a `.love` file
2. Fuses it with `love.exe` to create a standalone `.exe`
3. Applies a custom icon (if you have a `.ico` file in your game folder)
4. Bundles everything with required DLLs into a `.zip` file ready for distribution

### Prerequisites

#### 1. LÖVE 2D
Download and install LÖVE from: https://love2d.org/

**Default installation path:** `C:\Program Files\LOVE`

If you install it elsewhere, you'll need to edit the script or enter the path when prompted.

#### 2. Resource Hacker (for custom icons)
Download and install Resource Hacker from: https://www.angusj.com/resourcehacker/

**Default installation path:** `C:\Program Files (x86)\Resource Hacker`

> **Note:** Resource Hacker is only needed if you want custom icons. The script will still work without it.

### Setup

1. Download `love2dPackager.bat` from this repository
2. **Edit the paths in the script** (optional but recommended):
   - Open `love2dPackager.bat` in a text editor
   - Look for lines marked with `:: EDIT THIS:`
   - Update the paths to match your system:
     ```bat
     set "LoveDir=C:\Program Files\LOVE"
     set "ResourceHacker=C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe"
     set "OutDownloads=C:\Users\YourUsername\Downloads"
     ```

### How to Use

1. **Double-click `love2dPackager.bat`** to run it
2. **Enter your game folder path** when prompted:
   ```
   Game root path: C:\Users\YourName\Documents\MyGame
   ```
3. **Enter an output name** when prompted:
   ```
   Output name: MyAwesomeGame
   ```

The script outputs `MyAwesomeGame_Windows.zip` to your Downloads folder (or wherever you set `OutDownloads`).

### Custom Icon (Optional)

1. Create or convert your icon to `.ico` format
2. Place the `.ico` file in your game's root folder (same folder as `main.lua`)
3. The script will automatically find and apply it

If no `.ico` file is found, your game will use the default LÖVE icon.

### Output

The final `.zip` contains:
- `YourGame.exe` — Standalone executable
- All required `.dll` files from LÖVE
- `license.txt` (LÖVE license)

Users can extract and run `YourGame.exe` without installing LÖVE.

---

## love2dWebPackager.bat — Web / HTML5

### What It Does

1. Packages your game folder into a `.love` file (if you pass a folder)
2. Runs [love.js](https://github.com/Davidobot/love.js) to compile it to a web-ready HTML5 package
3. Outputs a folder you can host on any static web server or upload to itch.io
4. Optionally zips the output for easy distribution

### Prerequisites

#### 1. Node.js
Download and install from: https://nodejs.org/

Must be on your system `PATH`. The script will error with a download link if it's missing.

#### 2. love.js
The script checks for love.js automatically and **offers to install it for you** if it isn't found:

```
love.js not found.
Install love.js globally via npm now? (Y/N)
```

To install it manually ahead of time:
```bat
npm install -g love.js
```

### How to Use

1. **Double-click `love2dWebPackager.bat`** to run it
2. **Enter your game folder path** (or path to a pre-built `.love` file) when prompted:
   ```
   Game root path: C:\Users\YourName\Documents\MyGame
   ```
3. **Enter an output name** when prompted:
   ```
   Output game name: MyAwesomeGame
   ```
4. **Choose an output folder** (or press Enter to use the default next to the script)
5. **Choose compatibility mode** when prompted (see note below)

### Compatibility Mode

| Mode | Flag | Use when |
|---|---|---|
| Compatibility | `-c` (default) | itch.io, most static hosts, broadest browser support |
| Standard | (none) | Hosts that set `Cross-Origin-Opener-Policy` and `Cross-Origin-Embedder-Policy` headers |

> **Recommendation:** Use compatibility mode unless you know your host supports the required COOP/COEP headers. Audio may be slightly degraded in compatibility mode.

### Output

The script produces a folder (e.g. `MyAwesomeGame_web/`) containing:
- `index.html` — The game page
- `love.js` / `love.wasm` — The LÖVE runtime compiled to WebAssembly
- Game data files

Optionally, it also creates `MyAwesomeGame_web.zip` for easy uploading.

### Testing Locally

The output **cannot** be opened directly as a `file://` URL — you must serve it over HTTP:

```bat
cd MyAwesomeGame_web
python -m http.server 8000
```

Then open http://localhost:8000 in your browser.

### Uploading to itch.io

1. Zip the output folder
2. Upload the `.zip` to your itch.io project as an **HTML** upload
3. Enable **"This file will be played in the browser"**
4. Use compatibility mode (`-c`) unless you have SharedArrayBuffer support enabled in your itch.io project settings

---

## Troubleshooting

### love2dPackager.bat

**"ERROR: Failed to create .love file"**
- Make sure the game folder path is correct
- Verify the folder contains `main.lua`

**"Path to LOVE folder" prompt appears**
- LÖVE is not installed at the default location
- Enter the full path to your LÖVE installation folder

**"Path to ResourceHacker.exe" prompt appears**
- Resource Hacker is not installed at the default location
- Enter the full path to `ResourceHacker.exe`, or skip if you don't need custom icons

**Icon doesn't change**
- Make sure your `.ico` file is in the game's root folder
- Verify Resource Hacker is installed correctly
- The `.ico` file must be a valid Windows icon format

### love2dWebPackager.bat

**"Node.js was not found on PATH"**
- Install Node.js from https://nodejs.org/ and restart your terminal or PC

**"npm install failed"**
- Check your internet connection
- Try running `npm install -g love.js` manually in a terminal

**Game doesn't load / blank page**
- Make sure you're serving the folder over HTTP, not opening `index.html` directly
- Try switching to compatibility mode (`-c`) if you used standard mode

**"Uncaught ReferenceError: SharedArrayBuffer is not defined"**
- Switch to compatibility mode; your host does not set the required COOP/COEP headers

**Audio issues in browser**
- This is a known limitation of love.js in compatibility mode
- The standard (non-compat) mode has better audio but requires specific server headers

---

## Issues

Please use the [issues tab on GitHub](https://github.com/NasaBoi1234/LOVE-2D-Auto-exe-packager/issues/new) to report bugs and describe how to reproduce them.

## License

These scripts are provided as-is. Use them freely for your LÖVE 2D projects.
