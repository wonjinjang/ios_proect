# CityGuideApp

## 1. 프로젝트 수행 목적
### 1.1 프로젝트 정의
CityGuideApp은 사용자가 도시의 명소와 맛집을 쉽게 탐색할 수 있도록 도와주는 iOS 애플리케이션입니다.

### 1.2 프로젝트 배경
도시 여행 시 명소와 맛집을 찾는 데 어려움을 겪는 사용자들을 위해, 간편하게 장소를 검색하고 지도에서 확인할 수 있는 앱을 개발하고자 합니다.

### 1.3 프로젝트 목표
- 사용자가 구를 검색하면 해당 구의 지도로 이동
- 추천 장소를 지도에서 확인하고 상세 정보를 볼 수 있도록 함
- 즐겨찾기 기능을 통해 사용자가 좋아하는 장소를 저장

## 2. 프로젝트 개요
### 2.1 프로젝트 설명
- 검색창에서 구를 입력하면 해당 구의 지도로 이동
- 사용자를 위한 추천카드가 존재하고 추천카드 속 "Let's go!" 버튼을 누르면 해당 장소로 이동하고 상세 정보를 확인할 수 있음.
- 지도에서 장소(관광지 or 맛집)를 클릭하면 상세 정보를 확인할 수 있음
- 사용자는 즐겨찾기 기능을 통해 좋아하는 장소를 저장하고 나중에 쉽게 접근할 수 있음
- 앱은 사용자의 위치를 기반으로 주변 장소를 추천하고, 지도에서 실시간으로 위치를 확인할 수 있음
- 상세 정보 화면에서는 장소의 설명, 운영 시간, 주소 등 다양한 정보를 제공함

### 2.2 결과물
- 온보딩 화면<br>
<img src="https://github.com/user-attachments/assets/2ae46630-e1e6-43ed-9c94-c306d9efea40" width="270" style="border: 1.5px solid #bbb; border-radius: 10px;">
<br><br>

- 메인 화면<br>
<img src="https://github.com/user-attachments/assets/aa781b6f-258c-4651-a867-b23c199c3c28" width="270" style="border: 1.5px solid #bbb; border-radius: 10px;">
<br><br>

- 지도 화면<br>
<table><tr>
<td style="padding-right:16px;"><img src="https://github.com/user-attachments/assets/673f3ce1-7b47-4da2-929c-41d3c2d4bbd5" width="270" style="border: 1.5px solid #bbb; border-radius: 10px;"></td>
<td style="padding-right:16px;"><img src="https://github.com/user-attachments/assets/a0ce409a-2f2a-4d2e-9b9a-4c82902eaeba" width="270" style="border: 1.5px solid #bbb; border-radius: 10px;"></td>
<td><img src="https://github.com/user-attachments/assets/39b109e0-3d15-4428-831d-b7cc9eecc180" width="270" style="border: 1.5px solid #bbb; border-radius: 10px;"></td>
</tr></table>
<br><br>

- 상세 정보 화면<br>
<img src="https://github.com/user-attachments/assets/bfb02b77-3eb0-4b57-971a-5a189bdf299a" width="270" style="border: 1.5px solid #bbb; border-radius: 10px;">
<br><br>

- 사이트 방문하기 클릭 시 화면<br>
<img src="https://github.com/user-attachments/assets/196fbda4-246a-4ea5-a860-d2f652cae266" width="270" style="border: 1.5px solid #bbb; border-radius: 10px;">
<br><br>

- 즐겨찾기 화면<br>
<img src="https://github.com/user-attachments/assets/ebd132a5-be3f-47c8-a2a0-090639eed32d" width="270" style="border: 1.5px solid #bbb; border-radius: 10px;">
<br><br>

### 2.3 기대효과
- 사용자가 도시의 명소와 맛집을 쉽게 탐색할 수 있음
- 지도와 상세 정보를 통해 사용자 경험을 향상시킴
- 사용자의 여행 계획을 더 효율적으로 관리할 수 있음
- 앱을 통해 사용자의 여행 만족도를 높일 수 있음

### 2.4 관련 기술
| 기술 이름 | 설명 |
|-----------|------|
| **MapKit** | 지도 표시 및 위치 기반 기능을 제공하여 사용자가 장소를 쉽게 찾을 수 있도록 함 |
| **CoreLocation** | 위치 정보를 처리하여 사용자의 현재 위치를 기반으로 주변 장소를 추천함 |
| **UserDefaults** | 사용자 데이터를 저장하여 즐겨찾기 및 방문 기록을 관리함 |

### 2.5 개발 도구
- **Xcode**: iOS 애플리케이션 개발 환경
- **Swift**: 프로그래밍 언어
- **Storyboard**: UI 디자인 및 레이아웃
