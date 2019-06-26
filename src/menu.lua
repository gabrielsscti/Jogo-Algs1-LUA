function love.load()
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
end

function love.draw()
    love.graphics.draw(play[1], 320, 165)
    love.graphics.draw(quit[1], 320,300)
    love.graphics.setBackgroundColor(255,255,255)
    love.graphics.draw(rato,love.mouse.getX(),love.mouse.getY())
end
function love.mousepressed(x,y,button,istouch)
	if button==1 and mx>=320 and mx<320+play:getWidth() and my>=165 and my<165+play:getMeight() then
		actualbuttonp=play[2]
	end	
	if button==1 and mx>=320 and mx<320+play:getWidth() and my>=300 and my<300+play:getMeight() then
		actualbuttonq=quit[2]
	end	
end