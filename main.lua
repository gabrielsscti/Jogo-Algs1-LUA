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
        love.graphics.draw(playerim, player.xPos-12, player.yPos-12)-- desenha o player em sua posição
        love.graphics.draw(candy,580,45) -- desenha o doce em sua posição
        for i = 1, #enemies do
              love.graphics.draw(enemies[i].color,enemies[i].xPos-12,enemies[i].yPos-12) --desenha os inimigos todos saindo da mesma posição
        end
    elseif actGameState==gameState.GAMEOVER then --desenha a tela de fim de jogo
        love.graphics.draw(gameover,0,0) -- nas coordenadas do canto da tela
        musicplaying:stop() -- musica de jogo para
        musicgameover:play() -- musica de fim de jogo toca
        musicgameover:setLooping(true) -- musica de fim de jogo entra em loop 
    elseif actGameState==gameState.VICTORY then -- desenha a tela de vitória
        musicplaying:stop() -- musica de jogo para
        musicvictory:play() --musica de vitória toca
        musicvictory:setLooping(true) -- música de vitória entra em loop
        love.graphics.draw(victory,0,0) -- desenha a tela de vitória no canto da tela 
    end
end

function love.update(dt)
    if actGameState==gameState.MENU then --o jogo ja começa com a tela de menu

    elseif isEntitiesColliding(candyi,player) then --em caso de colisão do player com o objetivo
        actGameState=gameState.VICTORY -- a tela muda para a tela de vitória
        player.velocity=0 -- o player fica parado
        for i=1,#enemies do
            enemies[i].velocity=0 -- e o inimigo também 
        end
    else                     -- em caso contrário a ambos
        moveEntity(player, dt) -- o player se move
        for i = 1, #enemies do
            moveEntity(enemies[i], dt) -- os inimigos se movem
            if isEntitiesColliding(player,enemies[i]) then --checa a colisão de player com inimigo
                actGameState=gameState.GAMEOVER -- se for verdade, a tela de fim de jogo é mostrada
                player.xPos = 50 -- a posição do player reseta
                player.yPos = 50
                for i=1,#enemies do
                    enemies[i].xPos=448 --a posição dos inimigos reseta
                    enemies[i].yPos=160
                end
            end
        end
    end
end

function changePreviosDirection(entity) --FUNÇÃO PARA ATRIBUIR A DIREÇÃO ATUAL À DIREÇÃO ANTIGA DE UMA ENTIDADE
    entity.previousDirection = entity.direction
end



function loadEnemies(enemyNumbers, offsetX, offsetY) -- função para carregar os inimigos em quantidade e posição
    local enemy = {}
    for i = 1, enemyNumbers do
        enemy[i] = generateEnemy(offsetX + 448, 160 + offsetY)
    end
    return enemy
end

function checkCollision(entity, wall)  -- checa a colisão das paredes
    local function isEntitysRightColliding(wall)
        return (entity.xPos + (entity.width) / 2 >= wall.xPos)
    end
    local function isEntitysLeftColliding(wall)
        return (entity.xPos - (entity.width) / 2 <= wall.xPos + wall.width)
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
    return ((isEntitysRightColliding(wall) and isEntitysLeftColliding(wall) and isEntityInVerticalBounds(wall)) or
        (isEntitysDownColliding(wall) and isEntitysUpColliding(wall) and isEntityInHorizontalBounds(wall)))
end
--[[
    comentário da função de colisão aqui
--]]


function toggleGameState() -- muda o estado do jogo de playing para menu ou de menu para playing
    if isGamePaused(actGameState) then
        actGameState = gameState.PLAYING
    else
        actGameState = gameState.MENU
    end
end
function love.mousepressed(x, y, button, istouch)
    action = getMouseAction(button) -- se o usuario apertar no botao de play
    if action ~= false then
        toggleGameState() -- entao o jogo muda de menu para playing
    end
    if action == "quit" then --se ele apertar no botao de quit
        love.event.quit() --entao o jogo encerra
    end
end
function love.keypressed(key, unicode)
    if (key == "escape" and actGameState~=gameState.VICTORY) then -- se a tecla esc for pressionada em todas as telas exceto a de vitória
        toggleGameState() -- então a tela de jogo muda
    end
    if key=='escape' and actGameState==gameState.VICTORY then -- se a tecla esc for pressionada durante a tela de vitória 
        love.event.quit('restart') -- então o jogo reinicia
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
        end                                                  -- teclas de direcionamento do player
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

function checkEntityCollision(entity) -- checa a colisão entre entidades e paredes
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

function moveEntityPrevious(entity, dt)              -- faz com que a entidade se mova para a direção que seguia anteriormente em caso de
    if (not isDirectionOposite(entity.direction, entity.previousDirection)) then  -- colisão com alguma parede
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
function isEntitiesColliding(entity1,entity2)   -- checa a colisão entre entidades (playerXenemy, playerXcandy)
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
