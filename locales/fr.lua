local Translations = {
    afk = {
        will_kick = 'You are AFK and will be kicked in ',
        time_seconds = ' seconds!',
        time_minutes = ' minute(s)!',
        kick_message = 'You were kicked for being AFK',
    },
    wash = {
        in_progress = "Véhicule en cours de lavage ..",
        wash_vehicle = "[E] Laver le Véhicule",
        wash_vehicle_target = "Laver le Véhicule",
        dirty = "Le Véhicule n'est pas sale!",
        cancel = "Lavage annulé ..",
    },
    consumables = {
        eat_progress = "En train de manger..",
        drink_progress = "En train de boire..",
        liqour_progress = "En train de boire..",
        coke_progress = "Sniffer rapidement..",
        crack_progress = "Fume du crack..",
        ecstasy_progress = "Prend des cachets",
        healing_progress = "Se Soigne",
        meth_progress = "Fume de la bonne Meth",
        joint_progress = "Lighting joint..",
        use_parachute_progress = "Met un parachute..",
        pack_parachute_progress = "Range son parachute..",
        no_parachute = "Vous n'avez pas de parachute!",
        armor_full = "Vous avez déjà un gilet!",
        armor_empty = "Vous n'avez pas de gilet équipé..",
        armor_progress = "Met son gilet..",
        heavy_armor_progress = "Met son gilet lourd..",
        remove_armor_progress = "Enlève son gilet..",
        canceled = "Annulé..",
    },
    cruise = {
        unavailable = "Cruise control indisponible",
        activated = "Cruise ON: ",
        deactivated = "Cruise OFF",
    },
    editor = {
        started = "Started Recording!",
        save = "Saved Recording!",
        delete = "Deleted Recording!",
        editor = "Later aligator!"
    },
    firework = {
        place_progress = "Prépare le pétard..",
        canceled = "Annulé..",
        time_left = "Pétard s'active dans ~r~"
    },
    seatbelt = {
        use_harness_progress = "Met le Harnais de Course",
        remove_harness_progress = "Enlève le Harnais de Course",
        no_car = "Vous n'êtes pas dans une voiture."
    },
    teleport = {
        teleport_default = 'Utiliser Elevator'
    },
    pushcar = {
        stop_push = "[E] Arrêter de Pousser"
    }


}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
