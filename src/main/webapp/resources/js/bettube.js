	
	// 페이지 로드 시 초기화
    document.addEventListener('DOMContentLoaded', function() {
    	loadVideoList(); 
    });

	function loadVideoList() {
	    $.ajax({
	        url: `${cpath}/api/bettube/allBettube`,
	        type: 'GET',
	        success: function (res) {
	            const videoData = res.data;
	            const videoListDiv = document.getElementById('videoList');
	            videoListDiv.innerHTML = ""; // 기존 목록 초기화
	
	            videoData.forEach(video => {
	                const videoId = extractYouTubeId(video.bettube_url);  // 유튜브 ID 추출
	
	                const item = document.createElement('div');
	                item.className = 'content-item';
	
	                item.innerHTML = `
	                	<iframe src="https://www.youtube.com/embed/${videoId}" allowfullscreen></iframe>
	                	<h4>${video.title}</h4>
	                	<p>${video.description}</p>
	                	<div class="meta">
	                	    <span>카테고리: 게임 소개</span>
	                	    <span>조회: 0회</span>
	                	</div>
	                	<a href="${video.bettube_url}" class="link-preview" target="_blank">유튜브에서 보기</a>
	                	<div class="actions">
	                	    <button class="btn btn-warning" id='editVideoSubmitBtn' onclick="updateVideo(this, '${video.uid}')">수정</button>
	                	    <button class="btn btn-danger" id='deleteVideoBtn' onclick="deleteVideo('${video.uid}')">삭제</button>
	                	</div>
	                `;
	
	                videoListDiv.appendChild(item);
	            });
	        },
	        error: function (xhr) {
	            alert("영상 목록 불러오기 실패");
	        }
	    });
	}
	
	// 영상 등록 함수
	function submitVideoForm() {
		const submitBtn = document.getElementById("videoSubmitBtn");
	    submitBtn.disabled = true;
	    submitBtn.textContent = "등록 중...";

	    const title = document.getElementById('videoTitle').value.trim();
	    const url = document.getElementById('videoUrl').value.trim();
	    const description = document.getElementById('videoDescription').value.trim();

	    if (!title || !url || !description) {
	        alert("모든 항목을 입력해주세요.");
	        submitBtn.disabled = false;
	        submitBtn.textContent = "영상 등록";
	        return;
	    }

	    const videoId = extractYouTubeId(url);
	    if (!videoId || videoId.length !== 11) {
	        alert("올바른 유튜브 URL을 입력해주세요.");
	        submitBtn.disabled = false;
	        submitBtn.textContent = "영상 등록";
	        return;
	    }

	    const videoData = {
	        title: title,
	        bettube_url: url,
	        description: description,
	        video_id: videoId
	    };

	    $.ajax({
	        type: 'POST',
	        url: `${cpath}/api/bettube/insertBettube`,
	        data: JSON.stringify(videoData),
	        contentType: 'application/json',
	        success: function(res) {
	            alert(res);
	            loadVideoList(); // 영상 목록 새로고침
	            document.getElementById('videoForm').reset();
	        },
	        error: function(xhr) {
	            alert("영상 등록 실패: " + xhr.statusText);
	        },
	        complete: function () {
	            submitBtn.disabled = false;
	            submitBtn.textContent = "영상 등록";
	        }
	    });
	}

	// 유튜브 영상 등록 폼 제출
    document.getElementById('videoForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        submitVideoForm();
    });

    // 유튜브 ID 추출 함수
    function extractYouTubeId(url) {
        try {
            const urlObj = new URL(url);
            const hostname = urlObj.hostname;
            
            if (hostname.includes('youtu.be')) {
                // 짧은 링크 형태 ex) https://youtu.be/xxxxx
                return urlObj.pathname.slice(1);
            } else if (hostname.includes('youtube.com')) { // ex) https://www.youtube.com/watch?v=xxxxx
                const params = new URLSearchParams(urlObj.search);
                return params.get('v');
            }
        } catch (e) {
            return null;
        }
        return null;
    }
    
    // 영상 수정 버튼 클릭 시 호출
    function updateVideo(btnRef, uid) {
        const videoItem = btnRef.closest('.content-item');

        const oldTitle = videoItem.querySelector('h4').innerText.trim();
        const oldDescription = videoItem.querySelector('p').innerText.trim();
        const oldUrl = videoItem.querySelector('.link-preview').getAttribute('href');

        // 모달 필드 설정
        document.getElementById('editVideoUid').value = uid;
        document.getElementById('editVideoTitle').value = oldTitle;
        document.getElementById('editVideoUrl').value = oldUrl;
        document.getElementById('editVideoDescription').value = oldDescription;

        // 썸네일 미리보기 표시
        const videoId = extractYouTubeId(oldUrl);
        const thumbnailUrl = `https://img.youtube.com/vi/${videoId}/hqdefault.jpg`;
        document.getElementById('editVideoThumbnailPreview').innerHTML = `
            <img src="${thumbnailUrl}" alt="미리보기" style="max-width: 100%; border-radius: 8px; margin-top: 10px;">
        `;
        
        // 모달 열기
        document.getElementById('editVideoModal').style.display = 'block';
    }
    
    // 썸네일 자동 반영 코드
    document.getElementById('editVideoUrl').addEventListener('change', function () {
        const url = this.value.trim();
        const videoId = extractYouTubeId(url);

        const preview = document.getElementById('editVideoThumbnailPreview');
        
        if (!videoId || videoId.length !== 11) {
            alert("유효한 유튜브 ID가 아닙니다.");
            return;
        } else if (videoId) {
            const thumbnailUrl = `https://img.youtube.com/vi/${videoId}/hqdefault.jpg`;
            preview.innerHTML = `
                <img src="${thumbnailUrl}" alt="미리보기" style="max-width: 100%; border-radius: 8px; margin-top: 10px;">
            `;
        } else {
            preview.innerHTML = `<p style="color: red;">올바른 유튜브 링크가 아닙니다.</p>`;
        }
    });

    
    // 폼 제출 이벤트 처리
    document.getElementById('editVideoForm').addEventListener('submit', function (e) {
        e.preventDefault();

        const submitBtn = document.getElementById("editVideoSubmitBtn");
        submitBtn.disabled = true;
        submitBtn.textContent = "저장 중...";

        const uid = document.getElementById('editVideoUid').value;
        const title = document.getElementById('editVideoTitle').value.trim();
        const url = document.getElementById('editVideoUrl').value.trim();
        const description = document.getElementById('editVideoDescription').value.trim();

        if (!title || !url || !description) {
            alert("모든 항목을 입력해주세요.");
            submitBtn.disabled = false;
            submitBtn.textContent = "저장";
            return;
        }

        const videoId = extractYouTubeId(url);
        if (!videoId) {
            alert("유효한 유튜브 URL을 입력해주세요.");
            submitBtn.disabled = false;
            submitBtn.textContent = "저장";
            return;
        }

        const bettube = {
            uid: uid,
            title: title,
            bettube_url: url,
            description: description
        };

        $.ajax({
            url: `${cpath}/api/bettube/updateBettube`,
            method: "PUT",
            contentType: "application/json",
            data: JSON.stringify(bettube),
            success: function (res) {
                alert(res);
                closeEditVideoModal();
                loadVideoList(); // 목록 다시 불러오기
            },
            error: function (xhr) {
                alert("영상 수정 실패: " + xhr.statusText);
            },
            complete: function () {
                submitBtn.disabled = false;
                submitBtn.textContent = "저장";
            }
        });
    });
    
    
    // 모달 닫기
    function closeEditVideoModal() {
        document.getElementById('editVideoModal').style.display = 'none';
    }
    
    
    function deleteVideo(uid) {
        const submitBtn = document.getElementById("deleteVideoBtn");
        submitBtn.disabled = true;
        submitBtn.textContent = "삭제 중...";
        
        if (!confirm("정말 삭제하시겠습니까?")) {
        	submitBtn.disabled = false;
        	submitBtn.textContent = "삭제";
            return;
        }

        $.ajax({
            url: `${cpath}/api/bettube/deleteBettube/${uid}`,
            type: 'DELETE',
            success: function(res) {
                alert(res);
                loadVideoList(); // 영상 목록 새로고침
            },
            error: function(xhr) {
                alert("삭제 실패: " + xhr.statusText);
            },
            complete: function () {
            	submitBtn.disabled = false;
            	submitBtn.textContent = "삭제";
            }
        });
    }


    
    
    