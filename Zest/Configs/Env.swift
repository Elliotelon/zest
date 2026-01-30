//
//  Env.swift
//  Zest
//
//  Created by 김민규 on 1/14/26.
//

import Foundation

struct Env {
    static let googleAppID: String = {
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let appID = dict["GOOGLE_APP_ID"] as? String else {
            fatalError("🚨 GoogleService-Info.plist에 'GOOGLE_APP_ID'가 없습니다.")
        }
        return appID
    }()
    
    // Info.plist에서 ServerHost라는 키로 값을 읽어옵니다.
    static let host: String = {
        guard let host = Bundle.main.object(forInfoDictionaryKey: "SERVER_HOST") as? String else {
            // 설정을 실수했을 때 개발자가 바로 알 수 있게 에러 메시지 출력
            fatalError("🚨 Info.plist에 'ServerHost' 설정이 누락되었습니다.")
        }
        return host
    }()
    
    // 주소 완성 (https://를 여기서 붙여줌)
    static var baseURL: String {
        return "https://\(host)"
    }
    
    static var supabaseURL: URL {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
              let url = URL(string: "https://\(urlString)") else {
            fatalError("SUPABASE_URL 설정이 잘못되었습니다.")
        }
        return url
    }
    
    static var supabaseAnonKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String else {
            fatalError("SUPABASE_ANON_KEY 설정이 없습니다.")
        }
        return key
    }
}
