import JSON

extension Validate {
    public static func optionalDate(json: JSON, key: String) -> Date? {
        guard let value = json[key]?.date else { return nil }
        return value
    }
    
    public static func optionalDate<K: KeyRepresentable>(json: JSON, key: K) -> Date? {
        return optionalDate(json: json, key: key.rawValue)
    }
    
    public static func date(json: JSON, key: String) throws -> Date {
        guard let value = optionalDate(json: json, key: key) else {
            throw ValidationError.missingValue(key: key)
        }
        
        return value
    }
    
    public static func date<K: KeyRepresentable>(json: JSON, key: K) throws -> Date {
        return try date(json: json, key: key.rawValue)
    }
}

extension Validatable {
    public func optionalDate(key: String) -> Date? {
        return Validate.optionalDate(json: json, key: key)
    }
    
    public func optionalDate<K: KeyRepresentable>(key: K) -> Date? {
        return Validate.optionalDate(json: json, key: key)
    }
    
    public func date(key: String) throws -> Date {
        return try Validate.date(json: json, key: key)
    }
    
    public func date<K: KeyRepresentable>(key: K) throws -> Date {
        return try Validate.date(json: json, key: key)
    }
}
