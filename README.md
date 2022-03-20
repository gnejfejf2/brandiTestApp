# brandiTestApp

브랜디 iOS 과제 테스트 자료입니다.

앱 아키텍처는 MVVM - Coordinatr with RxSwift 를 사용 하였습니다

화면 전환은 Coordinator를 이용하여 진행하였습니다.

요구사항 

UISearchBar에 문자를 입력 후 1초가 지나면 자동으로 검색이 됩니다.

-> 진행 완료

검색어가 변경되면 목록 리셋 후 다시 데이터를 fetch 합니다. 
    데이터는 30개씩 페이징 처리합니다. (최초 30개 데이터 fetch 후 스크롤 시 30개씩 추가 fetch)
    
-> 진행 완료

검색 결과 목록은 UICollectionView를 사용하여 3xN 그리드 모양으로 구성합니다. (각 아이템은 동일한 크기로 정사각형 형태) 
    검색 결과가 없을 경우 '검색 결과가 없습니다.' 메시지를 화면에 보여줍니다.     
    검색 결과 목록 중 하나를 탭 하였을 때 전체 화면으로 이미지를 보여줍니다.
    
-> 진행 완료

전체 이미지 표시 할 때 좌우 여백이 0이고, 이미지 비율은 유지하도록 보여줍니다. 
이미지가 세로로 길 경우 스크롤 됩니다. 
response 데이터에 출처 'display_sitename', 문서 작성 시간 'datetime'이 있을 경우 
전체 화면 이미지 밑에 표시해 줍니다. 이 외 UI는 자유롭게 구성합니다.

-> 진행 완료
      
우대 사항

RxSwift || Combine 사용
-> RxSwift 사용

Test 코드 구현
-> Test 코드 구현 완료

Error 핸들링
-> 네트워크 문제가 있을경우 간단한 알림창을 뛰우는 로직으로 구현

SwiftUI
-> 요구사항 4번에서 UICollectionView를 사용하라는 요청 사항으로 Uikit 사용 


사용 라이브러리

-> RxSwift , RxCocoa , RxDataSources ,RxGesture
 
UI

-> SnapKit , Then

Networking

-> Kingfisher , Alamofire , Moya/RxSwfit

Test

-> RxTest


해당 프로젝트는 과제 검토후 Private로 전환될 예정입니다.

