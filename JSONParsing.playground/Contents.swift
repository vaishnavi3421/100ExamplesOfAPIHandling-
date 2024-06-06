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
