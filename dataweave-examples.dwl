%dw 2.0
output application/json

import * from dw::core::Strings
// last, isAlpha, countCharactersBy, isNumeric

import * from dw::core::Binaries
// toBase64, fromBase64

import * from dw::util::Values
// update - https://docs.mulesoft.com/dataweave/latest/dataweave-pattern-matching

import try, orElse, orElseTry from dw::Runtime


// typed-error-msg: error.muleMessage.payload
// json validation error field : error.errorMessage.payload


var colourString = "Red,Blue,Green"

var colours = colourString splitBy(',')
//var colours = ["Red", "Blue", "Green"]
var colourString2 = colours joinBy(':')

fun filterMatching(colour) = colours filter ($ != "Red")

var nonRed = filterMatching("Red")

var colourIdx = colours map ((item, idx) -> {
    (idx): item
})

var colourReducedList = colours reduce ((curr, acc = ">") -> curr ++ ":" ++ acc)


fun hasColour(c) = if(colours contains c) 
                        "found"
                    else if(c == "")
                        "empty colour"
                    else
                        "not found"

var aa = write(colours, "application/json")       
var regExStr = ["123-456-7890" replace /.*-/ with(""), "abc123def" replace /[b13e]/ with("-")]

// Local variable with "do"
var myVar = 1234
var myDo =  do {
    var fn = "Annie"
    var ln = "Point"
    ---
    {
      id : myVar,
      firstname : fn,
      lastname : ln
    }
}
// Local variable with using
var person1 = {
  person: using (user = "Robin", age = "5") { 
    name: user, 
    age: age
  }
}
// 


var payloadWithCredentials = {
    "AccountID": "DWX22341",
    "Login": {
        "Username": "DWX",
        "Password": "Test123#"
    }
}

fun maskPWD(src) = src update {
    case .Login.Password -> '***'
}

var simpleJsonObj1 = {
    "a": "1",
    "b": "2"
}

fun convertObjectToArray(obj) = pluck(obj, (value, key, index) -> {
    (index): {
        (value): key
    }
})


var pet = {
    "Id": "P523914",
    "Type": "Dog",
    "Owner": {
        "FirstName": "Jane",
        "Contact": "jane@pet.com"
    }
}
var mappedPet = pet mapObject ((value, key, index) -> {
//    no: index,
//    key: upper(key),
//    value: value
      (upper(key)): value
})


var isValidTry = try(() -> {
    status: 'valid',
}) orElse ({
    status: 'invalid'
})

var formatTime1 = (now() >> 'UTC') as DateTime {format: "dd-MMM-yy hh.mm.ss.SSSSSSSSS a VV"} as String {format: "yyyy-MM-dd'T'HH:mm:ss:SSS Z"}

var formatTime2 = "date6": (now() >> 'Pacific/Auckland') as DateTime {format: "dd-MMM-yy hh.mm.ss.SSSSSSSSS a VV"} as String {format: "yyyy-MM-dd'T'HH:mm:ss:SSS Z"}


var numberOfDays = 3
fun getActiveFinancial(pw) = pw.detail.financialRoles
    filter $.financialAccount.accountStatus == 'active'
        map ({
            isOwner: $.primaryOwner,
            accountId: $.financialAccount.id
        })

fun updateFields(pw) = pw update {
    case .id -> uuid()
    case .time -> (payload.time as DateTime >> "NZ") + |P1D|
                    as String {format: "yyyy-MM-dd HH:mm:ss z"}
    case .detail.financialRoles -> getActiveFinancial(pw)
}

var updateResult = updateFields(payload)
---
"Dataweave Examples"





// {
//   "id": "48efeaz6a5-43d4-59b2-c720-d2s3w7912f46",
//   "time": "2024-06-07T01:40:52Z",
//   "detail": {
//     "gender": "M",
//     "dateOfBirth": "1980-11-25",
//     "firstName": "ANDREW",
//     "surname": "CAMERON",
//     "title": "Mr",
//     "contactDetails": [
//       {
//         "address": {
//           "address1": "1 Frankton Crescent",
//           "address2": "",
//           "suburb": "Henderson",
//           "city": "Auckland",
//           "countryCode": "NZ",
//           "postcode": "0632"
//         },
//         "mobilePhone": "0212513701",
//         "addressStatus": "V",
//         "email": "henderson@dw-test.co.nz"
//       }
//     ],
//     "financialRoles": [
//       {
//         "primaryOwner": "Y",
//         "financialAccount": {
//           "id": "ab7aaaf2-fbd3-48b2-ae9a-zaew4a954cfd",
//           "accountStatus": "active",
//           "accountCommencementDate": "2024-06-07"
//         }
//       },
//       {
//         "primaryOwner": "Y",
//         "financialAccount": {
//           "accountCommencementDate": "2024-06-07"
//         }
//       }
//     ]
//   }
// }












