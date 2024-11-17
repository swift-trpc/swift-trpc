# swift-trpc

A Swift client library for consuming tRPC APIs in iOS and macOS applications. Designed to provide a type-safe way to interact with tRPC servers while maintaining Swift's elegant syntax and strong typing principles.

## Requirements

- iOS 13.0+ / macOS 10.15+
- Swift 4.0+
- Xcode 13.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/swift-trpc/swift-trpc.git", from: "0.0.2")
]
```

### CocoaPods

Add the following to your `Podfile`:

```ruby
pod 'swift-trpc', '~> 0.0.2'
```

## Usage

### Basic Setup

Initialize the tRPC client with your server URL:

```swift
let client = TrpcClient(serverUrl: "https://api.example.com")
```

### Making Queries

For simple queries without input parameters:

```swift
let request = TrpcRequest(type: .query, path: "users.list")
let response = try await client.execute(request: request, responseType: [User].self)

if let users = response.result {
    // Handle users array
}
```

For queries with input:

```swift
struct UserSearchInput: Codable {
    var query: String
    var limit: Int
}

let input = UserSearchInput(query: "John", limit: 10)
let request = TrpcInputfulRequest(
    type: .query,
    path: "users.search",
    input: input
)

let response = try await client.execute(request: request, responseType: [User].self)
```

### Making Mutations

For mutations that modify data:

```swift
struct CreateUserInput: Codable {
    var name: String
    var email: String
}

let input = CreateUserInput(name: "John Doe", email: "john@example.com")
let request = TrpcInputfulRequest(
    type: .mutation,
    path: "users.create",
    input: input
)

let response = try await client.execute(request: request, responseType: User.self)
```

### Batch Requests

Execute multiple requests in a single network call:

```swift
let requests: [TrpcRequestProtocol] = [
    TrpcRequest(type: .query, path: "users.list"),
    TrpcRequest(type: .query, path: "posts.list")
]

let batchResponse = try await client.executeBatch(requests: requests)

let users = try batchResponse.get(index: 0, responseType: [User].self)
let posts = try batchResponse.get(index: 1, responseType: [Post].self)
```

### Authentication

Add authentication headers to all requests:

```swift
client.baseHeaders["Authorization"] = "Bearer \(token)"
```

## Features

- ✅ Build completely on Swift Concurrency
- ✅ Type-safe requests and responses
- ✅ Batch request support

## Example Project

Check out the `[todo-example](https://github.com/swift-trpc/todo-example)` project for a complete SwiftUI application demonstrating:

- Authentication flow
- CRUD operations
- Real-time state management
- Error handling
- Batch requests

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

swift-trpc is available under the MIT license. See the LICENSE file for more info.

## Credits

Created and maintained by [Artem Tarasenko](https://github.com/shabashab).