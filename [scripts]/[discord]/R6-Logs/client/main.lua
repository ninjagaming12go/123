lib.callback.register('R6-Logs:client:GetScreenshot', function(webhook)
    if not webhook then return end

    local function tryUpload(fieldName)
        local uploaded = false
        local image
        local timeout = 0
        local maxTimeout = 100

        exports['screenshot-basic']:requestScreenshotUpload(webhook, fieldName, { encoding = 'webp', quality = 80 }, function(data)
            if not data or data == '' then
                print(string.format("[R6-Logs] Empty response from Discord webhook (field=%s). Check webhook URL & permissions.", tostring(fieldName)))
                uploaded = true
                return
            end

            local success, result = pcall(function()
                local decoded = json.decode(data)
                if decoded and decoded.message then
                    print(string.format("[R6-Logs] Discord webhook error: %s (field=%s)", tostring(decoded.message), tostring(fieldName)))
                    return nil
                end
                return decoded and decoded.attachments and decoded.attachments[1] and decoded.attachments[1].url
            end)

            if success and result then
                image = result
                uploaded = true
            else
                print(string.format("[R6-Logs] Failed to decode screenshot response (field=%s). Raw: %s", tostring(fieldName), tostring(data)))
                uploaded = true
            end
        end)

        while not uploaded and timeout < maxTimeout do
            Wait(500)
            timeout = timeout + 1
        end

        if timeout >= maxTimeout then
            print("[R6-Logs] Screenshot upload timed out after 50 seconds ("..tostring(fieldName)..")")
            return nil
        end

        return image
    end

    local image = tryUpload('files[]')
    if not image then
        image = tryUpload('file')
    end

    return image
end)

lib.callback.register('DiscordLogs:Client:CB:Ping', function()
    return true
end)