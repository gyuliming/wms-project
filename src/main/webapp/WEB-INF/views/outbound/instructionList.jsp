<%--
  Created by IntelliJ IDEA.
  User: JangwooJoo
  Date: 2025-11-10
  Time: 오후 8:18
  To change this template use File |
 Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%@ include file="../includes/header.jsp" %>

<div class="page-inner">
    <div class="page-header">
        <h3 class="fw-bold mb-3">출고 관리</h3>
        <ul class="breadcrumbs mb-3">
            <li class="nav-home"><a href="${contextPath}/"><i class="icon-home"></i></a></li>
            <li class="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a href="#">출고 관리</a></li>

            <li class="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a href="${contextPath}/instructions">출고 지시서 목록</a></li>
        </ul>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <%-- [신규] 관리자 버튼 추가 --%>
                    <div class="d-flex align-items-center">
                        <div class="card-title">출고 지시서 목록</div>
                        <div class="ms-auto">
                            <button class="btn btn-primary btn-round" type="button" id="bulkRegisterWaybillBtn">
                                <i class="fa fa-truck"></i> 선택 운송장 등록
                            </button>
                            <button class="btn btn-danger btn-round ms-2" type="button" id="bulkDeleteBtn">
                                <i class="fa fa-trash"></i> 선택 지시서 삭제
                            </button>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row g-3 justify-content-center mb-3">
                        <form id="searchForm" class="input-group">

                            <div class="col-auto">
                                <select class="form-select" name="type">
                                    <option value="I">상품명 (item_name)</option>
                                    <option value="W">창고ID (warehouse_index)</option>
                                    <option value="S">운송장상태 (si_waybill_status)</option>
                                </select>
                            </div>
                            <div class="col-5">
                                <input type="text" class="form-control" name="keyword" placeholder="검색어 입력">
                            </div>
                            <div class="col-auto">
                                <button class="btn btn-default" type="button" id="searchBtn">검색</button>
                            </div>
                        </form>
                    </div>

                    <div class="table-responsive">
                        <table class="display table table-striped table-hover">
                            <thead>
                            <tr>
                                <%-- [신규] 체크박스 헤더 --%>
                                <th><input class="form-check-input" type="checkbox" id="checkAll"></th>
                                <th>지시서 ID (si_index)</th>
                                <th>상품명 (item_name)</th>
                                <th>수량 (or_quantity)</th>
                                <th>창고 ID (warehouse_index)</th>
                                <th>승인일 (approved_at)</th>
                                <th>운송장 상태 (si_waybill_status)</th>
                            </tr>
                            </thead>
                            <tbody id="instructionTbody">
                            <%-- [수정] colspan="7" --%>
                            <tr><td colspan="7" class="text-center">데이터를 불러오는 중입니다...</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <div id="instructionPagination" class="mt-3 d-flex justify-content-center"></div>

                    <div class="mt-3 text-end">
                        <a href="${contextPath}/outbound/requests" class="btn btn-secondary">
                            출고 요청 목록
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    const contextPath = "${contextPath}";
    // [단순화] ADMIN API 경로만 정의 (ADMIN 전용 페이지)
    const API_BASE = "${contextPath}/api/admin/outbound";

    /**
     * LocalDateTime 배열을 JavaScript Date 객체로 변환
     */
    function parseLocalDateTime(arr) {
        if (!arr || arr.length < 6) {
            return null;
        }
        return new Date(arr[0], arr[1] - 1, arr[2], arr[3], arr[4], arr[5]);
    }

    /**
     * 지시서 목록 로드 함수
     */
    async function loadInstructionList(page = 1, type = '', keyword = '') {
        const tbody = document.getElementById("instructionTbody");
        // [수정] colspan="7"
        tbody.innerHTML = '<tr><td colspan="7" class="text-center">데이터를 불러오는 중입니다...</td></tr>';

        try {
            const params = new URLSearchParams({ page, amount: 10, type, keyword });
            const response = await axios.get(API_BASE + "/instruction", { params });

            const { list, pageDTO } = response.data;
            tbody.innerHTML = ""; // tbody 초기화

            if (!list || list.length === 0) {
                // [수정] colspan="7"
                tbody.innerHTML = '<tr><td colspan="7" class="text-center">출고 지시 내역이 없습니다.</td></tr>';
                renderPagination(pageDTO, loadInstructionList);
                return;
            }

            list.forEach(item => {
                const tr = document.createElement("tr");
                tr.style.cursor = "pointer";

                // [수정] (e) 파라미터 추가 및 체크박스 클릭 예외 처리
                tr.onclick = (e) => {
                    if (e.target.type === 'checkbox') {
                        e.stopPropagation();
                        return;
                    }
                    // [수정] (이전과 동일) 문자열 연결 사용
                    location.href = "${contextPath}/instruction/" + item.si_index;
                };

                // 날짜 변환
                const approvedDateObj = parseLocalDateTime(item.approved_at);
                const approvedDateStr = approvedDateObj
                    ? approvedDateObj.toLocaleString("ko-KR")
                    : "N/A";

                const status = item.si_waybill_status;

                // [수정] 백틱(``) 대신 문자열 연결(+)을 사용하여 tr.innerHTML 생성
                tr.innerHTML =
                    '<td><input class="form-check-input check-item" type="checkbox" ' +
                    'data-id="' + item.si_index + '" ' +
                    'data-status="' + status + '"></td>' +
                    '<td>' + item.si_index + '</td>' +
                    '<td>' + item.item_name + '</td>' +
                    '<td>' + item.or_quantity + '</td>' +
                    '<td>' + item.warehouse_index + '</td>' +
                    '<td>' + approvedDateStr + '</td>' +
                    '<td>' + status + '</td>';

                tbody.appendChild(tr);
            });

            // 페이지네이션 생성
            renderPagination(pageDTO, loadInstructionList);
        } catch (error) {
            console.error("Instruction List loading failed:", error);
            // [수정] colspan="7"
            tbody.innerHTML = '<tr><td colspan="7" class="text-center text-danger">목록 로딩에 실패했습니다.</td></tr>';
        }
    }

    /**
     * 페이지네이션 렌더링 함수 (수정 없음)
     */
    function renderPagination(pageDTO, loadFn) {
        const paginationUl = document.getElementById("instructionPagination");
        paginationUl.innerHTML = "";

        if (!pageDTO) return;

        let paginationHtml = '<ul class="pagination">';
        const { criteria, startPage, endPage, prev, next } = pageDTO;
        const { type, keyword } = criteria;
        if (prev) {
            paginationHtml += `<li class="page-item"><a class="page-link" href="#" data-page="${startPage - 1}">Previous</a></li>`;
        }
        for (let i = startPage; i <= endPage; i++) {
            paginationHtml += `
                <li class="page-item ${criteria.pageNum == i ? 'active' : ''}">
                    <a class="page-link" href="#" data-page="${i}">${i}</a>
                </li>
             `;
        }
        if (next) {
            paginationHtml += `<li class="page-item"><a class="page-link" href="#" data-page="${endPage + 1}">Next</a></li>`;
        }
        paginationHtml += '</ul>';
        paginationUl.innerHTML = paginationHtml;

        paginationUl.querySelectorAll("a.page-link").forEach(link => {
            link.addEventListener("click", function(e) {
                e.preventDefault();
                const pageNum = this.dataset.page;
                const form = document.getElementById("searchForm");
                const currentType = form.type.value;
                const currentKeyword = form.keyword.value;
                loadFn(pageNum, currentType, currentKeyword);
            });
        });
    }

    /**
     * [신규] 관리자 버튼 이벤트 바인딩
     */
    function bindAdminButtons() {
        // 1. 전체 선택 체크박스
        document.getElementById("checkAll").addEventListener("click", function() {
            const isChecked = this.checked;
            document.querySelectorAll(".check-item").forEach(cb => cb.checked = isChecked);
        });

        // 2. 일괄 운송장 등록
        document.getElementById("bulkRegisterWaybillBtn").addEventListener("click", async () => {
            const checkedItems = document.querySelectorAll(".check-item:checked");
            if (checkedItems.length === 0) {
                alert("운송장을 등록할 항목을 선택하세요.");
                return;
            }

            // 'PENDING' 상태인 항목만 필터링
            const itemsToRegister = [];
            let invalidItemFound = false;

            checkedItems.forEach(cb => {
                const id = cb.dataset.id;
                const status = cb.dataset.status;
                if (status === 'PENDING') {
                    itemsToRegister.push(id);
                } else {
                    invalidItemFound = true;
                }
            });

            if (invalidItemFound) {
                alert("선택된 항목 중 이미 운송장이 등록된 건이 포함되어 있습니다.\n('PENDING' 상태인 항목만 등록 가능합니다.)");
                return;
            }
            if (itemsToRegister.length === 0) {
                alert("운송장을 등록할 항목이 없습니다.");
                return;
            }

            if (!confirm("선택한 " + itemsToRegister.length + "건의 운송장을 등록하시겠습니까?")) return;

            let successCount = 0;
            let failCount = 0;

            for (const id of itemsToRegister) {
                try {
                    // API: POST /api/admin/outbound/waybill (Body: {si_index: id})
                    const data = { si_index: id };
                    await axios.post(API_BASE + "/waybill", data, {
                        headers: {'Content-Type': 'application/json'}
                    });
                    successCount++;
                } catch (error) {
                    console.error("ID " + id + " 운송장 등록 실패:", error);
                    failCount++;
                }
            }
            alert("운송장 등록 처리 완료\n성공: " + successCount + "건\n실패: " + failCount + "건");
            loadInstructionList(1, document.getElementById("searchForm").type.value, document.getElementById("searchForm").keyword.value);
            document.getElementById("checkAll").checked = false;
        });

        // 3. 일괄 삭제
        document.getElementById("bulkDeleteBtn").addEventListener("click", async () => {
            const checkedItems = document.querySelectorAll(".check-item:checked");
            if (checkedItems.length === 0) {
                alert("삭제할 지시서를 선택하세요.");
                return;
            }

            // 'PENDING' 상태인 항목만 필터링
            const itemsToDelete = [];
            let invalidItemFound = false;

            checkedItems.forEach(cb => {
                const id = cb.dataset.id;
                const status = cb.dataset.status;
                if (status === 'PENDING') {
                    itemsToDelete.push(id);
                } else {
                    invalidItemFound = true;
                }
            });

            if (invalidItemFound) {
                alert("선택된 항목 중 이미 운송장이 등록된 건이 포함되어 있습니다.\n('PENDING' 상태인 항목만 삭제 가능합니다.)");
                return;
            }
            if (itemsToDelete.length === 0) {
                alert("삭제 가능한 지시서가 없습니다.");
                return;
            }

            if (!confirm("선택한 " + itemsToDelete.length + "건의 지시서를 삭제하시겠습니까?")) return;

            let successCount = 0;
            let failCount = 0;

            for (const id of itemsToDelete) {
                try {
                    // [가정] API: DELETE /api/admin/outbound/instruction/{id}
                    await axios.delete(API_BASE + "/instruction/" + id);
                    successCount++;
                } catch (error) {
                    console.error("ID " + id + " 삭제 실패:", error);
                    failCount++;
                }
            }
            alert("삭제 처리 완료\n성공: " + successCount + "건\n실패: " + failCount + "건");
            loadInstructionList(1, document.getElementById("searchForm").type.value, document.getElementById("searchForm").keyword.value);
            document.getElementById("checkAll").checked = false;
        });
    }

    // 페이지 로드 시 1페이지 데이터 로드
    document.addEventListener("DOMContentLoaded", () => {
        loadInstructionList(1);
        // [신규] 관리자 버튼 이벤트 바인딩
        bindAdminButtons();
    });

    // 검색 버튼 이벤트
    document.getElementById("searchBtn").addEventListener("click", () => {
        const form = document.getElementById("searchForm");
        const type = form.type.value;
        const keyword = form.keyword.value;
        loadInstructionList(1, type, keyword);
    });
</script>
<%@ include file="../includes/end.jsp" %>
<%@ include file="../includes/end.jsp" %>