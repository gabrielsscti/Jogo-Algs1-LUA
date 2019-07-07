require("src.constants")
require("src.entities")
require("src.menu")
require("src.map")

function love.load()
    menuloadbuttons() --carrega as imagens dos botões do menu
    loadMusics()    --carregaos arquivos de áudio do jogo
    gameover = 0
    gameover = loadGameOver() -- carrega a tela de game over em caso de colisão de player com enemy
    victory = 0
    victory = loadVictory() -- carrega a tela de vitória em caso de colisão do player com o objetivo(candy)
    collidableTile = {}
    candy=love.graphics.newImage('assets/candy.png') -- carrega a imagem do "candy", objetivo do jogo
    playerim=love.graphics.newImage('assets/playerim.png') -- carrega a imagem do player
    actGameState = gameState.MENU -- estado atual do jogo, inicialmente MENU
    tiles = {}
    tiles = loadTiles() -- carrega as imagens das paredes e do chão 
    map = {} -- vetor gerado para matriz do mapa
    map_w = 20 -- quantidade de blocos na largura do mapa
    map_h = 15 -- quantidade de blocos na altura do mapa 
    map_offset_x = 0 --coordenada X de onde o mapa inicia
    map_offset_y = 0 -- coordenada Y de onde o mapa inicia
    map_display_w = 20 -- tamanho da tela do mapa, em blocos, largura
    map_display_h = 15 -- tamanho da tela do mapa, em blocos, altura
    tile_w = 32 --tamanho dos blocos em pixel
    tile_h = 32 --tamanho dos blocos em pixel
    enemies = loadEnemies(5, map_offset_x, 0) -- carrega as imagens dos inimigos de acordo com a quantidade e posição
    arenaWidth = map_display_w * tile_w -- tamanho do mapa em pixels, largura
    arenaHeight = map_display_h * tile_h -- tamanho do mapa em pixels, altura
    loadMap() -- carrega o mapa com elementos colisivos (checar o arquivo "map.lua")
    for i=1, #map do -- mostra na tela o mapa como uma matriz 
            for j=1, #map[i] do
            io.write(map[i][j] .. " ")
        end
        print()
    end              ---(para checar de fato: abrir arquivo "conf.lua", mudar a variavel t.console para "true")
end

function love.draw()
    love.graphics.reset()
    if (isGamePaused(actGameState)) then -- checa se o jogo está em tela de menu (verificar arquivo "constants.lua")
        musicgameover:stop() -- para a musica da tela de fim de jogo
        musicvictory:stop() -- para a musica da tela de conclusão do jogo
        musicmenu:play() -- começa a tocar a musica da tela de menu
        musicmenu:setLooping(true) -- faz com que a musica da tela de menu se repita assim que acabar
        drawbuttonsmenuplay() -- desenha na tela as fotos dos botões do menu (checar o arquivo "menu.lua")
        drawbuttonsmenuquit()
        drawup() -- desenha os botoes com cor diferente em caso do cursor do mouse estiver em cima do botao ("menu.lua")
        drawcorfundo() -- desenha a nova imagem do cursor do mouse e seta a cor branca para tela de fundo ("menu.lua")
    elseif actGameState==gameState.PLAYING then -- checa se o usuario clicou em jogar e está de fato na tela de jogo
        love.graphics.reset() -- reseta as cores setadas anteriormente para que não haja mistura nas cores
        musicmenu:stop() -- para a musica de menu 
        musicplaying:play() -- começa a tocar a musica da tela de jogo
        musicplaying:setLooping(true) -- faz com que a musica da tela de jogo se repita assim que acabar
        draw_map() -- desenha o mapa com todos os seus elementos colisivos e não-colisivos em posições pré-definidas ("map.lua")
--        love.graphics.setColor({255, 255, 255})
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

    elseif isEntitiesColliding(candyi,player) then
        actGameState=gameState.VICTORY
        player.velocity=0
        for i=1,#enemies do
            enemies[i].velocity=0
        end
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
    if (key == "escape" and actGameState~=gameState.VICTORY) then
        toggleGameState()
    end
    if key=='escape' and actGameState==gameState.VICTORY then
        love.event.quit('restart')
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
