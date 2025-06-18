<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}"  />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 대시보드</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="${cpath}/resources/css/home.css"> 
	<script src="${cpath}/resources/js/home.js"></script>
</head>
<body>
    <div class="container">
        <!-- 페이지 헤더 -->
        <div class="page-header">
            <h1>관리자 대시보드</h1>
            <p>모든 관리 기능을 한눈에 확인하고 관리하세요</p>
        </div>

        <!-- 메인 대시보드 섹션 -->
        <div id="dashboard" class="section active">
            <!-- 통계 카드 -->
            <div class="stats-grid">
                <div class="stat-card blue">
                    <h3>3</h3>
                    <p>총 회원 수</p>
                </div>
                <div class="stat-card green">
                    <h3>₩1.25M</h3>
                    <p>총 수익</p>
                </div>
                <div class="stat-card purple">
                    <h3>83.3%</h3>
                    <p>수익률</p>
                </div>
                <div class="stat-card orange">
                    <h3>250</h3>
                    <p>오늘 접속자</p>
                </div>
            </div>

            <!-- 관리 기능 카드 -->
            <h2 style="margin-bottom: 30px; color: #2d3748; font-size: 2rem; font-weight: 600;">관리 기능</h2>
            <div class="management-grid">
            
                <a href="${cpath}/user">
                <div class="management-card">
                    <div class="icon blue">🧑‍💼</div>
                    <h3>회원 관리</h3>
                    <p>회원 목록 확인 및 권한 관리</p>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
                        <span class="count">3</span>
                        <span class="count-label">명의 회원</span>
                    </div>
                </div>
                </a>
                
				<a href="${cpath}/board">
                <div class="management-card">
                    <div class="icon green">📋</div>
                    <h3>게시판 관리</h3>
                    <p>공지사항 및 게시글 관리</p>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
                        <span class="count">4</span>
                        <span class="count-label">개의 게시글</span>
                    </div>
                </div>
                </a>
				
				<a href="${cpath}/bettube">
                <div class="management-card">
                    <div class="icon purple">🖼️</div>
                    <h3>콘텐츠 관리</h3>
                    <p>배너 및 영상 콘텐츠 관리</p>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
                        <span class="count">3</span>
                        <span class="count-label">개의 콘텐츠</span>
                    </div>
                </div>
                </a>
				
				<a href="${cpath}/game_statistics">
                <div class="management-card">
                    <div class="icon orange">📊</div>
                    <h3>게임 통계</h3>
                    <p>수익률 및 이용 현황 분석</p>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
                        <span class="count">83.3%</span>
                        <span class="count-label">수익률</span>
                    </div>
                </div>
                </a>
				
				<a href="${cpath}/game">
                <div class="management-card">
                    <div class="icon red">🎮</div>
                    <h3>게임 관리</h3>
                    <p>게임 등록 및 설정 관리</p>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
                        <span class="count">3</span>
                        <span class="count-label">개의 게임</span>
                    </div>
                </div>
                </a>

                <a href="${cpath}/chatbot">
				  <div class="management-card">
				    <div class="icon indigo">🤖</div>
				    <h3>챗봇 관리</h3>
				    <p>QnA 및 고객 문의 관리</p>
				    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
				        <span class="count">2</span>
				        <span class="count-label">개의 QnA</span>
				    </div>
				  </div>
				</a>	
				
            </div>

            <!-- 최근 활동 요약 -->
            <h2 style="margin: 50px 0 30px 0; color: #2d3748; font-size: 2rem; font-weight: 600;">최근 활동</h2>
            <div class="recent-activity">
                <div class="card">
                    <h3 style="margin-bottom: 20px; color: #2d3748; font-size: 1.3rem;">최근 가입 회원</h3>
                    <div class="activity-item">
                        <div class="activity-info">
                            <h5>김철수</h5>
                            <p>kim@example.com</p>
                        </div>
                        <div class="activity-meta">
                            <span class="badge badge-admin">관리자</span>
                            <div class="date">2024-01-15</div>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-info">
                            <h5>이영희</h5>
                            <p>lee@example.com</p>
                        </div>
                        <div class="activity-meta">
                            <span class="badge badge-user">일반회원</span>
                            <div class="date">2024-02-20</div>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-info">
                            <h5>박민수</h5>
                            <p>park@example.com</p>
                        </div>
                        <div class="activity-meta">
                            <span class="badge badge-moderator">운영자</span>
                            <div class="date">2024-03-10</div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <h3 style="margin-bottom: 20px; color: #2d3748; font-size: 1.3rem;">최근 결제 내역</h3>
                    <div class="activity-item">
                        <div class="activity-info">
                            <h5>김철수</h5>
                            <p>슬롯머신</p>
                        </div>
                        <div class="activity-meta">
                            <div class="amount">₩50,000</div>
                            <div class="date">2024-01-20</div>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-info">
                            <h5>이영희</h5>
                            <p>블랙잭</p>
                        </div>
                        <div class="activity-meta">
                            <div class="amount">₩30,000</div>
                            <div class="date">2024-01-19</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 1. 회원 관리 섹션 -->
        <div id="members" class="section">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <div>
                    <h2 style="margin-bottom: 10px;">🧑‍💼 회원 관리</h2>
                    <p style="color: #718096;">회원 목록을 확인하고 권한을 관리하세요.</p>
                </div>
                <button class="btn btn-back" onclick="showSection('dashboard')">대시보드로 돌아가기</button>
            </div>
            
            <div class="card">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>이름</th>
                            <th>이메일</th>
                            <th>권한</th>
                            <th>가입일</th>
                            <th>작업</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>1</td>
                            <td style="font-weight: 600;">김철수</td>
                            <td>kim@example.com</td>
                            <td><span class="badge badge-admin">관리자</span></td>
                            <td>2024-01-15</td>
                            <td>
                                <select class="btn" style="margin-right: 10px; padding: 8px 12px;">
                                    <option>권한 변경</option>
                                    <option>관리자</option>
                                    <option>운영자</option>
                                    <option>일반회원</option>
                                </select>
                                <button class="btn btn-danger">삭제</button>
                            </td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td style="font-weight: 600;">이영희</td>
                            <td>lee@example.com</td>
                            <td><span class="badge badge-user">일반회원</span></td>
                            <td>2024-02-20</td>
                            <td>
                                <select class="btn" style="margin-right: 10px; padding: 8px 12px;">
                                    <option>권한 변경</option>
                                    <option>관리자</option>
                                    <option>운영자</option>
                                    <option>일반회원</option>
                                </select>
                                <button class="btn btn-danger">삭제</button>
                            </td>
                        </tr>
                        <tr>
                            <td>3</td>
                            <td style="font-weight: 600;">박민수</td>
                            <td>park@example.com</td>
                            <td><span class="badge badge-moderator">운영자</span></td>
                            <td>2024-03-10</td>
                            <td>
                                <select class="btn" style="margin-right: 10px; padding: 8px 12px;">
                                    <option>권한 변경</option>
                                    <option>관리자</option>
                                    <option>운영자</option>
                                    <option>일반회원</option>
                                </select>
                                <button class="btn btn-danger">삭제</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 2. 게시판 관리 섹션 -->
        <div id="boards" class="section">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <div>
                    <h2 style="margin-bottom: 10px;">📋 게시판 관리</h2>
                    <p style="color: #718096;">공지사항과 게시글을 관리하세요.</p>
                </div>
                <button class="btn btn-back" onclick="showSection('dashboard')">대시보드로 돌아가기</button>
            </div>
            
            <!-- 공지사항/FAQ 등록 폼 -->
            <div class="form-section">
                <h3>공지사항/FAQ 등록</h3>
                <form>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="boardType">유형</label>
                            <select id="boardType">
                                <option value="notice">공지사항</option>
                                <option value="faq">FAQ</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="boardTitle">제목</label>
                            <input type="text" id="boardTitle" placeholder="제목을 입력하세요">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="boardContent">내용</label>
                        <textarea id="boardContent" rows="4" placeholder="내용을 입력하세요"></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">등록</button>
                </form>
            </div>

            <!-- 등록된 게시글 테이블 -->
            <div class="card">
                <h3 style="margin-bottom: 20px;">등록된 공지사항/FAQ</h3>
                <table class="table">
                    <thead>
                        <tr>
                            <th>유형</th>
                            <th>제목</th>
                            <th>등록일</th>
                            <th>작업</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><span class="badge badge-notice">공지사항</span></td>
                            <td style="font-weight: 600;">서비스 점검 안내</td>
                            <td>2024-01-15</td>
                            <td>
                                <button class="btn btn-warning">수정</button>
                                <button class="btn btn-danger">삭제</button>
                            </td>
                        </tr>
                        <tr>
                            <td><span class="badge badge-faq">FAQ</span></td>
                            <td style="font-weight: 600;">회원가입 방법</td>
                            <td>2024-01-10</td>
                            <td>
                                <button class="btn btn-warning">수정</button>
                                <button class="btn btn-danger">삭제</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- 자유게시판 관리 -->
            <div class="card">
                <h3 style="margin-bottom: 20px;">자유게시판 관리</h3>
                <table class="table">
                    <thead>
                        <tr>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>작성일</th>
                            <th>조회수</th>
                            <th>작업</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td style="font-weight: 600;">게임 후기입니다</td>
                            <td>김철수</td>
                            <td>2024-01-20</td>
                            <td>45</td>
                            <td><button class="btn btn-danger">삭제</button></td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600;">질문있어요</td>
                            <td>이영희</td>
                            <td>2024-01-19</td>
                            <td>23</td>
                            <td><button class="btn btn-danger">삭제</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 3. 메인페이지 콘텐츠 섹션 -->
        <div id="content" class="section">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <div>
                    <h2 style="margin-bottom: 10px;">🖼️ 메인페이지 콘텐츠</h2>
                    <p style="color: #718096;">배너와 유튜브 영상을 관리하세요.</p>
                </div>
                <button class="btn btn-back" onclick="showSection('dashboard')">대시보드로 돌아가기</button>
            </div>
            
            <!-- 배너 등록 -->
            <div class="form-section">
                <h3>배너 등록</h3>
                <form>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="bannerTitle">배너 제목</label>
                            <input type="text" id="bannerTitle" placeholder="배너 제목을 입력하세요">
                        </div>
                        <div class="form-group">
                            <label for="bannerImage">이미지 업로드</label>
                            <input type="file" id="bannerImage" accept="image/*">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="bannerUrl">링크 URL</label>
                        <input type="url" id="bannerUrl" placeholder="클릭 시 이동할 URL을 입력하세요">
                    </div>
                    <button type="submit" class="btn btn-primary">배너 등록</button>
                </form>
            </div>

            <!-- 등록된 배너 -->
            <div class="card">
                <h3 style="margin-bottom: 20px;">등록된 배너</h3>
                <div class="content-grid">
                    <div class="content-item">
                        <img src="https://via.placeholder.com/400x200/667eea/ffffff?text=메인+배너" alt="메인 배너">
                        <h4>메인 배너</h4>
                        <p>링크: https://example.com</p>
                        <button class="btn btn-warning">수정</button>
                        <button class="btn btn-danger">삭제</button>
                    </div>
                    <div class="content-item">
                        <img src="https://via.placeholder.com/400x200/764ba2/ffffff?text=이벤트+배너" alt="이벤트 배너">
                        <h4>이벤트 배너</h4>
                        <p>링크: https://event.com</p>
                        <button class="btn btn-warning">수정</button>
                        <button class="btn btn-danger">삭제</button>
                    </div>
                </div>
            </div>

            <!-- 유튜브 영상 등록 -->
            <div class="form-section">
                <h3>유튜브 영상 등록</h3>
                <form>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="videoTitle">영상 제목</label>
                            <input type="text" id="videoTitle" placeholder="영상 제목을 입력하세요">
                        </div>
                        <div class="form-group">
                            <label for="videoUrl">유튜브 URL</label>
                            <input type="url" id="videoUrl" placeholder="https://youtube.com/watch?v=...">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="videoDesc">영상 설명</label>
                        <textarea id="videoDesc" rows="3" placeholder="영상 설명을 입력하세요"></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">영상 등록</button>
                </form>
            </div>

            <!-- 등록된 영상 -->
            <div class="card">
                <h3 style="margin-bottom: 20px;">등록된 영상</h3>
                <div class="content-grid">
                    <div class="content-item">
                        <iframe src="https://www.youtube.com/embed/dQw4w9WgXcQ" allowfullscreen></iframe>
                        <h4>게임 소개 영상</h4>
                        <p>게임의 기본 규칙과 플레이 방법을 소개합니다.</p>
                        <button class="btn btn-warning">수정</button>
                        <button class="btn btn-danger">삭제</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 4. 게임 통계 섹션 -->
        <div id="statistics" class="section">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <div>
                    <h2 style="margin-bottom: 10px;">📊 게임 통계</h2>
                    <p style="color: #718096;">수익률과 이용 현황을 확인하세요.</p>
                </div>
                <button class="btn btn-back" onclick="showSection('dashboard')">대시보드로 돌아가기</button>
            </div>
            
            <!-- 통계 카드 -->
            <div class="stats-grid">
                <div class="stat-card blue">
                    <h3>₩1,500,000</h3>
                    <p>총 결제 금액</p>
                </div>
                <div class="stat-card green">
                    <h3>₩1,250,000</h3>
                    <p>총 수익</p>
                </div>
                <div class="stat-card purple">
                    <h3>83.3%</h3>
                    <p>수익률</p>
                </div>
                <div class="stat-card orange">
                    <h3>250</h3>
                    <p>오늘 접속자</p>
                </div>
            </div>

            <!-- 회원 결제 내역 -->
            <div class="card">
                <h3 style="margin-bottom: 20px;">회원 결제 내역</h3>
                <table class="table">
                    <thead>
                        <tr>
                            <th>회원ID</th>
                            <th>결제금액</th>
                            <th>게임</th>
                            <th>결제일</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td style="font-weight: 600;">김철수</td>
                            <td style="color: #48bb78; font-weight: 600;">₩50,000</td>
                            <td>슬롯머신</td>
                            <td>2024-01-20</td>
                            <td><span class="badge badge-user">완료</span></td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600;">이영희</td>
                            <td style="color: #48bb78; font-weight: 600;">₩30,000</td>
                            <td>블랙잭</td>
                            <td>2024-01-19</td>
                            <td><span class="badge badge-user">완료</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- 차트 -->
            <div class="chart-grid">
                <div class="card">
                    <h3 style="margin-bottom: 20px;">일별 접속자 수</h3>
                    <div class="chart-container">
                        <canvas id="visitorsChart"></canvas>
                    </div>
                </div>
                <div class="card">
                    <h3 style="margin-bottom: 20px;">게임별 이용률</h3>
                    <div class="chart-container">
                        <canvas id="gameUsageChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- 5. 게임 관리 섹션 -->
        <div id="games" class="section">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <div>
                    <h2 style="margin-bottom: 10px;">🎮 게임 관리</h2>
                    <p style="color: #718096;">게임을 등록하고 관리하세요.</p>
                </div>
                <button class="btn btn-back" onclick="showSection('dashboard')">대시보드로 돌아가기</button>
            </div>
            
            <!-- 게임 생성 폼 -->
            <div class="form-section">
                <h3>새 게임 등록</h3>
                <form>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="gameName">게임 이름</label>
                            <input type="text" id="gameName" placeholder="게임 이름을 입력하세요">
                        </div>
                        <div class="form-group">
                            <label for="gameProbability">승률 (%)</label>
                            <input type="number" id="gameProbability" min="0" max="100" placeholder="50">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="gameDesc">게임 설명</label>
                        <textarea id="gameDesc" rows="3" placeholder="게임 설명을 입력하세요"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="gamePayout">배당률 (%)</label>
                        <input type="number" id="gamePayout" min="0" max="100" placeholder="95">
                    </div>
                    <button type="submit" class="btn btn-primary">게임 등록</button>
                </form>
            </div>

            <!-- 등록된 게임 리스트 -->
            <div class="card">
                <h3 style="margin-bottom: 20px;">등록된 게임</h3>
                <table class="table">
                    <thead>
                        <tr>
                            <th>게임명</th>
                            <th>설명</th>
                            <th>승률</th>
                            <th>배당률</th>
                            <th>상태</th>
                            <th>등록일</th>
                            <th>작업</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td style="font-weight: 600;">슬롯머신</td>
                            <td>클래식 슬롯머신 게임</td>
                            <td>45%</td>
                            <td>95%</td>
                            <td><span class="badge badge-user">활성</span></td>
                            <td>2024-01-15</td>
                            <td>
                                <button class="btn btn-warning">수정</button>
                                <button class="btn btn-danger">삭제</button>
                            </td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600;">블랙잭</td>
                            <td>카드 게임 블랙잭</td>
                            <td>48%</td>
                            <td>98%</td>
                            <td><span class="badge badge-user">활성</span></td>
                            <td>2024-01-10</td>
                            <td>
                                <button class="btn btn-warning">수정</button>
                                <button class="btn btn-danger">삭제</button>
                            </td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600;">룰렛</td>
                            <td>유럽식 룰렛</td>
                            <td>47%</td>
                            <td>97%</td>
                            <td><span class="badge badge-moderator">비활성</span></td>
                            <td>2024-01-05</td>
                            <td>
                                <button class="btn btn-warning">수정</button>
                                <button class="btn btn-danger">삭제</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        
            <!-- 기존 QnA 리스트 -->
            <div class="card">
                <h3 style="margin-bottom: 20px;">등록된 QnA</h3>
                <div class="qna-item">
                    <h4>Q: 회원가입은 어떻게 하나요?</h4>
                    <div class="answer"><strong>A:</strong> 홈페이지 우상단의 회원가입 버튼을 클릭하세요.</div>
                    <div class="meta">카테고리: 계정 | 등록일: 2024-01-15</div>
                    <button class="btn btn-warning">수정</button>
                    <button class="btn btn-danger">삭제</button>
                </div>
                <div class="qna-item">
                    <h4>Q: 게임 규칙을 알고 싶어요</h4>
                    <div class="answer"><strong>A:</strong> 각 게임 페이지에서 규칙을 확인할 수 있습니다.</div>
                    <div class="meta">카테고리: 게임 | 등록일: 2024-01-10</div>
                    <button class="btn btn-warning">수정</button>
                    <button class="btn btn-danger">삭제</button>
                </div>
            </div>

            <!-- 회원 질의 내역 -->
            <div class="card">
                <h3 style="margin-bottom: 20px;">회원 질의 내역</h3>
                <table class="table">
                    <thead>
                        <tr>
                            <th>회원ID</th>
                            <th>질문</th>
                            <th>답변</th>
                            <th>날짜</th>
                            <th>상태</th>
                            <th>작업</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td style="font-weight: 600;">user123</td>
                            <td>포인트 충전이 안돼요</td>
                            <td>고객센터로 문의해주세요.</td>
                            <td>2024-01-20</td>
                            <td><span class="badge badge-user">답변완료</span></td>
                            <td><button class="btn btn-warning">수정</button></td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600;">user456</td>
                            <td>비밀번호를 잊어버렸어요</td>
                            <td>-</td>
                            <td>2024-01-21</td>
                            <td><span class="badge badge-admin">대기중</span></td>
                            <td><button class="btn btn-primary">답변하기</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</body>
</html>
