import XCTest
import JSON
@testable import Validate

private struct User: Validatable {
    let json: JSON
    
    init(json: JSON) {
        self.json = json
    }
    
    enum CoolnessLevel: String, CaseIterable {
        case amazing, awesome, prettyCool, swell, yeahNo
    }
    
    enum Keys: String, KeyRepresentable {
        case username, email, images, location, thumbnail, street, city, state, coolness
        case postcode, latitude, longitude
        case firstName = "first_name"
        case lastName = "last_name"
        case isAwesome = "is_awesome"
        case isCool = "is_cool"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pastCoolness = "past_coolness"
        case notCoolness = "not_coolness"
    }
}

final class ValidateTests: XCTestCase {
    private var json: JSON!
    private var user: User!
    
    override func setUp() {
        json = JSON([
            "username": "hegdal",
            "email": "rolf.hegdal@example.com",
            "first_name": "Rolf",
            "last_name": "Hegdal",
            "is_awesome": true,
            "is_cool": false,
            "thumbnail": "https://randomuser.me/api/portraits/thumb/men/65.jpg",
            "street": "ljan terrasse 346",
            "city": "vear",
            "state": "rogaland",
            "postcode": 3095,
            "latitude": 54.8646,
            "longitude": -97.3136,
            "created_at": "Wed, 04 Nov 2015 14:09:36 -0800",
            "updated_at": "Sun, 27 Jan 2019 09:07:34 +0000",
            "not_a_date": "What Sunday? Monday?, I dunno",
            "coolness": "swell",
            "past_coolness": "amazing",
            "not_coolness": "yoyo",
        ])
        
        user = User(json: json)
    }
    
    func testValidateOptionalString() {
        XCTAssertEqual("Rolf", Validate.optionalString(json: json, key: "first_name"))
        XCTAssertEqual(nil, Validate.optionalString(json: json, key: "random"))
        XCTAssertEqual("hegdal", Validate.optionalString(json: json, key: User.Keys.username))
        
        XCTAssertEqual("Hegdal", user.optionalString(key: "last_name"))
        XCTAssertEqual(nil, user.optionalString(key: "wouwsa"))
        XCTAssertEqual("rolf.hegdal@example.com", user.optionalString(key: User.Keys.email))
    }
    
    func testValidateString() {
        XCTAssertEqual("Rolf", try Validate.string(json: json, key: "first_name"))
        XCTAssertThrowsError(try Validate.string(json: json, key: "random"))
        XCTAssertEqual("hegdal", try Validate.string(json: json, key: User.Keys.username))
        
        XCTAssertEqual("Hegdal", try user.string(key: "last_name"))
        XCTAssertThrowsError(try user.string(key: "wouwsa"))
        XCTAssertEqual("rolf.hegdal@example.com", try user.string(key: User.Keys.email))
    }
    
    func testOptionalInt() {
        XCTAssertEqual(3095, Validate.optionalInt(json: json, key: "postcode"))
        XCTAssertEqual(3095, Validate.optionalInt(json: json, key: User.Keys.postcode))
        XCTAssertEqual(nil, Validate.optionalInt(json: json, key: "test"))
        
        XCTAssertEqual(3095, user.optionalInt(key: "postcode"))
        XCTAssertEqual(3095, user.optionalInt(key: User.Keys.postcode))
        XCTAssertEqual(nil, user.optionalInt(key: "test"))
    }
    
    func testInt() {
        XCTAssertEqual(3095, try Validate.int(json: json, key: "postcode"))
        XCTAssertEqual(3095, try Validate.int(json: json, key: User.Keys.postcode))
        XCTAssertThrowsError(try Validate.int(json: json, key: "test"))
        
        XCTAssertEqual(3095, try user.int(key: "postcode"))
        XCTAssertEqual(3095, try user.int(key: User.Keys.postcode))
        XCTAssertThrowsError(try user.int(key: "test"))
    }
    
    func testValidateOptionalBool() {
        XCTAssertEqual(true, Validate.optionalBool(json: json, key: "is_awesome"))
        XCTAssertEqual(true, Validate.optionalBool(json: json, key: User.Keys.isAwesome))
        XCTAssertEqual(nil, Validate.optionalBool(json: json, key: "stuff"))
        
        XCTAssertEqual(false, user.optionalBool(key: "is_cool"))
        XCTAssertEqual(false, user.optionalBool(key: User.Keys.isCool))
        XCTAssertEqual(nil, user.optionalBool(key: "yolo"))
    }
    
    func testValidateBool() {
        XCTAssertEqual(true, try Validate.bool(json: json, key: "is_awesome"))
        XCTAssertEqual(true, try Validate.bool(json: json, key: User.Keys.isAwesome))
        XCTAssertThrowsError(try Validate.bool(json: json, key: "stuff"))
        
        XCTAssertEqual(false, try user.bool(key: "is_cool"))
        XCTAssertEqual(false, try user.bool(key: User.Keys.isCool))
        XCTAssertThrowsError(try user.bool(key: "yolo"))
    }
    
    func testOptionalDouble() {
        XCTAssertEqual(54.8646, Validate.optionalDouble(json: json, key: "latitude"))
        XCTAssertEqual(-97.3136, Validate.optionalDouble(json: json, key: User.Keys.longitude))
        XCTAssertEqual(nil, Validate.optionalDouble(json: json, key: "test"))
        
        XCTAssertEqual(-97.3136, user.optionalDouble(key: "longitude"))
        XCTAssertEqual(54.8646, user.optionalDouble(key: User.Keys.latitude))
        XCTAssertEqual(nil, user.optionalDouble(key: "test"))
    }
    
    func testDouble() {
        XCTAssertEqual(54.8646, try Validate.double(json: json, key: "latitude"))
        XCTAssertEqual(-97.3136, try Validate.double(json: json, key: User.Keys.longitude))
        XCTAssertThrowsError(try Validate.double(json: json, key: "test"))
        
        XCTAssertEqual(-97.3136, try user.double(key: "longitude"))
        XCTAssertEqual(54.8646, try user.double(key: User.Keys.latitude))
        XCTAssertThrowsError(try user.double(key: "test"))
    }
    
    func testValidateOptionalDate() {
        let createdAt = Date(timeIntervalSince1970: 1446674976)
        let updatedAt = Date(timeIntervalSince1970: 1548580054)
        
        XCTAssertEqual(createdAt, Validate.optionalDate(json: json, key: "created_at"))
        XCTAssertEqual(updatedAt, Validate.optionalDate(json: json, key: User.Keys.updatedAt))
        XCTAssertEqual(nil, Validate.optionalDate(json: json, key: "whatever"))
        XCTAssertEqual(nil, Validate.optionalDate(json: json, key: "not_a_date"))
        
        XCTAssertEqual(updatedAt, user.optionalDate(key: User.Keys.updatedAt))
        XCTAssertEqual(createdAt, user.optionalDate(key: "created_at"))
        XCTAssertEqual(nil, user.optionalDate(key: "whatever"))
    }
    
    func testValidateDate() {
        let createdAt = Date(timeIntervalSince1970: 1446674976)
        let updatedAt = Date(timeIntervalSince1970: 1548580054)
        
        XCTAssertEqual(createdAt, try Validate.date(json: json, key: "created_at"))
        XCTAssertEqual(updatedAt, try Validate.date(json: json, key: User.Keys.updatedAt))
        XCTAssertThrowsError(try Validate.date(json: json, key: "whatever"))
        XCTAssertThrowsError(try Validate.date(json: json, key: "not_a_date"))
        
        XCTAssertEqual(updatedAt, try user.date(key: User.Keys.updatedAt))
        XCTAssertEqual(createdAt, try user.date(key: "created_at"))
        XCTAssertThrowsError(try user.date(key: "whatever"))
    }
    
    func testValidateOptionalEnum() {
        XCTAssertEqual(User.CoolnessLevel.swell, try Validate.optionalEnum(json: json,
                                                                           oneOf: User.CoolnessLevel.self,
                                                                           key: "coolness"))
        XCTAssertEqual(User.CoolnessLevel.amazing, try Validate.optionalEnum(json: json,
                                                                             oneOf: User.CoolnessLevel.self,
                                                                             key: User.Keys.pastCoolness))
        XCTAssertEqual(nil, try Validate.optionalEnum(json: json, oneOf: User.CoolnessLevel.self,
                                                      key: "nah"))
        XCTAssertThrowsError(try Validate.optionalEnum(json: json, oneOf: User.CoolnessLevel.self,
                                                       key: User.Keys.notCoolness))
        
        XCTAssertEqual(User.CoolnessLevel.swell, try user.optionalEnum(oneOf: User.CoolnessLevel.self,
                                                                       key: "coolness"))
        XCTAssertEqual(User.CoolnessLevel.amazing, try user.optionalEnum(oneOf: User.CoolnessLevel.self,
                                                                         key: User.Keys.pastCoolness))
    }
    
    func testValidateEnum() {
        XCTAssertEqual(User.CoolnessLevel.swell, try Validate.enum(json: json,
                                                                   oneOf: User.CoolnessLevel.self,
                                                                   key: "coolness"))
        XCTAssertEqual(User.CoolnessLevel.amazing, try Validate.enum(json: json,
                                                                     oneOf: User.CoolnessLevel.self,
                                                                     key: User.Keys.pastCoolness))
        XCTAssertThrowsError(try Validate.enum(json: json, oneOf: User.CoolnessLevel.self,
                                               key: "nah"))
        XCTAssertThrowsError(try Validate.optionalEnum(json: json, oneOf: User.CoolnessLevel.self,
                                                       key: User.Keys.notCoolness))
        
        XCTAssertEqual(User.CoolnessLevel.swell, try user.enum(oneOf: User.CoolnessLevel.self,
                                                                       key: "coolness"))
        XCTAssertEqual(User.CoolnessLevel.amazing, try user.enum(oneOf: User.CoolnessLevel.self,
                                                                 key: User.Keys.pastCoolness))
    }

    static var allTests = [
        ("testValidateOptionalString", testValidateOptionalString),
        ("testValidateString", testValidateString),
        ("testValidateOptionalBool", testValidateOptionalBool),
        ("testValidateBool", testValidateBool),
        ("testOptionalInt", testOptionalInt),
        ("testInt", testInt),
        ("testOptionalDouble", testOptionalDouble),
        ("testDouble", testDouble),
        ("testValidateOptionalDate", testValidateOptionalDate),
        ("testValidateDate", testValidateDate),
        ("testValidateEnum", testValidateEnum)
    ]
}
