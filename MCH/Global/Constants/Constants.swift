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
    
    public enum HomeScreen: String {
        case storyboardId = "ProfileViewController"
    }
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

}
