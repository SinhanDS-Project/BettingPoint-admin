<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 대시보드</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 40px;
            padding: 40px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .page-header h1 {
            font-size: 3rem;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .page-header p {
            font-size: 1.2rem;
            opacity: 0.9;
        }

        /* 섹션 숨기기/보이기 */
        .section {
            display: none;
        }

        .section.active {
            display: block;
        }

        /* 통계 카드 */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            padding: 30px;
            border-radius: 15px;
            color: white;
            text-align: center;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card.blue {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .stat-card.green {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
        }

        .stat-card.purple {
            background: linear-gradient(135deg, #9f7aea 0%, #805ad5 100%);
        }

        .stat-card.orange {
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
        }

        .stat-card h3 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .stat-card p {
            opacity: 0.9;
            font-size: 1.1rem;
        }

        /* 관리 기능 카드 */
        .management-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .management-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .management-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
            border-color: #667eea;
        }

        .management-card .icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin-bottom: 20px;
        }

        .management-card .icon.blue { background: linear-gradient(135deg, #e6f3ff 0%, #cce7ff 100%); }
        .management-card .icon.green { background: linear-gradient(135deg, #e6fffa 0%, #ccfff5 100%); }
        .management-card .icon.purple { background: linear-gradient(135deg, #f0e6ff 0%, #e6ccff 100%); }
        .management-card .icon.orange { background: linear-gradient(135deg, #fff5e6 0%, #ffebcc 100%); }
        .management-card .icon.red { background: linear-gradient(135deg, #ffe6e6 0%, #ffcccc 100%); }
        .management-card .icon.indigo { background: linear-gradient(135deg, #eee6ff 0%, #ddccff 100%); }

        .management-card h3 {
            font-size: 1.4rem;
            margin-bottom: 10px;
            color: #2d3748;
            font-weight: 600;
        }

        .management-card p {
            color: #718096;
            margin-bottom: 15px;
            font-size: 0.95rem;
        }

        .management-card .count {
            font-size: 2rem;
            font-weight: 700;
            color: #667eea;
        }

        .management-card .count-label {
            font-size: 0.9rem;
            color: #a0aec0;
        }

        /* 일반 카드 */
        .card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
        }

        .card h2 {
            color: #2d3748;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 3px solid #667eea;
            font-size: 1.8rem;
            display: flex;
            align-items: center;
            font-weight: 600;
        }

        .card h2::before {
            margin-right: 12px;
            font-size: 1.6rem;
        }

        /* 버튼 스타일 */
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            margin-right: 10px;
            margin-bottom: 10px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-danger {
            background: linear-gradient(135deg, #e53e3e 0%, #c53030 100%);
            color: white;
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(229, 62, 62, 0.4);
        }

        .btn-warning {
            background: linear-gradient(135deg, #dd6b20 0%, #c05621 100%);
            color: white;
        }

        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(221, 107, 32, 0.4);
        }

        .btn-outline {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
        }

        .btn-outline:hover {
            background: #667eea;
            color: white;
        }

        .btn-back {
            background: #f7fafc;
            color: #4a5568;
            border: 2px solid #e2e8f0;
        }

        .btn-back:hover {
            background: #edf2f7;
            border-color: #cbd5e0;
        }

        /* 테이블 스타일 */
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .table th,
        .table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        .table th {
            background: linear-gradient(135deg, #f8fafc 0%, #edf2f7 100%);
            font-weight: 600;
            color: #4a5568;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .table tr:hover {
            background-color: #f8fafc;
        }

        .table tr:last-child td {
            border-bottom: none;
        }

        /* 폼 스타일 */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #4a5568;
            font-size: 0.95rem;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: white;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-row .form-group {
            flex: 1;
        }

        /* 배지 스타일 */
        .badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-admin {
            background: linear-gradient(135deg, #e53e3e 0%, #c53030 100%);
            color: white;
        }

        .badge-user {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
        }

        .badge-moderator {
            background: linear-gradient(135deg, #dd6b20 0%, #c05621 100%);
            color: white;
        }

        .badge-notice {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .badge-faq {
            background: linear-gradient(135deg, #9f7aea 0%, #805ad5 100%);
            color: white;
        }

        /* 차트 컨테이너 */
        .chart-container {
            position: relative;
            height: 400px;
            margin: 20px 0;
            background: white;
            border-radius: 10px;
            padding: 20px;
        }

        .chart-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        /* 콘텐츠 그리드 */
        .content-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .content-item {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 20px;
            background: #f8fafc;
            transition: all 0.3s ease;
        }

        .content-item:hover {
            border-color: #667eea;
            background: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .content-item img {
            width: 100%;
            height: 150px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .content-item iframe {
            width: 100%;
            height: 200px;
            border-radius: 8px;
            border: none;
        }

        .content-item h4 {
            font-size: 1.1rem;
            margin-bottom: 10px;
            color: #2d3748;
            font-weight: 600;
        }

        .content-item p {
            color: #718096;
            font-size: 0.9rem;
            margin-bottom: 15px;
        }

        /* QnA 아이템 */
        .qna-item {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            background: #f8fafc;
            transition: all 0.3s ease;
        }

        .qna-item:hover {
            border-color: #667eea;
            background: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .qna-item h4 {
            color: #667eea;
            margin-bottom: 12px;
            font-size: 1.1rem;
            font-weight: 600;
        }

        .qna-item .answer {
            margin-bottom: 15px;
            color: #4a5568;
        }

        .qna-item .meta {
            font-size: 0.85rem;
            color: #a0aec0;
            margin-bottom: 15px;
        }

        /* 최근 활동 */
        .recent-activity {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        .activity-item {
            display: flex;
            align-items: center;
            justify-content: between;
            padding: 20px;
            background: #f8fafc;
            border-radius: 12px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }

        .activity-item:hover {
            background: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .activity-info {
            flex: 1;
        }

        .activity-info h5 {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 5px;
        }

        .activity-info p {
            color: #718096;
            font-size: 0.9rem;
        }

        .activity-meta {
            text-align: right;
        }

        .activity-meta .amount {
            font-weight: 700;
            color: #48bb78;
            font-size: 1.1rem;
        }

        .activity-meta .date {
            font-size: 0.8rem;
            color: #a0aec0;
            margin-top: 5px;
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            
            .page-header h1 {
                font-size: 2rem;
            }
            
            .form-row {
                flex-direction: column;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .management-grid {
                grid-template-columns: 1fr;
            }
            
            .chart-grid {
                grid-template-columns: 1fr;
            }
            
            .recent-activity {
                grid-template-columns: 1fr;
            }
        }

        /* 폼 배경 */
        .form-section {
            background: linear-gradient(135deg, #f8fafc 0%, #edf2f7 100%);
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 30px;
            border: 1px solid #e2e8f0;
        }

        .form-section h3 {
            color: #2d3748;
            margin-bottom: 20px;
            font-size: 1.3rem;
            font-weight: 600;
        }
    </style>
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
                <div class="management-card" onclick="showSection('members')">
                    <div class="icon blue">🧑‍💼</div>
                    <h3>회원 관리</h3>
                    <p>회원 목록 확인 및 권한 관리</p>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
                        <span class="count">3</span>
                        <span class="count-label">명의 회원</span>
                    </div>
                </div>

                <div class="management-card" onclick="showSection('boards')">
                    <div class="icon green">📋</div>
                    <h3>게시판 관리</h3>
                    <p>공지사항 및 게시글 관리</p>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
                        <span class="count">4</span>
                        <span class="count-label">개의 게시글</span>
                    </div>
                </div>

                <div class="management-card" onclick="showSection('content')">
                    <div class="icon purple">🖼️</div>
                    <h3>콘텐츠 관리</h3>
                    <p>배너 및 영상 콘텐츠 관리</p>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
                        <span class="count">3</span>
                        <span class="count-label">개의 콘텐츠</span>
                    </div>
                </div>

                <div class="management-card" onclick="showSection('statistics')">
                    <div class="icon orange">📊</div>
                    <h3>게임 통계</h3>
                    <p>수익률 및 이용 현황 분석</p>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
                        <span class="count">83.3%</span>
                        <span class="count-label">수익률</span>
                    </div>
                </div>

                <div class="management-card" onclick="showSection('games')">
                    <div class="icon red">🎮</div>
                    <h3>게임 관리</h3>
                    <p>게임 등록 및 설정 관리</p>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
                        <span class="count">3</span>
                        <span class="count-label">개의 게임</span>
                    </div>
                </div>

                <div class="management-card" onclick="showSection('chatbot')">
                    <div class="icon indigo">🤖</div>
                    <h3>챗봇 관리</h3>
                    <p>QnA 및 고객 문의 관리</p>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
                        <span class="count">2</span>
                        <span class="count-label">개의 QnA</span>
                    </div>
                </div>
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

        <!-- 6. 챗봇 관리 섹션 -->
        <div id="chatbot" class="section">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <div>
                    <h2 style="margin-bottom: 10px;">🤖 챗봇 관리</h2>
                    <p style="color: #718096;">QnA와 사용자 질의를 관리하세요.</p>
                </div>
                <button class="btn btn-back" onclick="showSection('dashboard')">대시보드로 돌아가기</button>
            </div>
            
            <!-- QnA 등록 폼 -->
            <div class="form-section">
                <h3>QnA 등록</h3>
                <form>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="qnaQuestion">질문</label>
                            <input type="text" id="qnaQuestion" placeholder="자주 묻는 질문을 입력하세요">
                        </div>
                        <div class="form-group">
                            <label for="qnaCategory">카테고리</label>
                            <select id="qnaCategory">
                                <option value="general">일반</option>
                                <option value="game">게임</option>
                                <option value="payment">결제</option>
                                <option value="account">계정</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="qnaAnswer">답변</label>
                        <textarea id="qnaAnswer" rows="4" placeholder="답변을 입력하세요"></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">QnA 등록</button>
                </form>
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

    <script>
        // 섹션 전환 함수
        function showSection(sectionId) {
            // 모든 섹션 숨기기
            const sections = document.querySelectorAll('.section');
            sections.forEach(section => {
                section.classList.remove('active');
            });
            
            // 선택된 섹션 보이기
            document.getElementById(sectionId).classList.add('active');
            
            // 페이지 상단으로 스크롤
            window.scrollTo(0, 0);
        }

        // Chart.js 설정
        document.addEventListener('DOMContentLoaded', function() {
            // 일별 접속자 수 라인 차트
            const visitorsCtx = document.getElementById('visitorsChart');
            if (visitorsCtx) {
                new Chart(visitorsCtx.getContext('2d'), {
                    type: 'line',
                    data: {
                        labels: ['01-15', '01-16', '01-17', '01-18', '01-19', '01-20', '01-21'],
                        datasets: [{
                            label: '접속자 수',
                            data: [120, 150, 180, 200, 170, 220, 250],
                            borderColor: '#667eea',
                            backgroundColor: 'rgba(102, 126, 234, 0.1)',
                            tension: 0.4,
                            fill: true,
                            borderWidth: 3,
                            pointBackgroundColor: '#667eea',
                            pointBorderColor: '#ffffff',
                            pointBorderWidth: 2,
                            pointRadius: 6
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: false
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: {
                                    color: '#f1f5f9'
                                },
                                ticks: {
                                    color: '#64748b'
                                }
                            },
                            x: {
                                grid: {
                                    color: '#f1f5f9'
                                },
                                ticks: {
                                    color: '#64748b'
                                }
                            }
                        }
                    }
                });
            }

            // 게임별 이용률 파이 차트
            const gameUsageCtx = document.getElementById('gameUsageChart');
            if (gameUsageCtx) {
                new Chart(gameUsageCtx.getContext('2d'), {
                    type: 'pie',
                    data: {
                        labels: ['슬롯머신', '블랙잭', '룰렛', '포커', '기타'],
                        datasets: [{
                            data: [35, 25, 20, 15, 5],
                            backgroundColor: [
                                '#667eea',
                                '#764ba2',
                                '#f093fb',
                                '#f5576c',
                                '#4facfe'
                            ],
                            borderWidth: 0,
                            hoverOffset: 10
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: {
                                    padding: 20,
                                    usePointStyle: true,
                                    color: '#64748b'
                                }
                            }
                        }
                    }
                });
            }
        });

        // 폼 제출 이벤트 처리 (예시)
        document.addEventListener('submit', function(e) {
            e.preventDefault();
            alert('폼이 제출되었습니다! (실제로는 서버로 전송됩니다)');
        });

        // 삭제 버튼 클릭 이벤트
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('btn-danger') && e.target.textContent.includes('삭제')) {
                if (confirm('정말로 삭제하시겠습니까?')) {
                    alert('삭제되었습니다!');
                    // 실제로는 서버에 삭제 요청을 보냅니다
                }
            }
        });
    </script>
</body>
</html>
