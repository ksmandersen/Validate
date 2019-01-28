<p align="center">
    <a href="https//vapor.codes">
        <img src="http://img.shields.io/badge/vapor-2.0-brightgreen.svg" alt="Vapor 2" />
    </a>
    <a href="LICENSE">
        <img src="http://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://circleci.com/gh/ksmandersen/Validate">
        <img src="https://circleci.com/gh/ksmandersen/Validate.svg?style=shield" alt="Continuous Integration">
    </a>
    <a href="https://swift.org">
        <img src="http://img.shields.io/badge/swift-4.2-brightgreen.svg" alt="Swift 4.2">
    </a>
</p>

# Validate

Simple JSON validation for Vapor 2.0

**Please note this package is designed for the now outdated Vapor 2.0.
Newer and better options for valiating json are available with Vapor 3.0**

## Getting Started

```swift
import Validate
```

## Validating API models

```swift
enum UserType: String, CaseIterable {
    case normal, admin
}
struct CreateUserReqest: Validatable {
    let json: JSON

    let email: String
    let password: String
    let userType: String
    let rememberMe: Bool?

    init(json: JSON) throws {
        self.json = json

        self.email = try email(key: "username")
        self.password = try string(key: "password")
        self.userType = try enum(oneOf: UserType.self, key: "user_type")
        self.rememberMe = optionalBool(key: "remember_me")
    }
}
```

## Using Enums for Keys

```swift
extension User {
    enum Keys: String, KeyRepresentable {
        case email, password
        case rememberMe = "remember_me"
    }
}

struct UserLogInRequest: Validatable {
    let json: JSON

    let email: String
    let password: String
    let rememberMe: Bool?

    init(json: JSON) throws {
        self.json = json

        self.email = try email(key: User.Keys.email)
        self.password = try string(key: User.Keys.password)
        self.rememberMe = try optionalBool(key: User.Keys.rememberMe)
    }
}
```
