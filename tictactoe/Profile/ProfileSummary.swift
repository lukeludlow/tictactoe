//
//  ProfileSummary.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-26.
//

import SwiftUI

struct ProfileSummary: View {
    var profile: Profile
    
    static let goalFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        List {
            Text(profile.username)
                .bold()
                .font(.title)
            Text("notifications: \(self.profile.prefersNotifications ? "on" : "off")")
            Text("seasonal photos: \(self.profile.seasonalPhoto.rawValue)")
            Text("goal date: \(self.profile.goalDate, formatter: Self.goalFormat)")
            VStack(alignment: .leading) {
                Text("completed badges")
                    .font(.headline)
                ScrollView {
                    HStack {
                        HikeBadge(name: "first hike")
                        HikeBadge(name: "earth day")
                            .hueRotation(Angle(degrees: 90))
                        HikeBadge(name: "tenth hike")
                            .grayscale(0.5)
                            .hueRotation(Angle(degrees: 45))
                    }
                }
                .frame(height: 140)
            }
        }
    }
}

struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary(profile: Profile.default)
    }
}
