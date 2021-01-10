//
//  MenuStructure.swift
//  ShavermaApp
//
//  Created by Mac on 07.01.2021.
//

import Foundation
import Alamofire

// MARK: - Menu
struct Menu: Codable {
    var groups: [Group]?
    var revision: Int?
    var uploadDate: String?
    
    func getGroups() -> [String] {
        var list = [String]()
        
        for x in groups!{
            list.append(x.name ?? "Null")
        }
        
        return list
    }
    
    func getIndexes() -> [Int]{
        var list = [Int]()
        list.append(0)
        
        var temp = 0
        for x in 0...groups!.count - 1{
            temp = list[x]
            list.append(groups![x].products!.count + temp)
            print("list -> \(groups![x].products!.count)")
            print("list new -> \(groups![x].products!.count + temp)")
            
        }
        
        list.removeLast()
        return list
    }
    
    func getProducts() -> [Product]{
        var list = [Product]()
        
        for x in groups!{
            list+=x.products ?? [Product]()
        }
        
        return list
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseGroup { response in
//     if let group = response.result.value {
//       ...
//     }
//   }

// MARK: - Group
struct Group: Codable {
    var id, name: String?
    var products: [Product]?
    var order: Int?
    var parentGroup: JSONNull?
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseModifier { response in
//     if let modifier = response.result.value {
//       ...
//     }
//   }

// MARK: - Modifier
struct Modifier: Codable {
    var maxAmount, minAmount: Int?
    var modifierid: String?
    var modifierRequired: Bool?
    var defaultAmount: Int?
    var hideIfDefaultAmount: Bool?
    var products: [Product]?

    enum CodingKeys: String, CodingKey {
        case maxAmount, minAmount
        case modifierid
        case modifierRequired
        case defaultAmount, hideIfDefaultAmount, products
    }
    
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseGroupModifier { response in
//     if let groupModifier = response.result.value {
//       ...
//     }
//   }

// MARK: - GroupModifier
struct GroupModifier: Codable {
    var maxAmount, minAmount: Int?
    var modifierid: String?
    var groupModifierRequired: Bool?
    var childModifiers: [Modifier]?
    var childModifiersHaveMinMaxRestrictions: Bool?

    enum CodingKeys: String, CodingKey {
        case maxAmount, minAmount
        case modifierid
        case groupModifierRequired
        case childModifiers, childModifiersHaveMinMaxRestrictions
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseProduct { response in
//     if let product = response.result.value {
//       ...
//     }
//   }

// MARK: - Product
struct Product: Codable, Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.name == rhs.name && rhs.id == lhs.id
    }
    
    var additionalInfo: JSONNull?
    var productDescription, id, name: String?
    var carbohydrateAmount, carbohydrateFullAmount, energyAmount, energyFullAmount: Double?
    var fatAmount, fatFullAmount, fiberAmount, fiberFullAmount: Double?
    var groupModifiers: [GroupModifier]?
    var modifiers: [Modifier]?
    var price: Int?
    var weight: Double?
    var images: [String]?

    enum CodingKeys: String, CodingKey {
        case additionalInfo
        case productDescription
        case id, name, carbohydrateAmount, carbohydrateFullAmount, energyAmount, energyFullAmount, fatAmount, fatFullAmount, fiberAmount, fiberFullAmount, groupModifiers, modifiers, price, weight, images
    }
    
    mutating func get_specGMod(target: [Group]) -> [Product]? {
        var out2: [Product]?
        var prods: [Product] = [Product]()
        for gr in target{
            prods.append(contentsOf: gr.products!)
        }
        for gm in self.groupModifiers! {
            let tmp = gm.childModifiers?.filter{ mod in
                prods.contains(where: {(prod:Product) in  prod.name == (mod.products![0] as Product).name!})
            }
            if !tmp!.isEmpty{
                out2 = [Product]()
                tmp!.forEach{out2!.append($0.products![0])}
                return out2
            }
        }
        let tmp = self.modifiers?.filter{ mod in
            prods.contains(where: {(prod:Product) in  prod.name == (mod.products![0] as Product).name!})
        }
        if !tmp!.isEmpty{
            out2 = [Product]()
            tmp!.forEach{out2!.append($0.products![0])}}
        return out2
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Alamofire response handlers

//extension DataRequest {
//    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
//        return DataResponseSerializer { _, response, data, error in
//            guard error == nil else { return .failure(error!) }
//
//            guard let data = data else {
//                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
//            }
//
//            return Result { try newJSONDecoder().decode(T.self, from: data) }
//        }
//    }
//
//    @discardableResult
//    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
//        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
//    }
//
//    @discardableResult
//    func responseMenu(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Menu>) -> Void) -> Self {
//        return responseDecodable(queue: queue, completionHandler: completionHandler)
//    }
//}

// MARK: - Encode/decode helpers

@objcMembers class JSONNull: NSObject, Codable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    override public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

@objcMembers class JSONAny: NSObject, Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
