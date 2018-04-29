# Tetris in Elm

Tetris game based on [Captain Coder's video series](https://www.youtube.com/playlist?list=PL7C8fMD-89DKhlerIE3BrYNd0PlhA6Zch). I've also used [Mats Stijlaart's repository](https://github.com/stil4m/elm-tetris) as a reference, since the original code is written form Elm 0.16 and I'm using 0.18.

I'm just learning game programming in a language I'm familiar with!

## Running the game

I've included a `package.json` and a `.vscode` folder to make it easier for me to use VS Code and Elm extension in Windows. If you use VS Code and the extension, you don't need CLI commands at all. I prefer Yarn over NPM, but feel free to adapt commands below to `npm`.

### (Optional) install Elm platform, elm-format and elm-analyse

You can skip this if you have stuff mentioned above in path.

`yarn`

### Build

`elm-make` or `yarn build`

### Run elm-reactor (dev environment)

`elm-reactor` or `yarn start`

### Format code

`elm-format` or `yarn format`
