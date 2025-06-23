<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 게임 관리</title>
<link rel="stylesheet" href="${cpath}/resources/css/game.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	const cpath = "${pageContext.request.contextPath}";
</script>
<script src="${cpath}/resources/js/game.js"></script>
</head>
<body>
	
	<div id="game-admin" class="game-admin">
		<div class="page-header">
			<h2 style="margin-bottom: 10px;">🎮 게임 관리</h2>
		</div>

		<!-- 게임 등록 폼 -->
		<div class="form-section">
			<h3>게임 등록</h3>
			<p style="color: #718096; margin-bottom: 20px;">새로운 게임을 등록합니다.</p>
			<form id="gameForm" method="post">
				<div class="form-row">
					<div class="form-group">
						<label for="gameName">게임 이름</label> <input type="text"
							id="gameName" name="name" placeholder="게임 이름을 입력하세요" required>
					</div>
					<div class="form-group">
						<label for="gameType">종류</label> <select id="gameType" name="type"
							required>
							<option value="">종류 선택</option>
							<option value="SINGLE">개인</option>
							<option value="MULTI">단체</option>
						</select>
					</div>
				</div>

				<div class="form-row">
					<div class="form-group">
						<label for="gameLevel">난이도</label> <select id="gameLevel"
							name="level" required>
							<option value="">난이도 선택</option>
							<option value="HARD">상</option>
							<option value="MEDIUM">중</option>
							<option value="EASY">하</option>
						</select>
					</div>
					<div class="form-group">
						<label for="gameProbability">성공 확률 (%)</label> <input
							type="number" id="gameProbability" name="probability" step="0.1"
							min="0" max="100" placeholder="예: 65.5" required>
					</div>
				</div>

				<div class="form-row">
					<div class="form-group">
						<label for="reward">배당률</label> <input type="number" id="reward"
							name="reward" step="1" min="1" placeholder="예: 120" required>
					</div>
					<div class="form-group">
						<label for="status">상태</label> <select id="status" name="status"
							required>
							<option value="">상태 선택</option>
							<option value="ACTIVE">사용 가능</option>
							<option value="INACTIVE">개발 중</option>
						</select>
					</div>
				</div>

				<div class="form-group">
					<label for="gameDescription">게임 설명</label>
					<textarea id="gameDescription" name="description" rows="3"
						placeholder="게임에 대한 설명을 입력하세요" required></textarea>
				</div>

				<button type="submit" class="btn btn-primary">게임 등록</button>
			</form>
		</div>
	</div>

	<!-- 게임 목록 -->
	<div class="game-list-header">
		<h3>등록된 게임 목록</h3>
		<div id="gameList" class="game-list">
			<div class="game-grid"></div>
		</div>
	</div>
	
	<div id="editModal" class="modal" style="display: none;">
		<div class="modal-content">
			<div class="modal-header">
				<h3>게임 수정</h3>
				<span class="close" onclick="closeEditModal()">&times;</span>
			</div>
			<div class="modal-body">
				<form id="editForm">
					<input type="hidden" id="editUid">

					<div class="form-group">
						<label for="editName">게임 이름</label> <input type="text"
							id="editName" required>
					</div>

					<div class="form-row">
						<div class="form-group">
							<label for="editType">종류</label> <select id="editType" required>
								<option value="SINGLE">개인</option>
								<option value="GROUP">단체</option>
							</select>
						</div>
						<div class="form-group">
							<label for="editLevel">난이도</label> <select id="editLevel" required>
								<option value="HARD">상</option>
								<option value="MEDIUM">중</option>
								<option value="EASY">하</option>
							</select>
						</div>
					</div>

					<div class="form-row">
						<div class="form-group">
							<label for="editProbability">성공 확률</label> <input type="number"
								id="editProbability" step="0.1" required>
						</div>
						<div class="form-group">
							<label for="editReward">배당률</label> <input type="number"
								id="editReward" required>
						</div>
					</div>

					<div class="form-group">
						<label for="editStatus">상태</label> <select id="editStatus" required>
							<option value="ACTIVE">사용 가능</option>
							<option value="INACTIVE">개발 중</option>
						</select>
					</div>

					<div class="form-group">
						<label for="editDescription">설명</label>
						<textarea id="editDescription" required></textarea>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="submit" form="editForm" class="btn btn-primary">저장</button>
				<button type="button" class="btn btn-secondary"
					onclick="closeEditModal()">취소</button>
			</div>
		</div>
	</div>
</body>
</html>