	
	// 페이지 로드 시 초기화
    document.addEventListener('DOMContentLoaded', function() {
        setupDragAndDrop();
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

    // 배너 등록 폼 제출
    document.getElementById('bannerForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const title = document.getElementById('bannerTitle').value;
        //const position = document.getElementById('bannerPosition').value;
        const url = document.getElementById('bannerUrl').value;
        const description = document.getElementById('bannerDescription').value;
        
        if (title && url) {
            // 새로운 배너 아이템 생성
            const bannerList = document.getElementById('bannerList');
            const newBanner = document.createElement('div');
            newBanner.className = 'content-item';
            newBanner.innerHTML = `
                <img src="https://bettopia-bucket.s3.ap-southeast-2.amazonaws.com/activity.jpg" alt="${title}">
                <h4>${title}</h4>
                <p>${description || '배너 설명이 없습니다.'}</p>
                <div class="meta">
                    <span>위치: 메인 상단</span>
                    <span>조회: 0회</span>
                </div>
                //${url ? `<a href="${url}" class="link-preview" target="_blank">${url}</a>` : ''}
                <div class="actions">
                    <button class="btn btn-warning" onclick="editBanner(${Date.now()})">수정</button>
                    <button class="btn btn-danger" onclick="deleteBanner(${Date.now()})">삭제</button>
                    <button class="btn btn-success" onclick="toggleBannerStatus(${Date.now()})">활성화</button>
                </div>
            `;
            
            //bannerList.appendChild(newBanner);
            
            // 통계 업데이트
            //updateBannerCount();
            
            // 폼 초기화
            document.getElementById('bannerForm').reset();
            removePreview();
            
            alert('배너가 성공적으로 등록되었습니다!');
        }
    });

    // 유튜브 영상 등록 폼 제출
    document.getElementById('videoForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const title = document.getElementById('videoTitle').value;
        const url = document.getElementById('videoUrl').value;
        const description = document.getElementById('videoDescription').value;
        const category = document.getElementById('videoCategory').value;
        
        if (title && url && description && category) {
            const videoId = extractYouTubeId(url);
            if (videoId) {
                // 새로운 영상 아이템 생성
                const videoList = document.getElementById('videoList');
                const newVideo = document.createElement('div');
                newVideo.className = 'content-item';
                newVideo.innerHTML = `
                    <iframe src="https://www.youtube.com/embed/${videoId}" allowfullscreen></iframe>
                    <h4>${title}</h4>
                    <p>${description}</p>
                    <div class="meta">
                        <span>카테고리: ${getCategoryName(category)}</span>
                        <span>조회: 0회</span>
                    </div>
                    유튜브에서 보기
                    /* <a href="${url}" class="link-preview" target="_blank">유튜브에서 보기</a> */
                    <div class="actions">
                        <button class="btn btn-warning" onclick="editVideo(${Date.now()})">수정</button>
                        <button class="btn btn-danger" onclick="deleteVideo(${Date.now()})">삭제</button>
                        <button class="btn btn-success" onclick="toggleVideoStatus(${Date.now()})">활성화</button>
                    </div>
                `;
                
                videoList.appendChild(newVideo);
                
                // 통계 업데이트
                updateVideoCount();
                
                // 폼 초기화
                document.getElementById('videoForm').reset();
                
                alert('영상이 성공적으로 등록되었습니다!');
            } else {
                alert('올바른 유튜브 URL을 입력해주세요.');
            }
        }
    });

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

    // 통계 업데이트 함수
    function updateBannerCount() {
        const count = document.querySelectorAll('#bannerList .content-item').length;
        document.getElementById('bannerCount').textContent = count;
    }

    function updateVideoCount() {
        const count = document.querySelectorAll('#videoList .content-item').length;
        document.getElementById('videoCount').textContent = count;
    }

    // 배너/영상 관리 함수들
    function editBanner(id) {
        alert(`배너 ${id} 수정 기능입니다. 실제로는 수정 폼이 표시됩니다.`);
    }

    function deleteBanner(id) {
        if (confirm('정말로 이 배너를 삭제하시겠습니까?')) {
            alert('배너가 삭제되었습니다!');
            updateBannerCount();
        }
    }

    function toggleBannerStatus(id) {
        alert(`배너 ${id}의 상태가 변경되었습니다.`);
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
    function previewBanner() {
        const title = document.getElementById('bannerTitle').value;
        const description = document.getElementById('bannerDescription').value;
        const url = document.getElementById('bannerUrl').value;
        
        if (!title) {
            alert('배너 제목을 입력해주세요.');
            return;
        }
        
        const previewContent = document.getElementById('previewContent');
        previewContent.innerHTML = `
            <div style="text-align: center;">
                //<img src="https://via.placeholder.com/600x300/667eea/ffffff?text=${encodeURIComponent(title)}" alt="${title}" style="max-width: 100%; border-radius: 10px; margin-bottom: 20px;">
                <h3>${title}</h3>
                <p>${description || '배너 설명이 없습니다.'}</p>
                //${url ? `<p><strong>링크:</strong> <a href="${url}" target="_blank">${url}</a></p>` : ''}
            </div>
        `;
        
        document.getElementById('previewModal').style.display = 'block';
    }

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

    