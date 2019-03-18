import JSON
import Fluent

extension Validate {
    public static func optionalEntity<E: Entity>(json: JSON, key: String) throws -> E? {
        guard let id = optionalString(json: json, key: key) else { return nil }
        
        guard let entity = try E.find(id) else {
            throw ValidationError.custom(key: key, reason: "\(E.name) not found for key",
                                         identifier: "entity_not_found")
        }
        
        return entity
    }
    
    public static func optionalEntity<E: Entity, K: KeyRepresentable>(json: JSON, key: K) throws -> E? {
        return try optionalEntity(json: json, key: key.rawValue)
    }
    
    public static func entity<E: Entity>(json: JSON, key: String) throws -> E {
        guard let entity: E = try optionalEntity(json: json, key: key) else {
            throw ValidationError.missingValue(key: key)
        }
        
        return entity
    }
    
    public static func entity<E: Entity, K: KeyRepresentable>(json: JSON, key: K) throws -> E {
        return try entity(json: json, key: key.rawValue)
    }
}

extension Validatable {
    public func optionalEntity<E: Entity>(key: String) throws -> E? {
        return try Validate.optionalEntity(json: json, key: key)
    }
    
    public func optionalEntity<E: Entity, K: KeyRepresentable>(key: K) throws -> E? {
        return try Validate.optionalEntity(json: json, key: key)
    }
    
    public func entity<E: Entity>(key: String) throws -> E {
        return try Validate.entity(json: json, key: key)
    }
    
    public func entity<E: Entity, K: KeyRepresentable>(key: K) throws -> E {
        return try Validate.entity(json: json, key: key)
    }
}
