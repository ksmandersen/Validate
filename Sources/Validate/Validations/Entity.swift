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
    
    public static func optionalUniqueEntity<E: Entity>(json: JSON, key: String,
                                                      allowingId: Identifier? = nil) throws -> E? {
        guard let entity: E = try optionalEntity(json: json, key: key) else {
            return nil
        }
        
        if let allowingId = allowingId, entity.id == allowingId {
            return entity
        }
        
        throw ValidationError.custom(key: key, reason: "Enitity already exists for \(key)",
                                     identifier: "enitity_not_unique")
    }
    
    public static func optionalUniqueEntity<E: Entity, K: KeyRepresentable>(json: JSON, key: K,
                                               allowingId: Identifier? = nil) throws -> E? {
        return try optionalUniqueEntity(json: json, key: key.rawValue, allowingId: allowingId)
    }
    
    public static func uniqueEntity<E: Entity>(json: JSON, key: String,
                                               allowingId: Identifier? = nil) throws -> E {
        guard let entity: E = try optionalUniqueEntity(json: json, key: key,
                                                   allowingId: allowingId) else {
            throw ValidationError.missingValue(key: key)
        }
        
        return entity
    }
    
    public static func uniqueEntity<E: Entity, K: KeyRepresentable>(json: JSON, key: K,
                                               allowingId: Identifier? = nil) throws -> E {
        return try uniqueEntity(json: json, key: key.rawValue, allowingId: allowingId)
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
    
    public func optionalUniqueEntity<E: Entity>(key: String) throws -> E? {
        return try Validate.optionalUniqueEntity(json: json, key: key)
    }
    
    public func optionalUniqueEntity<E: Entity, K: KeyRepresentable>(key: K) throws -> E? {
        return try Validate.optionalUniqueEntity(json: json, key: key)
    }
    
    public func uniqueEntity<E: Entity>(key: String) throws -> E {
        return try Validate.uniqueEntity(json: json, key: key)
    }
    
    public func uniqueEntity<E: Entity, K: KeyRepresentable>(key: K) throws -> E {
        return try Validate.uniqueEntity(json: json, key: key)
    }
}
