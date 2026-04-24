local QBCore = exports['qb-core']:GetCoreObject()

local function IsBoss(Player)
    local job = Player.PlayerData.job
    local jobName = job.name
    local grade = job.grade.level

    if Config.BossGrades[jobName] and grade >= Config.BossGrades[jobName] then
        return true
    end

    return job.isboss == true
end

QBCore.Functions.CreateCallback('qb-banking:getPersonalBalance', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(0) end
    cb(Player.PlayerData.money['bank'] or 0)
end)

QBCore.Functions.CreateCallback('qb-banking:getJointAccounts', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end

    MySQL.query('SELECT ja.id, ja.account_name, ja.balance FROM joint_accounts ja JOIN joint_account_members jam ON ja.id = jam.account_id WHERE jam.citizenid = ?', {
        Player.PlayerData.citizenid
    }, function(result)
        cb(result or {})
    end)
end)

RegisterNetEvent('qb-banking:jointDeposit', function(accountId, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if Player.Functions.RemoveMoney('bank', amount) then
        MySQL.update('UPDATE joint_accounts SET balance = balance + ? WHERE id = ?', { amount, accountId })
        TriggerClientEvent('QBCore:Notify', src, 'Deposited £'..amount, 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Not enough bank balance', 'error')
    end
end)

RegisterNetEvent('qb-banking:jointWithdraw', function(accountId, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    MySQL.query('SELECT ja.balance FROM joint_accounts ja JOIN joint_account_members jam ON ja.id = jam.account_id WHERE ja.id = ? AND jam.citizenid = ?', {
        accountId, Player.PlayerData.citizenid
    }, function(result)
        if not result or not result[1] then
            return TriggerClientEvent('QBCore:Notify', src, 'Not a member', 'error')
        end

        if result[1].balance < amount then
            return TriggerClientEvent('QBCore:Notify', src, 'Insufficient funds', 'error')
        end

        MySQL.update('UPDATE joint_accounts SET balance = balance - ? WHERE id = ?', { amount, accountId })
        Player.Functions.AddMoney('bank', amount)
        TriggerClientEvent('QBCore:Notify', src, 'Withdrew £'..amount, 'success')
    end)
end)

QBCore.Functions.CreateCallback('qb-banking:getSocietyAccount', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(nil) end

    local job = Player.PlayerData.job.name
    if not Config.SocietyJobs[job] then return cb(nil) end

    MySQL.query('SELECT balance FROM society_accounts WHERE job = ?', { job }, function(result)
        if result and result[1] then
            cb({ job = job, balance = result[1].balance })
        else
            MySQL.insert('INSERT INTO society_accounts (job, balance) VALUES (?, 0)', { job })
            cb({ job = job, balance = 0 })
        end
    end)
end)

RegisterNetEvent('qb-banking:societyDeposit', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local job = Player.PlayerData.job.name
    if not Config.SocietyJobs[job] then
        return TriggerClientEvent('QBCore:Notify', src, 'No society account', 'error')
    end

    if Player.Functions.RemoveMoney('bank', amount) then
        MySQL.update('UPDATE society_accounts SET balance = balance + ? WHERE job = ?', { amount, job })
        TriggerClientEvent('QBCore:Notify', src, 'Deposited £'..amount, 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Not enough bank balance', 'error')
    end
end)

RegisterNetEvent('qb-banking:societyWithdraw', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if not IsBoss(Player) then
        return TriggerClientEvent('QBCore:Notify', src, 'Only bosses can withdraw', 'error')
    end

    local job = Player.PlayerData.job.name
    if not Config.SocietyJobs[job] then
        return TriggerClientEvent('QBCore:Notify', src, 'No society account', 'error')
    end

    MySQL.query('SELECT balance FROM society_accounts WHERE job = ?', { job }, function(result)
        if not result or not result[1] then
            return TriggerClientEvent('QBCore:Notify', src, 'Account missing', 'error')
        end

        if result[1].balance < amount then
            return TriggerClientEvent('QBCore:Notify', src, 'Insufficient funds', 'error')
        end

        MySQL.update('UPDATE society_accounts SET balance = balance - ? WHERE job = ?', { amount, job })
        Player.Functions.AddMoney('bank', amount)
        TriggerClientEvent('QBCore:Notify', src, 'Withdrew £'..amount, 'success')
    end)
end)
