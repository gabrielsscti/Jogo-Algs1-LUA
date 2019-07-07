require("src.constants")
require("src.entities")
require("src.menu")
require("src.map")

function love.load()
    menuloadbuttons()
--    loadMenuSE()
    musicmenu=love.audio.newSource('music/musicMenu.mp3','stream')
    musicplaying=love.audio.newSource('music/musicPlaying.mp3','stream')
    musicgameover=love.audio.newSource('music/musicGameOver.mp3','stream')
    musicvictory=love.audio.newSource('music/musicVictory.mp3','stream')
    gameover = 0
    gameover = loadGameOver()
    victory = 0
    victory = loadVictory()
    collidableTile = {}
    candy=love.graphics.newImage('assets/candy.png')
    playerim=love.graphics.newImage('assets/playerim.png')
    actGameState = gameState.MENU
    tiles = {}
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
    for i=1, #map do
        for j=1, #map[i] do
            io.write(map[i][j] .. " ")
        end
        print()
    end
end

function love.draw()
    love.graphics.reset()
    if (isGamePaused(actGameState)) then
        musicgameover:stop()
        musicvictory:stop()
        musicmenu:play()
        musicmenu:setLooping(true)
        drawbuttonsmenuplay()
        drawbuttonsmenuquit()
        drawup()
        drawcorfundo()
    elseif actGameState==gameState.PLAYING then
        love.graphics.reset()
        musicmenu:stop()
        musicplaying:play()
        musicplaying:setLooping(true)
        draw_map()
        love.graphics.setColor({255, 255, 255})
        love.graphics.draw(playerim, player.xPos-12, player.yPos-12)
--        love.graphics.circle("line", player.xPos, player.yPos, player.width / 2)
        love.graphics.draw(candy,580,45)
        for i = 1, #enemies do
--            love.graphics.setColor(enemies[i].color[1], enemies[i].color[2], enemies[i].color[3])
--            love.graphics.circle("fill", enemies[i].xPos, enemies[i].yPos, enemies[i].width / 2)
              love.graphics.draw(enemies[i].color,enemies[i].xPos-12,enemies[i].yPos-12)
        end
    elseif actGameState==gameState.GAMEOVER then
        love.graphics.draw(gameover,0,0)
        musicplaying:stop()
        musicgameover:play()
        musicgameover:setLooping(true)
    elseif actGameState==gameState.VICTORY then
        musicplaying:stop()
        musicvictory:play()
        musicvictory:setLooping(true)
        love.graphics.draw(victory,0,0)
    end

end

function love.update(dt)
    if actGameState==gameState.MENU then
    else
        moveEntity(player, dt)
        for i = 1, #enemies do
            moveEntity(enemies[i], dt)
            if isEntitiesColliding(player,enemies[i]) then
                actGameState=gameState.GAMEOVER
                player.xPos = 50
                player.yPos = 50
                for i=1,#enemies do
                    enemies[i].xPos=448
                    enemies[i].yPos=160
                end
            end
        end
        if isEntitiesColliding(candyi,player) then
            actGameState=gameState.VICTORY
            player.velocity=0
            for i=1,#enemies do
                enemies[i].velocity=0
            end
        end
    end

end

function changePreviosDirection(entity) --FUNÇÃO PARA ATRIBUIR A DIREÇÃO ATUAL À DIREÇÃO ANTIGA DE UMA ENTIDADE
    entity.previousDirection = entity.direction
end



function loadEnemies(enemyNumbers, offsetX, offsetY)
    local enemy = {}
    for i = 1, enemyNumbers do
        enemy[i] = generateEnemy(offsetX + 448, 160 + offsetY)
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
