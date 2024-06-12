import UIKit

//Decoding Arbitrary types

import UIKit

struct AnyDecodable : Decodable {
    
    let value :Any
    
    init<T>(_ value :T?) {
        self.value = value ?? ()
    }
    
    init(from decoder :Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        
        if let string = try? container.decode(String.self) {
            self.init(string)
        } else if let int = try? container.decode(Int.self) {
            self.init(int)
        } else {
            self.init(())
        }
        
    }
    
}

let json = """

{
   "foo" : "Hello",
   "bar" : 123
}

""".data(using: .utf8)!

let dictionary = try! JSONDecoder().decode([String:AnyDecodable].self, from: json)
dictionary["bar"]?.value
print(dictionary)


//Decoding Inherited type

class Car : Decodable {
    var make :String = ""
    var model :String = ""
    
    init() {
        
    }
}
class ElectricCar : Car {
    
    var range :Double
    var hasAutoPilot :Bool
    
    private enum CodingKeys : String, CodingKey {
        case range = "range"
        case hasAutoPilot = "hasAutoPilot"
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.range = try container.decode(Double.self, forKey: .range)
        self.hasAutoPilot = try container.decode(Bool.self, forKey: .hasAutoPilot)
        try super.init(from: decoder)
    }
}

let json2 = """

{
    "make" : "Tesla",
    "model" : "Model X",
    "range" : 250,
    "hasAutoPilot" : true
}

""".data(using: .utf8)!

let electricCar = try! JSONDecoder().decode(ElectricCar.self, from: json2)
print(electricCar.make)
print(electricCar.model)
print(electricCar.range)
print(electricCar.hasAutoPilot)


//Decoding from different type of values


struct Place :Decodable {
    
    var latitude :Double
    var longitude :Double
    
    private enum CodingKeys :String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    init(from decoder :Decoder) throws {
        
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            self.latitude = try container.decode(Double.self, forKey: .latitude)
            self.longitude = try container.decode(Double.self, forKey: .longitude)
        }
        else if var container = try? decoder.unkeyedContainer() {
            
            self.latitude = try container.decode(Double.self)
            self.longitude = try container.decode(Double.self)
        }
        else if let container = try? decoder.singleValueContainer() {
            
            let string = try container.decode(String.self)
            let values = string.components(separatedBy: ",")
            
            guard values.count == 2,
                let latitude = Double(values[0]),
                let longitude = Double(values[1]) else {
                    
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unable to decode coordinates")
            }
            
            self.latitude = latitude
            self.longitude = longitude
            
        }
        
        else {
            let context = DecodingError.Context.init(codingPath: decoder.codingPath, debugDescription: "Unable to decode coordinates!")
            throw DecodingError.dataCorrupted(context)
        }
        
    }
}

let payload1 = """

{
    "coordinates": [
        {
            "latitude": 37.332,
            "longitude": -122.011
        }
    ]
}

""".data(using: .utf8)!

let payload2 = """

{
    "coordinates": [
       [37.332,-122.011]
    ]
}

""".data(using: .utf8)!

let payload3 = """

{
    "coordinates": [
       "37.332,-122.011"
    ]
}

""".data(using: .utf8)!


let placesDictionary = try! JSONDecoder().decode([String:[Place]].self, from: payload3)
if let places = placesDictionary["coordinates"] {
    places[0].latitude
    places[0].longitude
}

//Implementing Custom encoding strategy

typealias Temperature = Double

extension Temperature {
    
    func toCelsius() -> Temperature {
        return (self - 32 * 5/9) + 32
    }
    
    func toFahrenheit() -> Temperature {
        return (self * 9/5)
    }
}

private enum TemperatureEncodingStrategy {
    case fahrenheit
    case celsius
}

extension CodingUserInfoKey {
    static let temperatureEncodingStrategy = CodingUserInfoKey.init(rawValue: "temperatureEncodingStrategy")!
}

struct Thermostat : Encodable {
    
    var readings :[Temperature]
    
    func encode(to encoder :Encoder) throws {
        
        var container = encoder.singleValueContainer()
        
        switch encoder.userInfo[CodingUserInfoKey.temperatureEncodingStrategy] as? TemperatureEncodingStrategy {
            
        case .celsius?:
            try container.encode(self.readings.map { $0.toCelsius() })
        
        case .fahrenheit?:
            try container.encode(self.readings.map { $0.toFahrenheit() })
        default:
             try container.encode(self.readings.map { $0.toCelsius() })
        }
    }
}

let readings = [12.34,23.45,56.78]

let encoder = JSONEncoder()
encoder.userInfo[CodingUserInfoKey.temperatureEncodingStrategy] = TemperatureEncodingStrategy.celsius

let thermostat = Thermostat(readings: readings)
let data = try! encoder.encode(thermostat)

print(String(data: data, encoding: .utf8))


//Decoding json in flat model

//1] Prepereing json amd model
let jsonData :Data = """

{
"id": 1,
"name": "Leanne Graham",
"username": "Bret",
"email": "Sincere@april.biz",
"address": {
    "street": "Kulas Light",
    "suite": "Apt. 556",
    "city": "Gwenborough",
    "zipcode": "92998-3874",
           }
}

""".data(using: .utf8)!
struct user : Decodable {
    let id : Int
    let name : String
    let username : String
    let email : String
    
    let street : String
    let suite : String
    let city : String
    let zipcode : String
    
    
    //Decoding the user
    private enum userKey : String , CodingKey {
        case id
        case name
        case username = "username"
        case email
        case address
    }
    private enum AddressKey : String , CodingKey {
        case street
        case suite
        case city
        case zipcode
    }
    
    init(from decoder : Decoder) throws {
        let container =  try decoder.container(keyedBy: userKey.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.username = try container.decode(String.self, forKey: .username)
        self.email =  try container.decode(String.self, forKey: .email)
        //Decoding Address
        let addresscontainer = try container.nestedContainer(keyedBy: AddressKey.self, forKey: .address)
        self.street = try addresscontainer.decode(String.self, forKey: .street)
        self.suite = try addresscontainer.decode(String.self, forKey: .suite)
        self.city = try addresscontainer.decode(String.self, forKey: .city)
        self.zipcode = try addresscontainer.decode(String.self, forKey: .zipcode)
        
    }
}

let User = try JSONDecoder().decode(user.self, from: jsonData)
    print(User.name)
    print(User.city)

// Consuming Json in Web API

//fetching data from api using urlSession


    struct Address : Decodable {
        var street : String
        var suite : String
        var city : String
        var geo : Geo
    }
    struct User1 : Decodable {
        var id : Int
        var name : String
        var username : String
        var email : String
        var address : Address
       
    }
struct Geo: Decodable {
    
    let latitude: String
    let longitude: String
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}


let url = URL(string:"https://jsonplaceholder.typicode.com/users")!
URLSession.shared.dataTask(with: url) { data, response, error in
    
    guard error == nil,
          let data = data else {
        print(error)
        return
    }
    let user = try? JSONDecoder().decode([User1].self, from: data)
    if let user = user {
         print(data)
        print(user[0].name)
        print(user[0].address.street)
        print("*****************")
        print(user[0].geo.longitude)
    }
    
    }.resume()
    
    //Implementing and Populating models with the APi result
    
//Custom key



 
struct User: Decodable {
    let name: String
    let age: Int
}
 
struct AnyKey: CodingKey {
    
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    init?(intValue: Int) {
        return nil
    }
}
 
struct DecodingStrategy {
    
    static var firstUpperCaseLetter: ([CodingKey]) -> CodingKey {
        return { keys -> CodingKey in
            let key = keys.first!
            let modifiedKey = key.stringValue.prefix(1).lowercased() + key.stringValue.dropFirst()
            return AnyKey(stringValue: modifiedKey)!
        }
    }
    
}
 
let json = """
    {
        "Name": "John Doe",
        "Age": 34
    }
"""
 
guard let jsonData = json.data(using: .utf8) else {
    throw fatalError("Unable to get data!")
}
 
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .custom(DecodingStrategy.firstUpperCaseLetter)
 
let user = try? decoder.decode(User.self, from: jsonData)
print(user)
