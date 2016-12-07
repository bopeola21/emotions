//
//  EmojiLibrary.swift
//  Emotions
//
//  Created by Jide O on 11/19/16.
//  Copyright © 2016 Bevi Mobile. All rights reserved.
//

import UIKit

class EmojiLibrary: NSObject {
    
    class func getEmoji(text: String) -> String? {
        
        switch text {
            case "happiness":
                return "😊"
            case "sadness":
                return "☹️"
            case "anger":
                return "😡"
            case "fear":
                return "😟"
            case "neutral":
                return "😐"
            case "contempt":
                return "🙂"
            case "disgust":
                return "😒"
            case "surprise":
                return "😮"
            case "glasses":
                return "👓"
            case "shirt":
                return "👕"
            case "jeans":
                return "👖"
            case "dress":
                return "👗"
            case "bikini":
                return "👙"
            case "purse":
                return "👛"
            case "shoe":
                return "👞"
            case "heels":
                return "👠"
            case "hat":
                return "🎩"
            case "umbrella":
                return "☂️"
            case "briefcase":
                return "💼"
            case "eyes":
                return "👀"
            case "tongue":
                return "👅"
            case "heart":
                return "❤️"
            case "backpack":
                return "🎒"
            case "dog":
                return "🐶"
            case "cat":
                return "🐱"
            case "bread":
                return "🍞"
            case "fruit":
                return "🍇"
            case "shrimp":
                return "🍤"
            case "candy":
                return "🍬"
            case "knife":
                return "🔪"
            case "car":
                return "🚗"
            case "train":
                return "🚅"
            case "plane":
                return "✈️"
            case "chair":
                return "💺"
            case "watch":
                return "⌚️"
            case "ball":
                return "🏀"
            case "pingpong":
                return "🏓"
            case "computer":
                return "🖥"
            case "laptop":
                return "💻"
            case "screen":
                return "🖥"
            case "monitor":
                return "🖥"
            case "television":
                return "📺"
            case "tv":
                return "📺"
            case "mouse":
                return "🖱"
            case "keyboard":
                return "⌨️"
            case "camera":
                return "📷"
            case "book":
                return "📖"
            case "pen":
                return "🖊"
            case "pencil":
                return "✏️"
            case "man":
                return "👨"
            case "woman":
                return "💁"
            default:
               return nil
        }
    }

}
