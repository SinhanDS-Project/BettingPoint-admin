
	function loadQAList() {
		var cpath = "/admin";
	    $.get(`${cpath}/api/chat/question`, function(data) {
	    	console.log(data);
	        let html = "";
	        data.forEach((q, index) => {
	            html += `<tr>
	                <td>${index + 1}</td>
	                <td>${q.category}</td>
	                <td>${q.question_text}</td>
	                <td>${q.answer_text}</td>
	                <td>
	                    <button onclick="fillForm('${q.uid}', '${q.category}', 
	                    						\`${q.question_text}\`, \`${q.answer_text}\`)">
							<img src="${cpath}/resources/images/edit.png" width="15" height="15"> 수정
						</button>
	                    <button onclick="deleteQA('${q.uid}')">
	                    	<img src="${cpath}/resources/images/bin.png" width="15" height="15"> 삭제
                    	</button>
	                </td>
	            </tr>`;
	        });
	        $("#qaTable tbody").html(html);
	    });
	}
	
	function insertQA() {
	    const data = {
	        category: $("#category").val(),
	        question_text: $("#question_text").val(),
	        answer_text: $("#answer_text").val()
	    };
	    
	    if (!data.category) {
	        alert("카테고리를 선택해주세요.");
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
				$("#qaForm")[0].reset();
				$("#category").val("");                 // 숨겨진 input도 비움
				$(".category-btn").removeClass("active"); // 버튼 선택 해제
	            
	        }
	    });
	}
	
	function updateQA() {
	    const data = {
	        uid: $("#uid").val(),
	        category: $("#category").val(),
	        question_text: $("#question_text").val(),
	        answer_text: $("#answer_text").val()
	    };
	    var cpath = "/admin";
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
	
	function deleteQA(uid) {
	    if (!confirm("정말 삭제하시겠습니까?")) return;
	    var cpath = "/admin";
	    $.ajax({
	        url: `${cpath}/api/chat/deleteqa/${uid}`,
	        method: "DELETE",
	        success: res => {
	            alert(res);
	            loadQAList();
	        }
	    });
	}
	
	function fillForm(uid, category, question, answer) {
	    $("#uid").val(uid);
	    $("#category").val(category);
	    $("#question_text").val(question);
	    $("#answer_text").val(answer);
	    
	    // 버튼 상태 초기화 후 해당 버튼 활성화
	    $(".category-btn").removeClass("active");
	    $(`.category-btn[data-category="${category}"]`).addClass("active");
	}
	
	$(document).ready(loadQAList);
	
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