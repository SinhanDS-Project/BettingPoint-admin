<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 게시판 관리</title>
	<link rel="stylesheet" href="${cpath}/resources/css/board.css">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="${cpath}/resources/js/board.js"></script>
	<script src="${cpath}/resources/js/fileAjax.js"></script>
</head>
<script>
	var cpath = '${pageContext.request.contextPath}';
</script>
<body>
<!-- 2. 게시판 관리 섹션 -->
<div id="board" class="board">
	<div class="page-header">
		<h1>관리자 대시보드</h1>
		<p>게시판 관리 기능입니다.</p>
	</div>
	<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
		<div>
			<h2 style="margin-bottom: 10px;">📋 게시판 관리</h2>
			<p style="color: #718096;">공지사항과 게시글을 관리하세요.</p>
		</div>
		<button class="btn btn-back" onclick="location.href='/admin'">대시보드로 돌아가기</button>
	</div>

	<!-- 공지사항/FAQ 등록 폼 -->
	<div class="form-section">
		<h3>공지사항/FAQ 등록</h3>
		<form> <%--onsubmit="uploadViaAjax()">--%>
			<div class="form-row">
				<div class="form-group">
					<label for="boardTitle">제목</label>
					<input type="text" id="boardTitle" placeholder="제목을 입력하세요">
				</div>
				<div class="form-group">
					<label for="boardType">카테고리</label>
					<select id="boardType">
						<option value="NOTICE">공지사항</option>
						<option value="FAQ">FAQ</option>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label for="boardContent">내용</label>
				<textarea id="boardContent" rows="4" placeholder="내용을 입력하세요"></textarea>
			</div>
			<div class="form-group">
				<label>게시판 이미지</label>
				<div class="drag-drop-area" id="boardDropArea">
					<div class="icon">
						<img src="${cpath}/resources/images/folder.png" width="100" height="100">
					</div>
					<p><strong>파일을 드래그하여 업로드하거나 클릭하여 선택하세요</strong></p>
					<p style="font-size: 0.9rem; color: #a0aec0; margin-top: 10px;">
						지원 형식: JPG, PNG, GIF (최대 5MB)<br>
						한 개의 이미지만 가능합니다.
					</p>
					<input type="file" id="bannerImage" accept="image/*" style="display: none;">
				</div>
				<div id="boardPreview" style="margin-top: 15px;"></div>
			</div>
			<button type="submit" class="btn btn-primary">등록</button>
		</form>
	</div>

	<!-- 등록된 게시글 테이블 (공지사항 / FAQ) -->
	<div class="card">
		<h3 style="margin-bottom: 20px;">등록된 공지사항/FAQ</h3>
		<table class="table">
			<thead>
			<tr>
				<th>카테고리</th>
				<th>제목</th>
				<th>작성자</th>
				<th>등록일</th>
				<th>작업</th>
			</tr>
			</thead>
			<tbody id="board-list-notice">
			<!-- JS로 렌더링 -->
			</tbody>
		</table>
	</div>

	<!-- 자유게시판 관리 -->
	<div class="card">
		<h3 style="margin-bottom: 20px;">자유게시판 관리</h3>
		<table class="table">
			<thead>
			<tr>
				<th>카테고리</th>
				<th>제목</th>
				<th>작성자</th>
				<th>등록일</th>
				<th>작업</th>
			</tr>
			</thead>
			<tbody id="board-list-free">
			<!-- JS로 렌더링 -->
			</tbody>
		</table>
	</div>
</div>

<!-- 게시글 수정 모달 -->
<div id="editModal" class="modal">
	<div class="modal-content">
		<div class="modal-header">
			<h3>게시글 수정</h3>
			<span class="close" onclick="closeEditModal()">&times;</span>
		</div>

		<form id="editBoardForm">
			<div class="modal-body">
				<input type="hidden" id="edit-board-id">

				<div class="form-group">
					<label for="edit-category">카테고리</label>
					<select id="edit-category">
						<option value="NOTICE">공지사항</option>
						<option value="FAQ">FAQ</option>
					</select>
				</div>

				<div class="form-group">
					<label for="edit-title">제목</label>
					<input type="text" id="edit-title" required>
				</div>

				<div class="form-group">
					<label for="edit-content">내용</label>
					<textarea id="edit-content" rows="4" required></textarea>
				</div>

				<div class="form-group">
					<label for="edit-img">이미지 URL</label>
					<input type="text" id="edit-img">
				</div>
			</div>

			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" onclick="closeEditModal()">취소</button>
				<button type="submit" class="btn btn-primary">수정 완료</button>
			</div>
		</form>
	</div>
</div>
<script>
	$(function () {
		// setupDragAndDrop();
		insertBoard();
		loadBoardList();
		updateBoard();
	});

	function closeEditModal() {
		$('#editModal').fadeOut();
	}
</script>
</body>
</html>