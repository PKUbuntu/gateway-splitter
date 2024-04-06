# Beam Splitter

- HTTP/Json <--> HTTP/Json transformation service
- HTTP/Json <--> gRPC transformation service

# HTTP+JSON Transformation Service

## Overview

The HTTP+JSON Transformation Service is a middleware designed for Nginx/OpenResty, aimed at dynamically transforming JSON data transmitted over HTTP. It supports adding, deleting, and modifying fields in the JSON payload, as well as more complex transformations like renaming fields and restructuring the data based on configurable rules.

## Features

- **Dynamic Transformation**: Apply complex rules for modifying JSON structures on-the-fly.
- **Configurable**: Use JSON-based configuration files to define transformation rules.
- **Flexible**: Supports basic field mappings, value modifications, and the addition of new fields computed from existing data.
- **Easy Integration**: Designed to work seamlessly with Nginx/OpenResty, making it suitable for a wide range of applications.

## Getting Started

To start using the HTTP+JSON Transformation Service, you need to have Nginx/OpenResty installed and Lua environment set up. Configuration involves setting up Lua package paths in your Nginx configuration and defining transformation rules in a JSON configuration file.

## Documentation

For detailed installation instructions, usage guidelines, and examples, please refer to the [User Documentation](./doc/HTTP_JSON_Transform_Service_Documentation.md).

## Contributing

Contributions are welcome! If you have ideas for new features or improvements, feel free to fork the repository, make changes, and submit a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
