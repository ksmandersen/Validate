import JSON

extension Validate {
    public static func optionalBool(json: JSON, key: String) -> Bool? {
        guard let value = json[key]?.bool else { return nil }
        return value
    }
    
    public static func optionalBool<K: KeyRepresentable>(json: JSON, key: K) -> Bool? {
        return optionalBool(json: json, key: key.rawValue)
    }
    
    public static func bool(json: JSON, key: String) throws -> Bool {
        guard let value = optionalBool(json: json, key: key) else {
            throw ValidationError.missingValue(key: key)
        }
        
        return value
    }
    
    public static func bool<K: KeyRepresentable>(json: JSON, key: K) throws -> Bool {
        return try bool(json: json, key: key.rawValue)
    }
}

extension Validatable {
    public func optionalBool(key: String) -> Bool? {
        return Validate.optionalBool(json: json, key: key)
    }
    
    public func optionalBool<K: KeyRepresentable>(key: K) -> Bool? {
        return Validate.optionalBool(json: json, key: key)
    }
    
    public func bool(key: String) throws -> Bool {
        return try Validate.bool(json: json, key: key)
    }
    
    public func bool<K: KeyRepresentable>(key: K) throws -> Bool {
        return try Validate.bool(json: json, key: key)
    }
}
