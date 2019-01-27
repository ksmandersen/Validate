import JSON

extension Validate {
    public static func optionalInt(json: JSON, key: String) -> Int? {
        guard let value = json[key]?.int else { return nil }
        return value
    }
    
    public static func optionalInt<K: KeyRepresentable>(json: JSON, key: K) -> Int? {
        return optionalInt(json: json, key: key.rawValue)
    }
    
    public static func int(json: JSON, key: String) throws -> Int {
        guard let value = optionalInt(json: json, key: key) else {
            throw ValidationError.missingValue(key: key)
        }
        
        return value
    }
    
    public static func int<K: KeyRepresentable>(json: JSON, key: K) throws -> Int {
        return try int(json: json, key: key.rawValue)
    }
}

extension Validatable {
    public func optionalInt(key: String) -> Int? {
        return Validate.optionalInt(json: json, key: key)
    }
    
    public func optionalInt<K: KeyRepresentable>(key: K) -> Int? {
        return Validate.optionalInt(json: json, key: key)
    }
    
    public func int(key: String) throws -> Int {
        return try Validate.int(json: json, key: key)
    }
    
    public func int<K: KeyRepresentable>(key: K) throws -> Int {
        return try Validate.int(json: json, key: key)
    }
}
