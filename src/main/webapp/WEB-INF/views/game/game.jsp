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
			<h1>관리자 대시보드</h1>
			<p>게임 관리 기능 입니다.</p>
		</div>

		<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
			<div>
				<h2 style="margin-bottom: 10px;">🎮 게임 관리</h2>
				<p style="color: #718096;">모든 게임을 관리하세요.</p>
			</div>
			<button class="btn btn-back" onclick="location.href='/admin'">대시보드로 돌아가기</button>
		</div>

		<!-- 게임 등록 폼 -->
		<div class="form-section">
			<h3>게임 등록</h3>
			<p style="color: #718096; margin-bottom: 20px;">새로운 게임을 등록합니다.</p>
			<form id="gameForm" method="post">
				<div class="form-row">
					<div class="form-group">
						<label for="gameName">게임 이름</label> 
						<input type="text" id="gameName" name="name" placeholder="게임 이름을 입력하세요" required>
					</div>
				</div>
				
				<div class="form-group">
                        <label>게임 이미지</label>
                        <div class="drag-drop-area" id="imageDropArea">
                            <div class="icon">
                            	<img src="${cpath}/resources/images/folder.png" width="100" height="100">
                            </div>
                            <p><strong>파일을 드래그하여 업로드하거나 클릭하여 선택하세요</strong></p>
                            <p style="font-size: 0.9rem; color: #a0aec0; margin-top: 10px;">
                                지원 형식: JPG, PNG, GIF (최대 5MB)<br>
                                한 개의 이미지만 가능합니다.
                            </p>
                            <input type="file" id="gameImage" accept="image/*" style="display: none;" required>
                        </div>
                        <div id="imagePreview" style="margin-top: 15px;"></div>
                    </div>
				
								
				<div class="form-row">					
					<div class="form-group">
						<label for="gameType">종류</label> 
						<select id="gameType" name="type" required>
							<option value="">종류 선택</option>
							<option value="SINGLE">개인</option>
							<option value="MULTI">단체</option>
						</select>
					</div>
					<div class="form-group">
						<label for="status">상태</label> 
						<select id="status" name="status" required>
							<option value="">상태 선택</option>
							<option value="ACTIVE">사용 가능</option>
							<option value="INACTIVE">개발 중</option>
						</select>
					</div>
				</div>
				
				<div class="form-row">
					<div class="form-group"> 
						<label for="gameProbability">Level: HARD  ➡️ 성공 확률 (%)</label> 
						<input type="number" id="probHard" name="probability" step="0.1"
								min="0" max="100" placeholder="예: 15.5" required>
					</div>
					<div class="form-group">
						<label for="reward">배당률</label> 
						<input type="number" id="rewardHard" name="reward" step="1" 
								min="1" placeholder="예: 330" required>
					</div>
				</div>
				<div class="form-row">
					<div class="form-group"> 
						<label for="gameProbability">Level: NORMAL ➡️ 성공 확률 (%)</label> 
						<input type="number" id="probNormal" name="probability" step="0.1"
							min="0" max="100" placeholder="예: 45.5" required>
					</div>
					<div class="form-group">
						<label for="reward">배당률</label> 
						<input type="number" id="rewardNormal" name="reward" step="1" 
								min="1" placeholder="예: 200" required>
					</div>
				</div>
				<div class="form-row">
					<div class="form-group"> 
						<label for="gameProbability">Level: EASY ➡️ 성공 확률 (%)</label> 
						<input type="number" id="probEasy" name="probability" step="0.1"
							min="0" max="100" placeholder="예: 65.5" required>
					</div>
					<div class="form-group">
						<label for="reward">배당률</label> 
						<input type="number" id="rewardEasy" name="reward" step="1" 
								min="1" placeholder="예: 120" required>
					</div>
				</div>

				<div class="form-group">
					<label for="gameDescription">게임 설명</label>
					<textarea id="gameDescription" name="description" rows="3" 
						placeholder="게임에 대한 설명을 입력하세요" required></textarea>
				</div>

				<button type="submit" id="gameSubmitBtn" class="btn btn-primary">게임 등록</button>
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
						<label for="editName">게임 이름</label> 
						<input type="text" id="editName" readonly="readonly">
					</div>
					
					<div class="form-group">
					    <label>게임 이미지</label>
					    <div class="drag-drop-area" id="editImageDropArea">
					        <div class="icon">
					            <img src="${cpath}/resources/images/folder.png" width="100" height="100">
					        </div>
					        <p><strong>파일을 드래그하여 업로드하거나 클릭하여 선택하세요</strong></p>
					        <p style="font-size: 0.9rem; color: #a0aec0; margin-top: 10px;">
					            지원 형식: JPG, PNG, GIF (최대 5MB)<br>
					            한 개의 이미지만 가능합니다.
					        </p>
					        <input type="file" id="editGameImageFile" accept="image/*" style="display: none;">
					    </div>
					    <div id="editImagePreview" style="margin-top: 15px;"></div>
					</div>

					<div class="form-row">
						<div class="form-group">
							<label for="editType">종류</label> 
							<select id="editType" required>
								<option value="SINGLE">개인</option>
								<option value="MULTI">단체</option>
							</select>
						</div>
						
						<div class="form-group">
							<label for="editStatus">상태</label> 
							<select id="editStatus" required>
								<option value="ACTIVE">사용 가능</option>
								<option value="INACTIVE">개발 중</option>
							</select>
						</div>
					</div>

					<div class="form-row">
						<div class="form-group">
							<label for="editProbability">Level: HARD ➡️ 성공 확률 (%)</label>
							<input type="number" id="editHardProb" step="0.1" required>
						</div>
						<div class="form-group">
							<label for="editReward">배당률</label> 
							<input type="number" id="editHardReward" required>
						</div>
					</div>
					
					<div class="form-row">
						<div class="form-group">
							<label for="editProbability">Level: NORMAL ➡️ 성공 확률 (%)</label>
							<input type="number" id="editNormalProb" step="0.1" required>
						</div>
						<div class="form-group">
							<label for="editReward">배당률</label> 
							<input type="number" id="editNormalReward" required>
						</div>
					</div>
					<div class="form-row">
						<div class="form-group">
							<label for="editProbability">Level: EASY ➡️ 성공 확률 (%)</label>
							<input type="number" id="editEasyProb" step="0.1" required>
						</div>
						<div class="form-group">
							<label for="editReward">배당률</label> 
							<input type="number" id="editEasyReward" required>
						</div>
					</div>

					<div class="form-group">
						<label for="editDescription">설명</label>
						<textarea id="editDescription" required></textarea>
					</div>
				</form>
			</div>
			
			<div class="modal-footer">
				<button type="submit" form="editForm" id="editGameSubmitBtn" class="btn btn-primary">저장</button>
				<button type="button" class="btn btn-secondary" onclick="closeEditModal()">취소</button>
			</div>
		</div>


		

	</div>
</body>
</html>