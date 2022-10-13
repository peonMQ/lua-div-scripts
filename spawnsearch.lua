

local mq = require('mq')
local spawnSearch = 'npc radius 50'
for i = 1, mq.TLO.SpawnCount(spawnSearch)() do
    local spawn = mq.TLO.NearestSpawn(i,spawnSearch)
    print(string.format('%s [%d - %s] - %s', spawn.CleanName(), spawn.Level(), spawn.Class(), spawn.Distance()))
end

local function getSpawnDataForFilter(filter, limit)
    local spawnCollection = {}

    local i = 1
    while mq.TLO.NearestSpawn(i, filter)() and i <= limit do
        table.insert(spawnCollection, mq.TLO.NearestSpawn(i, filter))
        i = i + 1
    end

    return spawnCollection
end

local playerSpawns = getSpawnDataForFilter("pc")
local namedSpawns = getSpawnDataForFilter("npc named")



local spawnSearch = 'npc targetable radius 250'
local spawnTable = {}

local function findSpawn()
    for i = 1, mq.TLO.SpawnCount(spawnSearch)() do
        local spawn = mq.TLO.NearestSpawn(i, spawnSearch)
        local nav = mq.TLO.Navigation
        table.insert(spawnTable, {
                        ID         = spawn.ID(),
                        PathLength = nav.PathLength('id ' .. spawn.ID())()
                    })
    end
end

findSpawn()

for aa, ab in pairs(spawnTable) do 
    print(aa.. ' - ID: ' .. ab['ID'] .. ' - PathLength: ' .. ab['PathLength'])
end



local spawnSearch = 'npc targetable radius 250'
local spawnTable = {}

local function findSpawn()
    for i = 1, mq.TLO.SpawnCount(spawnSearch)() do
        local spawn = mq.TLO.NearestSpawn(i, spawnSearch)
        local nav = mq.TLO.Navigation
        table.insert(spawnTable, 
            {
                ID         = spawn.ID(),
                PathLength = nav.PathLength('id ' .. spawn.ID())()
            })
    end
    table.sort(spawnTable, function(a, b) return a['PathLength'] < b['PathLength'] end)
end

findSpawn()

for spawnNr, spawn in ipairs(spawnTable) do 
    print(string.format('%d - \ag%s \ax- ID: \at%d \ax- PathLength: \at%.2f', spawnNr, mq.TLO.Spawn('id '..spawn.ID).CleanName(), spawn.ID, spawn.PathLength))
end