Config = {}
Config.Interior = vector3(-812.76, 178.95, 76.74) -- Interior to load where characters are previewed
Config.DefaultSpawn = vector3(432.54, -627.01, 28.71) -- Default spawn coords if you have start apartments disabled
Config.PedCoords = vector4(-811.68, 175.19, 76.75, 109.95)-- Create preview ped at these coordinates
Config.HiddenCoords = vector4(-812.76, 178.95, 76.74, 337.16) -- Hides your actual ped while you are in selection
Config.CamCoords = vector4(-813.97, 174.25, 76.74, 293.37) -- Camera coordinates for character preview screen
Config.EnableDeleteButton = true -- Define if the player can delete the character or not
Config.SkipSelection = false -- Skip the spawn selection and spawns the player at the last location
Config.Mysql = "oxmysql" -- | ghmattimysql / oxmysql / mysql-asyn
Config.StarterItems = {
    {item = "kurkakola", amount = 1},
    {item = "tosti", amount = 1},
    {item = "phone", amount = 1},
}

Config.DefaultNumberOfCharacters = 1 
Config.PlayersNumberOfCharacters = {
    { steam   = "steam:110000134edaeef", numberOfChars = 2 },
    { license = "license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", numberOfChars = 1 },
    { discord = "discord:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", numberOfChars = 1 },
}