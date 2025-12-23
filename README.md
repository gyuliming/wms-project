![바름생각](https://github.com/user-attachments/assets/9340dc75-5514-4e06-8b68-aec06afd0bde)

# 바름생각 WMS
**바름 + 생각**
  - 화장품 WMS 구축을 통해 화장품 유통에서도 성분만큼이나 정확함과 신뢰가 중요하다는 생각에서 출발


## 기획 배경
이번에 참여한 프로젝트는 화장품 유통의 재고 및 출고 관리를 위한 WMS를 구현한 프로젝트입니다.

K-뷰티 시장은 글로벌 수요 증가와 함께 빠른 성장을 이어가고 있으며, 이에 따라 화장품의 유통 규모와 물류 처리량 또한 지속적으로 확대되고 있습니다.

특히 잦은 신제품 출시와 짧은 제품 라이프사이클은 재고 관리의 복잡성을 높이고, 실시간 재고 파악과 신속한 출고를 필수적으로 요구합니다. 그러나 중소·신규 브랜드의 경우 이러한 물류 환경에 대응할 수 있는 체계적인 시스템을 갖추기 어려운 실정입니다.

이러한 문제를 해결하기 위해, 화장품을 핵심 관리 품목으로 한 창고관리시스템(WMS)을 주제로 프로젝트를 기획하게 되었습니다.


## 기술적 목표
- 트랜잭션 기반 데이터 일관성 보장
- MyBatis 동적 쿼리를 통한 유연한 검색 및 필터링
- 계층형 아키텍처 : Controller - Service - Mapper 3계층 구조로 책임을 명확히 분리
- 재사용 가능한 공통 컴포넌트 설계 : Criteria, PageDTO, EnumStatus 등 공통 모듈 구현
- RESTful API 설계 원칙 준수


## 팀원 구성 및 소개
| **AAA** | **BBB** | **CCC** | **gyuliming** |
| --- | --- | --- | --- |
| **팀장** | **팀원** | **팀원** | **팀원** |
| **회원 관리, 대시보드, 재고 관리** | **출고 관리, 견적 관리** | **입고 관리, 고객센터** | **창고 관리** |




## 사용 기술
- **FrontEnd**   `JSP` `JSTL` `HTML5` `CSS3` `JavaScript` `Bootstrap` `Axios` `Chart.js` `Kakao Map API` 
- **BackEnd**   `Java` `Spring` `MyBatis` `Gradle` `RESTful API` `SSR(Server-Side Rendering)` 
- **Database**   `MySQL`
- **Deploy**   `Apache Tomcat` 
- **API**   `Notion API` `Google Sheets API`


## 프로젝트 구조
**config**

- 프로젝트의 설정 정보 클래스 정의

**global**

- Enum ****: 프로젝트 전반에서 사용되는 상수 및 상태 값 정의
- advice : 전역 예외 처리 및 컨트롤러 보조 로직 정의
- domain : 페이징(Criteria) 등 공통으로 사용되는 핵심 엔티티 및 VO 정의

**domain**

- 각 기능별 핵심 데이터 엔티티 및 DTO 클래스 정의

**controller**

- 프레젠테이션 계층에 속하는 Controller 클래스 정의 (HTTP 요청 매핑 및 응답 처리)

**service**

- 비즈니스 로직을 수행하고 트랜잭션을 관리하는 Service 계층 클래스 정의

**mapper** 

- MyBatis를 사용하여 데이터베이스와 통신하는 영속성 계층의 인터페이스 정의

**exception**

- 각 도메인별 비즈니스 로직 수행 중 발생하는 커스텀 예외 클래스 정의


## 브랜치 전략 및 컨벤션
**Git-Flow 전략 채택**

- main, develop, feature 브랜치를 사용했습니다.
    - main 브랜치는 배포 가능한 용도로 사용했습니다.
        - develop 브랜치는 feature 브랜치들을 병합하는 브랜치로 사용했습니다.
        - feature 브랜치는 각자의 담당 기능을 개발하는 브랜치로 사용했습니다.
        - hotfix, release 브랜치는 실제 서비스를 제공하지 않아서 활용하지 않았습니다.

**네이밍 컨벤션**

- 변수 및 메서드명 : camel Case
- 클래스명 : Pascal Case
- 패키지 및 테이블 컬럼명 : snake case


## 프로젝트 기간
<img width="528" height="257" alt="todo" src="https://github.com/user-attachments/assets/001af9e4-6f00-44bc-840f-53cde8c6b110" />


## 파트별 설계

**회원**

- 권한은 총 관리자(MASTER), 일반 관리자(ADMIN), 회사(USER)로 구분되며, 모든 계정은 총 관리자의 승인을 받아야 시스템 이용이 가능
- 로그인 시 ID 존재 → 승인 상태(APPROVED) → 비밀번호 일치 순으로 검증하며, 세션에 관리자 인덱스와 ID를 저장


**재고**

- 재고는 창고-구역-아이템 단위로 관리되며, 입고 시 UPSERT 방식으로 수량을 누적하고 출고 시 차감
- 출고 요청 시 재고가 부족하면 차감을 거부하여 과출고를 방지하며, 매 입출고마다 실재고 스냅샷을 자동 기록


**창고**

- 창고는 총 용량과 위치로 식별되며, 중복된 이름이나 주소는 등록이 불가능
- 총 관리자가 창고 내부에 구역을 추가할 수 있고, 구역 추가 시 창고의 잔여 용량을 검증하여 초과 등록을 차단
- 상세 조회 시 전체 구역의 사용량을 합산하여 적재율(%)을 계산
- 한 창고에는 한 명의 MASTER만 배정 가능하며, 이미 배정된 MASTER는 다른 창고에 배정될 수 없음


**입고**

- 입고는 요청 등록 → 관리자 승인(구역 배정) → 실제 입고 처리 순으로 진행되며, 승인 시 레코드가 자동 생성
- 입고 처리 완료 시 재고가 증가하고 실재고 스냅샷이 생성되어 이력 추적이 가능
- 취소는 PENDING 상태에서만 가능하며, 취소 사유와 함께 상태가 CANCELED로 변경


**출고**

- 출고는 요청 등록 → 배차 등록 → 관리자 승인 → 출고지시서 자동 생성 → 운송장 발급 순으로 처리
- 출고 요청 시 수취인 우편번호 기반으로 담당 창고 지역을 판별하고, 해당 지역의 재고를 실시간 검증
- 배차 등록 시 요청 수량을 충족하는 최적 재고 위치를 자동 선택하며, 출고 승인 시 재고가 즉시 차감


**견적**

- 회사의 견적 요청 시 관리자가 답변을 등록하면 상태가 자동으로 ANSWERED로 변경되며, 요청 수정 시 기존 답변이 삭제되고 PENDING으로 초기화
- 댓글은 작성자 타입(USER/ADMIN)으로 구분되며, 본인 댓글만 수정/삭제 가능하도록 권한을 검증


**고객센터**

- 공지사항은 우선순위와 작성일 기준으로 정렬되며, 1:1 문의는 관리자 답변 등록 시 상태가 자동으로 ANSWERED로 변경
- 게시판 조회 시 조회수가 자동 증가하며, 관리자는 모든 게시글/댓글을 삭제할 수 있고 회원은 본인 작성 글만 수정/삭제 가능


**대시보드**

- 일별/월별 가입자, 입고, 출고 건수를 집계하여 라인 차트로 시각화하며, 전월 대비 이번 달 통계를 KPI 카드로 표시
- 최근 12개월 입출고 추이를 월 단위로 그룹핑하여 트렌드 그래프를 제공


## ERD
<img width="1180" height="648" alt="erd" src="https://github.com/user-attachments/assets/d6a52f1b-d323-40d9-b611-e915a84869ed" />


## 창고 관리

**플로우차트**

<img width="832" height="574" alt="flowchart" src="https://github.com/user-attachments/assets/fa80e4c4-5a1c-4e39-bb9f-a9a9395114a1" />
<br><br>

**유스케이스 다이어그램**

<img width="688" height="836" alt="usecase" src="https://github.com/user-attachments/assets/8d1146c8-fc60-4341-9f38-35b1264df3ab" />
<br><br>

**화면 와이어 프레임**

<img width="1818" height="1126" alt="wire" src="https://github.com/user-attachments/assets/34d02dbb-90b0-48cd-b018-9c46051bcbff" />
<br><br>

**구현**

**① 창고 등록**
- 창고를 등록할 때, 창고 이름, 창고 관리자, 창고 크기, 주소를 설정해서 등록할 수 있습니다.
- 창고와 창고 관리자는 1:1 관계이므로, 이미 창고를 배정받은 창고 관리자는 선택할 수 없습니다.
<img width="1917" height="909" alt="wh1" src="https://github.com/user-attachments/assets/906e7863-3d0a-4249-b879-ac5a1127b14d" />

- 카카오 우편번호 찾기 API를 통해서 주소를 찾을 수 있습니다.
<img width="278" height="344" alt="wh2" src="https://github.com/user-attachments/assets/921f66af-8755-47b7-bbc3-8049e707c4bf" />
<br><br>

**② 검색 조건 별 창고 조회**
- 검색 조건은 드롭 다운 형식으로, 창고 이름, 창고 코드, 창고 소재지로 가능합니다.
- 검색된 창고는 KaKao Map API를 통해서 위치를 확인할 수 있습니다.(기본값 : 전체 창고 위치)
<img width="1918" height="908" alt="wh3" src="https://github.com/user-attachments/assets/c35d0927-b3c9-4adc-88ad-f69a8e303b3c" />
<br><br>

**③  창고 상세 조회**
- 창고의 상세 정보를 확인할 수 있고, 해당 창고에 대해서 구역 생성, 수정 작업을 진행할 수 있습니다.
- 검색된 창고는 KaKao Map API를 통해서 위치를 확인할 수 있습니다.
- 하단에서는 생성된 창고의 구역 현황을 확인할 수 있습니다.
<img width="1917" height="907" alt="wh4" src="https://github.com/user-attachments/assets/64a6b5d9-5ca9-47cb-ad40-0e48735dd937" />
<br><br>

**④ 구역 생성**
- 모달 창을 통해 창고 내 구역을 생성할 수 있습니다.(구역명, 구역 종류(상온/저온), 적재 용량 입력)
- 적재 용량은 팔레트 단위로 설정하며, **1 팔레트 = 50 박스** 기준으로 산정됩니다.
<img width="497" height="415" alt="wh5" src="https://github.com/user-attachments/assets/3c24c776-5da4-49c8-a579-15ef1cc7f3b6" />
<br><br>

**⑤ 창고 수정**
- 창고의 정보(이름, 주소, 창고 상태)를 수정할 수 있습니다.
<img width="1197" height="644" alt="wh6" src="https://github.com/user-attachments/assets/d328587c-660c-46cf-bf80-4bbdc1ab31e5" />

- 카카오 우편번호 찾기 API를 통해서 주소를 찾을 수 있습니다.
<img width="273" height="341" alt="wh7" src="https://github.com/user-attachments/assets/ccff4ee2-3fd1-4612-beb6-659ac15c03c8" />
<br><br>

**⑥ 창고 폐쇄**
- 모달 창을 통해 해당 창고를 폐쇄(soft delete)할 수 있습니다.
<img width="1197" height="644" alt="wh8" src="https://github.com/user-attachments/assets/75613829-188f-48c4-9175-d115da07884c" />
<br><br>

**상세기능**

**REST API**
| URL | Method | Body (JSON) | Response (200 OK) | Error | Description |
|:---|:---:|:---|:---|:---:|:---|
| /api/warehouse | POST | {"wName": "이름", "wSize": 1000, "wAddress": "주소", "wZipcode": "우편번호"} | "창고 등록 완료" | 400, 403, 500 | 신규 창고 등록 |
| /api/warehouse/{id}/section | POST | {"sName": "A-1", "sType": "상온", "palletCount": 10} | "구역 추가 완료" | 400, 403, 500 | 특정 창고 내 구역 추가 (용량 및 중복 체크) |
| /api/warehouse/{id} | PUT | {"wName": "수정명", "wAddress": "수정주소", "wZipcode": "수정우편번호", "wStatus": "상태"} | "창고 수정 완료" | 400, 403, 500 | 기존 창고 정보 수정 (이름, 주소, 상태 등) |
| /api/warehouse/{id} | DELETE | - | "창고 폐쇄 완료" | 400, 403, 500 | 창고 논리적 삭제 (폐쇄 처리) |

* **400 (Bad Request):** 데이터 중복, 용량 초과, 수정/폐쇄 실패 등
* **403 (Forbidden):** 해당 기능에 대한 접근 권한 없음
* **500 (Internal Server Error):** 서버 내부 로직 오류


**View Routes**
| URL | Method | Body (Params) | Response (View) | Error | Description |
|:---|:---:|:---|:---|:---:|:---|
| /warehouse/list | GET | page, amount, typeStr, keyword | warehouse/list.jsp | 로그인 폼으로 리다이렉트 (로그인/권한 필요) | 창고 리스트 및 검색, 페이징 처리, 카카오맵 API 활용 |
| /warehouse/register | GET | - | warehouse/registerForm.jsp | 목록으로 리다이렉트 (총 관리자 권한 필요) | 창고 등록 폼  |
| /warehouse/{id} | GET | - | warehouse/detail.jsp | 로그인 폼으로 리다이렉트 (로그인/권한 필요) | 창고 정보 및 해당 창고의 구역 리스트 출력 |
| /warehouse/{id}/update | GET | - | warehouse/updateForm.jsp | 목록으로 리다이렉트 (총 관리자 권한 필요) | 창고 수정 폼 이동 |


## 트러블 슈팅: MyBatis의 NPE 및 ResultMap
**문제점**

MyBatis를 사용하여 DB 데이터를 조회할 때, 일반적으로 `<select>` 태그의 `resultType` 속성을 사용하여 DTO 객체로 자동 매핑을 시도했습니다.

하지만 `resultType` 만으로는 데이터가 제대로 매핑되지 않는 문제가 발생했습니다.

**WarehouseMapper.xml**

```jsx
<select id="getList" resultType="com.ssg.wms.warehouse.domain.WarehouseDTO">
        SELECT *
        FROM warehouse
        WHERE warehouse_status != 'CLOSED'
        ORDER BY warehouse_index DESC
        LIMIT #{skip}, #{amount}
    </select>
```

위와 같이 창고 목록을 조회하는 쿼리를 작성해서, `resultType`을 `WarehouseDTO`로 지정하여, 조회된 컬럼 값을 자바 객체의 필드에 자동으로 담으려고 시도했습니다.

**테스트 코드**

```jsx
@Test
void getListTest() {
    Criteria cri = new Criteria();
    List<WarehouseDTO> list = warehouseMapper.getList(cri);

    log.info("리스트 크기 : " + list.size());

    for (WarehouseDTO warehouse : list) {
        Assertions.assertAll(
                () -> Assertions.assertNull(warehouse.getWName()),
                () -> Assertions.assertNull(warehouse.getWLocation()),
                () -> Assertions.assertNull(warehouse.getWAddress()),
                () -> Assertions.assertNull(warehouse.getWZipcode()),
                () -> Assertions.assertNotEquals(0, warehouse.getWCode()),
                () -> Assertions.assertNotEquals(0, warehouse.getWSize())
        );
    }
}
```

**테스트 결과**
<img width="1462" height="480" alt="test1" src="https://github.com/user-attachments/assets/42c91279-ee34-4291-a96c-8622910697ef" />

**원인 분석**

처음에는 단순히 쿼리 문법 오류인가 싶어서 SQL 로그를 확인했으나, `SELECT` 쿼리가 실행되서 리스트를 정상적으로 가져오고 있었습니다. 데이터는 가져오는데 왜 자바 객체(DTO)에 담기지 않는지 의문이 들어, MyBatis 공식 문서의 매핑 전략 부분을 찾아보았습니다.

<img width="1461" height="92" alt="test2" src="https://github.com/user-attachments/assets/78a35b05-713c-45ec-95df-a2c6c4776f1d" />

이 규칙을 제 코드에 대입해 보니 문제의 원인이 명확해졌습니다.
DB 컬럼에서는 `warehouse_name` 과 같이 정의를 해서, 표준 변환 시에 `warehouseName` 을 찾는 것인데, 제가 정의한 DTO 필드에서는 `wName` 과 같이 정의를 해서 데이터가 버려지고 객체는 NULL로 반환되었던 것입니다.

**해결 방법**

<img width="2331" height="494" alt="test3" src="https://github.com/user-attachments/assets/f1e51731-0a57-4088-ba17-c2773f96d1ff" />

MyBatis 공식 문서에서는 이러한 경우, 자동 매핑(`resultType`) 대신 `resultMap` 을 사용하여 컬럼과 프로퍼티 간의 매핑을 명시적으로 정의할 것을 권장했습니다.
이에 따라, `WarehouseMapper.xml` 에 `resultMap` 을 정의하였고, `<select>` 태그의 `resultMap` 속성을 사용했습니다.

<img width="554" height="308" alt="test4" src="https://github.com/user-attachments/assets/83dd2b7a-150f-4c97-b348-bfde35a09fff" />

<img width="338" height="150" alt="test5" src="https://github.com/user-attachments/assets/27a24ed9-0cb8-45e1-ac4c-293fb3747296" />

**결과**

<img width="1497" height="543" alt="test6" src="https://github.com/user-attachments/assets/e3badb1e-429a-4385-9b63-24a526cf3d46" />
DB 컬럼명과 DTO 필드를 1:1로 명시적으로 매핑하였고, 그 결과 조회된 데이터가 DTO 객체에 정상적으로 주입되는 것을 확인할 수 있었습니다.
이를 통해 자동 매핑에 의존할 경우 발생할 수 있는 매핑 누락 문제를 방지할 수 있었습니다.


## 향후 개선 방향
- 예외 처리 구조 개선
  - 현재는 컨트롤러 단에서 개별적으로 예외를 처리하고 있습니다.
  - 추후 전역 예외 처리 구조로 개선하고, 일관된 에러 응답 형식을 제공할 예정입니다.

- 동시성 이슈 대응
  - 다수의 요청이 동시에 발생할 경우, 창고 구역 생성 과정에서 동시성 문제가 발생할 수 있습니다.
  - 이를 방지하기 위해 DB 락 또는 분산 락을 활용한 동시성 제어 방안을 적용할 계획입니다.


## 프로젝트 회고
이번 프로젝트에서 WMS의 핵심인 창고 및 섹션 관리 모듈을 담당하여 개발했습니다.
단순한 CRUD 구현을 넘어, 물리적인 창고 공간을 소프트웨어로 어떻게 정합성 있게 제어할 것인가를 고민하며 설계와 개발을 진행했습니다.

- MyBatis 기반 데이터 정합성 처리
  - 창고–섹션 간 매핑 로직을 구현하던 중, 섹션에 재고가 없는 경우 집계 결과가 NULL로 반환되어 NullPointerException이 발생하는 문제를 경험했습니다.
  - SQL 레벨에서 COALESCE 함수를 활용해 기본값을 0으로 처리함으로써, 안정적인 데이터 집계를 보장했습니다.
  - 이를 통해 애플리케이션 단이 아닌 DB 단에서의 방어적 설계의 중요성을 체감했습니다.

- RESTful API 설계 및 비동기 통신
  - @RestController를 통해 창고·섹션 관련 API를 설계하며, HTTP 상태 코드와 예외 메시지를 정의해 프론트엔드와의 책임 분리를 강화했습니다.
  - Ajax 기반의 요청을 고려한 API 구조를 설계하여, 페이지 새로고침 없이 섹션 추가 및 수정이 가능하도록 지원했습니다.
  - 이를 통해 API 설계가 사용자 경험에 직접적인 영향을 미친다는 점을 이해하게 되었습니다.

- 외부 API 연동
  - 주소 검색을 위한 외부 API를 연동하고, 검색 결과를 내부 도메인 규격에 맞게 정제하는 과정을 통해 외부 시스템과 내부 모델 간 데이터 흐름을 다루는 경험을 쌓았습니다.
  - 이 과정에서 외부 시스템과 내부 모델 간의 데이터 경계와 변환 책임을 명확히 분리하는 설계 경험을 쌓을 수 있었습니다.

- 팀 협업과 소통
  - 창고/섹션 모듈은 입고/재고 관리의 기준이 되는 핵심 기능이었기에, DB 구조와 API 명세가 팀원 작업에 직접적인 영향을 미쳤습니다.
  - 팀원들과의 지속적인 소통과 문서화를 통해 협업의 중요성을 체감할 수 있었습니다.

