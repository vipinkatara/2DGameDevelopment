push = require 'push' --mechanism to add other libraries [similar to #include in c and c++]

Class = require 'class'

--to include the class Paddle and ball
require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_HEIGHT = 243
VIRTUAL_WIDTH = 432

PADDLE_SPEED = 200

--To set the title of window
love.window.setTitle('Pong')


function love.load()

		--scaling feature that is used to minimizing and magnifying texture and fonts
		--in this case nearest -neighbour filtering is used for stimulating a retro feel
		love.graphics.setDefaultFilter('nearest','nearest')

		--use time in seonds so that each time when random to be generated is different
		math.randomseed(os.time())

		--to get new font from font file and font for hello pong
		smallFont = love.graphics.newFont('font.ttf',8)

		--font to display each player score
		scoreFont = love.graphics.newFont('font.ttf',32) 
		
		--font to display player's wins
		doneFont = love.graphics.newFont('font.ttf',50)

		--to set the deafault font
		love.graphics.setFont(smallFont) 
		
		--Lua's only Data Structure is used to store the sounds that will used in game
		--newSource() function will load sounds from memory and 'static' will kept them is memory until game is running
		sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }


	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    player1Score = 0
	player2Score = 0

	--here player1 and player2 are objects of class Paddle
    player1 = Paddle(10,30,5,20)
	player2 = Paddle(VIRTUAL_WIDTH - 10,VIRTUAL_HEIGHT - 30,5,20)

	--here ball are objects of class Ball
	ball = Ball(VIRTUAL_WIDTH/2 - 2,VIRTUAL_HEIGHT/2 - 2,2,2)

		

	--use to determine behaviour during render and update
	gameState = 'start'

end

function love.update(dt)
    

    if gameState == 'play' then

    	if ball:collides(player1) then

    		--when the ball collides then ball will move at negative speed and also speed will increase by 3%
    		ball.dx = -ball.dx * 1.03
    		--to display that ball just touched the paddle
    		ball.x = player1.x + 5

    		--when ball hit the pddle so that it move in random direction instead of moving in only same direction
    		if ball.dy < 0 then
    			ball.dy = -math.random(10,150)
    		else
    			ball.dy = math.random(10,150)
    		end
    		 sounds['paddle_hit']:play()
    	end

    	-- same operations as player 1
    	if ball:collides(player2) then
    		
    		ball.dx = -ball.dx * 1.03
    		ball.x = player2.x - 4


    		if ball.dy < 0 then
    			ball.dy = -math.random(10,150)
    		else

    			ball.dy = math.random(10,150)
    		
    		end

    		--this will play a sound when ball will it paddle
    		sounds['paddle_hit']:play()
    	end

    	--detect lower and upper boundary collision reversed if colliided
    	if ball.y <= 0 then
    		ball.y = 0
    		ball.dy = -ball.dy
    		sounds['wall_hit']:play()
    	end


    	if ball.y >= VIRTUAL_HEIGHT - 4 then
    		ball.y = VIRTUAL_HEIGHT -4
    		ball.dy = -ball.dy
    		sounds['wall_hit']:play()
    	end

    end

    --to check whether a score is happened by player 1 or not
    if ball.x < 0 then
    	--set the serving playe so tat it can be later used[so player can serve]
    	servingPlayer = 1
    	--to increase player 2 score by 1
    	player1Score = player1Score + 1
    	--reset the ball to center of screen
    	ball:reset()
    	--to play a sound of score
    	sounds['score']:play()
    	--move to game state serve
    	gameState = 'serve'
    end

    --to check whether a score is happened by player 2 or not
    if ball.x > VIRTUAL_WIDTH then
    	--set the serving playe so tat it can be later used[so player can serve]
    	servingPlayer = 2
    	--to increase player 2 score by 1
    	player2Score = player2Score + 1
    	--reset the ball to center of screen
    	ball:reset()
    	--to play a sound of score
    	sounds['score']:play()
    	--move to game state serve
    	gameState = 'serve'
    end

    -- player 1 movement
    if love.keyboard.isDown('w') then
        -- add negative paddle speed to current Y scaled by deltaTime
        player1.dy = -PADDLE_SPEED
    
    elseif love.keyboard.isDown('s') then
        -- add positive paddle speed to current Y scaled by deltaTime
        player1.dy = PADDLE_SPEED
    
    else
    	--paddle stops when no key is pressed
    	player1.dy = 0

    
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        -- add negative paddle speed to current Y scaled by deltaTime
        player2.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown('down') then
        -- add positive paddle speed to current Y scaled by deltaTime
        player2.dy = PADDLE_SPEED
    
    else
    	--paddle stops when no key is pressed
    	player2.dy = 0

    end

    --when a point is scored ny player
    if gameState == 'serve' then
    	
    	--have a random velocity at y co-ordinate
    	ball.dy = math.random(-50,50)

    	if servingPlayer == 1 then
    		--ball will be thrown towards player 1 side
    		ball.dx = math.random(120,150)
    	
    	else
    		--ball will be thrown towards player 2 side
    		ball.dx = -math.random(120,150)
		
		end
	
	end

	--to check whether player 1 has won or not
	if player1Score == 3 then
		gameState = 'done'
		win = 'Player 2'
	end

	--to check whether player 1 has won or not
	if player2Score == 3 then
		gameState = 'done'
		win = 'Player 1'
	end


    if gameState == 'play' then
    	--to update the ball frame by frame 
    	ball:update(dt)
    
    end

    	--to update the paddle when key is pressed
    	player1:update(dt)
    	player2:update(dt)
    
end

--function to resize the screen when modified
function love.resize(w,h)
	
	push:resize(w,h)

end

--this function will work when any key will be pressed
function love.keypressed(key)
	
	--here q will quit the application
	if	key == 'q' then 
		love.event.quit()

	elseif key == 'return' then

		--when enter will be pressed so then game can be played again
		if gameState == 'start' then
			gameState = 'play'

		--when enter will be pressed so then game can be played again[from serve state]
		elseif gameState == 'serve' then
			gameState = 'play'

		--when either of the player has won
		elseif gameState == 'done' then

			-- it is to reset the game to its initial state by reseting their player score and ball
			gameState = 'start' 
			player1Score = 0
			player2Score = 0


			ball:reset()


		else
			gameState = 'start'

			-- so that ball will return to its intial position
			ball:reset()
		end
	end

end

--basically the dunction that will print the all the details on output screen
function love.draw()
	
	--begin rendering at virtual resolution
	push:apply('start') 

	--basically to set the background and opaqueness
	love.graphics.clear(40,45,52,255) 

		--to display the current game state of a program
		-- '..' is used to concatenate strings 
		love.graphics.printf('Hello ' .. gameState .. ' state!',0,20,VIRTUAL_WIDTH,'center')

	

	--end
	if gameState == 'done' then
		--to customize the winning screen
		love.graphics.setFont(doneFont)
		love.graphics.print(win .. ' Wins!',VIRTUAL_WIDTH/2 -180,VIRTUAL_HEIGHT/2 - 50)
		love.graphics.setFont(smallFont)
		love.graphics.print('Press Enter to start again',VIRTUAL_WIDTH/2 - 50,VIRTUAL_HEIGHT/1.5)
	
	else
		love.graphics.setFont(scoreFont)

		--to display each player's score on the screen
		love.graphics.print(player1Score,VIRTUAL_WIDTH / 2 -50,VIRTUAL_HEIGHT/3)
		love.graphics.print(player2Score,VIRTUAL_WIDTH / 2 +30,VIRTUAL_HEIGHT/3)
	
		--render first paddle
		player1:render()
    
    	--render second paddle
    	player2:render()
	
		--render ball
		ball:render()
	end

	--call to a function to display Frame per second
	displayFPS()
	
	--end rendering at virtual resolution
	push:apply('end')	
end

--this function is used to display frame per second on output screen
function displayFPS()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(0,225,0,225)
	love.graphics.print('FPS : ' .. tostring(love.timer.getFPS()),10,10)
end