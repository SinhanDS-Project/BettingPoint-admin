let uploadedImageUrls = [];

// 게시글 등록
function insertBoard() {

    $('#summernote-create').summernote({
        height: 500,
        lang: "ko-KR",
        placeholder: '최대 2048자까지 쓸 수 있습니다',
        callbacks: {
            onImageUpload: function (files) {
                uploadSummernoteImageFile(files[0], this);
            }
        }
    });

    $('.form-section form').on('submit', function (e) {
        e.preventDefault();
        const boardData = {
            category: $('#boardType').val(),
            title: $('#boardTitle').val(),
            content: $('#summernote-create').summernote('code')
        };

        const currentImageUrls = boardData.content.match(/<img [^>]*src="([^"]*)"/g)
            ?.map(tag => tag.match(/src="([^"]*)"/)[1]) || [];

        const imageUrl = uploadedImageUrls.filter(url => !currentImageUrls.includes(url));

        deleteImages(imageUrl);

        const token = localStorage.getItem("accessToken");

        $.ajax({
            url: `${cpath}/api/board/insert`,
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
                $('#summernote-create').summernote('reset');
            }
        });
    });
}

function deleteImages(imageUrl) {
    $.ajax({
        url: `${cpath}/api/board/image-delete`,
        method: 'DELETE',
        contentType: 'application/json',
        data: JSON.stringify({urls: imageUrl}),
        success: function () {
            console.log('S3에서 이미지 삭제 완료');
            uploadedImageUrls = [];
        },
        error: function (err) {
            console.error('S3 이미지 삭제 실패:', err);
        }
    });
}

// 이미지 S3에 업로드 후 Summernote에 삽입
function uploadSummernoteImageFile(file, editor) {
    let data = new FormData();
    data.append("image", file);

    $.ajax({
        data: data,
        type: "POST",
        url: `${cpath}/api/board/image-upload`,
        contentType: false,
        processData: false,
        success: function (data) {
            $(editor).summernote('insertImage', data.url);
            uploadedImageUrls.push(data.url);
        },
        error: function () {
            alert("이미지 업로드에 실패했습니다.");
        }
    });
}

// 게시글 목록 불러오기
function loadBoardList() {
    $.ajax({
        url: `${cpath}/api/board/list`, // 실제 경로에 맞게 수정
        method: 'GET',
        success: function (data) {
            renderBoardTables(data);
        }
    });
}

// 게시글 목록 렌더링
function renderBoardTables(boardList) {
    const noticeFaqTbody = $('#board-list-notice');
    const freeTbody = $('#board-list-free');
    noticeFaqTbody.empty();
    freeTbody.empty();

    boardList.forEach(function (board) {
        const category = board.category.toLowerCase();
        const row = $('<tr>');

        if (category === 'notice' || category === 'faq') {
            // 공지사항 / FAQ: 유형, 제목, 작성자, 등록일, 작업
            const categoryLabel = category === 'notice' ? '공지사항' : 'FAQ';
            row.append(`<td><span class="badge badge-${category}">${categoryLabel}</span></td>`);
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
            if (category === 'free') {
                categoryLabel = '자유';
            } else if (category === 'info') {
                categoryLabel = '정보/조언';
            } else if (category === 'idea') {
                categoryLabel = '제안/아이디어';
            }

            row.append(`<td><span class="badge badge-${category}">${categoryLabel}</span></td>`);
            row.append(`<td style="font-weight:600;">${board.title}</td>`);
            row.append(`<td>${board.user_uid}</td>`);
            row.append(`<td>${formatDate(board.created_at)}</td>`);
            row.append(`
                <td>
                    <button class="btn btn-warning" onclick="location.href='/board/detail/${board.uid}'">조회</button>
                    <button class="btn btn-danger" onclick="deleteBoard('${board.uid}')">삭제</button>
                </td>
            `);
            freeTbody.append(row);
        }
    });
}

// 게시글 상세 조회
function detailBoard(boardId) {
    $.ajax({
        url: `${cpath}/api/board/detail/${boardId}`,
        method: 'GET',
        success: function (board) {
            loadBoardDetail(board);
        }
    });
}

function loadBoardDetail(board) {
    const categoryMap = {
        NOTICE: '공지사항',
        FAQ: 'FAQ',
        free: '자유',
        info: '정보/조언',
        idea: '제안/아이디어'
    };
    const categoryLabel = categoryMap[board.category] || board.category;

    // 카테고리 뱃지 + 제목 분리 렌더링
    $('#detail-category-badge')
        .text(categoryLabel)
        .attr('class', `badge badge-${board.category}`);

    $('#detail-title-text').text(board.title);
    $('#detail-user').text(board.user_uid);
    $('#detail-content').html(board.content);
    $('#detail-view-count').text(board.view_count);
    $('#detail-like-count').text(board.like_count);
    $('#detail-created-at').text(formatDate(board.created_at));

    if (board.board_img) {
        $('#detail-board-img').attr('src', board.board_img).show();
    } else {
        $('#detail-board-img').hide();
    }
}

// 게시글 삭제
function deleteBoard(boardId) {
    if (!confirm('정말 삭제하시겠습니까?')) return;

    $.ajax({
        url: `${cpath}/api/board/delete/${boardId}`,
        method: 'DELETE',
        success: function () {
            alert('삭제되었습니다.');
            loadBoardList();
        }
    });
}

// 모달 열기 + 기존 내용 불러오기
function updateBoardModal(boardId) {
    $('#summernote-update').summernote({
        height: 300,
        lang: 'ko-KR',
        placeholder: '최대 2048자까지 작성할 수 있습니다',
        callbacks: {
            onImageUpload: function (files) {
                uploadSummernoteImageFile(files[0], this);
            }
        }
    });

    $.ajax({
        url: `${cpath}/api/board/detail/${boardId}`,
        method: 'GET',
        success: function (board) {
            $('#edit-board-id').val(board.uid);
            $('#edit-category').val(board.category);
            $('#edit-title').val(board.title);
            $('#summernote-update').summernote('code', board.content);

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
    $('#editBoardForm').submit(function (e) {
        e.preventDefault();

        const boardId = $('#edit-board-id').val();
        const data = {
            category: $('#edit-category').val(),
            title: $('#edit-title').val(),
            content: $('#summernote-update').summernote('code')
        };

        const currentImageUrls = boardData.content.match(/<img [^>]*src="([^"]*)"/g)
            ?.map(tag => tag.match(/src="([^"]*)"/)[1]) || [];

        const imageUrl = uploadedImageUrls.filter(url => !currentImageUrls.includes(url));

        deleteImages(imageUrl)

        $.ajax({
            url: `${cpath}/api/board/update/${boardId}`,
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
