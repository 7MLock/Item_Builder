fx_version 'adamant'
game 'gta5'

lua54 'yes'

shared_scripts "config.lua"

client_scripts {
    "src_/RMenu.lua",
    "src_/menu/RageUI.lua",
    "src_/menu/Menu.lua",
    "src_/menu/MenuController.lua",
    "src_/components/*.lua",
    "src_/menu/elements/*.lua",
    "src_/menu/items/*.lua",
    "src_/menu/panels/*.lua",
    "src_/menu/windows/*.lua",

    "client/*.lua",
    "config.lua",
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "server/*.lua",
    "config.lua",
}


author {'Autheur du script: h4ci', 'Remake by: !Therapyst#9268'}

discord 'https://discord.gg/sml'

github 'https://github.com/7MLock/Item_Builder-V2'
