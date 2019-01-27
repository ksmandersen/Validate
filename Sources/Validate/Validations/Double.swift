import JSON

extension Validate {
    public static func optionalDouble(json: JSON, key: String) -> Double? {
        guard let value = json[key]?.double else { return nil }
        return value
    }
    
    public static func optionalDouble<K: KeyRepresentable>(json: JSON, key: K) -> Double? {
        return optionalDouble(json: json, key: key.rawValue)
    }
    
    public static func double(json: JSON, key: String) throws -> Double {
        guard let value = optionalDouble(json: json, key: key) else {
            throw ValidationError.missingValue(key: key)
        }
        
        return value
    }
    
    public static func double<K: KeyRepresentable>(json: JSON, key: K) throws -> Double {
        return try double(json: json, key: key.rawValue)
    }
}

extension Validatable {
    public func optionalDouble(key: String) -> Double? {
        return Validate.optionalDouble(json: json, key: key)
    }
    
    public func optionalDouble<K: KeyRepresentable>(key: K) -> Double? {
        return Validate.optionalDouble(json: json, key: key)
    }
    
    public func double(key: String) throws -> Double {
        return try Validate.double(json: json, key: key)
    }
    
    public func double<K: KeyRepresentable>(key: K) throws -> Double {
        return try Validate.double(json: json, key: key)
    }
}
