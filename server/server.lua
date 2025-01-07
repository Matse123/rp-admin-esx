function syncUsers()
    MySQL.query('SELECT id AS user_id, identifier, firstname, lastname, job, job_grade FROM users', {}, function(users)
        if #users == 0 then
            print("[RP-Admin Sync] Keine Spielerdaten zur Synchronisierung gefunden.")
            return
        end

        print("[RP-Admin Sync] Sende Daten an API.")
        PerformHttpRequest("https://tnynpbxxfqckchzzzjhx.supabase.co/functions/v1/esx-player-sync", function(statusCode, resultData, resultHeaders, errorData)
            if statusCode == 200 then
                print("[RP-Admin Sync] Status: 200;  Synchronisation erfolgreich durchgeführt.")
            else
                print(("[RP-Admin Sync] Synchronisation fehlgeschlagen: %d - %s"):format(statusCode, errorData or "Unbekannter Fehler"))
            end
        end, "POST", json.encode({ users = users }), { ["Content-Type"] = "application/json", ["Authorization"] = "Bearer " .. Config.Token })
    end)
end

-- Sync your Users with RP-Admin
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.Interval)
        syncUsers()
    end
end)


AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        print("[RP-Admin Sync] Ressource gestartet, initiale Synchronisation wird durchgeführt.")
        syncUsers()
    end
end)
