	const itemsPerPage = 5;
    let currentPage = 1;
    let totalCount = 0;
    
	document.addEventListener('DOMContentLoaded', () => {
	    loadUsers(currentPage);
	});


	// 회원 리스트
	function loadUsers(page = 1) {
		currentPage = page;
		
	    $.ajax({
	        url: `${cpath}/api/user?page=${page}`,
	        method: 'GET',
	        success: function (res) {
	        	const users = res.users;
	            totalUsers = res.total;
	            renderUserTable(users, page);
	            renderUserPagination(page, totalUsers);
	        },
	        error: function () {
	            alert('회원 목록 불러오기 실패');
	        }
	    });
	}
	
	// 🔹 회원 테이블 렌더링
	function renderUserTable(users, page) {
	    const tbody = document.getElementById('memberTableBody');
	    tbody.innerHTML = '';

	    if (!users || users.length === 0) {
	        tbody.innerHTML = `<tr><td colspan="7" class="text-center">회원 정보가 없습니다.</td></tr>`;
	        return;
	    }

	    users.forEach((user, index) => {
	        const tr = document.createElement('tr');
	        const firstChar = user.user_name ? user.user_name.charAt(0) : '';
	        const roleLabel = user.role === 'ADMIN' ? '관리자' : '일반회원';
	        const badgeClass = user.role === 'ADMIN' ? 'badge-admin' : 'badge-user';
	        const joinDate = formatDate(user.created_at);
	        const lastLogin = formatDateTime(user.last_login_at);
	        const formattedPoint = `${formatMoney(user.point_balance)}`;

	        tr.innerHTML = `
	            <td>${(page - 1) * itemsPerPage + index + 1}</td>
	            <td>
	                <div class="member-info">
	                    <div class="member-avatar">${firstChar}</div>
	                    <div class="member-details">
	                        <h5>${user.user_name}</h5>
	                        <p>${user.email}</p>
	                    </div>
	                </div>
	            </td>
	            <td><span class="badge ${badgeClass}">${roleLabel}</span></td>
	            <td>${joinDate}</td>
	            <td>${lastLogin}</td>
	            <td style="color: #48bb78; font-weight: 600;">${formattedPoint}</td>
	            <td>
	                <button class="btn btn-sm btn-warning" onclick="editRole('${user.uid}')">권한변경</button>
	                <button class="btn btn-sm btn-danger" onclick="deleteMember('${user.uid}')">삭제</button>
	                <button class="btn btn-sm btn-outline" onclick="viewMember('${user.uid}')">상세</button>
	            </td>
	        `;
	        tbody.appendChild(tr);
	    });
	}

	// 🔹 페이지네이션 렌더링
	function renderUserPagination(current, totalCount) {
	    const container = document.querySelector('.pagination');
	    const maxPages = Math.ceil(totalCount / itemsPerPage);
	    container.innerHTML = '';

	    container.innerHTML += `
	        <button onclick="changeUserPage(${current - 1})" ${current <= 1 ? 'disabled style="cursor:not-allowed;"' : ''}>이전</button>
	    `;

	    for (let i = 1; i <= maxPages; i++) {
	        container.innerHTML += `
	            <button class="${i === current ? 'active' : ''}" onclick="changeUserPage(${i})">${i}</button>
	        `;
	    }

	    container.innerHTML += `
	        <button onclick="changeUserPage(${current + 1})" ${current >= maxPages ? 'disabled style="cursor:not-allowed;"' : ''}>다음</button>
	    `;
	}

	// 🔹 페이지 변경
	function changeUserPage(page) {
	    const maxPages = Math.ceil(totalUsers / itemsPerPage);
	    loadUsers(page);
	}
	
	function formatDate(dateStr) {
	    if (!dateStr) return '-';
	    const date = new Date(dateStr);
	    if (isNaN(date)) return '-';

	    const year = date.getFullYear();
	    const month = ('0' + (date.getMonth() + 1)).slice(-2);  // 0~11 → 1~12
	    const day = ('0' + date.getDate()).slice(-2);
	    
	    return `${year}-${month}-${day}`; // YYYY-MM-DD
	}

	function formatDateTime(dateStr) {
	    if (!dateStr) return '-';
	    const date = new Date(dateStr);
	    if (isNaN(date)) return '-';

	    const year = date.getFullYear();
	    const month = ('0' + (date.getMonth() + 1)).slice(-2);
	    const day = ('0' + date.getDate()).slice(-2);
	    const hours = ('0' + date.getHours()).slice(-2);
	    const minutes = ('0' + date.getMinutes()).slice(-2);

	    return `${year}-${month}-${day} ${hours}:${minutes}`;
	}

	function formatMoney(value) {
	    return "🪙" + Number(value || 0).toLocaleString();
	}
	
	
	// 상세보기 모달
	function viewMember(uid) {
	    $.ajax({
	        url: `${cpath}/api/user/detail/${uid}`,
	        method: 'GET',
	        success: function (user) {
	            const badgeClass = user.role === 'ADMIN' ? 'badge-admin' : 'badge-user';
	            const roleLabel = user.role === 'ADMIN' ? '관리자' : '일반회원';
	            const joinDate = formatDate(user.created_at);
	            const lastLogin = formatDateTime(user.last_login_at);
	            const phone = user.phone_number || '-';
	            const birth = formatDate(user.birth_date);
	            const point = `${formatMoney(user.point_balance)}`;
	            const s3BaseUrl = "https://bettopia-bucket.s3.ap-southeast-2.amazonaws.com/";
	            const profile = user.profile_img
	                ? `<img src="${s3BaseUrl}${user.profile_img}" alt="프로필" style="width: 80px; height: 80px; border-radius: 50%;">`
	                : `<div style="width: 80px; height: 80px; border-radius: 50%; background: #eee; display: flex; align-items: center; justify-content: center;">N/A</div>`;
	            	            
	            document.getElementById('memberModalContent').innerHTML = `
	                <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px;">
	                    <div>
	                        <h4>기본 정보</h4>
	                        <p><strong>이름:</strong> ${user.user_name}</p>
	                        <p><strong>이메일:</strong> ${user.email}</p>
	                        <p><strong>전화번호:</strong> ${phone}</p>
	                        <p><strong>생년월일:</strong> ${birth}</p>
	            			<p><strong>닉네임:</strong> ${user.nickname}</p>
	                        <p><strong>프로필:</strong><br>${profile}</p>
	                    </div>
	                    <div>
	                        <h4>계정 정보</h4>
	                        <p><strong>권한:</strong> <span class="badge ${badgeClass}">${roleLabel}</span></p>
	                        <p><strong>가입일:</strong> ${joinDate}</p>
	                        <p><strong>최근 접속:</strong> ${lastLogin}</p>
	                        <p><strong>개인정보 동의:</strong> ${user.agree_privacy ? '동의' : '미동의'}</p>
	                    </div>
	                    <div>
	                        <h4>포인트</h4>
	                        <p><strong>보유 포인트:</strong> ${point}</p>
	                    </div>
	                </div>
	            `;

	            document.getElementById('memberModal').style.display = 'block';
	        },
	        error: function () {
	            alert('회원 정보를 불러오는 데 실패했습니다.');
	        }
	    });
	}
	
	// 모달 닫기
    function closeModal() {
        document.getElementById('memberModal').style.display = 'none';
    }

    // 모달 외부 클릭 시 닫기
    window.onclick = function(event) {
        const modal = document.getElementById('memberModal');
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    }
    
    // 권한 변경
    function editRole(uid) {
        // 유저 상세정보 먼저 조회
        $.ajax({
            url: `${cpath}/api/user/detail/${uid}`,
            method: 'GET',
            success: function (user) {
                if (user.role === 'ADMIN') {
                    alert('관리자는 권한을 변경할 수 없습니다.');
                    return;
                }

                const confirmed = confirm(`${user.user_name} 님의 권한을 "관리자"로 변경하시겠습니까?`);
                if (!confirmed) return;

                const updatedUser = Object.assign({}, user, { role: 'ADMIN' });

                $.ajax({
                    url: `${cpath}/api/user/updateUser`,
                    method: 'PUT',
                    contentType: 'application/json',
                    data: JSON.stringify(updatedUser),
                    success: function (message) {
                        alert(message);
                        loadUsers();  // 권한 변경 후 리스트 갱신
                    },
                    error: function () {
                        alert('권한 변경 중 오류가 발생했습니다.');
                    }
                });
            },
            error: function () {
                alert('유저 정보를 불러오는 데 실패했습니다.');
            }
        });
    }

	
	// 회원 삭제
    function deleteMember(uid) {
        if (!confirm('정말로 이 회원을 삭제하시겠습니까?')) return;

        $.ajax({
            url: `${cpath}/api/user/deleteUser/${uid}`,
            method: 'DELETE',
            success: function (msg) {
                alert(msg);
                loadUsers(); // 삭제 후 회원 목록 새로고침
            },
            error: function () {
                alert('회원 삭제 중 오류가 발생했습니다.');
            }
        });
    }



	// 회원 검색
    function searchMembers() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const rows = document.querySelectorAll('#memberTableBody tr');
        
        rows.forEach(row => {
            const memberInfo = row.querySelector('.member-details');
            const name = memberInfo.querySelector('h5').textContent.toLowerCase();
            const email = memberInfo.querySelector('p').textContent.toLowerCase();
            
            if (name.includes(searchTerm) || email.includes(searchTerm)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
	
	// 회원 필터링 (권한)
	function filterMembers() {
	    const roleFilter = document.getElementById('roleFilter').value;
	    const rows = document.querySelectorAll('#memberTableBody tr');
	
	    rows.forEach(row => {
	    	let showRow = true;
	    	
	    	if (roleFilter) {
		    	const roleBadge = row.querySelector('.badge');
	            const roleText = roleBadge.textContent.toLowerCase();
	        
	            const roleMap = {
	                'ADMIN': '관리자',
	                'USER': '일반회원'
	            };
	            
	            if (!roleText.includes(roleMap[roleFilter])) {
	            	showRow = false;
	            }
	        }
	
	        row.style.display = showRow ? '' : 'none';
	    });
	}
	
	// 회원 정렬
	function sortMembers() {
	    const sortBy = document.getElementById('sortBy').value;
	    const tbody = document.getElementById('memberTableBody');
	    const rows = Array.from(tbody.querySelectorAll('tr'));
	
	    rows.sort((a, b) => {
	        switch (sortBy) {
	            case 'name': // asc
	            	const nameA = a.querySelector('.member-details h5').textContent;
                    const nameB = b.querySelector('.member-details h5').textContent;
                    return nameA.localeCompare(nameB);
	            case 'date': // desc
	            	const dateA = new Date(a.cells[3].textContent);
                    const dateB = new Date(b.cells[3].textContent);
                    return dateB - dateA;
	            case 'spending': // desc
	            	const spendingA = parseInt(a.cells[5].textContent.replace(/[^\d]/g, ''));
                    const spendingB = parseInt(b.cells[5].textContent.replace(/[^\d]/g, ''));
                    return spendingB - spendingA;
	            default:
	                return 0;
	        }
	    });
	
	    rows.forEach(row => tbody.appendChild(row));
	}
	
	// 필터 초기화
	function resetFilters() {
	    document.getElementById('searchInput').value = '';
	    document.getElementById('roleFilter').value = '';
	    document.getElementById('sortBy').value = 'name';
	
	    const rows = document.querySelectorAll('#memberTableBody tr');
	    rows.forEach(row => row.style.display = '');
	}
