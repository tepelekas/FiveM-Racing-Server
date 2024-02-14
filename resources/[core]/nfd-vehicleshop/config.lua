NFD = exports['nfd-core']:getCoreObject()

Config = {
    Vehicles = NFD.Shared.Functions.GetConfig().Vehicles, -- Automatically takes the `Vechicles` table from the core config file
    SpawnCoords = vec(946.9545, -2993.1528, -47.8751, 179.4071)
}