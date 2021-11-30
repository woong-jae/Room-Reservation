# KNU ROOM

> 2021년 2학기 데이터베이스 강의 팀프로젝트

경북대학교 학생을 대상으로 한 가상 건물의 강의실을 예약을 통해 이용할 수 있도록 하는 웹서비스.

![image](https://user-images.githubusercontent.com/33220404/143905193-8a08c9c1-910f-461a-99ac-c05b95759763.png)

## Environment

- JavaSE-16 (jre)
- Apache Tomcat v8.5
- Oracle 19c

## Getting Started

### Prerequisites

1. 오라클에서 아래 정보의 사용자 생성 및 권한 부여.

- user: "knuroom"
- password: "comp322" 

2. Team12-database.sql 실행.    

3. Apache Tomcat Server 활성화.

### Install and Run 

1. Repository clone
```
git clone https://github.com/woong-jae/STT-Evaluation.git
```

2. Eclipse의 Project Explorer -> Import... -> General -> Existing Projects into Workspace -> Select root directory -> Phase4 -> Projects의 Phase4 체크 확인 -> Finish

3. Phase4 -> src -> main -> webapp -> index.jsp 더블 클릭 -> Run

4. `http://localhost:8080/Phase4/index.jsp`로 접속

### When Running Problems

1. Phase4 우클릭 Properties -> Java Build Path에서 ojdbc8.jar 위치 Edit으로 자신의 컴퓨터 환경에 맞도록 설정
   
2. Run As Server가 뜨지 않은 경우

   Phase4 우클릭 Properties -> Project Facets에서 Dynamic Web Module (버전은 Version 3.1), Java 체크 후 Apply ans Close
   
   - Run As Server 클릭 시 Tomcat Server가 뜨지 않을 경우
 
      이클립스 콘솔창 출력 부분의 Servers탭 -> Tomcat v8.5 Server at localhost 우클릭 -> Add and Remove -> Phase4 클릭 -> Add -> Finish

## Demo

https://www.youtube.com/watch?v=gGVNSLJ5zU0

## Contributor

[김동규](https://github.com/KingDonggyu)

[이장훈](https://github.com/bh2980)

[정재웅](https://github.com/woong-jae)
