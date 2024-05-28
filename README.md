# 경우의술(RamdomSoju)

## 💡 아이디어 및 기획

친구와 자주가지 않던곳에서 어느 술집을 가야할지를 고민하던중 특정한 반경안의 술집을 랜덤으로 추천해준다면 재미있겠다는 아이디어를 가지고 앱을 기획하게 되었습니다.

또한 프로젝트 진행시 학습을위해 mvvm패턴을 사용하고 codeBase로 UI를 구현합니다.

## 📱 UI/UX 와이어 프레임과 구상

<img src="https://github.com/chobo5/RandomSoju/assets/102145785/ca00220e-e4d0-4ab9-98ca-4091a91895b1" width="80%">

### Skills

`iOS` `Swift` 

`UIKit` `MVVM` `Rest API` `SnapKit` `SwiftSoup` `CodeBase` `NaverMap` `Kakao 검색 API`

### Home

1. 사용자의 위치를 기반으로 주변의 술집정보들을 받아 지도에 마커로 표시합니다.
2. 술집 정보를 가까운 거리순으로 collectionView에 표시하며 +버튼 선택시 ‘수우울’ 버튼 클릭시 이동하는 rouletteView의 배열에 추가합니다.

<p align="center"> 
  <img src="https://github.com/chobo5/RandomSoju/assets/102145785/addd494d-bd79-49b6-a32d-fcc08548cfd2" align="center" width="40%">
</p>



### Roulette

1. 사용자가 home화면에서 추가한 술집들을 룰렛에 표시하며 start버튼 클릭시 룰렛이 돌아가며 선택된 술집을 다음 결과화면에 표시합니다

<p align="center"> 
  <img src="https://github.com/chobo5/RandomSoju/assets/102145785/f1db3976-2d16-44a4-92b7-4d0f8c177eff" align="center" width="40%">
</p>



### Result

1. 룰렛에 의해 선택된 술집의 정보를 webView를 통해 사용자에게 보여줍니다.
2. 취소 버튼 클릭시 다시 룰렛화면으로 돌아갑니다.
3. 길찾기 버튼 클릭시 Home화면으로 돌아가며 지도에 현재위치에서 선택한 술집까지의 경로가 표시됩니다.

<p align="center"> 
  <img src="https://github.com/chobo5/RandomSoju/assets/102145785/76b17c76-4476-433d-93e7-5820ac53bab5" align="center" width="40%">
  <img src="https://github.com/chobo5/RandomSoju/assets/102145785/3c6d4303-e0cb-4962-bfaf-f58cf0685644" align="center" width="40%">
</p>
