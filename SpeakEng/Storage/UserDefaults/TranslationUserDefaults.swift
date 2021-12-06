//
//  TranslationUserDefaults.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 03.12.2021.
//

import Foundation

class TranslationUserDefaults {
    private let isShowTranslationKey = "UpdatedTopicsDateKey"
    
    func saveIsShowTranslation(isShow: Bool) {
        UserDefaults.standard.setValue(isShow, forKey: isShowTranslationKey)
    }
    
    func getIsShowTranslation() -> Bool {
        let isShow = UserDefaults.standard.bool(forKey: isShowTranslationKey)
        return isShow
    }
}
