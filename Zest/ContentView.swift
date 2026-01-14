//
//  ContentView.swift
//  Zest
//
//  Created by 김민규 on 1/13/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            print("🚀 현재 서버 주소: \(Env.baseURL)")
        }
    }
}

#Preview {
    ContentView()
}
