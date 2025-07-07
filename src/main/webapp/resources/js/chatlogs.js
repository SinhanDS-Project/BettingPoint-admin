
	const itemsPerPage = 8;
	let currentPage = 1;
	let totalCount = 0;

	document.addEventListener('DOMContentLoaded', function () {
	    loadChatLogs(1);
	});
	
	function loadChatLogs(page = 1) {
		currentPage = page;
		
	    $.ajax({
	        url: `${cpath}/api/chatlog?page=${page}`,
	        method: 'GET',
	        success: function (res) {
	        	const logs = res.logs;
	            totalCount = res.total;
	        	
	            const tbody = document.getElementById('chatlogTableBody');
	            tbody.innerHTML = '';  // 초기화
	
	            logs.forEach(log => {
	                const tr = document.createElement('tr');
	
	                const status = log.response ? '답변완료' : '대기중';
	                const badgeClass = log.response ? 'badge-user' : 'badge-admin';
	                const chat_date = formatDate(log.chat_date);
	                const actionBtn = log.response
	                    ? `<button class="btn btn-warning" onclick="editResponse('${log.uid}')">수정</button>`
	                    : `<button class="btn btn-primary" onclick="respondToQuery('${log.uid}')">답변하기</button>`;
	                
                    // 🛠️ HTML 제거 후 답변 미리보기 처리
                    const strippedResponse = log.response ? stripHtmlTags(log.response) : '';
                    const truncatedResponse = strippedResponse.length > 20
                        ? strippedResponse.slice(0, 20) + ' ...'
                        : strippedResponse || '-';
	                
	                tr.innerHTML = `
	                		<td style="font-weight: 600;">${log.user_name}</td>
	                		<td>${log.title}</td>
	                		<td>${truncatedResponse}</td>
	                		<td>${chat_date}</td>
	                		<td><span class="badge ${badgeClass}">${status}</span></td>
	                		<td>${actionBtn}</td>
	                `;
								
	                tbody.appendChild(tr);
	            });
	            
	            renderAdminChatPagination(currentPage, totalCount);
	        },
	        error: function (xhr) {
	            alert('채팅 로그 불러오기 실패');
	        }
	    });
	}
	
	function renderAdminChatPagination(current, totalCount) {
	    const container = document.getElementById('chatlogPagination');
	    container.innerHTML = '';
	    const maxPages = Math.ceil(totalCount / itemsPerPage);

	    const createBtn = (label, targetPage, disabled = false, isActive = false, isArrow = false) => {
	    	const classList = [
	    	                   'pagination-btn',
	    	                   isActive ? 'pagination-active' : '',
	    	                   isArrow && disabled ? 'pagination-disabled' : ''
	    	               ].join(' ');

	    	               return `
	    	                   <button 
	    	                       class="${classList}"
	    	                       ${disabled ? 'disabled' : ''}
	    	                       onclick="changeAdminPage(${targetPage})">
	    	                       ${label}
	    	                   </button>
	    	               `;
	    };

	    container.innerHTML += createBtn('<', current - 1, current <= 1);

	    for (let i = 1; i <= maxPages; i++) {
	        container.innerHTML += createBtn(i, i, false, i === current);
	    }

	    container.innerHTML += createBtn('>', current + 1, current >= maxPages);
	}
	
	function changeAdminPage(page) {
	    if (page < 1) return;
	    loadChatLogs(page);
	}
	
	function stripHtmlTags(str) {
	    return str.replace(/<[^>]*>?/gm, '').trim();
	}
	
	// HTML을 plain text로 변환
	function stripHtmlTags(html) {
	    const tmp = document.createElement("div");
	    tmp.innerHTML = html;
	    return tmp.textContent || tmp.innerText || "";
	}
	
	// 날짜 포맷팅 함수 (yyyy.mm.dd)
	function formatDate(dateStr) {
	    if (!dateStr) return "-";
	    const date = new Date(dateStr);
	    if (isNaN(date)) return "-";
	    return date.toLocaleDateString('ko-KR').replace(/\./g, '.').replace(/\s/g, '');
	}
	
	let isSummernoteInitialized = false;
	
	// 응답 등록 모달
	function openEditChatLogModal(log) {
	    document.getElementById('editChatlogUid').value = log.uid;
	    document.getElementById('editChatlogTitle').value = log.title;
	    document.getElementById('editChatlogUser').value = log.user_name;
	    document.getElementById('editChatlogQuestion').innerHTML = log.question;
	    document.getElementById('editChatlogDate').value = formatDate(log.chat_date);
	    
	    // Summernote가 아직 초기화되지 않았다면 초기화
	    if (!isSummernoteInitialized) {
	        $('#summernote').summernote({
	            height: 300,
	            lang: "ko-KR",
	            placeholder: '최대 2048자까지 쓸 수 있습니다',
	            fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New',
        			'맑은 고딕','궁서','굴림체','굴림','돋움체','바탕체'],
		        toolbar: [
		            	// 글꼴 
		                [ 'fontname', ['fontname']],
		                // 글자 크기 설정
		                ['fontsize', ['fontsize']],
		                // 글꼴 스타일
		                ['font', ['bold', 'underline', 'clear']],
		                // 글자 색상
		                ['color', ['color']],
		                // 문단 스타일
		                ['para', ['paragraph']],
		                // 글 높낮이 간격
		                ['height', ['height']],
		            	// 이미지 삽입
		                ['insert', ['picture']],
		                // 코드 보기
		                ['view', ['codeview']],   
		            ]
	            
	        });
	        isSummernoteInitialized = true;
	    }
	    
	    // 답변 내용 세팅
	    $('#summernote').summernote('code', log.response || "");

	    document.getElementById('editChatLogModal').style.display = 'block';
	}
	
	// ChatLog 응답 저장 처리
	document.getElementById('editChatLogForm').addEventListener('submit', function (e) {
	    e.preventDefault();

	    const submitBtn = document.getElementById('editChatlogSubmitBtn');
	    submitBtn.disabled = true;
	    submitBtn.textContent = "저장 중...";

	    const uid = document.getElementById('editChatlogUid').value;
	    const response = $('#summernote').summernote('code');

	    if (!response.trim() || response === '<p><br></p>') {
	        alert("답변을 입력해주세요.");
	        submitBtn.disabled = false;
	        submitBtn.textContent = "저장";
	        return;
	    }

	    const chatlog = {
	        uid: uid,
	        response: response
	    };
	    
	    $.ajax({
	        url: `${cpath}/api/chatlog/updateChatlog`,
	        method: 'PUT',
	        contentType: 'application/json',
	        data: JSON.stringify(chatlog),
	        success: function (res) {
	            alert(res);
	            closeEditChatLogModal();
	            loadChatLogs();  // 목록 갱신
	        },
	        error: function (xhr) {
	        	alert("답변 등록 실패");
	        },
	        complete: function () {
	            submitBtn.disabled = false;
	            submitBtn.textContent = "저장";
	        }
	    });
	});

	
	function closeEditChatLogModal() {
	    document.getElementById('editChatLogModal').style.display = 'none';
	}
	
	// 사용자 질의에 답변
    function respondToQuery(uid) {
    	$.get(`${cpath}/api/chatlog/detail/${uid}`, function (log) {
            openEditChatLogModal(log);  // 모달 오픈
        });
    }

    // 답변 수정
    function editResponse(uid) {
    	$.get(`${cpath}/api/chatlog/detail/${uid}`, function (log) {
            openEditChatLogModal(log);  // 모달 오픈
        });
    }


