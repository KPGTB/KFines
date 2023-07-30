![License](https://img.shields.io/badge/License-Apache%202.0-orange)
![Author](https://img.shields.io/badge/Author-KPG--TB-green)
---

![img](https://i.imgur.com/hDl0FQg.png)

# FiveM + ReactJS Simple Template

A simple template to make FiveM Lua scripts with NUI created in ReactJS. Webpack is configured to make editing easier. Editing styles and assets doesn't require building a node project. Only changes in JS/JSX files require building.

# Requirements

* [NodeJS](https://nodejs.org/en)

# Usage

1. Clone repository 
```
git clone https://github.com/KPGTB/fivem-react-template.git
```
You can also download that template or create a new repository from it.

2. Open terminal in `web/react` and install node packages
```
npm i
```

3. Change name, description, etc. in
   * fxmanifest.lua
   * web/react/package.json
   * web/react/src/index.html
4. Edit your code like you want
5. After changes in `web/react` you need to build react project
```
npm run build
```

---

**NOTE:** 
- Don't use Webpack Serve. Always build project and check it in-game
- You need to import every stylesheet into `web/styles/main.css`. Don't import styles into React components!
```css
@import url(PATH_TO_CSS_FILE);
```
- All asset paths must depend on `web/build/index.html` file. Don't import assets into React components!

Examples:

1. 
   * Image path: `web/assets/image.png`
   * Path to image in **every** component: `../assets/image.png`
2.
   * Image path: `web/assets/inventory/icons/apple.png`
   * Path to image in **every** component: `../assets/inventory/icons/apple.png`



# Project structure

* client - Client-side Lua scripts
  * client.lua - Example of NUI toggling
  * react.lua - Lua utils of react-fivem connection
* server - Server-side Lua scripts
* web - NUI
  * assets - NUI assets like images
    * logo.png - Example asset
  * styles - NUI styles (CSS)
    * main.css - Main CSS file
    * app.css - Example App component Style
  * build - Folder with built node project
  * react - ReactJS front-end
    * src - Source of node project
      * components - Components of ReactJS
      * pages - Pages of ReactJS (Components that represent pages)
      * utils - Some utils
        * FiveM.js - JS utils of react-fivem connection
      * App.jsx - File with basic ReactJS component + Small example

# Utils

In this template, I added some utilities that help with the react-fivem connection.

### Lua Utils (client-side)

1. Sending messages to ReactJS
```lua
SendReactMessage(action, data)
```
*action - Text with name of action (It will be used in JS)*

*data - Data of message. It can be text, number, boolean, table, etc.*

Example:
```lua
SendReactMessage("hello", "world")
```
*That function will send a message with the name `hello` and the data `world` to ReactJS. See `JS Utils` section to check receiving message in JS*

2. Setting visibility of NUI
```lua
SetReactVisible(visible)
```
*visible - true or false*

3. Toggling visibility of NUI
```lua
ToggleReactVisible()
```

4. Checking if NUI is visible
```lua
IsReactVisible()
```

### JS Utils

**To change default visibility, go to `web/react/src/App.jsx` and change state value `visible`**

1. Handling messages from NUI 
```js
useNui(action, handler)
```
*action - Name of action*

*handler - Function that will be executed after message from FiveM*

Example:
```js
useNui("hello", (data) => console.log(data))
```
*That function will print into the console data received from a message with the name `hello`. See `Lua Utils (client-side)` section to check sending messages from Lua. In that case, it should print `world`*

2. Sending data to Lua
```js
callNui(action, data, handler)
```
*action - Name of NUI callback*

*data - Data to send*

*handler - Function that will be invoked after callback*

Example:

LUA
```lua
RegisterNUICallback("example", function(data,cb)
    print(data)
    cb("sth")
end)
```

JS
```js
callNui('example', "test", (data) => console.log(data))
```

*What function will do:*
1. *FiveM will register callback with name `example`*
2. *ReactJS will send `test` to FiveM's callback with name `example`*
3. *FiveM will print `example` into console and send a callback with text `sth`*
4. *ReactJS will print into console response `sth`*

# Examples in code

In that template, I added some examples. Remove it when creating a new resource.

* `client/client.lua` - lines 1-3
* `web/assets/logo.png`
* `web/styles/app.css` (don't forget to also remove the import from `web/styles/main.css`)
* `web/react/App.jsx` - lines 13-14

# License
Apache 2.0