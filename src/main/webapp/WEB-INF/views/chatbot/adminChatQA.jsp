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
	<script src="${cpath}/resources/js/adminChatQA.js"></script>
    
</head>
<body>

    <h2>챗봇 QA 목록</h2>
    <table id="qaTable">
        <thead>
            <tr>
                <th>No.</th>
                <th>카테고리</th>
                <th>질문</th>
                <th>답변</th>
                <th>수정/삭제</th>
            </tr>
        </thead>
        <tbody>
        
        </tbody>
    </table>

    <div class="form-container">
        <h3>QA 등록/수정</h3>
        <div class="form-actions">
	        <button type="button" onclick="insertQA()">
	        	<img src="${cpath}/resources/images/register.png" width="15" height="15"> 등록
	        </button>
	        <button type="button" onclick="updateQA()">
	        	<img src="${cpath}/resources/images/edit.png" width="15" height="15"> 수정
	        </button>
	    </div>
        <form id="qaForm">
            <input type="hidden" id="uid">
            
            <label>카테고리:</label><br>
			<div id="categoryButtons">
			    <button type="button" class="category-btn" data-category="game">게임</button>
			    <button type="button" class="category-btn" data-category="point">포인트</button>
			    <button type="button" class="category-btn" data-category="etc">기타</button>
			</div>
			<input type="hidden" id="category">
            
            <label>질문:</label><br>
            <input type="text" id="question_text"><br>
            
            <label>답변:</label><br>
            <textarea id="answer_text" rows="4"></textarea><br>
            
            <br>
            
        </form>
    </div>

    <script>

    </script>

</body>
</html>
