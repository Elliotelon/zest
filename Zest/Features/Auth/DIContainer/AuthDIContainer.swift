import Supabase
import SwiftUI
import ZestCore

final class AuthDIContainer {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func makeLoginView() -> some View {
        let saveProfilesUseCase = SaveProfilesUseCase(repository: repository)
        let appleLoginUseCase = AppleLoginUseCase(
            repository: repository,
            saveProfilesUseCase: saveProfilesUseCase
        )
        let viewModel = AuthViewModel(appleLoginUseCase: appleLoginUseCase)
        return LoginView(viewModel: viewModel)
    }
}

