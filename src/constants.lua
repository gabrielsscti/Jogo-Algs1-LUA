gameState = {
    MENU = 1,
    PLAYING = 2
}

directions = {
    UP = 1,
    DOWN = 2,
    RIGHT = 3,
    LEFT = 4
}

function isGamePaused(actGameState)
    if(actGameState==gameState.MENU)then
        return true
    else
        return false
    end
end

