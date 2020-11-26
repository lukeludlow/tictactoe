//
//  ProfileEditor.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-26.
//

import SwiftUI

struct ProfileEditor: View {
    @Binding var profile: Profile
    
    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: profile.goalDate)!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: profile.goalDate)!
        return min...max
    }
        
    var body: some View {
        List {
            HStack {
                Text("username").bold()
                Divider()
                TextField("username", text: $profile.username)
            }
            Toggle(isOn: $profile.prefersNotifications) {
                Text("enable notifications")
            }
            VStack(alignment: .leading, spacing: 20) {
                Text("seasonal photo")
                    .bold()
                Picker("seasonal photo", selection: $profile.seasonalPhoto) {
                    ForEach(Profile.Season.allCases, id: \.self) { season in
                        Text(season.rawValue)
                            .tag(season)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.top)
            VStack(alignment: .leading, spacing: 20) {
                Text("goal date")
                    .bold()
                DatePicker(
                    "goal date",
                    selection: $profile.goalDate,
                    in: dateRange,
                    displayedComponents: .date
                )
            }
            .padding(.top)
        }
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(profile: .constant(.default))
    }
}
