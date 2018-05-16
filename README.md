# Tetris in Elm

Tetris game based on [Captain Coder's video series](https://www.youtube.com/playlist?list=PL7C8fMD-89DKhlerIE3BrYNd0PlhA6Zch). I've also used [Mats Stijlaart's repository](https://github.com/stil4m/elm-tetris) as a reference, since the original code is written form Elm 0.16 and I'm using 0.18.

I'm just learning game programming in a language I'm familiar with!

## Running the game

### Local or global Elm?

I've included a `package.json` and a `.vscode` folder with example settings to make it easier (for me) to use [Visual Studio Code](https://code.visualstudio.com) and `elm` extension in Windows. If you use VS Code and the `elm` extension, you don't need CLI commands at all. You might find the examples useful on other platforms too if you want this workspace to contain everything that you need to develop this project.

In order to get things to work, create a `settings.json` file with contents from one of the example files. `yarn` commands below use local Elm installation. If you prefer to use a global Elm installation (in PATH), you can skip all of this and carry on like you normally do.

I prefer Yarn over NPM, but feel free to adapt `yarn` commands below to `npm`.

### (Optional) install Elm platform, elm-format and elm-analyse

You can skip this if you have `elm-make`, `elm-reactor` and `elm-format` in PATH.

`yarn`

### Build

`elm-make` or `yarn build`

### Run elm-reactor (dev environment)

`elm-reactor` or `yarn start`

### Format code

`elm-format` or `yarn format`
