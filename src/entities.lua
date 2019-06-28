require("src.constants")

player = {
    xPos = 300,
    yPos = 300,
    velocity = 200,
    width = 24,
    height = 24,
    direction = directions.RIGHT,
    previousDirection = directions.DOWN, 
}

function isEnemy(entity)
    if entity.difficulty ~= nil then
        return true
    end
    return false
end

function generateEnemy(xPos, yPos)
    enemySeed = love.math.random(1, 10)
    enemy = {
        xPos = xPos,
        yPos = yPos,
        color = {},
        velocity = 0,
        width = 24,
        height = 24,
        direction = directions.RIGHT,
        previousDirection = directions.DOWN
    }
    if(enemySeed<=6) then
        enemy.velocity = 180
        enemy.color = {0.15, 0.15, 0.7, 1}
        enemy.difficulty = enemyDifficulties.EASY
    elseif(enemySeed<=9) then
        enemy.velocity = 195
        enemy.color = {0.5, 0.1, 0.4, 1}
        enemy.difficulty = enemyDifficulties.MEDIUM
    else
        enemy.velocity = 205
        enemy.color = {0.8, 0.1, 0.1, 1}
        enemy.difficulty = enemyDifficulties.HARD
    end
    return enemy
end

