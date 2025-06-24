
$(document).ready(function () {
 fetchGameList()
  $("#gameForm").on("submit", function (e) {
    e.preventDefault();  // 기존 폼 제출 막기

    const gameData = {
      name: $("#gameName").val(),
      type: $("#gameType").val(),
      level: $("#gameLevel").val(),
      probability: $("#gameProbability").val(),
      reward: $("#reward").val(),
      status: $("#status").val(),
      description: $("#gameDescription").val()
    };

    $.ajax({
      url: cpath + "/admin/game/create",
      type: "POST",
      contentType: "application/json",
      data: JSON.stringify(gameData),
      success: function (res) {
        if (res === "success") {
          alert("게임 등록 완료!");
          $("#gameForm")[0].reset();      // 입력 초기화
          fetchGameList();                // 목록 갱신
        } else {
          alert("등록 실패 ");
        }
      },
      error: function () {
        alert("서버 오류 발생!");
      }
    });
  });
});


function openEditModal(uid) {
  const game = window.gameList.find(g => g.uid === uid);
  if (!game) return alert("게임 정보를 찾을 수 없습니다");

  // 기존 값 채워넣기
  $("#editUid").val(game.uid);
  $("#editName").val(game.name);
  $("#editType").val(game.type);
  $("#editLevel").val(game.level);
  $("#editProbability").val(game.probability);
  $("#editReward").val(game.reward);
  $("#editStatus").val(game.status);
  $("#editDescription").val(game.description);

  $("#editModal").fadeIn();  // 모달 열기
}

function closeEditModal() {
  $("#editModal").fadeOut();  // 모달 닫기
}

$(document).ready(function () {
  $("#editForm").on("submit", function (e) {
    e.preventDefault();

    const data = {
      uid: $("#editUid").val(),
      name: $("#editName").val(),
      type: $("#editType").val(),
      level: $("#editLevel").val(),
      probability: $("#editProbability").val(),
      reward: $("#editReward").val(),
      status: $("#editStatus").val(),
      description: $("#editDescription").val()
    };

    $.ajax({
      url: cpath + "/admin/game/update",
      type: "PUT",
      contentType: "application/json",
      data: JSON.stringify(data),
      success: function (res) {
        if (res === "success") {
          alert("수정 완료!");
          closeEditModal();
          fetchGameList();  // 목록 새로고침
        } else {
          alert("수정 실패 ");
        }
      }
    });
  });
});

function deleteGame(uid) {
  if (!confirm("정말 삭제하시겠습니까?")) return;

  $.ajax({
    url: cpath + "/admin/game/delete/" + uid,
    type: "DELETE",
    success: function (res) {
      if (res === "success") {
        alert("삭제 완료!");
        fetchGameList();  // 목록 갱신
      } else {
        alert("삭제 실패!");
      }
    },
    error: function () {
      alert("서버 오류 발생 ");
    }
  });
}


function fetchGameList() {
 console.log("돌아가니 돌아가니 돌아가니 진짜로");

  $.ajax({
    url: cpath + "/admin/game/list",
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
            <p><strong>난이도:</strong>
              <span class="difficulty-${game.level}">
                ${game.level === 'HARD' ? '상' : game.level === 'NORMAL' ? '중' : '하'}
              </span>
            </p>
            <p><strong>성공 확률:</strong> <span class="probability-value">${game.probability}%</span></p>
            <p><strong>배당률:</strong> <span class="reward-value">${game.reward}%</span></p>
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

