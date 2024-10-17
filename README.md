# ✈️ Trip.PD ReadMe

## ✈️ 프로젝트 소개
> 국내 여행을 손쉽게 짤 수 있는 나만의 여행 플래너
<img src="https://github.com/user-attachments/assets/4f878401-7ab0-488d-b2e0-074951fc5c94" width="19%"/>
<img src="https://github.com/user-attachments/assets/3696201b-257f-4e59-a382-24eaa5f23568" width="19%"/>
<img src="https://github.com/user-attachments/assets/6cc7fe58-1288-49d6-9768-632f9280a82e" width="19%"/>
<img src="https://github.com/user-attachments/assets/aba1a129-cbc7-410e-8f2c-eee2c23983bd" width="19%"/>
<img src="https://github.com/user-attachments/assets/0ecac6ce-82fe-4286-b6dd-eb8f550f5afb" width="19%"/>


## ✈️ 프로젝트 환경
- 인원: 1명
- 출시 개발 기간: 2024.09.12 ~ 2024.10.01
- 유지 보수 기간: 2024.10.01 ~ 
- 개발 환경: Xcode 15
- 최소 버전: iOS 16.0


## ✈️ 기술 스택
- SwiftUI, MVC + MVVM
-  Alamofire, BottomSheet, HorizonCalendar, PHPickerView, PopupView, Realm
- Access Control, CustomFont, FileManager, Decoder, DTO, NWPathMonitor, UIKit Wrapping
- Input/Output﹒Singleton﹒Router Pattern

## ✈️ 핵심 기능
- 여행 플래너 생성 및 삭제
- 여행 플래너 커버 커스텀
- 여행 계획표에 장소 추가 및 장소 삭제
- 마커 클릭 시 WebView로 해당 장소에 대한 정보 제공
- 여행 계획표에 시간순으로 장소 정렬

## ✈️ 주요 기술
- Airbnb의 오픈소스 라이브러리인 HorizonCalendar를 Custom하여 여행 일정을 선택할 수 있도록 구현
- Alamofire를 사용한 KakaoLocalManager Singleton Pattern으로 구성
   - Genric을 활용하여 Decodable한 타입들로 디코딩 진행
   - Custom TargetType을 API Networking에 대한 요소들을 정의한 protocol을 통해 API Networking을 위한 Router 추상화
- UIKit의 MKMapView, PHPickerView, WebView 등을 UIViewRepresentable Wrapping 및 Coordinator 패턴을 활용하여 뷰 구성
   - setVisibleMapRect를 활용하여 검색결과의 마커들을 최대한으로 MapCamera에 담아 보여질 수 있도록 구현
   - MKMarkerAnnotationView를 활용한 Custom 마커와 애니메이션 구현
- Realm Swift를 데이터베이스로 채택하여 여행 플래너 저장 및 삭제 등 다양한 기능 구현
   - 더 자유로운 데이터 활용을 위해 Realm을 위한 데이터 구조와 View를 위한 데이터 구조를 별개로 생성하여 서로 연동이 되도록 구현
- FileManager를 활용하여 여행 플래너 커버 이미지를 저장하고 로드하도록 구현
   - Realm의 데이터 요소에 이미지 링크를 저장하여 이미지 로드에 사용
- 관련 기능들을 Manager 네이밍의 하나의 클래스로 생성하여 뷰 전역에서 사용하는 Singleton Pattern 사용
- NotificationCenter를 활용하여 keyboard의 On/Off 유무에 따른 뷰 레이아웃이 유연하게 변경되도록 구현

## ✈️ 트러블 슈팅

****1. Realm DTO 과정**** 

1) 문제 발생
- 기존에는 Realm의 @ObservedResults를 직접 사용하여 기본 기능(여행 플래너 생성 및 삭제, 장소 삭제 등)을 구현하였으나, Travel의 요소인 List<Date>를 활용한 정렬기능을 구현하기 위해 @ObservedResults를 Array로 단순 변환하여 사용하기로 결정함
- 그러나 HomeView의 하위뷰에서 여행플래너을 삭제하고 다시 HomeView로 이동하는 코드에서 Realm의 해당 데이터는 삭제되지만, dismiss에서 지속적인 "Object has been deleted or invalidated." 런타임 에러가 발생함

2) 해결 방법
- Realm은 class 객체이기에 만약 데이터를 삭제하였다 하더라도 홈뷰나 하위뷰에 계속 삭제된 데이터를 참조할 수도 있다고 생각하게 되었음
- 그래서 Realm에서 사용할 데이터 구조 외에, 실제 View에 사용될 View의 데이터 구조를 생성하여 Realm 데이터를 Binding해주는 setupObserver 메서드를 추가하여 구현
- List타입도 기본 Array타입으로 변환되기 때문에 sorted 메서드도 쉽게 동작할 수 있게 됨

<details><summary> 구현한 코드
</summary></details>

## ✈️ 회고
- 목표한 심사 및 출시 날짜를 위해 빠른 개발을 위하여 MVC 패턴으로 코드를 작성하게 되었는데, 프로퍼티를 많이 사용하는 뷰에서 코드가 복잡해지고 가독성이 떨어지는 것을 확인하여습니다. 그래서 유지보수 기간동안 코드를 개선하기 위해 Combine을 활용한 MVVM 패턴으로 리팩토링을 진행하고 있습니다.
- MVVM 패턴으로의 리팩토링을 진행하면서 SwiftUI에서의 MVVM 디자인 패턴이 크게 효율성이 있을까라는 의문점이 들었습니다. MVVM 패턴은 관찰할 데이터와 비즈니스 로직을 ViewModel에 담아 뷰와 Data를 연결하는 양방향 Data Flow인데, SwiftUI의 View에서 @State, @Binding 등의 프로퍼티 래퍼를 사용하여 충분히 View와 ViewModel의 기능을 구현할 수 있기 때문에 ViewModel이 불필요해질 수 있다는 것을 느끼게 되었습니다. 그래서 MVVM 디자인 패턴으로 리팩토링을 진행한 이후, Apple에서 지향하는 단방향 Data Flow를 따르는 디자인 패턴인 MVI, TCA, Redux 등을 공부해보고 리팩토링을 한번더 진행하거나 다음 프로젝트에 적용해보려고 합니다.
- TripPD는 Database로 Realm 라이브러리를 학습하여 사용하였는데, Apple에서는 Database '기능'을 지원하는 CoreData와 SwiftData가 존재한다는 것을 확인하였습니다. 다음 프로젝트에선 CoreData나 SwiftData를 공부하여 적용해보고 Realm과 CoreData/SwiftData의 차이점을 확인해보려 합니다.
