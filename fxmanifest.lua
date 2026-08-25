
--[[
--
--                       ________ __________      ________________ ________ ________                
--                       ___  __ \___  ____/_____ __  ____/__  __ \___  __ \___  __ \               
--        ________       __  /_/ /__  __/   ___(_)_  /     _  / / /__  /_/ /__  / / /       ________
--        _/_____/       _  _, _/ _  /___   ___   / /___   / /_/ / _  _, _/ _  /_/ /        _/_____/
--                       /_/ |_|  /_____/   _(_)  \____/   \____/  /_/ |_|  /_____/                 
--                                                                                                  
---]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version '0.3.0'
author 'Ⓒ RE:CORD | @Nazu'
description 'Ⓒ RE:CORD Utils'

dependencies {
    'REC_Library',
}

shared_script {
    '@ox_lib/init.lua',
    'config/sh_config.lua',
    'locales/*.lua',
    'shared/*.lua',
}

client_scripts {
    'client/modules/**/*.lua',
    'client/*.lua',
}

server_scripts {
    -- '@oxmysql/lib/MySQL.lua',
    'config/sv_config.lua',
    'server/modules/**/*.lua',
    'server/*.lua',
}
