//
//  CouponView.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import SwiftUI
import ZestCore

struct CouponView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "ticket")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                Text("쿠폰 기능 준비 중")
                    .font(.headline)
                    .padding()
                Text("선착순 쿠폰 발급 기능이 곧 추가될 예정입니다.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("쿠폰")
        }
    }
}
