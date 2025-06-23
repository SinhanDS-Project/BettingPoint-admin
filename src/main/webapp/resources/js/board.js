// 게시글 등록
function insertBoard() {
    $('.form-section form').on('submit', function (e) {
        e.preventDefault();
        const boardData = {
            category: $('#boardType').val(),
            title: $('#boardTitle').val(),
            content: $('#boardContent').val(),
            // board_img: $('#bannerImage').val()
        };

        const token = localStorage.getItem("accessToken");

        $.ajax({
            url: '/api/board/insert',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(boardData),
            headers: {
                Authorization: 'Bearer ' + token
            },
            success: function () {
                alert('게시글이 등록되었습니다.');
                loadBoardList();
                $('.form-section form')[0].reset();
            }
        });
    });
}

// 게시글 목록 불러오기
function loadBoardList() {
    $.ajax({
        url: '/api/board/list', // 실제 경로에 맞게 수정
        method: 'GET',
        success: function (data) {
            renderBoardTables(data);
        }
    });
}

function renderBoardTables(boardList) {
    const noticeFaqTbody = $('#board-list-notice');
    const freeTbody = $('#board-list-free');
    noticeFaqTbody.empty();
    freeTbody.empty();

    boardList.forEach(function (board) {
        const row = $('<tr>');

        if (board.category === 'NOTICE' || board.category === 'FAQ') {
            // 공지사항 / FAQ: 유형, 제목, 작성자, 등록일, 작업
            const categoryLabel = board.category === 'NOTICE' ? '공지사항' : 'FAQ';
            row.append(`<td><span class="badge badge-${board.category}">${categoryLabel}</span></td>`);
            row.append(`<td style="font-weight:600;">${board.title}</td>`);
            row.append(`<td>${board.user_uid}</td>`);
            row.append(`<td>${formatDate(board.created_at)}</td>`);
            row.append(`
                <td>
                    <button class="btn btn-warning" onclick="updateBoardModal('${board.uid}')">수정</button>
                    <button class="btn btn-danger" onclick="deleteBoard('${board.uid}')">삭제</button>
                </td>
            `);
            noticeFaqTbody.append(row);
        } else {
            // 자유게시판: 제목, 작성자, 등록일, 작업
            let categoryLabel;
            if (board.category === 'free') {
                categoryLabel = '자유';
            } else if (board.category === 'info') {
                categoryLabel = '정보/조언';
            } else if (board.category === 'idea') {
                categoryLabel = '제안/아이디어';
            }

            row.append(`<td><span class="badge badge-${board.category}">${categoryLabel}</span></td>`);
            row.append(`<td style="font-weight:600;">${board.title}</td>`);
            row.append(`<td>${board.user_uid}</td>`);
            row.append(`<td>${formatDate(board.created_at)}</td>`);
            row.append(`
                <td>
                    <button class="btn btn-danger" onclick="deleteBoard('${board.uid}')">삭제</button>
                </td>
            `);
            freeTbody.append(row);
        }
    });
}

// 게시글 삭제
function deleteBoard(boardId) {
    if (!confirm('정말 삭제하시겠습니까?')) return;

    $.ajax({
        url: `/api/board/delete/${boardId}`,
        method: 'DELETE',
        success: function () {
            alert('삭제되었습니다.');
            loadBoardList();
        }
    });
}

// 모달 열기 + 기존 내용 불러오기
function updateBoardModal(boardId) {
    $.ajax({
        url: `/api/board/detail/${boardId}`,
        method: 'GET',
        success: function (board) {
            $('#edit-board-id').val(board.uid);
            $('#edit-category').val(board.category);
            $('#edit-title').val(board.title);
            $('#edit-content').val(board.content);
            // $('#bannerImage').val(board.board_img || '');

            requestAnimationFrame(() => {
                $('#editModal').stop(true, true).fadeIn(200);
            });
        },
        error: function () {
            alert('게시글을 불러오는 데 실패했습니다.');
        }
    });
}

// 게시글 수정
function updateBoard() {
    $('#editBoardForm').off('submit');
    $('#editBoardForm').submit(function (e) {
        e.preventDefault();

        const boardId = $('#edit-board-id').val();
        const data = {
            category: $('#edit-category').val(),
            title: $('#edit-title').val(),
            content: $('#edit-content').val(),
            // board_img: $('#bannerImage').val()
        };

        $.ajax({
            url: `/api/board/update/${boardId}`,
            method: 'PUT',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function () {
                alert('수정이 완료되었습니다.');
                closeEditModal();
                loadBoardList();
            },
            error: function () {
                alert('수정에 실패했습니다.');
            }
        });
    });
}

// 타임스탬프를 YYYY-MM-DD 형식으로 변환
function formatDate(timestamp) {
    const date = new Date(timestamp);
    return date.toISOString().slice(0, 10); // 'YYYY-MM-DD'
}

// 드래그 앤 드롭 기능
function setupDragAndDrop() {
    const dropArea = document.getElementById('boardDropArea');
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
            const preview = document.getElementById('boardPreview');
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
    document.getElementById('boardPreview').innerHTML = '';
    document.getElementById('bannerImage').value = '';
}
