require("src.constants")

function changePreviosDirection(entity)
    entity.previousDirection = player.direction
    
end

function loadTiles()
    local tiles = {}
    for i=1, 3 do
        table.insert(tiles, love.graphics.newImage('assets/background'..i..'.png'))
    end
    for i=1, 4 do
        table.insert(tiles, love.graphics.newImage('assets/wall'..i..'.png'))
    end

    return tiles;
end
function love.load()
--[[
--menu and mouse
    play={}
	quit={}
	for i=1,2 do
		play[i]=love.graphics.newImage('assets/play'..i..'.png')
	end
	for i=1,2 do
		quit[i]=love.graphics.newImage('assets/quit'..i..'.png')
	end
	actuabuttonp=play[1]
	actualbuttonq=quit[1]
	rato=love.graphics.newImage('assets/rato.png')
	love.mouse.setVisible(false)
	img={}
	for i=1,5 do
		img[i]=love.graphics.newImage('assets/didudxs_paradas'..i..'.png')
	end 
	timer = 0
	num = 1
	growing=true
	actualAnimation = img[num]
--]]
    player = {
        xPos = 300,
        yPos = 300,
        velocity = 100,
        width = 24,
        height = 24,
        direction = directions.RIGHT,
        previousDirection = directions.DOWN,
        
    }

    collidableTile = {}
    directionOposite = false

    actGameState = gameState.PLAYING
    tiles = loadTiles()
    map = {}
    map_w = 20
    map_h = 15
    map_offset_x = 100
    map_offset_y = 0
    map_display_w = 20
    map_display_h = 15
    tile_w = 32
    tile_h = 32
    loadMap()
end

function checkCollision(entity, wall)
    local function isEntitysRightColliding(wall)
        return (entity.xPos + (entity.width)/2 >= wall.xPos) --REMOVER DIVISÃO POR DOIS SE FOR IMAGEM
    end
    local function isEntitysLeftColliding(wall)
        return (entity.xPos - (entity.width)/2 <= wall.xPos + wall.width)  --REMOVER SUBTRAÇÃO SE FOR IMAGEM
    end
    local function isEntitysDownColliding(wall)
        return (entity.yPos + (entity.height)/2 >= wall.yPos)
    end
    local function isEntitysUpColliding(wall)
        return (entity.yPos - (entity.height)/2 <= wall.yPos + wall.height)
    end
    local function isEntityInVerticalBounds(wall)
        return ((entity.yPos + (entity.height)/2 >= wall.yPos) and ((entity.yPos - (entity.height)/2) <= wall.yPos+wall.height))
    end
    local function isEntityInHorizontalBounds(wall)
        return ((entity.xPos + (entity.height)/2 >= wall.xPos) and ((entity.xPos - (entity.height)/2) <= wall.xPos+wall.width))
    end
    --print(tostring(isEntitysRightColliding(wall)) .. " " .. tostring(isEntitysLeftColliding(wall)))
    return(
        (isEntitysRightColliding(wall) and isEntitysLeftColliding(wall) and isEntityInVerticalBounds(wall)) or
        (isEntitysDownColliding(wall) and isEntitysUpColliding(wall) and isEntityInHorizontalBounds(wall))
    )

end

function loadMap()
    for i=1, map_w do
        map[i] = {}
        for j=1, map_h do
            if(love.math.random()<0.7) then
                map[i][j] = love.math.random(3)
            else
                map[i][j] = love.math.random( 4, 7 );
                table.insert(collidableTile, {
                    xPos = i*tile_w+map_offset_x,
                    yPos = j*tile_h+map_offset_y,
                    width = tile_w,
                    height = tile_h
                })
            end
        end
    end
end

function draw_map()
    for y=1, (map_display_h) do
       for x=1, (map_display_w) do                                                    
            love.graphics.draw(
                tiles[map[x][y]], 
                (x*tile_w)+map_offset_x, 
                (y*tile_h)+map_offset_y )
       end
    end
end

function love.draw()
--[[
--menu's buttons
	love.graphics.draw(play[1], 320, 165)
    love.graphics.draw(quit[1], 320,300)
    love.graphics.setBackgroundColor(255,255,255)
    love.graphics.draw(rato,love.mouse.getX(),love.mouse.getY())
    love.graphics.draw(actualAnimation,80,500)
    love.graphics.setBackgroundColor(255,255,255)
--]]	
    if(isGamePaused(actGameState)) then
        --CODIGO DO MENU
    else
        draw_map();
        love.graphics.circle(
            'fill',
            player.xPos,
            player.yPos,
            player.width/2
        )
        love.graphics.print(tostring(isDirectionOposite(player.direction, player.previousDirection)))
        
        
    end
end
--[[
-- menu's dog and bird
	timer = timer + dt
	if timer>=0.07 then
		if growing==true then
			num = num+1
		else
			num=num-1
		end
		if num==5 then
			growing=false
		elseif num==1 then
			growing=true
		end
		actualAnimation = img[num]
		timer = 0
	end
--]]


function toggleGameState()
    if isGamePaused(actGameState) then
        actGameState = gameState.PLAYING
    else
        actGameState = gameState.MENU
    end
end

function love.keypressed(key, unicode) 
    if(key=='escape') then
        toggleGameState()
    end
    if(key=='w' or key=='up') then
        if player.direction ~= directions.UP then
            changePreviosDirection(player)
            player.direction = directions.UP
        end
    end
    if(key=='a' or key=='left') then
        if player.direction ~= directions.LEFT then
            changePreviosDirection(player)
            player.direction = directions.LEFT
        end
    end
    if(key=='d' or key=='right') then
        if player.direction ~= directions.RIGHT then
            changePreviosDirection(player)
            player.direction = directions.RIGHT
        end
    end
    if(key=='s' or key=='down') then
        if player.direction ~= directions.DOWN then
            changePreviosDirection(player)
            player.direction = directions.DOWN
        end
    end
end

function checkPlayerCollision()
    for i=1, #collidableTile do
        temp = checkCollision(player, collidableTile[i])
        if(temp) then
            return true
        end
    end
    return false
end

function isDirectionOposite(directionA, directionB)
    return (directionA+directionB==3 or directionA+directionB==7)
end


function moveEntityPrevious(entity, dt)
    if(not isDirectionOposite(entity.direction, entity.previousDirection)) then
        if(entity.previousDirection == directions.UP) then
            entity.yPos = entity.yPos - (dt*entity.velocity)
            if checkPlayerCollision() then
                entity.yPos = entity.yPos + (dt*entity.velocity)
            end
        end   
        if(entity.previousDirection == directions.DOWN) then
            entity.yPos = entity.yPos + (dt*entity.velocity)
            if checkPlayerCollision() then
                entity.yPos = entity.yPos - (dt*entity.velocity)
            end
        end
        if(entity.previousDirection == directions.RIGHT) then
            entity.xPos = entity.xPos + (dt*entity.velocity)
            if checkPlayerCollision() then
                entity.xPos = entity.xPos - (dt*entity.velocity)
            end
        end    
        if(entity.previousDirection == directions.LEFT) then
            entity.xPos = entity.xPos - (dt*entity.velocity)
            if checkPlayerCollision() then
                entity.xPos = entity.xPos + (dt*entity.velocity)
            end
        end
    end
end

function moveEntity(entity, dt)
    if(entity.direction == directions.UP) then
        entity.yPos = entity.yPos - (dt*entity.velocity)
        if checkPlayerCollision() then
            entity.yPos = entity.yPos + (dt*entity.velocity)
            moveEntityPrevious(entity, dt)
        end
    end   
    if(entity.direction == directions.DOWN) then
        entity.yPos = entity.yPos + (dt*entity.velocity)
        if checkPlayerCollision() then
            entity.yPos = entity.yPos - (dt*entity.velocity)
            moveEntityPrevious(entity, dt)
        end
    end
    if(entity.direction == directions.RIGHT) then
        entity.xPos = entity.xPos + (dt*entity.velocity)
        if checkPlayerCollision() then
            entity.xPos = entity.xPos - (dt*entity.velocity)
            moveEntityPrevious(entity, dt)
        end
    end    
    if(entity.direction == directions.LEFT) then
        entity.xPos = entity.xPos - (dt*entity.velocity)
        if checkPlayerCollision() then
            entity.xPos = entity.xPos + (dt*entity.velocity)
            moveEntityPrevious(entity, dt)
        end
    end
end

function love.update(dt)
    if(isGamePaused()) then
    else
        moveEntity(player, dt);
        directionOposite = tostring(isDirectionOposite(player.direction, player.previousDirection))
    end
end
