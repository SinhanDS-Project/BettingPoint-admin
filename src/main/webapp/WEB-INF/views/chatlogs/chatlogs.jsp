<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>문의 내역 관리</title>
		
 	<link rel="stylesheet" href="${cpath}/resources/css/chatlogs.css"> 
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		const cpath = "${pageContext.request.contextPath}";
	</script>
	<script src="${cpath}/resources/js/chatlogs.js" defer></script>
		
	<!-- summernote -->
	<script src="${cpath}/resources/js/summernote/summernote-lite.js"></script>
	<link rel="stylesheet"
		  href="${cpath}/resources/css/summernote/summernote-lite.css">

</head>
<body>
	<div class="chatlogs">
		<div class="page-header">
            <h1>관리자 대시보드</h1>
            <p>문의 내역 관리 페이지입니다.</p>
        </div>
        
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
			<div>
			    <h2 style="margin-bottom: 10px;">💬 문의 내역 관리</h2>
				<p style="color: #718096;">사용자와의 QnA를 관리하세요.</p>
			</div>
			<button class="btn btn-back" onclick="location.href='/admin'">대시보드로 돌아가기</button>
		</div>
		
		<!-- 사용자 질의 내역 -->
        <div class="card">
            <h3>사용자 질의 내역</h3>
            <p style="color: #718096; margin-bottom: 20px;">사용자들이 챗봇에게 문의한 내용과 답변 현황입니다.</p>
            <table class="table">
                <thead>
                    <tr>
                        <th>사용자</th>
                        <th>질문</th>
                        <th>답변</th>
                        <th>날짜</th>
                        <th>상태</th>
                        <th>작업</th>
                    </tr>
                </thead>
                <!-- 문의 내역 list -->
                <tbody id="chatlogTableBody"></tbody>
            </table>
            
            <!-- ✅ 페이지네이션 영역 추가 -->
		    <div id="chatlogPagination" class="pagination-container" style="margin-top: 20px; text-align: center;">
	        </div>
        </div>
        
        <!-- 답변 등록 모달 -->
        <div id="editChatLogModal" class="modal" style="display: none;">
		    <div class="modal-content">
		        <div class="modal-header">
		            <h3>문의 응답</h3>
		            <span class="close" onclick="closeEditChatLogModal()">&times;</span>
		        </div>
		        <div class="modal-body">
		            <form id="editChatLogForm">
		                <input type="hidden" id="editChatlogUid" />
		
		                <div class="form-group">
		                    <label for="editChatlogTitle">제목</label>
		                    <input type="text" id="editChatlogTitle" readonly />
		                </div>
		
		                <div class="form-group" style="display: flex; gap: 10px;">
						    <div style="flex: 1;">
						        <label for="editChatlogUser">작성자</label>
						        <input type="text" id="editChatlogUser" readonly />
						    </div>
						    <div style="flex: 1;">
						        <label for="editChatlogDate">문의일</label>
						        <input type="text" id="editChatlogDate" readonly />
						    </div>
						</div>
		
		                <div class="form-group">
		                    <label for="editChatlogQuestion">질문 내용</label>
		                    <textarea id="editChatlogQuestion" rows="4" readonly></textarea>
		                </div>
		
		                <div class="form-group">
		                    <label for="editChatlogResponse">답변 내용</label>
		                    <!-- summernote가 적용될 textarea (id와 name 둘 다 content로 통일) -->
							<textarea id="summernote" name="content"></textarea>
		                    <!-- <textarea id="editChatlogResponse" rows="4" placeholder="여기에 답변 내용을 입력하세요" required></textarea> -->
		                </div>
		            </form>
		        </div>
		        <div class="modal-footer">
		            <button type="submit" form="editChatLogForm" class="btn btn-primary" id="editChatlogSubmitBtn">저장</button>
		            <button type="button" class="btn btn-secondary" onclick="closeEditChatLogModal()">취소</button>
		        </div>
		    </div>
		</div>
        
	</div>
</body>
</html>