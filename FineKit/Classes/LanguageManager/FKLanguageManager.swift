//
//  FKLanguageManager.swift
//  EdifierDance
//
//  Created by apple on 2021/9/28.
//

public class FKLanguageManager {
    public static let shared = FKLanguageManager()
    private static let userDefaultsKey = "current_language"
    private static let defautLanguage = "zh"

    private init() {
//        currentLanguage = FKLanguageManager.storedCurrentLanguage ?? FKLanguageManager.defautLanguage
        currentLanguage = FKLanguageManager.getSuitableLanguage()
    }
    
    /// 获取最合适的语言
    /// - Parameter followSystem: 是否跟随系统，是否读取本地存储语言
    public static func getSuitableLanguage(followSystem: Bool = true) -> String {
        var lan = FKLanguageManager.defautLanguage
        if !followSystem, let kLanguage = FKLanguageManager.storedCurrentLanguage { // 不跟随系统，读取存储语言
            lan = kLanguage
        } else {
            if let systemLanguage = FKLanguageManager.systemLanguage, FKLanguageManager.availableLanguages.contains(systemLanguage) {
                lan = systemLanguage
            } else {
                lan = FKLanguageManager.defautLanguage
            }
        }
        return lan
    }

    /// 语言是否为中文
    public func LanguageIsChinese() -> Bool {
        return currentLanguage.hasPrefix("zh")
    }

    /// 可用的语言
    public static var availableLanguages: [String] {
        Bundle.main.localizations.sorted()
    }

    /// 当前语言
    public var currentLanguage: String {
        didSet {
            storeCurrentLanguage()
        }
    }
    
    /// 系统语言
    public static var systemLanguage: String? {
        if let language = NSLocale.preferredLanguages.first {
            let array = language.components(separatedBy: NSCharacterSet(charactersIn: "-") as CharacterSet)
            if let current = array.first {
                return current
            }
            return nil
        }
        return nil
    }
    

    /// 当前语言展示的名字
    public var currentLanguageDisplayName: String? {
        displayName(language: currentLanguage)
    }

    /// 根据语言国际化展示的名字
    public func displayName(language: String) -> String? {
        (currentLocale as NSLocale).displayName(forKey: NSLocale.Key.identifier, value: language)?.capitalized
    }
    /// 原始语言显示名称
    public static func nativeDisplayName(language: String) -> String? {
        let locale = NSLocale(localeIdentifier: language)
        return locale.displayName(forKey: NSLocale.Key.identifier, value: language)?.capitalized
    }
}

extension FKLanguageManager {

    /// 存储当前语言
    private func storeCurrentLanguage() {
        UserDefaults.standard.set(currentLanguage, forKey: FKLanguageManager.userDefaultsKey)
    }

    /// 获取存设置的语言
    private static var storedCurrentLanguage: String? {
        UserDefaults.standard.value(forKey: userDefaultsKey) as? String
    }

    /// 推荐语言
    private static var preferredLanguage: String? {
        Bundle.main.preferredLocalizations.first { availableLanguages.contains($0) }
    }
}

extension FKLanguageManager {

    public var currentLocale: Locale {
        Locale(identifier: currentLanguage)
    }
}

extension FKLanguageManager {

    public func localize(string: String, bundle: Bundle?) -> String {
        let source = self.LanguageIsChinese() ? "zh-Hans" : currentLanguage
        
        if let languageBundleUrl = bundle?.url(forResource: source, withExtension: "lproj"), let languageBundle = Bundle(url: languageBundleUrl) {
            return languageBundle.localizedString(forKey: string, value: nil, table: nil)
        }

        return string
    }

    public func localize(string: String, bundle: Bundle?, arguments: [CVarArg]) -> String {
        String(format: localize(string: string, bundle: bundle), locale: currentLocale, arguments: arguments)
    }
}

public extension String {
    /// 国际化
    var loc: String {
        get {
            return FKLanguageManager.shared.localize(string: self, bundle: Bundle.main)
        }
    }
}
