local love = require("love")

local function rect(x, y, w, h)
    return {
        body = love.physics.newBody(
            world,
            x,
            y,
            "static"
        ),
        shape = love.physics.newRectangleShape(w, h),
    }
end

function love.load()
    love.keyboard.setKeyRepeat(true)

    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    world = love.physics.newWorld(0, 9.81 * 64, true)

    char = love.graphics.newImage("assets/char.png")

    rectUp = rect(0, 0, width * 2, 20)
    rectUp.fix = love.physics.newFixture(rectUp.body, rectUp.shape)
    rectUp.fix:setRestitution(1)
    rectUp.fix:setUserData("rectUp")

    rectDown = rect(0, height, width * 2, 20)
    rectDown.fix = love.physics.newFixture(rectDown.body, rectDown.shape)
    rectDown.fix:setRestitution(1)
    rectDown.fix:setUserData("rectDown")

    rectLeft = rect(-20, 0, 20, height * 2)
    rectLeft.fix = love.physics.newFixture(rectLeft.body, rectLeft.shape)
    rectLeft.fix:setRestitution(1)
    rectLeft.fix:setUserData("rectLeft")

    rectRight = rect(width, 0, 20, height * 2)
    rectRight.fix = love.physics.newFixture(rectRight.body, rectRight.shape)
    rectRight.fix:setRestitution(1)
    rectRight.fix:setUserData("rectRight")

    playerWidth = char:getWidth()
    playerHeight = char:getHeight()

    player = {
        x = width / 2 - playerWidth / 2,
        y = height - playerHeight - 20
    }

    paddleSkeleton = {
        body = love.physics.newBody(
            world,
            player.x + 59,
            player.y - 20,
            "kinematic"
        ),
        shape = love.physics.newRectangleShape(100, 20)
    }
    paddleSkeleton.fix = love.physics.newFixture(
        paddleSkeleton.body,
        paddleSkeleton.shape
    )
    paddleSkeleton.fix:setRestitution(1)
    paddleSkeleton.fix:setUserData("paddleSkeleton")

    paddle = love.graphics.newImage("assets/paddle.png")

    math.randomseed(os.time())

    ball = {
        body = love.physics.newBody(
            world,
            math.random(0, width),
            20,
            "dynamic"
        ),
        shape = love.physics.newCircleShape(30),
    }
    ball.fix = love.physics.newFixture(ball.body, ball.shape)
    ball.fix:setRestitution(1.05)
    ball.fix:setUserData("ball")
    ball.body:setLinearVelocity(math.random(-1000, 1000), 0)
end

function love.update(dt)
    world:update(dt)

    if (love.keyboard.isDown("left")
            or love.keyboard.isDown("a"))
        and not (player.x < 0) then
        player.x = player.x - 250 * dt
        paddleSkeleton.body:setX(paddleSkeleton.body:getX() - 250 * dt)
    end

    if (love.keyboard.isDown("right")
            or love.keyboard.isDown("d"))
        and not (player.x > width - playerWidth) then
        player.x = player.x + 250 * dt
        paddleSkeleton.body:setX(paddleSkeleton.body:getX() + 250 * dt)
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)

    love.graphics.setBackgroundColor(1,1,1)
    love.graphics.draw(char, player.x, player.y)

    love.graphics.draw(
        paddle,
        paddleSkeleton.body:getX() - 50,
        paddleSkeleton.body:getY()
    )

    love.graphics.rectangle(
        "fill",
        rectUp.body:getX(),
        rectUp.body:getY(),
        width,
        20
    )

    love.graphics.rectangle(
        "fill",
        rectDown.body:getX(),
        rectDown.body:getY(),
        width,
        20
    )

    love.graphics.rectangle(
        "fill",
        rectLeft.body:getX(),
        rectLeft.body:getY(),
        20,
        height
    )

    love.graphics.rectangle(
        "fill",
        rectRight.body:getX(),
        rectRight.body:getY(),
        20,
        height
    )

    love.graphics.setColor(1, 1, 1, 0)
    love.graphics.rectangle(
        "line",
        paddleSkeleton.body:getX(),
        paddleSkeleton.body:getY(),
        100,
        20
    )

    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.circle(
        "fill",
        ball.body:getX(),
        ball.body:getY(),
        ball.shape:getRadius()
    )
end
