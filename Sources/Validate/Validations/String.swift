import JSON

extension Validate {
    public static func optionalString(json: JSON, key: String) -> String? {
        guard let value = json[key]?.string else { return nil }
        return value
    }
    
    public static func optionalString<K: KeyRepresentable>(json: JSON, key: K) -> String? {
        return optionalString(json: json, key: key.rawValue)
    }
    
    public static func string(json: JSON, key: String) throws -> String {
        guard let value = optionalString(json: json, key: key) else {
            throw ValidationError.missingValue(key: key)
        }
        
        return value
    }
    
    public static func string<K: KeyRepresentable>(json: JSON, key: K) throws -> String {
        return try string(json: json, key: key.rawValue)
    }
}

extension Validatable {
    public func optionalString(key: String) -> String? {
        return Validate.optionalString(json: json, key: key)
    }
    
    public func optionalString<K: KeyRepresentable>(key: K) -> String? {
        return Validate.optionalString(json: json, key: key)
    }
    
    public func string(key: String) throws -> String {
        return try Validate.string(json: json, key: key)
    }
    
    public func string<K: KeyRepresentable>(key: K) throws -> String {
        return try Validate.string(json: json, key: key)
    }
}
