<!-- IF YOU CAN READ THIS, OPEN THE FILE IN VISUAL STUDIO CODE AND PRESS CTRL+SHIFT+V, OR RIGHT CLICK THE FILE IN THE LEFT SIDEBAR AND CLICK "Open Preview" -->

# loaf_bankrobbery

Bank robbery script for ESX & QBCore. If you have a standalone framework, you can modify the framework/custom/client.lua and framework/custom/server.lua files to work with your framework. If you have any issues, join my [discord](https://discord.gg/4dUvf34) and create a bug report in the [#❌bug-reports](https://discord.com/channels/668570162609520653/1164708334931296276) channel.

## Requirements

-   OneSync infinity
-   [ox_lib](https://github.com/overextended/ox_lib/releases/latest/download/ox_lib.zip)

## Installation

-   Drag the resource to your `resources` folder
-   Make sure to have an IPL script that loads the bank interiors
-   Add `ensure loaf_bankrobbery` to your server.cfg
-   Make sure that you have all the items required for a bank robbery on your server. By default the items are:
    -   drill
    -   drill_bit
    -   thermite
    -   laptop
    -   usb_device

## Configuration

-   Check out the shared/config.lua file
-   To translate, edit shared/locales.lua

### Dispatch

By default the script supports a few popular dispatch scripts. These are:

-   qs-dispatch
-   ps-dispatch
-   cd_dispatch
    If you have one of these dispatch scripts, they should work automatically unless you have renamed them.

To add a custom dispatch script, go to server/functions.lua and modify the `AlertPolice(bankId)` function at line 12. Before the `else` statement, add `elseif GetResourceState("your-dispatch-script") == "started" then` and trigger the dispatch event inside the elseif statement.

### Hacking

The script supports a few popular hacking scripts.

To add your own thermite hacking script, go to client/functions.lua and modify the `ThermiteHack()` function at line 166.
To add your own keycard hacking script, go to client/functions.lua and modfiy the `KeycardHack()` function at line 197.

The ones supported for thermite are:

-   [ps-ui](https://forum.cfx.re/t/project-sloth-free-standalone-ps-ui/4873444)
-   [memorygame](https://github.com/pushkart2/memorygame)

The ones supported for hacking the keycard are:

-   [ps-ui](https://forum.cfx.re/t/project-sloth-free-standalone-ps-ui/4873444)
-   [ultra-voltlab](https://forum.cfx.re/t/release-voltlab-hacking-minigame-cayo-perico-mission/3933171)
-   [howdy-hackminigame](https://forum.cfx.re/t/free-howdys-hack-minigame/4814601)
-   [datacrack](https://forum.cfx.re/t/standalone-datacrack-hacking-mini-game/1066972)
-   [utk_fingerprint](https://forum.cfx.re/t/finger-print-hacking-mini-game-standalone/1185122)
-   [electus_hacking](https://forum.cfx.re/t/qb-esx-paid-electus-hacking-hacker-job-terminal-hack/4989175)

### Adding a bank

The script comes with a built in tool to easily add banks.

1. Set `Config.EnableCreator` to true in shared/config.lua
2. Restart the resource

Commands:

-   /bankrobberydraw - toggles drawing of nearby bank objects
-   /bankrobberyplace [depositbox/trolley/cash/gold/security] - spawns an object that you can move around to find coordinates for loot/hacking/drilling spots
