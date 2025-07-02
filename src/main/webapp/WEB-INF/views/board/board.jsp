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
	<script src="${cpath}/resources/js/summernote/summernote-lite.js"></script>
	<link rel="stylesheet" href="${cpath}/resources/css/summernote/summernote-lite.css">
</head>
<script>
	var cpath = '${pageContext.request.contextPath}';
</script>
<script src="${cpath}/resources/js/board.js"></script>
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
		<button class="btn btn-back" onclick="location.href='/'">대시보드로 돌아가기</button>
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
				<label for="summernote-create">내용</label>
				<textarea id="summernote-create" name="content" required></textarea>
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
					<label for="summernote-update">내용</label>
					<textarea id="summernote-update" name="content"></textarea>
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