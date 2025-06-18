
// 섹션 전환 함수
function showSection(sectionId) {
    // 모든 섹션 숨기기
    const sections = document.querySelectorAll('.section');
    sections.forEach(section => {
        section.classList.remove('active');
    });
    
    // 선택된 섹션 보이기
    document.getElementById(sectionId).classList.add('active');
    
    // 페이지 상단으로 스크롤
    window.scrollTo(0, 0);
}

// Chart.js 설정
document.addEventListener('DOMContentLoaded', function() {
    // 일별 접속자 수 라인 차트
    const visitorsCtx = document.getElementById('visitorsChart');
    if (visitorsCtx) {
        new Chart(visitorsCtx.getContext('2d'), {
            type: 'line',
            data: {
                labels: ['01-15', '01-16', '01-17', '01-18', '01-19', '01-20', '01-21'],
                datasets: [{
                    label: '접속자 수',
                    data: [120, 150, 180, 200, 170, 220, 250],
                    borderColor: '#667eea',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    tension: 0.4,
                    fill: true,
                    borderWidth: 3,
                    pointBackgroundColor: '#667eea',
                    pointBorderColor: '#ffffff',
                    pointBorderWidth: 2,
                    pointRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: '#f1f5f9'
                        },
                        ticks: {
                            color: '#64748b'
                        }
                    },
                    x: {
                        grid: {
                            color: '#f1f5f9'
                        },
                        ticks: {
                            color: '#64748b'
                        }
                    }
                }
            }
        });
    }

    // 게임별 이용률 파이 차트
    const gameUsageCtx = document.getElementById('gameUsageChart');
    if (gameUsageCtx) {
        new Chart(gameUsageCtx.getContext('2d'), {
            type: 'pie',
            data: {
                labels: ['슬롯머신', '블랙잭', '룰렛', '포커', '기타'],
                datasets: [{
                    data: [35, 25, 20, 15, 5],
                    backgroundColor: [
                        '#667eea',
                        '#764ba2',
                        '#f093fb',
                        '#f5576c',
                        '#4facfe'
                    ],
                    borderWidth: 0,
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 20,
                            usePointStyle: true,
                            color: '#64748b'
                        }
                    }
                }
            }
        });
    }
});

// 폼 제출 이벤트 처리 (예시)
document.addEventListener('submit', function(e) {
    e.preventDefault();
    alert('폼이 제출되었습니다! (실제로는 서버로 전송됩니다)');
});

// 삭제 버튼 클릭 이벤트
document.addEventListener('click', function(e) {
    if (e.target.classList.contains('btn-danger') && e.target.textContent.includes('삭제')) {
        if (confirm('정말로 삭제하시겠습니까?')) {
            alert('삭제되었습니다!');
            // 실제로는 서버에 삭제 요청을 보냅니다
        }
    }
});