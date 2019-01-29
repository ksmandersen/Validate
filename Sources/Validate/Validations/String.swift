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
    
    public static func length(json: JSON, min: Int?, max: Int?, key: String) throws -> String? {
        guard let value = optionalString(json: json, key: key) else { return nil }
        if let min = min, value.count < min {
            throw ValidationError.invalidLength(key: key, min: min, max: max)
        }
        
        if let max = max, value.count > max {
            throw ValidationError.invalidLength(key: key, min: min, max: max)
        }
        
        return value
    }
    
    public static func length<K: KeyRepresentable>(json: JSON, min: Int?,
                                                   max: Int, key: K) throws -> String? {
        return try length(json: json, min: min, max: max, key: key.rawValue)
    }
    
    public static func length(json: JSON, min: Int?, max: Int?, key: String) throws -> String {
        let _ = try string(json: json, key: key)
        return try length(json: json, min: min, max: max, key: key)
    }
    
    public static func length<K: KeyRepresentable>(json: JSON, min: Int?,
                                                   max: Int, key: K) throws -> String {
        return try length(json: json, min: min, max: max, key: key.rawValue)
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
