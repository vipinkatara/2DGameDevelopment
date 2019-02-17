
--create a class of ball

Ball = Class{}

--constructor to initialize values when object will be created
function Ball:init(x , y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height

	self.dx = math.random(2) == 1 and 100 or -100
	self.dy = math.random(-50,50)
end

function Ball:reset()
	--reset the ball at center with random speed 
	self.x = VIRTUAL_WIDTH / 2 - 2
	self.y = VIRTUAL_HEIGHT / 2 - 2
	self.dy = math.random(-50,50)
	self.dx = math.random(2) == 1 and 100 or -100
	
end

--to move the ball frame by frame in appropriate direction
function Ball:update(dt)

	self.x = self.x + self.dx*dt
	self.y = self.y + self.dy*dt 

end

function Ball:render()
	--to draw the ball on the screen
	love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)
	
end

function Ball:collides(paddle)

	--first check if left edge is farther to right and then the right edge of other
	if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
		return false
	end
	--first check bottom edge is higher and vice versa
	if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
		return false
	end

	--if not any of the above condition is true then collision will happen
	--else
		return true
	--end

end