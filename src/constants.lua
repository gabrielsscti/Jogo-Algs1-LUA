gameState = {
    MENU = 1,
    PLAYING = 2,
    GAMEOVER = 3,
    VICTORY = 4
}
music ={
    menu=1,
    playin=2,
    gameover=3,
    victory=4
}
directions = {
    UP = 1,
    DOWN = 2,
    RIGHT = 3,
    LEFT = 4
}

enemyDifficulties = {
    HARD = 3,
    MEDIUM = 2,
    EASY = 1
}

function isGamePaused(actGameState)
    return actGameState==gameState.MENU
end
