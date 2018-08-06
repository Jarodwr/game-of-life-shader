rules = love.graphics.newShader [[
    uniform vec2 normalized;
    const vec4 ALIVE    = vec4(1.0, 1.0, 1.0, 1.0);
    const vec4 DEAD     = vec4(0.0, 0.0, 0.0, 1.0);

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        int neighbors = 0;

        if (Texel(texture, texture_coords + vec2( 0.0,  1.0) * normalized) == ALIVE) { neighbors++; } 
        if (Texel(texture, texture_coords + vec2( 1.0,  1.0) * normalized) == ALIVE) { neighbors++; }
        if (Texel(texture, texture_coords + vec2( 1.0,  0.0) * normalized) == ALIVE) { neighbors++; } 
        if (Texel(texture, texture_coords + vec2( 1.0, -1.0) * normalized) == ALIVE) { neighbors++; }
        if (Texel(texture, texture_coords + vec2( 0.0, -1.0) * normalized) == ALIVE) { neighbors++; }
        if (Texel(texture, texture_coords + vec2(-1.0, -1.0) * normalized) == ALIVE) { neighbors++; }
        if (Texel(texture, texture_coords + vec2(-1.0,  0.0) * normalized) == ALIVE) { neighbors++; }
        if (Texel(texture, texture_coords + vec2(-1.0,  1.0) * normalized) == ALIVE) { neighbors++; }

        if (neighbors == 3 || (Texel(texture, texture_coords) == ALIVE && neighbors == 2)) {
            return ALIVE;
        }
        return DEAD;
    }
]]
board = love.graphics.newCanvas(500, 500)
rules:send("normalized", {1 / board:getWidth(), 1 / board:getHeight()})

function love.draw()
    love.graphics.setCanvas(board)
    love.graphics.draw(love.graphics.newImage("seed.png"))
    love.graphics.setCanvas()
    love.draw = function()
        local next = love.graphics.newImage(board:newImageData())
        love.graphics.setCanvas(board)
        love.graphics.setShader(rules)
        love.graphics.draw(next)
        love.graphics.setShader()
        love.graphics.setCanvas()
        love.graphics.draw(board)
    end
end
