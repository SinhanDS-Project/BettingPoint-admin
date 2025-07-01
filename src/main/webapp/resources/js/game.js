	
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
						     <button class="btn btn-danger" onclick="deleteGame('${game.uid}')">삭제</button>
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
		
		    $.ajax({
				  url: `${cpath}/api/game/create`,
				  type: "POST",
				  contentType: "application/json",
				  data: JSON.stringify(requestData),
				  success: function (res) {
					  alert("게임 등록 완료!");
					  $("#gameForm")[0].reset();
					  fetchGameList();
				  },
				  error: function () {
					  alert("서버 오류 발생!");
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
				
				game_img = game.game_img;
				
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

			const uid = $("#editUid").val();
			
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
						status: $("#editStatus").val()						
					},
					levels: levels
				};
			
		    $.ajax({
		    	url: `${cpath}/api/game/update`,
		    	method: "PUT",
		    	contentType: "application/json",
		    	data: JSON.stringify(gameData),
		    	success: function (res) {
	    			alert("게임 수정 성공!");
	    			closeEditModal();
	    			fetchGameList();
		    	},
		    	error: function () {
			        alert("서버 통신 오류 발생");
		    	}
	    	});
		});
	});

	//모달 닫기
	function closeEditModal() {
		$("#editForm")[0].reset();
		$("#editModal").fadeOut();
	}


	function deleteGame(uid) {
		if (!confirm("정말 삭제하시겠습니까?")) return;
	
		$.ajax({
			url:`${cpath}/api/game/delete/${uid}`,
			type: "DELETE",
			success: function (res) {
				alert("삭제 완료!");
				fetchGameList();  // 목록 갱신
			},
			error: function () {
				alert("서버 오류 발생 ");
		    }
		});
	}


