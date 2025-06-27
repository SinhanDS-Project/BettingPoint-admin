<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>콘텐츠 관리</title>
	
	<link rel="stylesheet" href="${cpath}/resources/css/contents.css"> 
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
	    const cpath = "${pageContext.request.contextPath}";
	</script>
	<script src="${cpath}/resources/js/banner.js" defer></script>
	<script src="${cpath}/resources/js/bettube.js" defer></script>
	
	<script>
        
    </script>	
	
</head>
<body>
	<div class="contents">
		<div class="page-header">
            <h1>관리자 대시보드</h1>
            <p>콘텐츠 관리 페이지입니다.</p>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
			<div>
			    <h2 style="margin-bottom: 10px;">🖼️ 콘텐츠 관리</h2>
				<p style="color: #718096;">QnA와 사용자 질의를 관리하세요.</p>
			</div>
			<button class="btn btn-back" onclick="location.href='/admin'">대시보드로 돌아가기</button>
		</div>
		
		<!-- 통계 카드 -->
        <!-- <div class="stats-grid">
            <div class="stat-card blue">
                <h3 id="bannerCount">2</h3>
                <p>등록된 배너</p>
            </div>
            <div class="stat-card green">
                <h3 id="videoCount">1</h3>
                <p>등록된 영상</p>
            </div>
            <div class="stat-card purple">
                <h3 id="totalViews">1,234</h3>
                <p>총 조회수</p>
            </div>
            <div class="stat-card orange">
                <h3 id="totalClicks">567</h3>
                <p>총 클릭수</p>
            </div>
        </div> -->
		
		<!-- 탭 메뉴 -->
        <div class="tabs">
            <button class="tab-button active" onclick="showTab('banners')">🖼️ 배너 관리</button>
            <button class="tab-button" onclick="showTab('videos')">📹 유튜브 영상</button>
        </div>
		
		<!-- 배너 관리 탭 -->
        <div id="banners" class="tab-content active">
            <!-- 배너 등록 폼 -->
            <div class="form-section">
                <h3>배너 등록</h3>
                <p style="color: #718096; margin-bottom: 20px;">메인페이지에 표시될 배너를 등록합니다.</p>
                
                <form id="bannerForm">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="bannerTitle">배너 제목</label>
                            <input type="text" id="bannerTitle" placeholder="배너 제목을 입력하세요" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>배너 이미지</label>
                        <div class="drag-drop-area" id="bannerDropArea">
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
                        <div id="bannerPreview" style="margin-top: 15px;"></div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="bannerUrl">링크 URL</label>
                            <input type="url" id="bannerUrl" placeholder="클릭 시 이동할 URL을 입력하세요.  ex) http://localhost:9999/admin/board?id=10">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="bannerDescription">배너 설명</label>
                        <textarea id="bannerDescription" rows="3" placeholder="배너에 대한 설명을 입력하세요"></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary" id="bannerSubmitBtn">배너 등록</button>
                </form>
            </div>

            <!-- 등록된 배너 -->
			<div class="card">
				<h3>
                	등록된 배너&nbsp;<small style="font-size: 0.7em; color: #666;">(등록순으로 보여집니다.)</small>
               	</h3>
			    <div class="content-grid" id="bannerList"></div>
			</div>
			
			<!-- 배너 수정 모달 -->
			<div id="editBannerModal" class="modal" style="display: none;">
				<div class="modal-content">
					<div class="modal-header">
						<h3>배너 수정</h3>
						<span class="close" onclick="closeEditBannerModal()">&times;</span>
					</div>
					<div class="modal-body">
						<form id="editBannerForm">
							<input type="hidden" id="editBannerUid" />

							<div class="form-group">
								<label for="editBannerTitle">제목</label> 
								<input type="text" id="editBannerTitle" required />
							</div>

							<div class="form-group">
							    <label>배너 이미지</label>
							    <div class="drag-drop-area" id="editBannerDropArea">
							        <div class="icon">
							            <img src="${cpath}/resources/images/folder.png" width="100" height="100">
							        </div>
							        <p><strong>파일을 드래그하여 업로드하거나 클릭하여 선택하세요</strong></p>
							        <p style="font-size: 0.9rem; color: #a0aec0; margin-top: 10px;">
							            지원 형식: JPG, PNG, GIF (최대 5MB)<br>
							            한 개의 이미지만 가능합니다.
							        </p>
							        <input type="file" id="editBannerImageFile" accept="image/*" style="display: none;">
							    </div>
							    <div id="editBannerPreview" style="margin-top: 15px;"></div>
							</div>

							
							<div class="form-group">
								<label for="editBannerLink">배너 링크 URL</label> 
								<input type="url" id="editBannerLink" required />
							</div>
							
							<div class="form-group">
								<label for="editBannerDescription">설명</label>
								<textarea id="editBannerDescription" required></textarea>
							</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="submit" form="editBannerForm" class="btn btn-primary" id="editBannerSubmitBtn">저장</button>
						<button type="button" class="btn btn-secondary" onclick="closeEditBannerModal()">취소</button>
					</div>
				</div>
			</div>
		</div>
		
		
        <!-- 유튜브 영상 탭 -->
        <div id="videos" class="tab-content">
            <div class="form-section">
                <h3>유튜브 영상 등록</h3>
                <p style="color: #718096; margin-bottom: 20px;">메인페이지에 표시될 유튜브 영상을 등록합니다.</p>
                
                <form id="videoForm">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="videoTitle">영상 제목</label>
                            <input type="text" id="videoTitle" placeholder="영상 제목을 입력하세요" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="videoUrl">유튜브 URL</label>
                        <input type="url" id="videoUrl" placeholder="https://youtube.com/watch?v=..." required>
                        <small style="color: #718096; font-size: 0.85rem; margin-top: 5px; display: block;">
                            유튜브 동영상 URL을 입력하면 자동으로 썸네일이 생성됩니다.
                        </small>
                    </div>

                    <div class="form-group">
                        <label for="videoDescription">영상 설명</label>
                        <textarea id="videoDescription" rows="4" placeholder="영상에 대한 설명을 입력하세요" required></textarea>
                    </div>
                    
                    <button type="submit" class="btn btn-primary" id="videoSubmitBtn">영상 등록</button>
                </form>
            </div>


            <div class="card">
                <h3>
                	등록된 영상&nbsp;<small style="font-size: 0.7em; color: #666;">(등록순으로 보여집니다.)</small>
               	</h3>
                <div class="content-grid" id="videoList"></div>
            </div>
            
            
            <!-- 유튜브 영상 수정 모달 -->
			<div id="editVideoModal" class="modal" style="display: none;">
			    <div class="modal-content">
			        <div class="modal-header">
			            <h3>영상 수정</h3>
			            <span class="close" onclick="closeEditVideoModal()">&times;</span>
			        </div>
			        <div class="modal-body">
			            <form id="editVideoForm">
			                <input type="hidden" id="editVideoUid" />
			
			                <div class="form-group">
			                    <label for="editVideoTitle">영상 제목</label>
			                    <input type="text" id="editVideoTitle" placeholder="영상 제목을 입력하세요" required />
			                </div>
			
			                <div class="form-group">
			                    <label for="editVideoUrl">유튜브 URL</label>
			                    <input type="url" id="editVideoUrl" placeholder="https://youtube.com/watch?v=..." required />
			                    <small style="color: #718096; font-size: 0.85rem; margin-top: 5px; display: block;">
			                        유튜브 동영상 URL을 입력하면 자동으로 썸네일이 생성됩니다.
			                    </small>
			                </div>
			                
			                <div id="editVideoThumbnailPreview" style="margin: 10px 0;">
			                    <!-- 썸네일 미리보기 영역 -->
			                </div>
			
			                <div class="form-group">
			                    <label for="editVideoDescription">영상 설명</label>
			                    <textarea id="editVideoDescription" rows="4" placeholder="영상에 대한 설명을 입력하세요" required></textarea>
			                </div>
			                
			            </form>
			        </div>
			        <div class="modal-footer">
			            <button type="submit" form="editVideoForm" class="btn btn-primary" id="editVideoSubmitBtn">저장</button>
			            <button type="button" class="btn btn-secondary" onclick="closeEditVideoModal()">취소</button>
			        </div>
			    </div>
			</div>
            
        </div>
    </div>		
</body>
</html>


