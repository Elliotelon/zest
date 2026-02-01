import SwiftUI

struct ProfileView: View {
    let profileId: UUID?
    let email: String?
    let name: String?
    let onLogout: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                Section("사용자 정보") {
                    HStack {
                        Text("ID")
                        Spacer()
                        Text(profileId?.uuidString ?? "")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    
                    if let email = email {
                        HStack {
                            Text("이메일")
                            Spacer()
                            Text(email)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if let name = name {
                        HStack {
                            Text("이름")
                            Spacer()
                            Text(name)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
               
                
                Section {
                    Button(action: onLogout) {
                        HStack {
                            Spacer()
                            Text("로그아웃")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("프로필")
        }
    }
}
