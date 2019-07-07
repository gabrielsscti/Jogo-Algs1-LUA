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
                    if j>=11 and j<=13 then
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
                    if j<=4 and j~=2 then
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
end

function draw_map()
    for y = 1, (map_display_h) do
        for x = 1, (map_display_w) do
            love.graphics.draw(tiles[map[x][y]], ((x - 1) * tile_w) + map_offset_x, ((y - 1) * tile_h) + map_offset_y)
        end
    end
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