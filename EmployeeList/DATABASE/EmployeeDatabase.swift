//
//  EmployeeDatabase.swift
//  EmployeeList
//
//  Created by UITOUX on 13/06/20.
//  Copyright © 2020 KGISL. All rights reserved.

import Foundation
import SQLite

class EmployeeDataBase{
    
    var database: Connection!
    let table = Table("EMPLOYEE_TABLE")
    
    let name = Expression<String>("names")
    let userId = Expression<Int>("user_id")
    let email = Expression<String>("email")
    let streetName = Expression<String>("street_name")
    let dateOfBirth = Expression<String>("dob")
    let pincode = Expression<String>("pincode")
    let userImage = Expression<Data>("user_image")
    let barCode = Expression<Data>("barcode")
    let geoLocation = Expression<String>("geo_location")
    let weather = Expression<String>("weather")
    let showIdCard = Expression<String>("false")
   
    

    init() {
        do {
            let docDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = docDirectory.appendingPathComponent("EmployeeDetails").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            print("Database created")
        }catch{
            print(error)
        }
    }
    
    func createTable(){
        let createTable = self.table.create{(table) in
            table.column(self.name)
            table.column(self.userId, primaryKey: .autoincrement)
            table.column(self.email, unique: true)
            table.column(self.dateOfBirth)
            table.column(self.streetName)
            table.column(self.pincode)
            table.column(self.userImage)
            table.column(self.barCode)
            table.column(self.geoLocation)
            table.column(self.weather)
            table.column(self.showIdCard)
            
        }
        do {
            try self.database.run(createTable)
            print("Table Created")
        }catch{
            print(error)
        }
    }
    
    func insertTable(name: String,userId: Int,email: String,dob: String,streetName: String,pincode: String,userImage: Data,barcode: Data, geoLocation: String,weather: String,showIdCard: String) -> Bool{

        let insertToTable = self.table.insert(self.name <- name, self.userId <- userId, self.email <- email, self.dateOfBirth <- dob, self.streetName <- streetName, self.pincode <- pincode, self.userImage <- userImage, self.barCode <- barcode,self.geoLocation <- geoLocation, self.weather <- weather, self.showIdCard <- showIdCard)

        do {
            try self.database.run(insertToTable)
            print("Table value inserted")
            return true
        }catch {
            print(error)
            return false
        }
    }
 
    func updateUser(employee: EmployeeList) -> Bool{

        let userID = self.table.filter(self.userId == employee.userID)
        let updateUser = userID.update(self.name <- employee.name,self.email <- employee.email,self.dateOfBirth <- employee.dob,self.streetName <- employee.streetName,self.pincode <- employee.pincode,self.userImage <- employee.userImage,self.barCode <- employee.barCode, self.geoLocation <- employee.geoLocation, self.weather <- employee.weather,self.showIdCard <- employee.showIdCard)
        do{
            try self.database.run(updateUser)
            print("updated")
            return true
        }catch{
            print(error)
            return false
        }
    
    }
    
    func getTable() -> [EmployeeList]{
        var employees = [EmployeeList]()
        
        do {
            for rows in try self.database.prepare(self.table){
                let nameString = rows[self.name]
                let userID = rows[self.userId]
                let email = rows[self.email]
                let dob = rows[self.dateOfBirth]
                let streetName = rows[self.streetName]
                let pincode = rows[self.pincode]
                let userImage = rows[self.userImage]
                let barCode = rows[self.barCode]
                let geoLocation = rows[self.geoLocation]
                let weather = rows[self.weather]
                let showIdCard = rows[self.showIdCard]
                let employee: EmployeeList = EmployeeList(name: nameString, userID: userID, email: email, dob: dob, streetName: streetName, pincode: pincode, userImage: userImage, barCode: barCode,geoLocation: geoLocation, weather: weather, showIdCard: showIdCard)
                employees.append(employee)
            }
        }catch{
            print("can't get table data")
        }
        return employees
    }
    
    

    func delete(userID: Int){
        let user = self.table.filter(self.userId == userID)
                   let deleteUser = user.delete()
        do {
            try self.database.run(deleteUser)
           }catch {
                print(error)
           }
    }
    
    
}

