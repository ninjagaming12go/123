# R6 Logs - Complete Documentation

A unified logging system for FiveM servers with Discord webhook integration, screenshot support, and framework detection (QBX, QB-Core, ESX).

---

## 📋 Table of Contents
1. [How It Works](#how-it-works)
2. [Configuration](#configuration)
3. [Webhook Categories](#webhook-categories)
4. [Usage Examples](#usage-examples)
5. [Advanced Features](#advanced-features)

---

## 🔧 How It Works

### System Architecture

The logging system consists of:
1. **Webhook Configuration** - Discord webhook URLs mapped to categories
2. **Color Mapping** - 24 predefined colors for different log types
3. **Framework Detection** - Auto-detects QBX, QB-Core, or ESX
4. **Screenshot Integration** - Takes screenshots using `screenshot-basic`
5. **Export Function** - `CreateLog` callable from any resource

---

## ⚙️ Configuration

### 1. Webhooks Table

```lua
Webhooks = {
    ["default"] = "YOUR_WEBHOOK_URL",
    ["screenshots"] = "YOUR_SCREENSHOT_WEBHOOK_URL",
    ["join/leave"] = "",
    ["resources"] = "",
    ["explosions"] = "",
    ["chat"] = "",
    ["admin"] = "",
    ["money"] = "",
    ["death"] = "",
    -- Add your own categories here
}
```

**How Categories Work:**
- When you call `CreateLog` with `category = "chat"`, the system looks for `Webhooks["chat"]`
- If the category exists → sends to that webhook
- If the category is empty or missing → sends to `Webhooks["default"]`
- **Important:** The `category` name in your log must match the key in `Webhooks` table

**Example:**
```lua
-- In your script
exports['R6-Logs']:CreateLog({
    category = 'money',  -- ← This must match Webhooks["money"]
    title = 'Money Logs',
    -- ...
})
```

---

### 2. Colors

Available colors (used with `color` field):

| Color | Hex Code | Use Case |
|-------|----------|----------|
| `green` | #57F287 | Success, Join |
| `red` | #ED4245 | Error, Death |
| `orange` | #E67E22 | Admin, Warning |
| `blue` | #3498DB | Info, General |
| `grey` | #95A5A6 | Chat, Neutral |
| `darkred` | #992D22 | Critical, Cheat |
| `gold` | #F1C40F | VIP, Important |
| `purple` | #9B59B6 | Special Events |

Full list includes 24 colors (check the `colors` table in code).

---

## 📂 Webhook Categories

### Understanding Categories

**Category** = The name you use to route logs to specific Discord webhooks.

**Setup Process:**
1. Create a webhook in Discord (Server Settings → Integrations → Webhooks)
2. Copy the webhook URL
3. Add it to `Webhooks` table with a unique name
4. Use that name in `category` when logging

**Example Setup:**
```lua
-- In server/main.lua
Webhooks = {
    ["default"] = "https://discord.com/api/webhooks/...",
    ["admin"] = "https://discord.com/api/webhooks/...",  -- Admin actions webhook
}

-- In your script
exports['R6-Logs']:CreateLog({
    category = 'admin',  -- Goes to admin webhook
    -- ...
})
```

**Recommended Categories:**
- `join/leave` - Player connections
- `chat` - Chat messages
- `admin` - Admin commands (kick, ban, teleport)
- `money` - Transactions, payments
- `death` - Player deaths
- `explosions` - Explosion events
- `resources` - Resource start/stop
- `rcon` - RCON commands
- `custom` - Your custom logs

---

## 🧱 CreateLog Structure

```lua
exports['R6-Logs']:CreateLog({
    category = "string",      -- REQUIRED: Webhook category (must match Webhooks table key)
    title = "string",         -- REQUIRED: Log title
    action = "string",        -- OPTIONAL: Action description (appended to title)
    color = "string",         -- OPTIONAL: Color name (default: "default")

    players = {               -- OPTIONAL: Player(s) involved
        { id = source, role = "Role Name" }
    },

    info = {                  -- OPTIONAL: Main information fields
        { name = "Key", value = "Value" }
    },

    extra = {                 -- OPTIONAL: Additional organized sections
        {
            title = "Section Title",
            data = {
                { name = "Key", value = "Value" }
            }
        }
    },

    takeScreenshot = false,   -- OPTIONAL: Take screenshot (requires screenshot-basic)
    screenshotTargetId = nil  -- OPTIONAL: Specific player to screenshot (defaults to first player)
})
```

---

## 🧩 Usage Examples

### Example 1: Simple Chat Log
```lua
AddEventHandler('chatMessage', function(src, author, message)
    exports['R6-Logs']:CreateLog({
        category = 'chat',           -- ← Must exist in Webhooks table
        title = 'Chat Logs',
        action = 'Message Sent',
        color = 'grey',
        players = {
            { id = src, role = 'Sender' }
        },
        info = {
            { name = 'Message', value = message }
        }
    })
end)
```

**What happens:**
1. Checks `Webhooks["chat"]`
2. If exists → sends to that webhook
3. If not → sends to `Webhooks["default"]`

---

## 🚀 Advanced Features

### 1. Framework Detection

The system automatically detects and extracts player data from:
- **QBX Core** (`qbx_core`)
- **QB-Core** (`qb-core`)
- **ESX** (`es_extended`, `esx_core`, `esx_legacy`)

**Extracted Data:**
- Character Name (First + Last)
- Citizen ID / Identifier
- Steam ID
- License / License2
- Discord ID

---

### 2. Screenshot System

**Requirements:**
- Resource: `screenshot-basic`
- Config: `Config.Logs.UseScreenShot = true`
- Webhook: `Webhooks["screenshots"]` must be set

**How it works:**
1. Client-side callback attempts first
2. If fails → Server-side fallback (exports method)
3. Screenshot uploaded to `screenshots` webhook
4. Image URL embedded in log

**Usage:**
```lua
takeScreenshot = true,
screenshotTargetId = playerId  -- Optional: specific player
```

---

### 3. Extra Sections

Organize complex logs with multiple sections:

```lua
extra = {
    {
        title = "Player Stats",
        data = {
            { name = "Level", value = "50" },
            { name = "Money", value = "$100,000" }
        }
    },
    {
        title = "Server Info",
        data = {
            { name = "Players Online", value = "32/64" },
            { name = "Uptime", value = "5 hours" }
        }
    }
}
```

---

## 🛡️ Error Handling

The system includes built-in error checking:

1. **Missing Category:**
   - Prints error: `"Category is missing"`
   - Uses `default` webhook

2. **Category Not in Webhooks:**
   - Prints warning: `"Category webhook doesn't exist"`
   - Falls back to `default` webhook

3. **Missing Title:**
   - Prints error: `"Title is missing"`
   - Log not sent

4. **Screenshot Failures:**
   - Tries client callback
   - Falls back to server-side
   - Prints debug messages if fails

---

## 💡 Best Practices

1. **Create Separate Webhooks** for each category (easier to manage)
2. **Use Clear Category Names** (lowercase, no spaces)
3. **Match Category Names** exactly in Webhooks table
4. **Don't Overuse Screenshots** (Discord rate limits)
5. **Use Colors Consistently** (red = errors, green = success, etc.)
6. **Test Webhooks** before production
7. **Add Custom Categories** as needed

---

## 📝 Quick Reference

```lua
exports['R6-Logs']:CreateLog({
    category = 'admin',
    title = 'Admin Logs',
    action = 'Ban Player',
    color = 'darkred',
    players = {
        { id = adminId, role = 'Admin' },
        { id = targetId, role = 'Banned Player' }
    },
    info = {
        { name = 'Reason', value = 'Cheating' },
        { name = 'Duration', value = 'Permanent' }
    },
    extra = {
        {
            title = 'Evidence',
            data = {
                { name = 'Reports', value = '5' },
                { name = 'Proof', value = 'Screenshot attached' }
            }
        }
    },
    takeScreenshot = true
})
```

---

**Remember:** The `category` field is the bridge between your log and the Discord webhook. Always ensure the category name exists in the `Webhooks` table!
