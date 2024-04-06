local cjson = require "cjson.safe"

local external_func = require "op_func"

local func_map = {
   add_suffix = external_func.add_suffix,
   generate_id = external_func.generate_id,
   -- 可以在这里继续添加更多的映射
}

local function call_function_by_name(func_name, ...)

   local func = func_map[func_name]
   if func then
       return func(...)
   else
       error("Function not found: " .. tostring(func_name))
   end
end

-- 功能：从文件中读取JSON配置
local function load(file_path)
   local file = io.open(file_path, "r")
   if not file then
      ngx.log(ngx.ERR, "Failed to open config file: ", file_path)
      return nil
   end
   local content = file:read("*a")
   file:close()
   local config, err = cjson.decode(content)
   if not config then
       ngx.log(ngx.ERR, "Failed to decode config file: ", err)
       return nil
   end
   return config
end

-- 功能：根据路径获取或设置JSON对象的值
local function access_json_by_path(obj, path, value)
   local parts = {}
   for part in string.gmatch(path, "[^%.]+") do
      table.insert(parts, part)
   end

   for i = 1, #parts - 1 do
      obj = obj[parts[i]]
      if not obj then return nil end
   end

   local lastPart = parts[#parts]
   if value then
      obj[lastPart] = value
   else
      return obj[lastPart]
   end
end


local function apply_rules(src, dest, rules)
   for _, rule in ipairs(rules) do
       local src_value = rule.spath and access_json_by_path(src, rule.spath) or nil
       local dest_path = rule.dpath

       -- 如果指定了操作函数，则调用该函数处理源值
       if rule.op and type(rule.op) == "table" and rule.op[1] then
           local func_name = table.remove(rule.op, 1)
           src_value = call_function_by_name(func_name, src_value, table.unpack(rule.op))
       end

       -- 将处理后的值设置到目标路径
       access_json_by_path(dest, dest_path, src_value)
   end
end

local function transform(json_str, config_path)
   local src_data = cjson.decode(json_str)
   local dest_data = {} -- 创建新的JSON结构

   -- 读取配置文件
   config = load(config_path)
   
   local rules = config.rules

   if src_data and rules then
       apply_rules(src_data, dest_data, rules)
       return cjson.encode(dest_data)
   end

   return json_str
end

return {
   transform = transform
}


