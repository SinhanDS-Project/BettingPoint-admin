
	let qnaData = [];     // 전체 QnA 데이터 저장
	const itemsPerPage = 3;  // 한 페이지에 보여줄 개수
	let currentPage = 1;
	
	// 최초 호출
	function loadQAList() {
	    const cpath = "/admin";
	    $.get(`${cpath}/api/chat/question`, function(data) {
	        qnaData = data;
	        currentPage = 1;
	        renderPage(currentPage);
	    });
	}
	
	// 페이지 렌더링
	function renderPage(page) {
	    const start = (page - 1) * itemsPerPage;
	    const end = start + itemsPerPage;
	    const pageItems = qnaData.slice(start, end);
	
	    const qnaList = document.getElementById("qnaList");
	    qnaList.innerHTML = ""; // 초기화
	
	    pageItems.forEach(q => {
	        const qnaItem = document.createElement("div");
	        qnaItem.className = "qna-item";
	        qnaItem.innerHTML = `
	            <h4>Q: ${q.question_text}</h4>
	            <div class="answer"><strong>A:</strong> ${q.answer_text}</div>
	            <div class="meta">
	                <span class="badge badge-outline">${getCategoryName(q.category)}</span>
	            </div>
	            <button class="btn btn-warning" onclick="updateQA(this, '${q.uid}')">
	                <img src="${cpath}/resources/images/edit.png" width="15" height="15">  수정
	            </button>
	            <button class="btn btn-danger" onclick="deleteQA('${q.uid}')">
	                <img src="${cpath}/resources/images/bin.png" width="15" height="15">  삭제
	            </button>
	        `;
	        qnaList.appendChild(qnaItem); // 최신순 위로
	    });
	
	    renderPagination();
	}
	
	// 페이지네이션 렌더링
	function renderPagination() {
	    const totalPages = Math.ceil(qnaData.length / itemsPerPage);
	    const pagination = document.getElementById("pagination");
	    pagination.innerHTML = "";
	
	    const makeButton = (label, page) => {
	        const btn = document.createElement("button");
	        btn.innerText = label;
	        btn.className = (page === currentPage) ? "active-page" : "";
	        btn.onclick = () => {
	            currentPage = page;
	            renderPage(page);
	        };
	        return btn;
	    };
	
	    // 이전 버튼
	    if (currentPage > 1) pagination.appendChild(makeButton("<", currentPage - 1));
	
	    for (let i = 1; i <= totalPages; i++) {
	        pagination.appendChild(makeButton(i, i));
	    }
	
	    // 다음 버튼
	    if (currentPage < totalPages) pagination.appendChild(makeButton(">", currentPage + 1));
	}

	
	function getCategoryName(category) {
	    const categories = {
	        'game': '게임',
	        'point': '포인트',
	        'etc': '기타'
	    };
	    return categories[category] || category;
	}
	
	function insertQA() {
	    const data = {
	        category: $("#qnaCategory").val(),
	        question_text: $("#qnaQuestion").val(),
	        answer_text: $("#qnaAnswer").val()
    	};
    
	    if (!data.category || !data.question_text || !data.answer_text) {
	        alert("모든 항목을 입력해주세요.");
	        return;
	    }
	    
	    var cpath = "/admin";
	    $.ajax({
	        url: `${cpath}/api/chat/insertqa`,
	        method: "POST",
	        contentType: "application/json",
	        data: JSON.stringify(data),
	        success: res => {
	            alert(res);
	            loadQAList();
	            
	            // 등록 성공 후 input 초기화
            	$("#qnaForm")[0].reset();  // form 전체 초기화   
	        },
	        error: (xhr, status, err) => {
		        console.error("요청 실패:", xhr.status, xhr.responseText);
		        alert("요청에 실패했습니다: " + xhr.status);
		    }
	    });
	}
	
	function updateQA(btnRef, uid) {
		const qnaItem = btnRef.closest('.qna-item');
		
	    const oldQuestion = qnaItem.querySelector('h4').innerText.replace("Q: ", "").trim();
	    const oldAnswer = qnaItem.querySelector('.answer').innerText.replace("A:", "").trim();
	    const oldCategory = qnaItem.querySelector('.badge').innerText.trim();
		
		const newQuestion = prompt("새로운 질문을 입력하세요:", oldQuestion);
    	const newAnswer = prompt("새로운 답변을 입력하세요:", oldAnswer);
    	
    	const categoryMap = {
	        "게임": "game",
	        "포인트": "point",
	        "기타": "etc"
	    };
	    const category = categoryMap[oldCategory]; // 한글 → DB 컬럼값
		
		if (newQuestion && newAnswer) {
	        const cpath = "/admin";
	        const data = {
	            uid: uid,
	            question_text: newQuestion,
	            answer_text: newAnswer,
	            category: category
	        };
	
	        $.ajax({
	            url: `${cpath}/api/chat/updateqa`,
	            method: "PUT",
	            contentType: "application/json",
	            data: JSON.stringify(data),
	            success: res => {
	                alert(res);
	                loadQAList();
	            }
	        });
	    }
	}
	
	function deleteQA(uid) {
	    if (!confirm("정말 삭제하시겠습니까?")) return;
	    
	    const cpath = "/admin";
	    $.ajax({
	        url: `${cpath}/api/chat/deleteqa/${uid}`,
	        method: "DELETE",
	        success: res => {
	            alert(res);
	            loadQAList();
	        }
	    });
	}
	
	// 카테고리 버튼 관련 
	$(document).ready(function () {
        $(".category-btn").click(function () {
        	
            $(".category-btn").removeClass("active"); // 다른 버튼 비활성화            
            $(this).addClass("active"); // 현재 버튼 활성화
            
            // hidden input에 값 저장
            const selected = $(this).data("category"); 
            $("#category").val(selected);
            console.log(selected);
        });
    });
    
	$(document).ready(loadQAList);
	
	document.addEventListener("DOMContentLoaded", function () {
	    const qnaForm = document.getElementById('qnaForm');
	    if (qnaForm) {
	        qnaForm.addEventListener('submit', function(e) {
	            e.preventDefault();
	            insertQA();
	        });
	    }
	});
	
    
    