import UIKit
// Parsing JSON using JSONSerialization
let json1 = """


{
    "Firstname" : "Vaish" ,
    "Lastname" : "Waghule" ,
    "age" : 45
 
}

""".data(using: .utf8)!

if let dictionary = try! JSONSerialization.jsonObject(with: json1,options: .allowFragments) as? [String:Any] {
    dictionary["Firstname"]
    dictionary["Lastname"]
    dictionary["age"]
}
//Maping JSON result to customer Model
struct customer {
    var Firstname : String
    var Lastname : String
    var age : Int
    // there is already a initializer it may be override
    
}
extension customer {
    init?(dictionary : [String : Any]) {
        guard let firstname =  dictionary["Firstname"] as? String ,
                let lastname = dictionary["Lastname"] as? String,
              let age = dictionary["age"] as? Int else {
            return nil
        }
        self.Firstname = firstname
        self.Lastname = lastname
        self.age = age
    }
}

let json = """


{
    "Firstname" : "Vaish" ,
    "Lastname" : "Waghule" ,
    "age" : 45
 
}

""".data(using: .utf8)!

if let dictionary = try! JSONSerialization.jsonObject(with: json,options: .allowFragments) as? [String:Any] {
    if let customer = customer(dictionary: dictionary) {
        print(customer)
    }
}

//Fixing Playgrounds error
/* 1]
 command + spaceBar => Search for "Activity Monitor"
 find " homed " and Quit
   2]
 press and hold run button changed the setting from manually-> Automaticlly->manually
 */

//Mapping JSON Array

let json2 = """

[
{
    "Firstname" : "Vaish" ,
    "Lastname" : "Waghule" ,
    "age" : 45
},
{
    "Firstname" : "Allu" ,
    "Lastname" : "Arjun" ,
    "age" : 50
},
{
    "Firstname" : "Amir" ,
    "Lastname" : "Khan" ,
    "age" : 57
}
]

""".data(using: .utf8)!

if let customerDictionaries = try! JSONSerialization.jsonObject(with: json2,options: .allowFragments) as? [[String:Any]] {
    let customers = customerDictionaries.compactMap (customer.init)
print("********************")
    print(customers)
}
//Begining of Json Parsing using JSOn Encoder and JSOn Decoder
//Decoding JSON into Model
                    // Protocol
struct Customer1 : Decodable {
    var firstname: String
    var lastname: String
    var age: Int
    /*
    //////////////////////////////////////////////////////////
    // COding Key Protocol :- Which represents what properties you want to decode.
    //here there are 3 properties.
    private enum CodingKeys : String, CodingKey {
        case firstname
        case lastname
        case age
    }
    //init with decoder it may fails thats why we are using throwing error
    init(from decoder: Decoder) throws {
        // for container we need coding key protocol
        //it also throws an exception
       let container = try decoder.container(keyedBy: CodingKeys.self)
                                            // type , key
        self.firstname = try container.decode(String.self, forKey: .firstname)
        self.lastname = try container.decode(String.self, forKey: .lastname)
        self.age = try container.decode(Int.self, forKey: .age)
    }
    ////////////////////////////////////////////////
     */
}
//let json3 = """
//{
//    "firstname" : "Vaish" ,
//    "lastname" : "Waghule" ,
//    "age" : 45
//}
//""".data(using: .utf8)!
//let customer11 = try! JSONDecoder().decode(Customer1.self, from: json)
//print(customer11)

// Encoding Model to JSON
//If you want encode or decode at tthe same time we can use "codable"
/*
struct Customer5 : Codable {
    var Firstname : String
    var Lastname : String
    var age : Int
}
let customer5 = Customer5(Firstname: "monika", Lastname: "sundarfull", age: 25)
let encoderCustomertoJSON = try! JSONEncoder().encode(customer5)
print(encoderCustomertoJSON)

//Decoding JSON Array

struct Place : Decodable {
    var name : String
    var Latitude : Double
    var Logitude : Double
    var Visited : Bool
}
let json3 = """
[
{
"name" : "Costa rise"
"Latitude" : 23.45
"Logitude" :45.23
"Visited" : true
},
{
"name" : "Pruvcv dfii"
"Latitude" : 67.87
"Logitude" :87.56
"Visited" : true
},
{
"name" : "MAxico city"
"Latitude" : 56.9
"Logitude" :57.78
"Visited" :true
},
{
"name" : "Island"
"Latitude" :98.56
"Logitude" :89.45
"Visited" :false

}
]
""".data(using: .utf8)!
 let places = try! JSONDecoder().decode([Place].self, from: json3)
places[0].name
places[1].name
places[2].name
print(places)
*/

/// Intermidiate JSON parsing using ENcoder and decoder

// [1] Decoding basic key- value type
print("##############################################")
struct PlacesResponse : Decodable {
    var places :[Place]
}
struct Place : Decodable {
    var name :String
    var latitude :Double
    var longitude :Double
}
let json4 = """
{
     "places":[
            {
                "name" : "Costa Rica",
                "latitude" : 34.56,
                "longitude" : 65.67
            },
            {
                "name" : "Boston",
                "latitude" : 134.56,
                "longitude" : 265.67
            }
            ]
}
""".data(using: .utf8)!
let placesResponse = try! JSONDecoder().decode(PlacesResponse.self, from: json4)
print(placesResponse.places)

//let placesDictionary = try! JSONDecoder().decode([String:[Place]].self, from: json)
//let places = placesDictionary["places"]
//print(places)

// places dictionary is not working

struct LocationResponse : Decodable {
    let locations :[Location]
    // here locations are match with locations within json
}

struct Location : Decodable{
    let name : String
    let latitude : Double
    let longitude : Double
}

let json5 = """
{
     "locations":[
            {
                "name" : "Rica",
                "latitude" : 34.56,
                "longitude" : 65.67
            },
            {
                "name" : "Bon",
                "latitude" : 134.56,
                "longitude" : 265.67
            }
            ]
}
""".data(using: .utf8)!

let locatioResponse =  try! JSONDecoder().decode(LocationResponse.self, from: json5)
print(locatioResponse.locations)

//[2]Decoding Nested Object

struct Geo : Decodable {
    var latitude :Double
    var longitude :Double
}

struct Address : Decodable {
    var street :String
    var city :String
    var state :String
    var geo :Geo
}


struct Customer : Decodable {
    var firstName :String
    var lastName :String
    var address :Address
}

struct CustomersResponse :Decodable {
    var customers :[Customer]
}


let json6 = """

{
    "customers":[
        {
            "firstName" : "John",
            "lastName" : "Doe",
            "address" : {
                "street" : "1200 Richmond Ave",
                "city" : "Houston",
                "state" : "TX",
                "geo" : {
                    "latitude" : 34.56,
                    "longitude" : 35.65
                }
            }
        }
    
    ]

}

""".data(using: .utf8)!

let customersResponse = try! JSONDecoder().decode(CustomersResponse.self, from: json6)
print(customersResponse)
print(customersResponse.customers[0].address.geo.latitude)

//Decoding Enum
//Decoding Dates and Timestamps
//for date formatter: reference :- useyourloaf.com
extension DateFormatter {
    static let iso8601full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm/dd/yyyy"
        return formatter
    }()
}

enum AddressType : String, Decodable {
    case apartment = "apartment"
    case house = "house"
    case condo = "condo"
    case townHouse = "townHouse"
}

struct Geo1 : Decodable {
    var latitude :Double
    var longitude :Double
}
struct Address1 : Decodable {
    var street :String
    var city :String
    var state :String
    var geo1 :Geo1
    var addressType :AddressType
}



struct Customer11 : Decodable {
    var firstName :String
    var lastName :String
    var dateCreated : Date
    var address1 :Address1
}


struct CustomerRespo : Decodable {
    var customers11 : [Customer11]
}
let json7 = """

{
    "customers11":[
        {
            "firstName" : "John",
            "lastName" : "Doe",
            "dateCreated" : "05/04/2000",
            "address1" : {
                "street" : "1200 Richmond Ave",
                "city" : "Houston",
                "state" : "TX",
                "geo1" : {
                    "latitude" : 34.56,
                    "longitude" : 35.65
                },
                "addressType" : "condo"
            }
        }
    
    ]

}

""".data(using: .utf8)!

let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601full)

 let customerRespo = try! decoder.decode(CustomerRespo.self, from: json7)
print (customerRespo)
//print(customerRespo.customers11[0].address1.addressType.rawValue)

//Handling property name mismatched
// use .convertFromSnakeCase

//struct student : Decodable {
//    var firstname : String
//    var lastname : String
//    var age : Int
//}
//let json9 = """
//
//{
//    "first-name" : "vaish",
//    "last-name"  : "Waghule",
//    "age" : 23
//}
//""".data(using: .utf8)!
//
//print ("@@@@@@@@@@@@@@")
//
//let decoder111 = JSONDecoder()
//decoder.keyDecodingStrategy = .convertFromSnakeCase
//
//let Student = try! decoder111.decode(student.self, from: json9)
//print(Student)


struct Customer222 : Decodable {
    var firstName222 :String
    var lastName222 :String
    var age222 :Int
}

let json222 = """

{
    "first_name" : "John",
    "last_name" : "Doe",
    "age" : 34
}

""".data(using: .utf8)!

let decoder222 = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let customer222 = try! decoder222.decode(Customer222.self, from: json222)

print(customer222)

//Coding Key





//struct Address : Decodable {
//    var street :String
//    var state  :String
//    var zipCode :String
//    
//    private enum CodingKeys : String, CodingKey {
//        case street = "STREET"
//        case state = "STATE"
//        case zipCode = "ZIPCODE"
//    }
//}
//
//struct Customer : Decodable {
//    var firstName :String
//    var lastName :String
//    var age :Int
//    var address :Address?
//    
//    private enum CodingKeys : String, CodingKey {
//        case firstName = "FIRSTNAME"
//        case lastName = "LASTNAME"
//        case age = "AGE"
//        case address = "ADDRESS"
//    }
//}
//
//let json = """
//
//{
//    "FIRSTNAME" : "John",
//    "LASTNAME" : "Doe",
//    "AGE" : 34,
//    "ADDRESS": {
//        "STREET" : "1200 Richmond Ave",
//        "STATE" : "TX",
//        "ZIPCODE" : "77042"
//    }
//}
//
//""".data(using: .utf8)!
//
//let decoder = JSONDecoder()
//let customer = try! decoder.decode(Customer.self, from: json)
//
//print(customer)
//
//





