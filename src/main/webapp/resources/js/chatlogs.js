	
	document.addEventListener('DOMContentLoaded', function () {
	    loadChatLogs();
	});
	
	function loadChatLogs() {
	    $.ajax({
	        url: `${cpath}/api/chatlog`,
	        method: 'GET',
	        success: function (logs) {
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
	                
	                // 답변 앞 10자 + 말줄임
	                const truncatedResponse = log.response
	                    ? log.response.length > 10
	                        ? log.response.slice(0, 20) + ' ...'
	                        : log.response
	                    : '-';
	                
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
	        },
	        error: function (xhr) {
	            alert('채팅 로그 불러오기 실패');
	        }
	    });
	}
	
	// 날짜 포맷팅 함수 (yyyy.mm.dd)
	function formatDate(dateStr) {
	    if (!dateStr) return "-";
	    const date = new Date(dateStr);
	    if (isNaN(date)) return "-";
	    return date.toLocaleDateString('ko-KR').replace(/\./g, '.').replace(/\s/g, '');
	}
	
	// 응답 등록 모달
	function openEditChatLogModal(log) {
	    document.getElementById('editChatlogUid').value = log.uid;
	    document.getElementById('editChatlogTitle').value = log.title;
	    document.getElementById('editChatlogUser').value = log.user_name;
	    document.getElementById('editChatlogQuestion').value = log.question;
	    document.getElementById('editChatlogDate').value = formatDate(log.chat_date);
	    document.getElementById('editChatlogResponse').value = log.response || "";

	    document.getElementById('editChatLogModal').style.display = 'block';
	}
	
	// ChatLog 응답 저장 처리
	document.getElementById('editChatLogForm').addEventListener('submit', function (e) {
	    e.preventDefault();

	    const submitBtn = document.getElementById('editChatlogSubmitBtn');
	    submitBtn.disabled = true;
	    submitBtn.textContent = "저장 중...";

	    const uid = document.getElementById('editChatlogUid').value;
	    const response = document.getElementById('editChatlogResponse').value;

	    if (!response.trim()) {
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


