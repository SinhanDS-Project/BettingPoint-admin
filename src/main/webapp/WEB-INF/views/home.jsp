<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}"  />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 대시보드</title>
    <link rel="stylesheet" href="${cpath}/resources/css/home.css"> 
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
				
				<a href="${cpath}/contents">
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
				
				<a href="${cpath}/chatlogs">
                <div class="management-card">
                    <div class="icon orange">💬</div>
                    <h3>CS 관리</h3>
                    <p>사용자 문의 내역 관리</p>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
                        <span class="count">5</span>
                        <span class="count-label">문의 내역</span>
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
    </div>

</body>
</html>
