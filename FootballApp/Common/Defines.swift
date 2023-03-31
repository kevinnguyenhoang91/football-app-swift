//
//  Defines.swift
//  FootballApp
//
//  Created by Kha Nguyễn on 30/03/2023.
//

import Foundation
import UIKit
import Combine

public struct Defines {
    static let baseURL = "https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com"
    static let dateFormatString = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static let displayDateFormatString = "dd/MM/yyyy - h:mm a"
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = appDelegate.persistentContainer.viewContext
}
