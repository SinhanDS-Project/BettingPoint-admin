	
	let originalBannerImageUrl = '';
	
	// 페이지 로드 시 초기화
    document.addEventListener('DOMContentLoaded', function() {
    	loadBannerList(1);
        setupDragAndDrop('bannerDropArea', 'bannerImage', 'bannerPreview');
    });

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
    function setupDragAndDrop(dropAreaId, fileInputId, previewId) {
        const dropArea = document.getElementById(dropAreaId);
        const fileInput = document.getElementById(fileInputId);
        
        // ✅ 중복 등록 방지
        if (fileInput.dataset.listenerAttached === 'true') {
            return; // 이미 등록된 경우 아무 것도 하지 않음
        }
        fileInput.dataset.listenerAttached = 'true'; // 최초 등록 표시
        
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
                    const dt = new DataTransfer();
                    dt.items.add(file);
                    fileInput.files = dt.files;
                	
                    displayImagePreview(file, previewId);
                } else {
                    alert('이미지 파일만 업로드 가능합니다.');
                }
            }
        }
        

        function displayImagePreview(file, previewId = 'bannerPreview') {
            const reader = new FileReader();
            reader.onload = function(e) {
                const preview = document.getElementById(previewId);
                preview.innerHTML = '';  // 기존 미리보기 초기화
                
                // previewId에 따라 함수 선택
                const removeFn = previewId === 'editBannerPreview'
                    ? `restoreOriginalPreview('${previewId}')`
                    : `removePreview('${previewId}')`;
                
                preview.innerHTML = `
                    <div style="position: relative; display: inline-block;">
                        <img src="${e.target.result}" alt="미리보기" style="max-width: 300px; max-height: 200px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
                        <button type="button" onclick="${removeFn}" style="position: absolute; top: 5px; right: 5px; background: #e53e3e; color: white; border: none; border-radius: 50%; width: 25px; height: 25px; cursor: pointer;">×</button>
                    </div>
                `;
                
                preview.dataset.oldPath = file.name;
            };
            reader.readAsDataURL(file);
        }
    }

    function removePreview(previewId = 'bannerPreview') {
        const preview = document.getElementById(previewId);
        preview.innerHTML = '';
        // 선택된 파일도 초기화하려면 해당 input도 초기화
        const inputId = previewId === 'editBannerPreview' ? 'editBannerImageFile' : 'bannerImage';
        document.getElementById(inputId).value = '';
    }    

    
    function loadBannerList(page = 1) {
	    $.ajax({
	        url: `${cpath}/api/banner/allBanner`,
	        type: 'GET',
	        success: function(res) {
	            const bannerData = res.data;
	            
	            const bannerListDiv = document.getElementById('bannerList');
	            bannerListDiv.innerHTML = ""; // 기존 내용 비우기
	
	            bannerData.forEach(banner => {
	                const item = document.createElement('div');
	                item.className = 'content-item';

	                item.innerHTML = `
	                    <img src="${banner.image_path}" alt="${banner.title}">
	                    <h4>${banner.title}</h4>
	                    <p>${banner.description}</p>
	                    <div class="meta">
	                        <span>위치: 미지정</span>
	                        <span>조회: 0회</span>
	                    </div>
	                    <a href="${banner.banner_link_url}" class="link-preview" target="_blank">${banner.banner_link_url}</a>
	                    <div class="actions">
	                        <button class="btn btn-warning" onclick="editBanner(this, '${banner.uid}')">수정</button>
	                        <button class="btn btn-danger" id="deleteBannerSubmitBtn" onclick="deleteBanner('${banner.image_path}', '${banner.uid}')">삭제</button>
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
    
    
    // 폼 등록 함수(insert)
    function submitBannerForm() {    	
    	const submitBtn = document.getElementById("bannerSubmitBtn");
        submitBtn.disabled = true;
        submitBtn.textContent = "등록 중...";
        
	    const fileInput = document.getElementById("bannerImage");
	    const file = fileInput.files[0];
	
	    if (!file) {
	        alert("이미지를 선택해주세요.");
	        submitBtn.disabled = false;
	        submitBtn.textContent = "배너 등록";
	        return;
	    }
	
	    if (file.size > 5 * 1024 * 1024) {
	        alert("파일 크기는 5MB를 초과할 수 없습니다.");
	        submitBtn.disabled = false;
	        submitBtn.textContent = "배너 등록";
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
	        },
	        complete: function () {
	            // 성공하든 실패하든 버튼 복구
	            submitBtn.disabled = false;
	            submitBtn.textContent = "배너 등록";
	        }
	    });
	}

    // 배너 등록 폼 제출
    document.getElementById('bannerForm').addEventListener('submit', function(e) {
    	e.preventDefault();
    	
    	submitBannerForm();
    });
            
    // 수정 모달 미리보기 되돌리기
    function restoreOriginalPreview(previewId) {
        const preview = document.getElementById(previewId);
        const imgUrl = originalBannerImageUrl;
        
        preview.innerHTML = `
            <div style="position: relative; display: inline-block;">
                <img src="${imgUrl}" alt="기존 이미지" 
                     style="max-width: 300px; max-height: 200px; border-radius: 8px;">
                <button type="button" onclick="restoreOriginalPreview('${previewId}')" 
                    style="position: absolute; top: 5px; right: 5px; 
                           background: #e53e3e; color: white; border: none; 
                           border-radius: 50%; width: 25px; height: 25px; cursor: pointer;">×</button>
            </div>
        `;
        
        // input 초기화
        const inputId = (previewId === 'editBannerPreview') ? 'editBannerImageFile' : 'bannerImage';
        const fileInput = document.getElementById(inputId);
        if (fileInput) {
            fileInput.value = '';
        }

        // hidden dataset에 원래 path 다시 설정
        preview.dataset.oldPath = imgUrl.split('/').pop();
    }


	// 배너 수정
    function editBanner(btnRef, uid) { // update
    	const bannerItem = btnRef.closest('.content-item');
    	
    	const oldTitle = bannerItem.querySelector('h4').innerText.trim();
	    const oldDescription = bannerItem.querySelector('p').innerText.trim();
	    const oldUrl = bannerItem.querySelector('.link-preview').innerText.trim();
		const oldImagePath = bannerItem.querySelector('img').getAttribute('src');
		
		originalBannerImageUrl = oldImagePath; // ← 글로벌 변수에 저장
	
		// 모달에 값 설정
	    document.getElementById('editBannerUid').value = uid;
	    document.getElementById('editBannerTitle').value = oldTitle;
	    document.getElementById('editBannerDescription').value = oldDescription;
	    document.getElementById('editBannerLink').value = oldUrl;
	    
	    // 이미지 미리보기 설정
	    document.getElementById('editBannerPreview').innerHTML = `
	    		<div style="position: relative; display: inline-block;">
	    			<img src="${oldImagePath}" alt="현재 이미지"
	    					style="max-width: 300px; max-height: 200px; border-radius: 8px;">
	    			<button type="button" onclick="restoreOriginalPreview('editBannerPreview')" 
	    					style="position: absolute; top: 5px; right: 5px; 
	    						background: #e53e3e; color: white; border: none; 
	    						border-radius: 50%; width: 25px; 
	    						height: 25px; cursor: pointer;">×</button>
	    		</div>
	    `;
	    // 기존 이미지 경로 저장
	    document.getElementById('editBannerPreview').dataset.oldPath = oldImagePath.split('/').pop();

	    // 모달 열기
	    document.getElementById('editBannerModal').style.display = 'block';
	    setupDragAndDrop('editBannerDropArea', 'editBannerImageFile', 'editBannerPreview');
    }
    
    document.getElementById('editBannerForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const submitBtn = document.getElementById("editBannerSubmitBtn");
        submitBtn.disabled = true;
        submitBtn.textContent = "저장 중...";
        
        const formData = new FormData();

        const uid = document.getElementById('editBannerUid').value;
        const title = document.getElementById('editBannerTitle').value.trim();
        const link = document.getElementById('editBannerLink').value.trim();
        const description = document.getElementById('editBannerDescription').value.trim();
        const imagePath = document.getElementById('editBannerPreview').dataset.oldPath;


        if (!title || !link || !imagePath) {
            alert("필수 항목을 입력해주세요.");
            submitBtn.disabled = false;
            submitBtn.textContent = "저장";
            return;
        }

        const banner = {
            uid: uid,
            title: title,
            banner_link_url: link,
            description: description,
            image_path: imagePath, // 기존 이미지 그대로 보내고, 새로 선택 시 JS에서 교체됨
            original_image_path: originalBannerImageUrl.split('/').pop()
        };
        
        formData.append("banner", new Blob([JSON.stringify(banner)], { type: "application/json" }));
        
        const fileInput = document.getElementById('editBannerImageFile');
        if (fileInput.files.length > 0) {
            formData.append("file", fileInput.files[0]);
        }
        
        $.ajax({
            url: `${cpath}/api/banner/updateBanner`,
            method: "POST",
            data: formData,
            enctype: 'multipart/form-data',
            processData: false,
            contentType: false,            
            success: function(res) {
                alert(res);
                closeEditBannerModal();
                loadBannerList(); // 목록 갱신
            },
            error: function(xhr) {
                alert("배너 수정 실패: " + xhr.statusText);
            },
            complete: function () {
                // 성공하든 실패하든 버튼 원상복귀
                submitBtn.disabled = false;
                submitBtn.textContent = "저장";
            }
        });
    });
    
    function closeEditBannerModal() {
        document.getElementById('editBannerModal').style.display = 'none';
    }

    
    // 배너 삭제
	function deleteBanner(imagePath, uid) {
		const submitBtn = document.getElementById("deleteBannerSubmitBtn");
        submitBtn.disabled = true;
        submitBtn.textContent = "삭제 중...";
        
        if (!confirm("정말 삭제하시겠습니까?")) {
        	submitBtn.disabled = false;
            submitBtn.textContent = "삭제";
        	return;
        }
        
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
	        },
            complete: function () {
                // 성공하든 실패하든 버튼 원상복귀
                submitBtn.disabled = false;
                submitBtn.textContent = "삭제";
            }
	    });
    }
 