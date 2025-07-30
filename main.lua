function love.load()
    love.window.setTitle("Dice Game")
    player = {
        x = 400,
        y = 300,
        radius = 20,
        xVelocity = 100,
        yVelocity = 0
    }
    gravity = 1200

    -- Particle system setup
    local particleImage = love.graphics.newImage("assets/particle.png")
    particles = love.graphics.newParticleSystem(particleImage, 100)
    particles:setParticleLifetime(0.5, 1)
    particles:setSpeed(200, 400)
    particles:setSizes(0.5, 5) -- Reduced base sizes
    particles:setSpread(math.pi * 2)
    particles:setColors(1, 0, 0, 1, 1, 0, 0, 0) -- Red particles that fade out

    -- Load the shader
    local success, shader = pcall(love.graphics.newShader, "shader/background_shader.glsl")
    if success then
        backgroundShader = shader
        print("Shader loaded:", backgroundShader ~= nil)
    else
        print("Failed to load shader: " .. shader)
    end
end

function love.update(dt)
    -- Update shader time uniform
    if backgroundShader then
        backgroundShader:send("time", love.timer.getTime())
        backgroundShader:send("resolution", {love.graphics.getWidth(), love.graphics.getHeight()})
    end

    -- Update player position based on velocity
    player.x = player.x + player.xVelocity * dt
    player.y = player.y + player.yVelocity * dt

    -- Update particle system
    particles:update(dt)

    -- Apply gravity only if it's active
    if gravity > 0 then
        player.yVelocity = player.yVelocity + gravity * dt
    end

    -- Damping factor based on velocity magnitude
    local dampingMult = 0.85
    local dampingSubtract = -10
    local crossDampingFactor = 0.7
    local crossDampingValue = dampingMult + crossDampingFactor * (1 - dampingMult)
    local minimumYVelocity = 18
    local rollFriction = 0.999 -- Friction applied to xVelocity when on the ground

    -- If player position is at or beyond boundaries, reverse velocity with damping
    if player.x - player.radius < 0 then
        player.x = player.radius
        player.xVelocity = -player.xVelocity * dampingMult - dampingSubtract
        player.yVelocity = player.yVelocity * crossDampingValue
        spawnParticles(player.x, player.y)
    elseif player.x + player.radius > love.graphics.getWidth() then
        player.x = love.graphics.getWidth() - player.radius
        player.xVelocity = -player.xVelocity * dampingMult - dampingSubtract
        player.yVelocity = player.yVelocity * crossDampingValue
        spawnParticles(player.x, player.y)
    end
    if player.y - player.radius < 0 then
        player.y = player.radius
        player.yVelocity = -player.yVelocity * dampingMult - dampingSubtract
        player.xVelocity = player.xVelocity * crossDampingValue
        spawnParticles(player.x, player.y)
    elseif player.y + player.radius > love.graphics.getHeight() then
        player.y = love.graphics.getHeight() - player.radius

        -- Print yVelocity for debugging
        print("yVelocity on collision: " .. player.yVelocity)

        -- Stop jittering and apply ground friction
        if player.yVelocity < minimumYVelocity and player.y >= love.graphics.getHeight() - player.radius then
            player.yVelocity = 0
            gravity = 0 -- Disable gravity when on the ground
        else
            player.yVelocity = -player.yVelocity * dampingMult - dampingSubtract
            player.xVelocity = player.xVelocity * crossDampingValue
        end
        spawnParticles(player.x, player.y)
    end
    if player.yVelocity == 0 and player.y >= love.graphics.getHeight() - player.radius then
        -- Apply ground friction to xVelocity when on the ground
        player.xVelocity = player.xVelocity * rollFriction
    end
end

function love.draw()
    -- Clear the screen first
    love.graphics.clear(0, 0, 0, 1)

    -- Apply the shader
    if backgroundShader then
        love.graphics.setShader(backgroundShader)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setShader() -- Reset the shader
    end

    -- Draw the player and particles
    love.graphics.circle("fill", player.x, player.y, player.radius)
    love.graphics.draw(particles)
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then -- Left mouse button
        local boostRange = 5 -- Adjust the range of the random boost
        local boostMult = 5000 -- Adjust the multiplier for the random boost
        player.xVelocity = player.xVelocity + math.random(-boostRange, boostRange) * boostMult
        player.yVelocity = player.yVelocity + math.random(-boostRange, boostRange) * boostMult
        gravity = 1200 -- Re-enable gravity when the ball is boosted
    end
end

-- Function to spawn particles at a given position
function spawnParticles(x, y)
    -- Calculate collision speed (magnitude of velocity)
    local collisionSpeed = math.sqrt(player.xVelocity * player.xVelocity + player.yVelocity * player.yVelocity)
    
    -- Scale factor based on collision speed (adjust these values to tune the effect)
    local minSpeed = 100
    local maxSpeed = 1000
    local speedFactor = math.max(0, math.min(1, (collisionSpeed - minSpeed) / (maxSpeed - minSpeed)))
    
    -- Scale particle properties based on collision speed
    local baseSize = 0.5
    local maxSize = 5
    local sizeRange = maxSize - baseSize
    local currentMaxSize = baseSize + (sizeRange * speedFactor)
    
    -- Update particle system properties
    particles:setSizes(baseSize, currentMaxSize)
    particles:setPosition(x, y)
    
    -- Emit more particles for faster collisions
    local particleCount = math.floor(10 + (20 * speedFactor))
    particles:emit(particleCount)
end