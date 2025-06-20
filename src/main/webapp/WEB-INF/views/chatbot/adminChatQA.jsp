<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 챗봇 QA 관리</title>
    
    <link rel="stylesheet" href="${cpath}/resources/css/adminChatQA.css"> 
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
	    const cpath = "${pageContext.request.contextPath}";
	</script>
	<script src="${cpath}/resources/js/adminChatQA.js" defer></script>

</head>
<body>
	<div class="chatbot">
		<div class="page-header">
            <h1>관리자 대시보드</h1>
            <p>모든 관리 기능을 한눈에 확인하고 관리하세요</p>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
			<div>
			    <h2 style="margin-bottom: 10px;">🤖 챗봇 관리</h2>
				<p style="color: #718096;">QnA와 사용자 질의를 관리하세요.</p>
			</div>
			<button class="btn btn-back" onclick="location.href='/admin'">대시보드로 돌아가기</button>
		</div>
        	    
	    <!-- QnA 등록 폼 -->
        <div class="form-section">
            <h3>QnA 등록</h3>
            <p style="color: #718096; margin-bottom: 20px;">챗봇이 사용할 질문과 답변을 등록합니다.</p>
            <form id="qnaForm" method="post">
                <div class="form-row">
                    <div class="form-group">
                        <label for="qnaQuestion">질문</label>
                        <input type="text" id="qnaQuestion" placeholder="자주 묻는 질문을 입력하세요" required>
                    </div>
                    <div class="form-group">
                        <label for="qnaCategory">카테고리</label>
                        <select id="qnaCategory" required>
                            <option value="">카테고리 선택</option>
                            <option value="game">게임</option>
                            <option value="point">포인트</option>
                            <option value="etc">기타</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="qnaAnswer">답변</label>
                    <textarea id="qnaAnswer" rows="4" placeholder="답변을 입력하세요" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">QnA 등록</button>
            </form>
        </div>
        
    
    
	    <!-- QnA 리스트 테이블 -->
	    <div class="card">
	    	<h3>등록된 QnA</h3>
		    <!-- 이 div에 카드들이 추가됨 -->
			<div id="qnaList" class="qna-list"></div>
			<div id="pagination" class="pagination" style="margin-top: 20px; text-align: center;"></div>
		</div>
	</div>
  
</body>
</html>
