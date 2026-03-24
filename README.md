# Python Playwright + noVNC Devcontainer with VScode

VScode로 Python Playwright 작업을 위한 Dev Container 설정 저장소입니다.
목표는 다음 3가지를 한 번에 제공하는 것입니다.

- Playwright Python 기반 브라우저 자동화 환경
- noVNC를 통한 GUI 접속 가능한 데스크톱 환경
- Chromium에서 ibus-hangul 기반 한글 입력이 가능한 환경

## 포함된 환경

- Base image: mcr.microsoft.com/playwright/python:v1.58.0-noble
- GUI/입력기: desktop-lite(noVNC), ibus-hangul, dbus-x11, im-config
- 로케일/폰트: ko_KR.UTF-8, Nanum/Noto CJK
- Python 도구: playwright, pytest, pytest-playwright, pytest-asyncio, uv, ruff, httpx, loguru

## 한글 입력 설정

컨테이너에는 한글 입력을 위해 아래 환경 변수가 설정되어 있습니다.

- GTK_IM_MODULE=ibus
- QT_IM_MODULE=ibus
- XMODIFIERS=@im=ibus

## 주요 파일

- .devcontainer/devcontainer.json: VS Code Dev Container 설정
- .devcontainer/docker-compose.yml: 서비스/볼륨/환경변수 설정 (공용)
- .devcontainer/docker-compose.override.yml: 로컬 전용 오버라이드 (Git 무시)
- .devcontainer/Dockerfile.novnc: Python Playwright + noVNC + 한글 입력 환경 빌드

## 사용 방법

### 1단계: 서버 환경 준비

이 저장소를 서버에 배포하기 위한 준비:

1. 이 저장소를 서버의 원하는 위치에 클론:
   ```bash
   git clone https://github.com/jnote1/playwright-node /path/to/playwright-node
   cd /path/to/playwright-node
   ```

### 2단계: VSCode에서 Dev Container로 열기

1. VSCode를 열고 서버 폴더 열기:
   - File > Open Folder > `/path/to/playwright-node`

2. Remote - Containers 확장이 감지하면 알림 표시:
   - "Reopen in Container" 버튼 클릭
   - 또는 Command Palette (`Ctrl+Shift+P`) > "Dev Containers: Reopen in Container"

3. 컨테이너 빌드 & 시작:
   - 첫 실행 시 Dockerfile 빌드 (몇 분 소요)
   - 이후 컨테이너 자동 시작

### 3단계: noVNC GUI 접속

1. VSCode의 포트 포워딩 확인:
   - View > Terminal 또는 `Ctrl+` `
   - 또는 VSCode 왼쪽 아래 "Remote" 표시 클릭

2. 브라우저에서 noVNC 접속:
   - URL: `http://localhost:6080`
   - 또는 서버 IP 사용: `http://<server-ip>:6080`

### 4단계: 작업 수행

VSCode 터미널 또는 noVNC 데스크톱에서:

1. 기본 async 테스트 실행:
   ```bash
   pytest -s
   ```
해당 테스트는 `async_playwright()`를 사용해 Chromium을 비동기로 실행하고,
`headless=False`로 브라우저를 띄운 뒤 `https://playwright.dev/python/`에 접속합니다.
마지막에 `page.pause()`로 Playwright Inspector에서 수동 확인/디버깅이 가능합니다.


### 참고: noVNC 포트 확인

컨테이너가 실행 중이면 포트 포워딩이 자동으로 설정됩니다.

VSCode 포트 탭에서 확인:
- View > Ports
- 6080 포트가 포워드되어 있는지 확인
- 필요하면 "Forward a Port" 클릭 후 6080 입력
