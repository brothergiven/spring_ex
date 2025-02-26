# -------------------------
# 1. 빌드 단계 (Builder Stage)
FROM openjdk:17 AS builder

WORKDIR /app

# 소스 코드 복사 및 빌드 도구 설치
COPY . .

# Gradle 빌드에 필요한 xargs 설치
RUN chmod +x ./gradlew
RUN microdnf install findutils

# Gradle을 사용해 애플리케이션 빌드 (테스트 생략)
RUN ./gradlew build -x test

# -------------------------
# 2. 실행 단계 (Run Stage)
FROM openjdk:17-jdk-alpine

WORKDIR /app

# 빌드 스테이지에서 생성된 JAR 파일만 복사
COPY --from=builder /app/build/libs/*.jar app.jar

# 애플리케이션 포트 노출
EXPOSE 8080

# 컨테이너 시작 시 애플리케이션 자동 실행
ENTRYPOINT ["java", "-jar", "app.jar"]