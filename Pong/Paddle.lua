Paddle = Class{}

--constructor to initialize the values
function Paddle:init(x,y,width,height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.dy = 0
	
end

--to set the movements of paddle when key is pressed  
function Paddle:update(dt)
	if self.dy < 0 then

		--paddle can move up and not go outside the screen
		self.y = math.max(0,self.y + self.dy * dt)

	else

		--paddle can move down and not go outside the screen
		self.y = math.min(VIRTUAL_HEIGHT - self.height,self.y + self.dy * dt)
	
	end

	
end

function Paddle:render()
	--to draw the paddle on the screen
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

end