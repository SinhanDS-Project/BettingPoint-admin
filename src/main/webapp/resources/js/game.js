	
	let originalGameImageUrl = '';
	
	// 페이지 로드 시 초기화
    document.addEventListener('DOMContentLoaded', function() {
    	fetchGameList();
        setupDragAndDrop('imageDropArea', 'gameImage', 'imagePreview');
    });

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

        function displayImagePreview(file, previewId = 'imagePreview') {
            const reader = new FileReader();
            reader.onload = function(e) {
                const preview = document.getElementById(previewId);
                preview.innerHTML = '';  // 기존 미리보기 초기화
                
                // previewId에 따라 함수 선택
                const removeFn = previewId === 'editImagePreview'
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
    
    
    function removePreview(previewId = 'imagePreview') {
        const preview = document.getElementById(previewId);
        preview.innerHTML = '';
        // 선택된 파일도 초기화하려면 해당 input도 초기화
        const inputId = previewId === 'editImagePreview' ? 'editGameImageFile' : 'gameImage';
        document.getElementById(inputId).value = '';
    } 
    
 // 수정 모달 미리보기 되돌리기
    function restoreOriginalPreview(previewId) {
        const preview = document.getElementById(previewId);
        const imgUrl = originalGameImageUrl;
        
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
        const inputId = (previewId === 'editImagePreview') ? 'editGameImageFile' : 'gameImage';
        const fileInput = document.getElementById(inputId);
        if (fileInput) {
            fileInput.value = '';
        }

        // hidden dataset에 원래 path 다시 설정
        preview.dataset.oldPath = imgUrl.split('/').pop();
    }
    
    

	function fetchGameList() {
	  $.ajax({
		  url: cpath + "/api/game/list",
		  type: "GET",
		  success: function(data) {
			  const grid = $(".game-grid");
			  grid.empty();
	
			  data.forEach(game => {
				  const card = `
					<div class="game-card">
						  <h4>
						  	 ${game.name}
						  	 <span class="badge ${game.type}">
						  	 	 ${game.type === 'SINGLE' ? '개인' : '단체'}
						  	 </span>
						  </h4>
        	
						  <img src="${game.game_img}" alt="${game.game_name}" width="200" height="200">
						  <p><strong>설명:</strong> ${game.description}</p>
						  <p><strong>상태:</strong>
						  	 ${game.status === 'ACTIVE'
						  	 	? '<span class="status-active">✅ 사용 가능</span>'
						     	: '<span class="status-developing">🚧 개발 중</span>'
						  	 }
						  </p>

						  <div class="game-actions">
						  	 <button class="btn btn-primary" onclick="openEditModal('${game.uid}')">수정</button>
						     <button class="btn btn-danger" id="deleteGameSubmitBtn" onclick="deleteGame('${game.game_img}','${game.uid}')">삭제</button>
						  </div>
					</div>
				  `;
				  grid.append(card);
			  });
	
			  // 전역 변수로 저장해두면 수정 시 활용 가능
			  window.gameList = data;
		  },
		  error: function() {
			  alert("게임 목록을 불러오지 못했습니다.");
		  }
	  });
	}


	$(document).ready(function () {
	  	fetchGameList();
	
	  	$("#gameForm").on("submit", function (e) {
	    	e.preventDefault(); // 기본 제출 막기
	    	
	    	const submitBtn = document.getElementById("gameSubmitBtn");
	        submitBtn.disabled = true;
	        submitBtn.textContent = "등록 중...";
	    	
	    	const fileInput = document.getElementById("gameImage");
		    const file = fileInput.files[0];
		
		    if (!file) {
		        alert("이미지를 선택해주세요.");
		        submitBtn.disabled = false;
		        submitBtn.textContent = "게임 등록";
		        return;
		    }
		
		    if (file.size > 5 * 1024 * 1024) {
		        alert("파일 크기는 5MB를 초과할 수 없습니다.");
		        submitBtn.disabled = false;
		        submitBtn.textContent = "게임 등록";
		        return;
		    }
	
		    // 🔹 게임 정보
		    const gameData = {
				name: $("#gameName").val(),
				type: $("#gameType").val(),
				description: $("#gameDescription").val(),
				game_img: "",
				status: $("#status").val()
		    };
	
		    // 🔹 게임 레벨 정보 수집
		    const levelInputs = [
				{ level: "HARD", probId: "#probHard", rewardId: "#rewardHard" },
				{ level: "NORMAL", probId: "#probNormal", rewardId: "#rewardNormal" },
				{ level: "EASY", probId: "#probEasy", rewardId: "#rewardEasy" }
		    ];
	
		    const levels = levelInputs.map(input => ({
				level: input.level,
				probability: parseFloat($(input.probId).val()),
				reward: parseFloat($(input.rewardId).val())
		    }));
	
		    // 🔹 전체 전송 데이터 (GameDetailDTO 형식)
		    const requestData = {
				game: gameData,
				levels: levels
		    };
		    
		    const formData = new FormData();
		    formData.append("game", new Blob([JSON.stringify(requestData)], { type: "application/json" }));
		    formData.append("file", file); 
		
		    $.ajax({
				  url: `${cpath}/api/game/create`,
				  type: "POST",
				  data: formData,
				  enctype: 'multipart/form-data',
				  processData: false,
				  contentType: false,
				  success: function (res) {
					  alert("게임 등록 완료!");
					  $("#gameForm")[0].reset();
					  removePreview('imagePreview');
					  fetchGameList();
				  },
				  error: function () {
					  alert("서버 오류 발생!");
				  },
				  complete: function () {
					  // 성공하든 실패하든 버튼 복구
					  submitBtn.disabled = false;
					  submitBtn.textContent = "게임 등록";
				  }
			});
	  	});
	});


	function openEditModal(uid) {
		 $.ajax({
		    url: `${cpath}/api/game/${uid}`,
		    type: "GET",
		    success: function (res) {
		    	const game = res.game;
		        const levels = res.levels || [];
		        				
				// 기존 값 채워넣기
				$("#editUid").val(game.uid);
				$("#editName").val(game.name);
				$("#editType").val(game.type);
				$("#editStatus").val(game.status);
				$("#editDescription").val(game.description);
				
				const oldImagePath = game.game_img;
				
				originalGameImageUrl = oldImagePath;
				
				// 이미지 미리보기 설정
			    document.getElementById('editImagePreview').innerHTML = `
			    		<div style="position: relative; display: inline-block;">
			    			<img src="${oldImagePath}" alt="현재 이미지"
			    					style="max-width: 300px; max-height: 200px; border-radius: 8px;">
			    			<button type="button" onclick="restoreOriginalPreview('editImagePreview')" 
			    					style="position: absolute; top: 5px; right: 5px; 
			    						background: #e53e3e; color: white; border: none; 
			    						border-radius: 50%; width: 25px; 
			    						height: 25px; cursor: pointer;">×</button>
			    		</div>
			    `;
			    // 기존 이미지 경로 저장
			    document.getElementById('editImagePreview').dataset.oldPath = oldImagePath.split('/').pop();
				
				// 레벨 정보 맵핑
			    const levelMap = {};
			    levels.forEach(lvl => {
			        levelMap[lvl.level] = lvl;
			    });
				
				const levelInputs = [
			        { level: "HARD", probId: "#editHardProb", rewardId: "#editHardReward" },
			        { level: "NORMAL", probId: "#editNormalProb", rewardId: "#editNormalReward" },
			        { level: "EASY", probId: "#editEasyProb", rewardId: "#editEasyReward" }
			    ];
				
				levelInputs.forEach(({ level, probId, rewardId }) => {
				    const lvlData = levelMap[level];
				    if (lvlData) {
				    	$(probId).val(lvlData.probability);
				    	$(rewardId).val(lvlData.reward);
				    } else {
					    $(probId).val("");
					    $(rewardId).val("");
					}
				});
				
				$("#editModal").fadeIn();  // 모달 열기
			    setupDragAndDrop('editImageDropArea', 'editGameImageFile', 'editImagePreview');
		    },
		    error: function () {
		    	alert("게임 정보를 불러오는 데 실패했습니다.");
		    }
		 });
	}

	// 폼 제출 이벤트
	$(document).ready(function () {
		$("#editForm").on("submit", function (e) {
			e.preventDefault();
			
			const submitBtn = document.getElementById("editGameSubmitBtn");
	        submitBtn.disabled = true;
	        submitBtn.textContent = "저장 중...";
	        
			const uid = $("#editUid").val();
			const imagePath = document.getElementById('editImagePreview').dataset.oldPath;

			
			// ✅ 게임 레벨 정보 수집 (3개 레벨)
			const levels = [
				{
					level: "HARD",
					probability: parseFloat($("#editHardProb").val()),
					reward: parseFloat($("#editHardReward").val())
				},
				{
					level: "NORMAL",
					probability: parseFloat($("#editNormalProb").val()),
					reward: parseFloat($("#editNormalReward").val())
				},
				{
					level: "EASY",
					probability: parseFloat($("#editEasyProb").val()),
					reward: parseFloat($("#editEasyReward").val())
				}
			];
			
			const gameData = {
					game: {
						uid: uid,
						name: $("#editName").val(),
						type: $("#editType").val(),
						description: $("#editDescription").val(),
						game_img: imagePath,
						original_image_path: originalGameImageUrl.split('/').pop(),
						status: $("#editStatus").val()
						
					},
					levels: levels
				};

	        const formData = new FormData();
			formData.append("game", new Blob([JSON.stringify(gameData)], { type: "application/json" }));
	        
	        const fileInput = document.getElementById('editGameImageFile');
	        if (fileInput.files.length > 0) {
	            formData.append("file", fileInput.files[0]);
	        }
			
		    $.ajax({
		    	url: `${cpath}/api/game/update`,
		    	method: "POST",
		    	data: formData,
	            enctype: 'multipart/form-data',
	            processData: false,
	            contentType: false,  
		    	success: function (res) {
	    			alert("게임 수정 성공!");
	    			closeEditModal();
	    			fetchGameList();
		    	},
		    	error: function () {
			        alert("서버 통신 오류 발생");
		    	},
	            complete: function () {
	                // 성공하든 실패하든 버튼 원상복귀
	                submitBtn.disabled = false;
	                submitBtn.textContent = "저장";
	            }
	    	});
		});
	});

	//모달 닫기
	function closeEditModal() {
		$("#editForm")[0].reset();
		$("#editModal").fadeOut();
	}


	function deleteGame(imagePath, uid) {
		const submitBtn = document.getElementById("deleteGameSubmitBtn");
        submitBtn.disabled = true;
        submitBtn.textContent = "삭제 중...";
        
        if (!confirm("정말 삭제하시겠습니까?")) {
        	submitBtn.disabled = false;
            submitBtn.textContent = "삭제";
        	return;
        }
	
		$.ajax({
			url:`${cpath}/api/game/delete`,
			type: "DELETE",
			contentType: 'application/json',
	        data: JSON.stringify({
	            uid: uid,
	            game_img: imagePath
	        }),
			success: function (res) {
				alert("삭제 완료!");
				fetchGameList();  // 목록 갱신
			},
			error: function () {
				alert("서버 오류 발생 ");
		    },
            complete: function () {
                // 성공하든 실패하든 버튼 원상복귀
                submitBtn.disabled = false;
                submitBtn.textContent = "삭제";
            }
		});
	}


