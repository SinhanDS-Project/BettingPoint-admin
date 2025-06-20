	
	function uploadViaAjax() {
		var files = document.getElementById("bannerImage").files;
		
		if (files.size > 5 * 1024 * 1024) {
	        alert("파일 크기는 5MB를 초과할 수 없습니다.");
	        return;
	    }
		
		var formData = new FormData();
		
		
		// 선택된 모든 파일을 FormData에 추가
		for (var i = 0; i < files.length; i++) {
			formData.append('files', files[i]);
		}
		
		// 필요하면 다른 일반 폼 필드도 formData.append로 추가 가능
		$.ajax({
			type: 'POST',
			url: `${cpath}/api/uploadAjax`,
			data: formData,
			processData: false,  // 파일 데이터를 전송할 때 필수 설정
			contentType: false,  // 콘텐츠 타입 자동 설정되도록 false로 지정
			success: function(response) {
				console.log("업로드된 파일 URL 목록:", response);
			    alert("업로드 성공!");
			
			    // 첫 번째 이미지 보여주기
			    if (response.length > 0) {
			        document.getElementById("preview").innerHTML =
			            `<img src="${response[0]}" style="max-width: 200px;">`;
			    }
			},
			error: function(xhr, status, error) {
				alert("업로드 실패: " + error);
			}
		});
	}