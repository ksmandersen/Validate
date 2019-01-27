import HTTP
import Vapor

public enum ValidationError: AbortError {
    case missingValue(key: String)
    case invalidLength(key: String, min: Int?, max: Int?)
    case invalidValue(key: String, found: String?, expected: String?)
    case custom(key: String?, reason: String?, identifier: String)
    
    public var status: Status {
        return .expectationFailed
    }
    
    public var reason: String {
        switch self {
        case let .missingValue(key: key):
            return "Missing value for field: \(key)"
        case let .invalidValue(key: key, found: found, expected: expected):
            var reason = "Invalid value for key: \(key)"
            
            if let found = found {
                reason += ". Found: \(found)"
            }
            
            if let expected = expected {
                reason += ". Expected: \(expected)"
            }
            
            return reason
        case let .invalidLength(key: key, min: min, max: max):
            var reason = "Invalid length for key: \(key)"
            
            switch (min, max) {
            case let (.some(min), .some(max)): reason += ". Must be between \(min) and \(max)"
            case let (.some(min), .none): reason += ". Must be longer than \(min)"
            case let (.none, .some(max)): reason += ". Must less than \(max)"
            case (.none, .none): reason += "."
            }
            
            return reason
        case let .custom(key: key, reason: reason, identifier: _):
            if let reason = reason {
                return reason
            }
            
            return "Validation failed for key: \(key ?? "(not set)")"
        }
    }
    
    public var identifier: String {
        switch self {
        case .missingValue(key: _):
            return "missing_field"
        case .invalidLength(key: _, min: _, max: _):
            return "invalid_length"
        case .invalidValue(key: _, found: _, expected: _):
            return "invalid_value"
        case let .custom(key: _, reason: _, identifier: identifier):
            return identifier
        }
    }
    
    public var metadata: Node? {
        var node = Node(nil)
        
        try? node.set("reason", reason)
        try? node.set("identifier", identifier)
        
        switch self {
        case .missingValue(key: let key):
            try? node.set("key", key)
        case let .invalidLength(key: key, min: min, max: max):
            try? node.set("key", key)
            try? node.set("min", min)
            try? node.set("max", max)
        case let .invalidValue(key: key, found: found, expected: expected):
            try? node.set("key", key)
            try? node.set("found", found)
            try? node.set("expected", expected)
        case let .custom(key: key, reason: _, identifier: _):
            try? node.set("key", key)
        }
        
        return node
    }
}
