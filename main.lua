require("src.constants")
require("src.entities")
require("src.menu")

function love.load()
    menuloadbuttons()
    collidableTile = {}

    actGameState = gameState.MENU
    --tiles = {}
    tiles = loadTiles()
    map = {}
    map_w = 20
    map_h = 15
    map_offset_x = 0
    map_offset_y = 0
    map_display_w = 20
    map_display_h = 15
    tile_w = 32
    tile_h = 32
    enemies = loadEnemies(5, map_offset_x, 0)
    arenaWidth = map_display_w * tile_w
    arenaHeight = map_display_h * tile_h

    loadMap()
    --[[for i=1, #map do
        for j=1, #map[i] do
            io.write(map[i][j] .. " ")
        end
        print()
    end--]]
end

function love.draw()
    love.graphics.reset()
    if (isGamePaused(actGameState)) then
        drawbuttonsmenuplay()
        drawbuttonsmenuquit()

        drawup()
        drawcorfundo()
    else
        love.graphics.reset()
        draw_map()
        love.graphics.setColor({255, 255, 255})
        love.graphics.circle("fill", player.xPos, player.yPos, player.width / 2)
        for i = 1, #enemies do
            love.graphics.setColor(enemies[i].color[1], enemies[i].color[2], enemies[i].color[3])
            love.graphics.circle("fill", enemies[i].xPos, enemies[i].yPos, enemies[i].width / 2)
        end
    end
end

function love.update(dt)
    if (isGamePaused(actGameState)) then
    else
        moveEntity(player, dt)
        for i = 1, #enemies do
            moveEntity(enemies[i], dt)
            if isEntitiesColliding(player,enemies[i]) then
                love.load()
            end
        end
    end

end

function changePreviosDirection(entity) --FUNÇÃO PARA ATRIBUIR A DIREÇÃO ATUAL À DIREÇÃO ANTIGA DE UMA ENTIDADE
    entity.previousDirection = entity.direction
end

function loadTiles() --FUNÇÃO PARA PEGAR OS ARQUIVOS DE FUNDO DO MAPA E RETORNAR-LOS COMO ARRAY
    local tiles = {}
    for i = 1, 3 do
        table.insert(tiles, love.graphics.newImage("assets/background" .. i .. ".png"))
    end
    for i = 1, 4 do
        table.insert(tiles, love.graphics.newImage("assets/wall" .. i .. ".png"))
    end

    return tiles
end

function loadEnemies(enemyNumbers, offsetX, offsetY)
    local enemy = {}
    for i = 1, enemyNumbers do
        enemy[i] = generateEnemy(offsetX + (i * 70), 60 + offsetY)
    end
    return enemy
end

function checkCollision(entity, wall)
    local function isEntitysRightColliding(wall)
        return (entity.xPos + (entity.width) / 2 >= wall.xPos) --REMOVER DIVISÃO POR DOIS SE FOR IMAGEM
    end
    local function isEntitysLeftColliding(wall)
        return (entity.xPos - (entity.width) / 2 <= wall.xPos + wall.width) --REMOVER SUBTRAÇÃO SE FOR IMAGEM
    end
    local function isEntitysDownColliding(wall)
        return (entity.yPos + (entity.height) / 2 >= wall.yPos)
    end 
    local function isEntitysUpColliding(wall)
        return (entity.yPos - (entity.height) / 2 <= wall.yPos + wall.height)
    end
    local function isEntityInVerticalBounds(wall)
        return ((entity.yPos + (entity.height) / 2 >= wall.yPos) and
            ((entity.yPos - (entity.height) / 2) <= wall.yPos + wall.height))
    end
    local function isEntityInHorizontalBounds(wall)
        return ((entity.xPos + (entity.height) / 2 >= wall.xPos) and
            ((entity.xPos - (entity.height) / 2) <= wall.xPos + wall.width))
    end
    --print(tostring(isEntitysRightColliding(wall)) .. " " .. tostring(isEntitysLeftColliding(wall)))
    return ((isEntitysRightColliding(wall) and isEntitysLeftColliding(wall) and isEntityInVerticalBounds(wall)) or
        (isEntitysDownColliding(wall) and isEntitysUpColliding(wall) and isEntityInHorizontalBounds(wall)))
end

function loadMap()
    for i = 1, map_w do
        map[i] = {}
        for j = 1, map_h do
            if (i ~= 1 and j ~= 1 and i ~= map_w and j ~= map_h) then
               if i==2 then
                    if j==6 or j==9 then
                        map[i][j]=love.math.random(4,7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==3 then
                    if j==3 or j==2 or j>=5 and j<=7 or j==9 or j==13 then
                        map[i][j]=love.math.random(4,7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==4 then
                    if j==3 or j==7 or j==9 or j==13 then
                        map[i][j]=love.math.random(4,7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==5 then
                    if j==7 or j==13 then
                        map[i][j]=love.math.random(4,7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )

                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==6 then
                    if j==7 or j>=11 and j<=13 then
                        map[i][j]=love.math.random(4,7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==7 then
                    if j==3 or j==4 or j==6 or j==7 or j==4 then
                        map[i][j] = love.math.random(4, 7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==8 then
                    if j==7 or j>=11 and j<=13 then
                        map[i][j] = love.math.random(4, 7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==9 then
                    if j>=2 and j<=5 or j==7 or j==13 then
                        map[i][j] = love.math.random(4, 7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==10 then
                    if j>=7 and j<=9 or j>=13 then
                        map[i][j] = love.math.random(4, 7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==11 then
                    if j<=4 then
                        map[i][j] = love.math.random(4, 7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==12 then
                    if j>=4 and j<=13 then
                        map[i][j] = love.math.random(4, 7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==13 then
                    if j==9 or j==13 then
                        map[i][j] = love.math.random(4, 7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==14 then
                    if j==4 or j>=9 and j<=11 then
                        map[i][j] = love.math.random(4, 7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==15 then
                    if j==7 or j==11 then
                        map[i][j] = love.math.random(4, 7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==16 then
                    if j>=3 and j<=5 or j==7 or j==9 or j==11 then
                        map[i][j] = love.math.random(4, 7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==17 then
                    if j==9 or j==11 then
                        map[i][j] = love.math.random(4, 7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==18 then
                    if j==3 or j==4 or j==9 or j>=11 and j<=13 then
                        map[i][j] = love.math.random(4, 7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                elseif i==19 then
                    if j==5 then
                        map[i][j] = love.math.random(4, 7)
                        table.insert(
                            collidableTile,
                            {
                                xPos = (i - 1) * tile_w + map_offset_x,
                                yPos = (j - 1) * tile_h + map_offset_y,
                                width = tile_w,
                                height = tile_h
                            }
                        )
                    else
                        map[i][j]=love.math.random(3)
                    end
                else
                    map[i][j] = love.math.random(3)
                end

            else
                map[i][j] = love.math.random(4, 7)
                table.insert(
                    collidableTile,
                    {
                        xPos = (i - 1) * tile_w + map_offset_x,
                        yPos = (j - 1) * tile_h + map_offset_y,
                        width = tile_w,
                        height = tile_h
                    }
                )
            end
        end
    end
    for i=1,#map do
        for j=1,#map[i] do
            io.write(map[i][j]..' ')
        end
        print()
    end
end

function draw_map()
    for y = 1, (map_display_h) do
        for x = 1, (map_display_w) do
            love.graphics.draw(tiles[map[x][y]], ((x - 1) * tile_w) + map_offset_x, ((y - 1) * tile_h) + map_offset_y)
        end
    end
end

function toggleGameState()
    if isGamePaused(actGameState) then
        actGameState = gameState.PLAYING
    else
        actGameState = gameState.MENU
    end
end
function love.mousepressed(x, y, button, istouch)
    action = getMouseAction(button)
    if action ~= false then
        toggleGameState()
    end
    if action == "quit" then
        love.event.quit()
    end
end
function love.keypressed(key, unicode)
    if (key == "escape") then
        toggleGameState()
    end
    if (key == "w" or key == "up") then
        if player.direction ~= directions.UP then
            changePreviosDirection(player)
            player.direction = directions.UP
        end
    end
    if (key == "a" or key == "left") then
        if player.direction ~= directions.LEFT then
            changePreviosDirection(player)
            player.direction = directions.LEFT
        end
    end
    if (key == "d" or key == "right") then
        if player.direction ~= directions.RIGHT then
            changePreviosDirection(player)
            player.direction = directions.RIGHT
        end
    end
    if (key == "s" or key == "down") then
        if player.direction ~= directions.DOWN then
            changePreviosDirection(player)
            player.direction = directions.DOWN
        end
    end
end

function checkEntityCollision(entity)
    for i = 1, #collidableTile do
        temp = checkCollision(entity, collidableTile[i])
        if (temp) then
            return true
        end
    end
    return false
end

function isDirectionOposite(directionA, directionB)
    return (directionA + directionB == 3 or directionA + directionB == 7)
end

function moveEntityPrevious(entity, dt)
    if (not isDirectionOposite(entity.direction, entity.previousDirection)) then
        if (entity.previousDirection == directions.UP) then
            entity.yPos = entity.yPos - (dt * entity.velocity)
            if checkEntityCollision(entity) then
                entity.yPos = entity.yPos + (dt * entity.velocity)
            end
        end
        if (entity.previousDirection == directions.DOWN) then
            entity.yPos = entity.yPos + (dt * entity.velocity)
            if checkEntityCollision(entity) then
                entity.yPos = entity.yPos - (dt * entity.velocity)
            end
        end
        if (entity.previousDirection == directions.RIGHT) then
            entity.xPos = entity.xPos + (dt * entity.velocity)
            if checkEntityCollision(entity) then
                entity.xPos = entity.xPos - (dt * entity.velocity)
            end
        end
        if (entity.previousDirection == directions.LEFT) then
            entity.xPos = entity.xPos - (dt * entity.velocity)
            if checkEntityCollision(entity) then
                entity.xPos = entity.xPos + (dt * entity.velocity)
            end
        end
    end
    if isEnemy(entity) then
        entity.direction = love.math.random(1, 4)
    end
end


function moveEntity(entity, dt)
    if (entity.direction == directions.UP) then
        entity.yPos = entity.yPos - (dt * entity.velocity)
        if checkEntityCollision(entity) then
            entity.yPos = entity.yPos + (dt * entity.velocity)
            moveEntityPrevious(entity, dt)
        end
    end
    if (entity.direction == directions.DOWN) then
        entity.yPos = entity.yPos + (dt * entity.velocity)
        if checkEntityCollision(entity) then
            entity.yPos = entity.yPos - (dt * entity.velocity)
            moveEntityPrevious(entity, dt)
        end
    end
    if (entity.direction == directions.RIGHT) then
        entity.xPos = entity.xPos + (dt * entity.velocity)
        if checkEntityCollision(entity) then
            entity.xPos = entity.xPos - (dt * entity.velocity)
            moveEntityPrevious(entity, dt)
        end
    end
    if (entity.direction == directions.LEFT) then
        entity.xPos = entity.xPos - (dt * entity.velocity)
        if checkEntityCollision(entity) then
            entity.xPos = entity.xPos + (dt * entity.velocity)
            moveEntityPrevious(entity, dt)
        end
    end
    if isEnemy(entity) then
        randomMovement = love.math.random()
        if (randomMovement < 0.01) then
            entity.direction = love.math.random(1, 4)
        end
    end
end
function isEntitiesColliding(entity1,entity2)
    local x1,y1 = entity1.xPos,entity1.yPos
    local x2,y2 = entity2.xPos,entity2.yPos
    local raid1,raid2 = ((entity1.width)/2),((entity2.width)/2)
    local distance = math.sqrt(((x2-x1)^2)+((y2-y1)^2))
    if distance<=raid1+raid2 then
        return true
    else
        return false
    end
end
