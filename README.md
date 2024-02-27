# Branch
- 같은 관심사를 가진 사람들과 채팅을 할 수 있는 앱입니다.
- 인원: 1인
- 개발 기간: 23.01.02 ~ 진행중
- 최소 버전: iOS 16.0
 
## 앱 소개 
- 회원가입, 소셜 로그인
- 워크스페이스, 채널 생성 및 조회
- 실시간 채팅 구현
- 채팅 알림 기능

## 기술 스택
- UIKit(CodeBase UI), MVVM
- PhotosUI, Diffable DataSource, Compositional Layout 
- RxSwift, Realm, SocketIO
- Alamofire, SnapKit, Kingfisher, IQKeyboardManager

## 주요 기능
- RxSwift **Input/Output** 패턴을 활용해 회원가입 로직 구현
- 카카오톡, 애플 로그인 구현
- DiffableDataSource를 활용한 **Expandable**기능 구현
- realm을 활용한 채팅 내역(텍스트, 이미지, 보낸 사람, 채널 정보) 저장 및 불러오기
- MultipartForm/Data를 활용한 **여러장의 이미지 포함 채팅 업로드**
- repository pattern을 이용한 realm 사용, 데이터베이스 모듈화
- SocketIO 기반 양방향 통신을 통해 **실시간 채팅** 기능
- Firebase Cloud Messaging을 이용해 Push Notification 수신


## 트러블 슈팅
### 1. 불필요한 네트워크 통신을 방지하기 위해 realm에서 마지막 날짜를 가져온 후 cursorDate를 업데이트 시켜줘야 했습니다.
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
       
