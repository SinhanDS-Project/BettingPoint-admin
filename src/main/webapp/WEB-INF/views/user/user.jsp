<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>회원 관리 페이지</title>
	
	<link rel="stylesheet" href="${cpath}/resources/css/user.css">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
	    const cpath = "${pageContext.request.contextPath}";
	</script>
	<script src="${cpath}/resources/js/user.js" defer></script>

</head>
<body>
	<div class="userManagement">
		<div class="page-header">
			<h1>관리자 대시보드</h1>
			<p>회원 관리 페이지입니다.</p>
		</div>
		<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
			<div>
				<h2 style="margin-bottom: 10px;">👤 회원 관리</h2>
				<p style="color: #718096;">회원 목록을 확인하고 권한을 관리하세요.</p>
			</div>
			<button class="btn btn-back" onclick="location.href='/admin'">대시보드로 돌아가기</button>
		</div>

		<!-- 회원 목록 탭 -->
		<div id="list" class="tab-content active">
			<!-- 검색 및 필터 -->
			<div class="search-filter-section">
				<div class="search-row">
					<div class="form-group">
						<label for="searchInput">회원 검색</label> 
						<input type="text" id="searchInput" placeholder="이름, 이메일로 검색..."
							oninput="searchMembers()">
					</div>
					<div class="form-group">
						<label for="roleFilter">권한 필터</label> 
						<select id="roleFilter" onchange="filterMembers()">
							<option value="">전체</option>
							<option value="ADMIN">관리자</option>
							<option value="USER">일반회원</option>
						</select>
					</div>
					<div class="form-group">
						<label for="sortBy">정렬</label> 
						<select id="sortBy" onchange="sortMembers()">
							<option value="name">이름순</option>
							<option value="date">가입일순</option>
							<option value="spending">포인트순</option>
						</select>
					</div>
					<div>
						<label>&nbsp;</label>
						<button class="btn btn-primary" onclick="resetFilters()">초기화</button>
					</div>
				</div>
			</div>

			<!-- 회원 테이블 -->
			<div class="card">
				<div class="table-container">
					<table class="table" id="memberTable">
						<thead>
							<tr>
								<th>No. </th>
								<th>회원 정보</th>
								<th>권한</th>
								<th>가입일</th>
								<th>최근 접속</th>
								<th>총 포인트</th>
								<th>작업</th>
							</tr>
						</thead>
						<tbody id="memberTableBody"></tbody>
					</table>
				</div>

				<!-- 페이지네이션 -->
				<div class="pagination"></div>
			</div>
		</div>
		
		 <!-- 회원 상세 모달 -->
	    <div id="memberModal" class="modal">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h3>회원 상세 정보</h3>
	                <span class="close" onclick="closeModal()">&times;</span>
	            </div>
	            <div class="modal-body" id="memberModalContent">
	                <!-- 회원 상세 정보가 여기에 표시됩니다 -->
	            </div>
	        </div>
	    </div>		
		
	</div>
</body>
</html>