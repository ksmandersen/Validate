import JSON

extension Validate {
    public static func optionalEnum<E: RawRepresentable>(json: JSON, oneOf: E.Type, key: String) throws -> E?
        where E: CaseIterable, E.RawValue == String {
            guard let rawValue = optionalString(json: json, key: key) else {
                return nil
            }
            
            guard let instance = E(rawValue: rawValue) else {
                let expected = E.allCases.map({ $0.rawValue }).joined(separator: ", ")
                throw ValidationError.invalidValue(key: key, found: rawValue, expected: expected)
            }
            
            return instance
    }
    
    public static func optionalEnum<E: RawRepresentable, K: KeyRepresentable>(json: JSON, oneOf: E.Type, key: K) throws -> E?
        where E: CaseIterable, E.RawValue == String {
            return try optionalEnum(json: json, oneOf: E.self, key: key.rawValue)
    }
    
    public static func `enum`<E: RawRepresentable>(json: JSON, oneOf: E.Type, key: String) throws -> E
        where E: CaseIterable, E.RawValue == String {
            guard let instance: E = try optionalEnum(json: json, oneOf: E.self, key: key) else {
                throw ValidationError.missingValue(key: key)
            }
            
            return instance
    }
    
    public static func `enum`<E: RawRepresentable, K: KeyRepresentable>(json: JSON, oneOf: E.Type, key: K) throws -> E
        where E: CaseIterable, E.RawValue == String {
        return try `enum`(json: json, oneOf: E.self, key: key.rawValue)
    }
}

extension Validatable {
    public func optionalEnum<E: RawRepresentable>(oneOf: E.Type, key: String) throws -> E?
        where E: CaseIterable, E.RawValue == String {
            return try Validate.optionalEnum(json: json, oneOf: E.self, key: key)
    }
    
    public func optionalEnum<E: RawRepresentable, K: KeyRepresentable>(oneOf: E.Type, key: K) throws -> E?
        where E: CaseIterable, E.RawValue == String {
            return try Validate.optionalEnum(json: json, oneOf: E.self, key: key.rawValue)
    }
    
    public func `enum`<E: RawRepresentable>(oneOf: E.Type, key: String) throws -> E
        where E: CaseIterable, E.RawValue == String {
            return try Validate.enum(json: json, oneOf: E.self, key: key)
    }
    
    public func `enum`<E: RawRepresentable, K: KeyRepresentable>(oneOf: E.Type, key: K) throws -> E
        where E: CaseIterable, E.RawValue == String {
            return try Validate.enum(json: json, oneOf: E.self, key: key)
    }
}
