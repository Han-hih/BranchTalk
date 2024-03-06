
<img src="https://github.com/Han-hih/BranchTalk/assets/109748526/0d0f4f3b-a9fe-40f2-95bc-e9cf416cd05a" width="75" height="75">

# Branch

> 같은 관심을 가진 사람들과 채팅을 할 수 있는 앱입니다.

## UI
회원가입, 로그인 

<img src="https://github.com/Han-hih/BranchTalk/assets/109748526/e0b127f7-a9d6-4e21-b2fa-ee3e3b6063c9" width="200" height="400">
<img src="https://github.com/Han-hih/BranchTalk/assets/109748526/310953d4-a19e-440c-9222-d6c379614c5d" width="200" height="400">
<img src="https://github.com/Han-hih/BranchTalk/assets/109748526/d8d1d0e3-33c9-452b-92f8-eac4572b8311" width="200" height="400">
<img src="https://github.com/Han-hih/BranchTalk/assets/109748526/94ee427a-e4a9-4a5e-8522-6e19bd9305b0" width="200" heigth="400">

- 애플 로그인 / 카카오 로그인을 사용할 수 있습니다.
- 회원가입시 입력값에 대한 유효성 검증과 정규식을 활용한 회원가입 로직을 만들었습니다.

워크스페이스, 채널

<img src="https://github.com/Han-hih/BranchTalk/assets/109748526/e88516e5-1e12-405c-a3e0-78dfd2d0e071" width="200" height="400">
<img src="https://github.com/Han-hih/BranchTalk/assets/109748526/4f2fe399-a220-485a-90c3-37698b0d3c84" width="200" height="400">
<img src="https://github.com/Han-hih/BranchTalk/assets/109748526/bb903b43-9a2d-439a-a1c8-03b1d2a9806a" width="200" height="400">

채팅, 알림기능 

<img src="https://github.com/Han-hih/BranchTalk/assets/109748526/886aaeed-0a19-41a5-9139-a03a92b5a6b3" width="200" height="400">
<img src="https://github.com/Han-hih/BranchTalk/assets/109748526/faf866d5-3cd2-4ccc-982e-218b25566622" width="200" height="400">
<img src="https://github.com/Han-hih/BranchTalk/assets/109748526/950f5e54-277e-4a37-8761-727f0b1aac53" width="200" height="400">

프로필, 인앱결제 

<img src="https://github.com/Han-hih/BranchTalk/assets/109748526/8557c92c-173b-498e-aa50-616ffd4bcb1b" width="200" height="400">
<img src="https://github.com/Han-hih/BranchTalk/assets/109748526/a5f00ad9-2c23-4044-b664-387932f3b1a0" width="200" height="400">
<img src="https://github.com/Han-hih/BranchTalk/assets/109748526/7ad15082-847b-4d43-a06b-bd4afd8b1346" width="200" height="400">




## 작업환경
- 개발 기간: 23.01.02 ~ 23.03.01
- 인원: 1인
- 최소 버전: iOS 16.0
 
## 주요 기능
- 회원가입 / 소셜 로그인
- 워크스페이스 / 채널 생성 및 조회
- 실시간 채팅 / 채팅 알림 
- PG결제를 통해 코인 충전

## 기술 스택
- UIKit, PhotosUI,
- Realm, SocketIO, Iamport-ios
- RxSwift, Alamofire, Snapkit, Kingfisher, IQKeyboardManager
- CodeBase UI, AutoLayout, Codable, Diffable DataSource, Compositional Layout 

## 주요 기능
- RxSwift **Input/Output** 패턴을 활용해 회원가입 로직 구현
- **Kakao SDK**를 활용한 카카오톡 로그인, **Local Authentication**을 활용한 애플 로그인 구현
- DiffableDataSource를 활용한 **Expandable**기능 구현
- Realm을 활용한 채팅 내역(텍스트, 이미지, 보낸 사람, 채널 정보) 저장 및 불러오기
- MultipartForm/Data를 활용한 **여러장의 이미지 포함 채팅 업로드**
- repository pattern을 이용한 Realm 사용, 데이터베이스 모듈화
- SocketIO 기반 양방향 통신을 통해 **실시간 채팅** 기능
- Firebase Cloud Messaging을 이용해 Push Notification 수신
- PG(Payment Gateway)를 활용한 **외부결제** 및 코인 충전 


## 트러블 슈팅
### 1. 불필요한 네트워크 통신을 방지하기 위해 Realm에서 마지막 날짜를 가져온 후 cursorDate를 업데이트 시켜줘야 했습니다.
#### 해결방법: RxSwift의 **do(onNext:)** 메서드를 이용해서 realm에서 먼저 데이터를 받아온 뒤 cursorDate를 업데이트 해주고 flatMapLatest를 사용해 네트워크 통신을 해서 마지막 날짜 이후로만 채팅을 받아오도록 설정해서 불필요한 네트워크 콜을 방지했습니다.
```swift
input.chatTrigger
    .do(onNext: { [unowned self] _ in
        if realm.isEmpty { // 채널에 처음 들어온 사용자일 경우 realm에 데이터가 없다.
          lastDay = "".toDate()
        } else {
            // 이곳에 렘에서 데이터를 가져오고 lastDay를 업데이트 시켜줌
        }
    })
    .flatMapLatest { _ in
        NetworkManager.shared.requestSingle(
             type: [ChannelChatting].self,
             api: .getChannelChatting(
                 cursor_date: self.lastDay?.toString(),
                 name: UserDefaults.standard.string(forKey: "channelName") ?? "",
                 id: UserDefaults.standard.integer(forKey: "workSpaceID")
                        )
                    )
                }
                .bind(with: self, onNext: { owner, result in
                    switch result {
                    case .success(let response):
                        if response.isEmpty {
                            print("🔥", "새로운 채팅없음", response)
                        } else {
                            print("👍", "새로운 채팅 있음", response)
                            //렘에 새로운 채팅 저장해주는 로직 구현
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                })
                .disposed(by: disposeBag)
```

### 2. 백그라운드에 진입했을 때 소켓이 해제가 안 되어서 불필요한 네트워크 통신이 발생했습니다.
#### 해결방법: sceneDelegate의 sceneDidEnterBackground와 sceneWillEnterForeground메서드를 이용해 백그라운드에 진입했을 때, 다시 돌아왔을 때에 대응을 해줬습니다.
