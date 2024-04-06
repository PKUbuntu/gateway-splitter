
# HTTP+JSON 转换服务用户文档

## 概述

HTTP+JSON 转换服务是基于 Nginx/OpenResty 的中间件，旨在实现对通过 HTTP 传输的 JSON 数据进行动态转换。该服务支持字段的增加、删除、修改，以及更复杂的转换逻辑，如字段重命名和结构调整。通过配置文件，用户可以灵活定义转换规则。

## 安装和配置

### 前置条件

- 已安装 Nginx 或 OpenResty。
- Lua 环境已配置，包括 `lua-cjson` 和其他必要的 Lua 库。

### 配置 Nginx

1. **Lua 包路径设置**：

    在 Nginx 配置文件（通常是 `nginx.conf`）中，设置 Lua 包的搜索路径：

    ```nginx
    http {
        lua_package_path '/path/to/lua/scripts/?.lua;;';
    }
    ```

    确保替换 `/path/to/lua/scripts/` 为您的 Lua 脚本实际路径。

2. **服务端点配置**：

    在 Nginx 配置中定义处理转换的 location 块：

    ```nginx
    server {
        listen 8080;

        location /transform {
            access_by_lua_block {
                ngx.req.read_body()
                local modify_json = require "sky_fire"
                local config_path = load_config.load("/path/to/transform_conf.json")
                local modified_body = modify_json.transform(ngx.req.get_body_data(), config_path)
                ngx.say(modified_body)
                ngx.exit(ngx.HTTP_OK)
            }
        }
    }
    ```

    替换 `/path/to/transform_conf.json` 为您的转换规则配置文件实际路径。

## 使用指南

### 转换规则配置

转换规则定义在 JSON 配置文件中。以下是配置文件的基本结构示例：

```json
{
    "rules": [
        {
            "spath": "source_field_path",
            "dpath": "destination_field_path",
            "op": ["optional_operation"]
        }
    ]
}
```

- **`spath`**：源字段路径。
- **`dpath`**：目标字段路径。
- **`op`**：（可选）指定操作的函数名称列表。

### 发送转换请求

使用 `curl` 或其他 HTTP 客户端工具发送 JSON 数据到转换服务端点：

```bash
curl -X POST http://localhost:8080/transform      -H "Content-Type: application/json"      -d '{ 
          	"param1": "value1", 
			"param2": 2, 
			"param3": [1, 2, 3]
	}'
```

### 转换操作示例

- **基本映射**：直接从源字段映射到目标字段，不改变值。
- **内部表映射**：将值映射到嵌套结构`inner_table.param2`。
- **值转换**：应用指定的函数转换字段值。
- **新增字段**：基于源数据计算并新增字段。

## 维护和支持

- 确保定期检查 Nginx 错误日志以获取服务运行中的错误或警告。
- 更新转换规则或 Lua 脚本后，重新加载 Nginx 配置以应用更改。

## 常见问题解答

**Q**: 如何调试转换规则不生效的问题？

**A**: 验证 Nginx 配置文件中 Lua 路径设置正确，确保 Lua 脚本无语法错误，并检查 Nginx 错误日志以获取详细的错误信息。

**Q**: 能否同时处理多个转换规则？

**A**: 是的，您可以在配置文件中定义多个转换规则，它们将按照数组中的顺序依次应用。
