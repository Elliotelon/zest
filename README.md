# 쿠폰 앱 (TestFlight 배포)

## 📌 프로젝트 개요
- MVVM + Clean Architecture 기반 구조 설계
- 테스트 가능한 코드 구조 확보
- CI 병목 개선: **Swift Package 모듈화 → 테스트 시간 30분 → 7분 단축**
- Fastlane + Match 기반 **CI/CD 자동화 및 TestFlight 배포**

## 🛠 기술 스택
- **언어:** Swift
- **아키텍처:** MVVM, Clean Architecture, DI Container
- **모듈화:** Swift Package 기반 Feature 분리 (쿠폰 기능), Core/Feature 레이어 분리
- **테스트:** ViewModel / UseCase 단위 테스트, Mock Repository 활용
- **배포/CI:** Fastlane, Match, TestFlight
- **모니터링/로깅:** Firebase Crashlytics, 데코레이터 패턴 기반 로깅

## 🔑 핵심 특징
- **인증:** Supabase 애플 로그인 (토큰 자동 갱신)
- **모듈화:** Feature 단위 Swift Package로 CI 테스트 범위 최소화
- **배포 자동화:** Fastlane + Match + TestFlight
- **테스트 가능한 구조:** ViewModel / UseCase 중심 단위 테스트 설계

## 🧪 테스트 전략
- **ViewModel 테스트:** 
  - 사용 가능한 쿠폰 조회 성공/실패
  - 사용자 쿠폰 조회 성공
  - 쿠폰 발급 성공/실패
  - 발급 중복 요청 방지
  - 상태/토스트 메시지 검증
- **UseCase 테스트:**
  - 쿠폰 조회, 발급 로직 단위 테스트
  - 중복 발급 방지
  - 이미 발급된 쿠폰 차단
  - 유저 보유 쿠폰 조회
- **Mock Repository**를 활용해 외부 의존성 제거 → 순수 비즈니스 로직 검증
- 테스트 구조 설계 덕분에 **네트워크 없이도 핵심 로직 검증 가능**  
- CI 환경에서 **패키지 단위 테스트 실행** 가능, 전체 프로젝트 빌드 없이 빠른 피드백 확보

## ⚠️ 실행 안내
- 실제 실행을 위해서는 **Supabase 등 프로젝트 환경설정 필요**
