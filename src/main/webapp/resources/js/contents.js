	
	// 페이지 로드 시 초기화
    document.addEventListener('DOMContentLoaded', function() {
    	loadBannerList(1);
        setupDragAndDrop();
    });
    
    function loadBannerList(page = 1) {
	    $.ajax({
	        url: `${cpath}/api/banner/allBanner`,
	        type: 'GET',
	        success: function(res) {
	            const bannerData = res.data;
	            
	            const bannerListDiv = document.getElementById('bannerList');
	            const s3BaseUrl = "https://bettopia-bucket.s3.ap-southeast-2.amazonaws.com/";
	            bannerListDiv.innerHTML = ""; // 기존 내용 비우기
	
	            bannerData.forEach(banner => {
	                const item = document.createElement('div');
	                item.className = 'content-item';

	                item.innerHTML = `
	                    <img src="${s3BaseUrl}${banner.image_path}" alt="${banner.title}">
	                    <h4>${banner.title}</h4>
	                    <p>${banner.description}</p>
	                    <div class="meta">
	                        <span>위치: 미지정</span>
	                        <span>조회: 0회</span>
	                    </div>
	                    <a href="${banner.banner_link_url}" class="link-preview" target="_blank">${banner.banner_link_url}</a>
	                    <div class="actions">
	                        <button class="btn btn-warning" onclick="editBanner(this, '${banner.uid}')">수정</button>
	                        <button class="btn btn-danger" onclick="deleteBanner('${banner.image_path}', '${banner.uid}')">삭제</button>
	                    </div>
	                `;
	                bannerListDiv.appendChild(item);
	            });
	        },
	        error: function(xhr) {
	            alert("배너 목록 불러오기 실패");
	        }
	    });
	}

	// 탭 전환 함수
    function showTab(tabName) {
        // 모든 탭 버튼과 콘텐츠 비활성화
        document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
        
        // 선택된 탭 활성화
        event.target.classList.add('active');
        document.getElementById(tabName).classList.add('active');
    }

    // 드래그 앤 드롭 기능
    function setupDragAndDrop() {
        const dropArea = document.getElementById('bannerDropArea');
        const fileInput = document.getElementById('bannerImage');

        // 드래그 앤 드롭 이벤트
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, preventDefaults, false);
        });

        function preventDefaults(e) {
            e.preventDefault();
            e.stopPropagation();
        }

        ['dragenter', 'dragover'].forEach(eventName => {
            dropArea.addEventListener(eventName, highlight, false);
        });

        ['dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, unhighlight, false);
        });

        function highlight(e) {
            dropArea.classList.add('dragover');
        }

        function unhighlight(e) {
            dropArea.classList.remove('dragover');
        }

        dropArea.addEventListener('drop', handleDrop, false);
        dropArea.addEventListener('click', () => fileInput.click());

        function handleDrop(e) {
            const dt = e.dataTransfer;
            const files = dt.files;
            handleFiles(files);
        }

        fileInput.addEventListener('change', function(e) {
            handleFiles(this.files);
        });

        function handleFiles(files) {
            if (files.length > 0) {
                const file = files[0];
                if (file.type.startsWith('image/')) {
                    displayImagePreview(file);
                } else {
                    alert('이미지 파일만 업로드 가능합니다.');
                }
            }
        }

        function displayImagePreview(file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const preview = document.getElementById('bannerPreview');
                preview.innerHTML = `
                    <div style="position: relative; display: inline-block;">
                        <img src="${e.target.result}" alt="미리보기" style="max-width: 300px; max-height: 200px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
                        <button type="button" onclick="removePreview()" style="position: absolute; top: 5px; right: 5px; background: #e53e3e; color: white; border: none; border-radius: 50%; width: 25px; height: 25px; cursor: pointer;">×</button>
                    </div>
                `;
            };
            reader.readAsDataURL(file);
        }
    }

    function removePreview() {
        document.getElementById('bannerPreview').innerHTML = '';
        document.getElementById('bannerImage').value = '';
    }
    
    
    // 폼 등록 함수(insert)
    function submitBannerForm() {
	    const fileInput = document.getElementById("bannerImage");
	    const file = fileInput.files[0];
	
	    if (!file) {
	        alert("이미지를 선택해주세요.");
	        return;
	    }
	
	    if (file.size > 5 * 1024 * 1024) {
	        alert("파일 크기는 5MB를 초과할 수 없습니다.");
	        return;
	    }
	
	    const bannerData = {
	        title: document.getElementById('bannerTitle').value,
	        banner_link_url: document.getElementById('bannerUrl').value,
	        description: document.getElementById('bannerDescription').value
	    };
	
	    const formData = new FormData();
	    formData.append("banner", new Blob([JSON.stringify(bannerData)], { type: "application/json" }));
	    formData.append("file", file);  
		
	    $.ajax({
	        type: 'POST',
	        url: `${cpath}/api/banner/insertBanner`,
	        data: formData,
	        enctype: 'multipart/form-data',
	        processData: false,
	        contentType: false,
	        success: function (res) {
	            alert(res);
	            loadBannerList();
	            document.getElementById('bannerForm').reset();
	            removePreview();
	        },
	        error: function (xhr) {
	            alert("등록 실패: " + xhr.statusText);
	        }
	    });
	}

    // 배너 등록 폼 제출
    document.getElementById('bannerForm').addEventListener('submit', function(e) {
    	e.preventDefault();
    	
    	submitBannerForm();
    });

	// 배너/영상 관리 함수들
    function editBanner(btnRef, uid) { // update
    	const bannerItem = btnRef.closest('.content-item');
    	
    	const oldTitle = bannerItem.querySelector('h4').innerText.trim();
	    const oldDescription = bannerItem.querySelector('p').innerText.trim();
	    const oldUrl = bannerItem.querySelector('.link-preview').innerText.trim();
		const fullUrl = bannerItem.querySelector('img').getAttribute('src');
		const oldImagePath = fullUrl.split('/').pop();
	
	    const newTitle = prompt("새로운 제목을 입력하세요:", oldTitle);
	    const newDescription = prompt("새로운 설명을 입력하세요:", oldDescription);
	    const newUrl = prompt("새로운 링크를 입력하세요:", oldUrl);
    	
    	if (newTitle && newUrl) {
			const data = {
			    uid: uid,
			    title: newTitle,
			    description: newDescription,
			    banner_link_url: newUrl,
			    image_path: oldImagePath
			};
			
			const cpath = "/admin";
			
			$.ajax({
			    url: `${cpath}/api/banner/updateBanner`,
			    method: "PUT",
			    contentType: "application/json",
			    data: JSON.stringify(data),
			    success: function (res) {
			        alert(res);
			        loadBannerList();
			    },
			    error: function (xhr) {
			        alert("배너 수정 실패: " + xhr.statusText);
			    }
			});
    	}
    
    }
    
	function deleteBanner(imagePath, uid) {
        if (!confirm("정말 삭제하시겠습니까?")) {
        	return;
        }
        
	    const cpath = "/admin";
	    $.ajax({
	    	url: `${cpath}/api/banner/deleteBanner`,
	        type: 'DELETE',
	        contentType: 'application/json',
	        data: JSON.stringify({
	            uid: uid,
	            image_path: imagePath
	        }),
	        success: function(res) {
	            alert(res);
	            loadBannerList(); // 목록 갱신
	        },
	        error: function(xhr) {
	            alert("삭제 실패: " + xhr.statusText);
	        }
	    });
    }
	
	
	
	
	
	
	

    // 유튜브 ID 추출 함수
    function extractYouTubeId(url) {
        const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|&v=)([^#&?]*).*/;
        const match = url.match(regExp);
        return (match && match[2].length === 11) ? match[2] : null;
    }

    // 카테고리명 변환
    function getCategoryName(category) {
        const categories = {
            'intro': '게임 소개',
            'tutorial': '튜토리얼',
            'event': '이벤트',
            'review': '리뷰',
            'news': '뉴스'
        };
        return categories[category] || category;
    }

    function updateVideoCount() {
        const count = document.querySelectorAll('#videoList .content-item').length;
        document.getElementById('videoCount').textContent = count;
    }

    function editVideo(id) {
        alert(`영상 ${id} 수정 기능입니다. 실제로는 수정 폼이 표시됩니다.`);
    }

    function deleteVideo(id) {
        if (confirm('정말로 이 영상을 삭제하시겠습니까?')) {
            alert('영상이 삭제되었습니다!');
            updateVideoCount();
        }
    }

    function toggleVideoStatus(id) {
        alert(`영상 ${id}의 상태가 변경되었습니다.`);
    }

    // 미리보기 함수들
    function previewVideo() {
        const title = document.getElementById('videoTitle').value;
        const url = document.getElementById('videoUrl').value;
        const description = document.getElementById('videoDescription').value;
        
        if (!title || !url) {
            alert('영상 제목과 URL을 입력해주세요.');
            return;
        }
        
        const videoId = extractYouTubeId(url);
        if (!videoId) {
            alert('올바른 유튜브 URL을 입력해주세요.');
            return;
        }
        
        const previewContent = document.getElementById('previewContent');
        previewContent.innerHTML = `
            <div style="text-align: center;">
                //<iframe src="https://www.youtube.com/embed/${videoId}" width="100%" height="400" frameborder="0" allowfullscreen style="border-radius: 10px; margin-bottom: 20px;"></iframe>
                <h3>${title}</h3>
                <p>${description}</p>
            </div>
        `;
        
        document.getElementById('previewModal').style.display = 'block';
    }

    function closeModal() {
        document.getElementById('previewModal').style.display = 'none';
    }

    // 모달 외부 클릭 시 닫기
    window.onclick = function(event) {
        const modal = document.getElementById('previewModal');
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    }

    