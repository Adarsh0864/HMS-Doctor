//
//  Staff.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 19/03/25.
//

import Foundation

enum Role: String, Codable {
    case doctor
}

struct UnavailablePeriod: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
    }

    let startDate: Date
    let endDate: Date

}

struct Staff: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case emailAddress = "email_address"
        case password = "password"
        case contactNumber = "contact_number"
        case specializations = "specializations"
        case department = "department"
        case onLeave = "on_leave"
        case unavailabilityPeriods = "unavailability_periods"
        case licenseId = "license_id"
        case role = "role"
    }

    var id: String = UUID().uuidString
    var firstName: String
    var lastName: String?

    var emailAddress: String
    var password: String
    var contactNumber: String
    var specializations: [String]
    var department: String
    var onLeave: Bool = false

    var unavailabilityPeriods: [UnavailablePeriod] = []
    var licenseId: String
    var role: Role = .doctor

    var fullName: String {
        let lastName = lastName ?? ""
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }

}
