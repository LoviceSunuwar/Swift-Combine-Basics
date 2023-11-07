//
//  APICaller.swift
//  Combine Basics
//
//  Created by Lovice Sunuwar on 06/11/2023.
//
import Combine
import Foundation

/* Usually a fetch data froom api would have a completion handler, Something like
 func fetchData(Completion: ([String]) -> Void) {
 completion([" Some String returned")]
 }
 
 but, Now for example we are fetching a list of Fruits with combine
 instead of completion handler combione uses Future
 func fetchFruits() -> Future<[String], Error> {
 return Future { promixe in
 promixe(.sucess(["Apple, Banana, Orange, Mango"  ]))
   }
 }
 
 -> Calling on the VC (ViewController is fairly similar to the completion handler )
 
*/

class APICaller {
    static  let shared = APICaller() // Create a singleton
    
    func fetchFruits() -> Future<[String], Error> {
        return Future { promixe in
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                promixe(.success(["Apple", "Banana", "Mango", "Orange"]))
            }
        }
    }
}
