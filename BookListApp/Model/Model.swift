//
//  Model.swift
//  BookListApp
//
//  Created by Malik Em on 22.09.2022.
//

import Foundation
import UserNotifications
import UIKit

var bookListItems: [[String: Any]] = []

func addItem(nameItem: String, isCompleted: Bool = false) {
    bookListItems.append(["Name": nameItem, "isCompleted": false])
    setBadge()
    saveData()
}

func deleteItem(at index: Int) {
    bookListItems.remove(at: index)
    setBadge()
    saveData()
}

func changeState(at item: Int) -> Bool {
    bookListItems[item]["isCompleted"] = !(bookListItems[item]["isCompleted"] as! Bool)
    setBadge()
    saveData()
    return bookListItems[item]["isCompleted"] as! Bool
}

func moveItem(fromIndex: Int, toIndex: Int) {
    let from = bookListItems[fromIndex]
    bookListItems.remove(at: fromIndex)
    bookListItems.insert(from, at: toIndex)
}

func saveData() {
    UserDefaults.standard.set(bookListItems, forKey: "BookListItemsData")
    UserDefaults.standard.synchronize()
}

func loadData() {
    if let array = UserDefaults.standard.array(forKey: "BookListItemsData") as? [[String: Any]] {
        bookListItems = array 
    } else {
        bookListItems = []
    }
}

func requestForNotification() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { isEnabled, error in
        if isEnabled {
            print("Согласие получено")
        } else {
            print("Пришел отказ")
        }
    }
}

func setBadge() {
    var totalBadgeNumber = 0
    for item in bookListItems {
        if (item["isCompleted"] as? Bool) == false {
            totalBadgeNumber += 1
        }
    }
    UIApplication.shared.applicationIconBadgeNumber = totalBadgeNumber
}
