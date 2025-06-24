<%--
  Created by IntelliJ IDEA.
  User: fzaca
  Date: 25. 6. 24.
  Time: 오전 10:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}"  />
<html>
<head>
    <title>게시판 상세 조회</title>
    <link rel="stylesheet" href="${cpath}/resources/css/board.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${cpath}/resources/js/board.js"></script>
</head>
<script>
    var cpath = '${pageContext.request.contextPath}';
</script>
<body>
<div class="board">
    <div class="card">
        <!-- 제목 + 목록 버튼 -->
        <h2 id="detail-title">
            <span id="detail-category-badge" class="badge" style="margin-right: 8px;"></span>
            <span id="detail-title-text"></span>
        </h2>

        <div class="form-section" id="board-detail-section">
            <!-- 작성자 -->
            <div class="form-group" style="display: flex; align-items: center; gap: 8px;">
                <label style="margin: 0;">작성자</label>
                <p id="detail-user" style="margin: 0;"></p>
            </div>

            <!-- 내용 -->
            <div class="form-group">
                <label>내용</label>
                <div id="detail-content" class="qna-item answer"></div>
            </div>

            <!-- 이미지 -->
            <div class="form-group" style="text-align: center;">
                <img id="detail-board-img" src="" alt="게시글 이미지" style="max-width: 100%; border-radius: 12px; display: none;">
            </div>

            <!-- 좋아요, 조회수 (왼쪽 정렬) + 작성일 (오른쪽 정렬) -->
            <div class="form-row" style="display: flex; justify-content: space-between; align-items: center;">
                <div style="display: flex; gap: 20px; align-items: center;">
                    <div class="form-group" style="display: flex; align-items: center; gap: 6px; margin: 0;">
                        <label style="margin: 0;">좋아요</label>
                        <p id="detail-like-count" style="margin: 0;"></p>
                    </div>
                    <div class="form-group" style="display: flex; align-items: center; gap: 6px; margin: 0;">
                        <label style="margin: 0;">조회수</label>
                        <p id="detail-view-count" style="margin: 0;"></p>
                    </div>
                </div>
                <div class="form-group" style="display: flex; align-items: center; gap: 6px; margin: 0; justify-content: flex-end;">
                    <label style="margin: 0;">작성일</label>
                    <p id="detail-created-at" style="margin: 0;"></p>
                </div>
            </div>
        </div>

        <div style="text-align: right; margin-top: 20px;">
            <a href="/board" class="btn btn-back">목록으로</a>
        </div>
    </div>
</div>
<script>
    $(function () {
        const boardId = "${boardId}";
        detailBoard(boardId)
    });
</script>
</body>
</html>
