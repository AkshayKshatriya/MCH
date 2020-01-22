//
//  Constants.swift
//  MCH
//
//  Created by Akshay Gawade on 01/01/20.
//  Copyright © 2020 Akshay Gawade. All rights reserved.
//

import Foundation

public struct Constants {
    
    static let storyboardName = "Main"
    
    public enum StoryboardId: String {
        case profile = "ProfileViewController"
        case activityCenter = "ActivityCenterController"
        case searchPopUp = "SearchPopUpController"
    }
    
//    public enum HomeScreen: String {
//    }
    
//    public enum ActivityCenterController : String {
//    }
    
    public enum NavigationBar: String {
        case backIcon = "back"
    }
    public enum HamburgerIcons: String {
        case home = "home"
        case trendingUp = "trendingUp"
        case messageCircle = "messageCircle"
        case activity = "activity"
        case bell = "bell"
    }
    public enum HamburgerMenus: String {
        case home = "Home"
        case analytics = "Analytics"
        case chat = "Chat"
        case activity = "Activity Center"
        case reminders = "Remiders"
    }
    public enum ProfileScreen: String {
        case backIcon = "back"
    }
    
    public enum SearchApi: String {
        case disease = "https://clinicaltables.nlm.nih.gov/api/icd10cm/v3/search?sf=code,name&terms="
        case surgery = "https://browser.ihtsdotools.org/snowstorm/snomed-ct/browser/MAIN/2019-07-31/descriptions?limit=100&term=surgery&active=true&conceptActive=true&lang=english"
    }

}
