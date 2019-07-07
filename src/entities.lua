require("src.constants")

player = {
    position={},
    xPos = 50,
    yPos = 50,
    velocity = 100,
    width = 24,
    height = 24,
    direction = directions.RIGHT,
    previousDirection = directions.DOWN
}
candyi={
    xPos=580,
    yPos=48,
    width = 24,
    height = 24,
}

function isEnemy(entity)
    if entity.difficulty == nil then
        return false
    end
    return true
end

function generateEnemy(xPos, yPos)
    enemySeed = love.math.random(0, 10)
    enemy = {
        xPos = xPos,
        yPos = yPos,
        color = {},
        velocity = 0,
        width = 24,
        height = 24,
        direction = directions.RIGHT,
        previousDirection = directions.DOWN,
        difficulty = enemyDifficulties.EASY
    }
    if(enemySeed<=6) then
        enemy.velocity = 160
        enemy.color = love.graphics.newImage('assets/enemy1.png')
        enemy.difficulty = enemyDifficulties.EASY
    elseif(enemySeed<=9) then
        enemy.velocity = 175
        enemy.color = love.graphics.newImage('assets/enemy2.png')
        enemy.difficulty = enemyDifficulties.MEDIUM
    else
        enemy.velocity = 195
        enemy.color = love.graphics.newImage('assets/enemy3.png')
        enemy.difficulty = enemyDifficulties.HARD
    end
    return enemy
end

