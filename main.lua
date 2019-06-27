require("src.constants")

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
        xPos = 100,
        yPos = 100,
        velocity = 100,
        direction = directions.RIGHT
    }

    actGameState = gameState.PLAYING
    tiles = loadTiles()
    map = {}
    map_w = 30
    map_h = 30
    map_x = 0
    map_y = 0
    map_offset_x = 30
    map_offset_y = 30
    map_display_w = 30
    map_display_h = 30
    tile_w = 16
    tile_h = 16
    for i=1, map_w do
        map[i] = {}
        for j=1, map_h do
            if(love.math.random()<0.7) then
                map[i][j] = love.math.random(3)
            else
                map[i][j] = love.math.random( 4, 7 );
            end
        end
    end
end



function draw_map()
    for y=1, (map_display_h) do
       for x=1, (map_display_w) do                                                    
            love.graphics.draw(
                tiles[map[y+map_y][x+map_x]], 
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
            5
        )
    end
end
function love.update(dt)
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
    if(isGamePaused(actGameState)) then
        --CODIGO DE MENU
    else
        moveEntity(player, dt)
    end


end

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
        player.direction = directions.UP
    end
    if(key=='a' or key=='left') then
        player.direction = directions.LEFT
    end
    if(key=='d' or key=='right') then
        player.direction = directions.RIGHT
    end
    if(key=='s' or key=='down') then
        player.direction = directions.DOWN
    end
end

function moveEntity(entity, dt)
    if(entity.direction == directions.UP) then
        entity.yPos = entity.yPos - (dt*entity.velocity)
    end
    if(entity.direction == directions.DOWN) then
        entity.yPos = entity.yPos + (dt*entity.velocity)
    end    
    if(entity.direction == directions.RIGHT) then
        entity.xPos = entity.xPos + (dt*entity.velocity)
    end    
    if(entity.direction == directions.LEFT) then
        entity.xPos = entity.xPos - (dt*entity.velocity)
    end
end
