local M = {}

function M.add_suffix(value)
    return tostring(value) .. "_suffix"
end

function M.generate_id()
    return "ID_" .. tostring(math.random(1000, 9999))
end

return M