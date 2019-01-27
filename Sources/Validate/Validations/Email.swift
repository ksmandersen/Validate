import JSON

extension Validate {
    public static func optionalEmail(json: JSON, key: String) throws -> String? {
        guard let email = optionalString(json: json, key: key) else { return nil }
        
        guard let range = email.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}",
                                      options: [.regularExpression, .caseInsensitive]),
            range.lowerBound == email.startIndex && range.upperBound == email.endIndex else {
                throw ValidationError.custom(key: key,
                                             reason: "Not a valid email address",
                                             identifier: "invalid_email")
        }
        
        return email
    }
    
    public static func optionalEmail<K: KeyRepresentable>(json: JSON, key: K) throws -> String? {
        return try optionalEmail(json: json, key: key.rawValue)
    }
    
    public static func email(json: JSON, key: String) throws -> String {
        guard let value = try optionalEmail(json: json, key: key) else {
            throw ValidationError.missingValue(key: key)
        }
        
        return value
    }
    
    public static func email<K: KeyRepresentable>(json: JSON, key: K) throws -> String {
        return try email(json: json, key: key.rawValue)
    }
}

extension Validatable {
    public func optionalEmail(json: JSON, key: String) throws -> String? {
        return try Validate.optionalEmail(json: json, key: key)
    }
    
    public func optionalEmail<K: KeyRepresentable>(json: JSON, key: K) throws -> String? {
        return try Validate.optionalEmail(json: json, key: key)
    }
    
    public func email(json: JSON, key: String) throws -> String {
        return try Validate.email(json: json, key: key)
    }
    
    public func email<K: KeyRepresentable>(json: JSON, key: K) throws -> String {
        return try Validate.email(json: json, key: key)
    }
}
