fundo = love.graphics.newImage('assets/fundo.png')
function love.load()
	img={}
	for i=1,5 do
		img[i]=love.graphics.newImage('assets/didudxs_paradas'..i..'.png')
	end 
	timer = 0
	num = 1
	growing=true
	actualAnimation = img[num]
end
function love.draw()
	love.graphics.draw(fundo,0,0)
    love.graphics.draw(actualAnimation)
end
function love.update(dt)
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

end
