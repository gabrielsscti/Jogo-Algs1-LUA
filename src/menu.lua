function menuloadbuttons()
	play ={
	playi = love.graphics.newImage('assets/play1.png'),
	pressed = love.graphics.newImage('assets/play2.png')
}
	quit = {
	quiti = love.graphics.newImage('assets/quit1.png'),
	pressed = love.graphics.newImage('assets/quit2.png')
}
	altura = 105
	largura = 180
end
function drawbuttonsmenu()
	love.graphics.draw(play.playi,320,160)
	love.graphics.draw(quit.quiti,320,280)
end
function drawup()
	local x,y=love.mouse.getPosition()
	if x>320 and x<=largura+320 and y>160 and y<altura+160 then 
		love.graphics.draw(play.pressed,320,160)
	elseif x>320 and x<=largura+320 and y>280 and y<altura+280 then 
		love.graphics.draw(quit.pressed,320,280)
	end
end