<%--
  Created by IntelliJ IDEA.
  User: JangwooJoo
  Date: 2025-11-11
  Time: 오후 4:35
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%-- [중요] 뷰 컨트롤러가 Model에 "or_index"를 전달해야 함 --%>
<c:set var="or_index" value="${or_index}" />

<%@ include file="../includes/header.jsp" %>

<div class="page-inner">
    <div class="page-header">
        <h3 class="fw-bold mb-3">출고 관리</h3>
        <ul class="breadcrumbs mb-3">
            <li class="nav-home"><a href="${contextPath}/"><i class="icon-home"></i></a></li>
            <li class="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a href="${contextPath}/outbound/requests">출고요청 리스트</a></li>
            <li class="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a href="#">출고요청 상세</a></li>
        </ul>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <h4 class="card-title">출고요청 상세 (요청 번호: <span id="detailOrIndex">...</span>)</h4>

                        <%-- [사용자] 수정/삭제 버튼 (본인 + PENDING 상태일 때만 표시됨) --%>
                        <div id="userActionGroup" class="ms-auto" style="display: none;">
                            <a id="modifyBtn" href="#" class="btn btn-primary btn-round">
                                <i class="fa fa-pen"></i> 수정
                            </a>
                            <button type="button" id="deleteOutboundBtn" class="btn btn-danger btn-round ms-2">
                                <i class="fa fa-trash"></i> 삭제
                            </button>
                        </div>
                    </div>

                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>상품 ID (item_index)</label>
                                <input type="text" class="form-control" id="detailItemIndex" readonly>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>상품 이름 (item_name)</label>
                                <input type="text" class="form-control" id="detailItemName" readonly>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>출고 수량 (or_quantity)</label>
                                <input type="text" class="form-control" id="detailOrQuantity" readonly>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <h5 class="mb-3">배송 정보</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>수취인명 (or_name)</label>
                                <input type="text" class="form-control" id="detailOrName" readonly>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>수취인 연락처 (or_phone)</label>
                                <input type="text" class="form-control" id="detailOrPhone" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>우편번호 (or_zip_code)</label>
                                <input type="text" class="form-control" id="detailOrZipCode" readonly>
                            </div>
                        </div>
                        <div class="col-md-8">
                            <div class="form-group">
                                <label>주소 (or_street_address)</label>
                                <input type="text" class="form-control" id="detailOrStreetAddress" readonly>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>상세주소 (or_detailed_address)</label>
                                <input type="text" class="form-control" id="detailOrDetailedAddress" readonly>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <h5 class="mb-3">요청 상태</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>요청일 (created_at)</label>
                                <input type="text" class="form-control" id="detailCreatedAt" readonly>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>승인 상태 (or_approval)</label>
                                <input type="text" class="form-control" id="detailOrApproval" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="rejectDetailGroup" style="display: none;">
                        <label>반려 사유 (reject_detail)</label>
                        <textarea class="form-control" id="detailRejectDetail" rows="3" readonly></textarea>
                    </div>
                </div>

                <%-- [신규] 이전/다음 버튼 포함 --%>
                <div class="card-action d-flex justify-content-between">
                    <a href="${contextPath}/outbound/requests" class="btn btn-secondary">목록으로</a>
                    <div>
                        <a href="#" id="prevBtn" class="btn btn-outline-primary disabled">
                            <i class="fa fa-arrow-left"></i> 이전
                        </a>
                        <a href="#" id="nextBtn" class="btn btn-outline-primary ms-2 disabled">
                            다음 <i class="fa fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>

            <%-- [관리자] 승인 및 배차 카드 (관리자일 때만 표시됨) --%>
            <div id="adminActionCard" class="card" style="display: none;">
                <div class="card-header">
                    <h4 class="card-title">관리자 승인 및 배차</h4>
                </div>
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <strong>배차 상태 (or_dispatch_status):</strong>
                            <span id="dispatchStatusBadge" class="badge bg-warning text-dark">배차 대기</span>
                        </div>
                        <div id="adminBtnGroup">
                            <p>데이터 로드 중...</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- [관리자] 승인/반려 모달 --%>
<div class="modal fade" id="approvalModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="approvalForm">
                <div class="modal-header">
                    <h5 class="modal-title">출고 요청 처리</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>이 출고 요청을 승인 또는 반려하시겠습니까?</p>
                    <div class="form-group">
                        <label for="reject_detail">반려 사유 (반려 시 필수 입력)</label>
                        <textarea class="form-control" id="reject_detail" name="reject_detail" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    <button type="button" id="rejectBtn" class="btn btn-danger" data-approval-status="REJECTED">반려</button>
                    <button type="button" id="approveBtn" class="btn btn-primary" data-approval-status="APPROVED">승인</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%-- [관리자] 배차 등록/수정 모달 --%>
<div class="modal fade" id="dispatchModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <%-- 모달 내용은 JS 템플릿으로 동적 생성됨 --%>
            <div class="modal-body">
                <p>데이터를 불러오는 중입니다...</p>
            </div>
        </div>
    </div>
</div>

<%-- [관리자] 배차 등록 템플릿 --%>
<script type="text/template" id="dispatchRegisterTemplate">
    <form id="dispatchRegisterForm">
        <div class="modal-header">
            <h5 class="modal-title">배차 등록</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <div class="form-group">
                <label for="reg_start_point">출발지</label>
                <input type="text" class="form-control" id="reg_start_point" name="start_point" placeholder="예: 제 1 물류센터" value="제 1 물류센터">
            </div>
            <div class="form-group">
                <label for="reg_end_point">도착지 (자동 완성)</label>
                <input type="text" class="form-control" id="reg_end_point" name="end_point" readonly>
            </div>
            <div class="form-group">
                <label for="reg_vehicleIdSelect">배차 가능 차량</label>
                <select class="form-select" id="reg_vehicleIdSelect" name="vehicle_index" required>
                    <option value="">차량 목록 로딩 중...</option>
                </select>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            <button type="button" id="registerDispatchBtn" class="btn btn-primary">등록</button>
        </div>
    </form>
</script>

<%-- [관리자] 배차 수정 템플릿 --%>
<script type="text/template" id="dispatchModifyTemplate">
    <form id="dispatchModifyForm">
        <div class="modal-header">
            <h5 class="modal-title">배차 상세/수정</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <div class="form-group">
                <label>현재 배차 차량</label>
                <input type="text" id="mod_currentVehicleInfo" class="form-control" readonly>
            </div>
            <div class="form-group">
                <label for="mod_start_point">출발지</label>
                <input type="text" class="form-control" id="mod_start_point" name="start_point">
            </div>
            <div class="form-group">
                <label for="mod_end_point">도착지</label>
                <input type="text" class="form-control" id="mod_end_point" name="end_point" readonly>
            </div>
            <div class="form-group">
                <label for="mod_vehicleIdSelect">차량 변경</label>
                <select class="form-select" id="mod_vehicleIdSelect" name="vehicle_index" required>
                    <option value="">차량 목록 로딩 중...</option>
                </select>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" id="deleteDispatchBtn" class="btn btn-danger">배차 삭제</button>
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            <button type="button" id="modifyDispatchBtn" class="btn btn-primary">수정</button>
        </div>
    </form>
</script>


<%@ include file="../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    // --- JSTL 변수 (세션 정보) ---
    const contextPath = "${contextPath}";
    // [수정] list.jsp의 인증 방식 사용
    const isAdmin = ${not empty sessionScope.loginAdminId};
    const loginUserId = "${sessionScope.loginUserId}"; // (본인 확인용)

    // --- JS 전역 변수 ---
    let currentOutboundId = null; // or_index (JSP EL로 초기화)
    let currentDispatchId = null; // dispatch_index
    let currentListContext = null; // (이전/다음 버튼용) ?page=1&type=I...

    // --- [API 경로 설정] ---
    // [수정] 백틱(``) 대신 큰따옴표("") 사용
    const API = {
        MEMBER: "${contextPath}/api/outbound",
        ADMIN: "${contextPath}/api/admin/outbound"
    };
    const READ_API_BASE = isAdmin ? API.ADMIN : API.MEMBER;
    const WRITE_API_BASE = isAdmin ? API.ADMIN : API.MEMBER;

    // (공통) 폼 데이터 -> JS Object 변환 함수
    function getFormData(formId) {
        const form = document.getElementById(formId);
        const formData = new FormData(form);
        const data = {};
        formData.forEach((value, key) => { data[key] = value; });
        return data;
    }

    // (공통) LocalDateTime 배열 -> Date 객체
    function parseLocalDateTime(arr) {
        if (!arr || arr.length < 6) { return null; }
        return new Date(arr[0], arr[1] - 1, arr[2], arr[3], arr[4], arr[5]);
    }

    // (공통) 날짜 포맷팅
    function formatDateTime(arr) {
        const dateObj = parseLocalDateTime(arr);
        return dateObj ? dateObj.toLocaleString("ko-KR") : "N/A";
    }

    // --- [핵심] 페이지 로드 ---
    document.addEventListener("DOMContentLoaded", function() {
        // [수정] 뷰 컨트롤러가 Model로 넘긴 or_index 사용
        const id = "${or_index}";

        // [수정] list.jsp가 넘겨준 URL 파라미터(?page=...) 저장
        currentListContext = window.location.search;

        if (!id || id === "0") {
            alert("잘못된 접근입니다. (출고 ID 없음)");
            location.href = "${contextPath}/outbound/requests";
            return;
        }
        currentOutboundId = id;
        loadPageData(id, currentListContext);
    });

    /**
     * 페이지에 필요한 모든 데이터를 병렬로 로드합니다.
     * @param {string} id - 출고 요청 ID (or_index)
     * @param {string} listContextQuery - ?page=1&type=... (이전/다음용)
     */
    async function loadPageData(id, listContextQuery) {
        try {
            // [수정] API 호출 시 listContextQuery를 전달 (이전/다음 ID용)
            // (API 컨트롤러는 OutboundRequestDetailDTO 하나만 반환)
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            const outboundPromise = axios.get(READ_API_BASE + "/request/" + id + listContextQuery);

            // 배차 정보 API (수정 없음)
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            const dispatchPromise = axios.get(READ_API_BASE + "/dispatch/" + id).catch(e => null);

            const [outboundRes, dispatchRes] = await Promise.all([outboundPromise, dispatchRes]);

            // [!!! 1. 핵심 수정 !!!]
            // API 응답(outboundRes.data)이 DTO 자체임
            const outbound = outboundRes.data;
            // DTO에서 prevId, nextId를 직접 추출
            const prevId = outbound.prevId;
            const nextId = outbound.nextId;

            if (!outbound) {
                alert("요청 정보를 찾을 수 없습니다.");
                location.href = "${contextPath}/outbound/requests";
                return;
            }

            // [수정] 사용자 보안 체크
            if (!isAdmin && loginUserId && String(outbound.user_index) !== loginUserId) {
                alert("본인의 요청만 조회할 수 있습니다.");
                location.href = "${contextPath}/outbound/requests";
                return;
            }

            // --- 1. 상세 정보 렌더링 (DTO 속성 반영) ---
            document.getElementById("detailOrIndex").textContent = outbound.or_index;
            document.getElementById("detailItemIndex").value = outbound.item_index;
            document.getElementById("detailItemName").value = outbound.item_name;
            document.getElementById("detailOrQuantity").value = outbound.or_quantity;
            document.getElementById("detailOrName").value = outbound.or_name;
            document.getElementById("detailOrPhone").value = outbound.or_phone;
            document.getElementById("detailOrZipCode").value = outbound.or_zip_code;
            document.getElementById("detailOrStreetAddress").value = outbound.or_street_address;
            document.getElementById("detailOrDetailedAddress").value = outbound.or_detailed_address;
            document.getElementById("detailCreatedAt").value = formatDateTime(outbound.created_at);
            document.getElementById("detailOrApproval").value = outbound.or_approval;

            if(outbound.or_approval === 'REJECTED') {
                document.getElementById("rejectDetailGroup").style.display = "block";
                document.getElementById("detailRejectDetail").value = outbound.reject_detail || 'N/A';
            }

            // --- 2. 사용자 버튼 렌더링 (요청대로 수정/삭제 버튼 표시) ---
            if (!isAdmin && loginUserId && String(outbound.user_index) === loginUserId && outbound.or_approval === 'PENDING') {
                document.getElementById("userActionGroup").style.display = "flex";
                // [수정] 수정 버튼은 별도 수정 페이지로 이동
                document.getElementById("modifyBtn").href = "${contextPath}/outbound/request/modify/" + id;
                bindUserButtons(); // (삭제 버튼 이벤트 바인딩)
            }

            // --- 3. 관리자 UI 렌더링 ---
            if (isAdmin) {
                document.getElementById("adminActionCard").style.display = "block";
                const dispatch = dispatchRes ? dispatchRes.data : null; // DispatchDetailDTO
                renderAdminUI(outbound.or_approval, outbound.or_dispatch_status, dispatch, id);
            }

            // --- 4. [신규] 이전/다음 버튼 렌더링 ---
            renderPrevNext(prevId, nextId, listContextQuery);

        } catch (error) {
            console.error("Page loading failed:", error);
            if (error.response && error.response.status === 404) {
                alert("요청 정보를 찾을 수 없습니다.");
            } else {
                alert("데이터를 불러오는 데 실패했습니다. 목록으로 돌아갑니다.");
            }
            // [수정] 백틱(``) 대신 큰따옴표("") 사용
            location.href = "${contextPath}/outbound/requests";
        }
    }

    /**
     * [신규] 이전/다음 버튼 렌더링
     */
    function renderPrevNext(prevId, nextId, listContextQuery) {
        const prevBtn = document.getElementById("prevBtn");
        const nextBtn = document.getElementById("nextBtn");

        if (prevId) {
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            prevBtn.href = "${contextPath}/outbound/request/" + prevId + listContextQuery;
            prevBtn.classList.remove("disabled");
        } else {
            prevBtn.href = "#";
            prevBtn.classList.add("disabled");
        }

        if (nextId) {
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            nextBtn.href = "${contextPath}/outbound/request/" + nextId + listContextQuery;
            nextBtn.classList.remove("disabled");
        } else {
            nextBtn.href = "#";
            nextBtn.classList.add("disabled");
        }
    }

    /**
     * [수정] 관리자 버튼 및 모달 UI 렌더링
     */
    function renderAdminUI(approvalStatus, dispatchStatus, dispatch, or_index) {

        const adminBtnGroup = document.getElementById("adminBtnGroup");
        const modalContent = document.querySelector("#dispatchModal .modal-content");
        const endPointAddress = document.getElementById("detailOrStreetAddress").value;

        // 1. 배차 상태 배지 설정
        if (dispatchStatus === 'COMPLETED' && dispatch) {
            currentDispatchId = dispatch.dispatch_index;
            const badge = document.getElementById("dispatchStatusBadge");
            badge.textContent = "배차 완료";
            badge.className = "badge bg-success";
        }

        // 2. 출고 상태에 따른 버튼 설정 (JS 백틱 사용 - JSP EL 없음)
        if (approvalStatus === 'PENDING') {
            adminBtnGroup.innerHTML = `<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#approvalModal">승인/반려 처리</button>`;
        } else if (approvalStatus === 'APPROVED' && dispatchStatus === 'PENDING') {
            adminBtnGroup.innerHTML = `<button class="btn btn-info" data-bs-toggle="modal" data-bs-target="#dispatchModal">배차 등록</button>`;
        } else if (approvalStatus === 'APPROVED' && dispatchStatus === 'COMPLETED') {
            adminBtnGroup.innerHTML = `<button class="btn btn-info" data-bs-toggle="modal" data-bs-target="#dispatchModal">배차 수정/삭제</button>`;
        } else {
            adminBtnGroup.innerHTML = `<button class="btn btn-secondary" disabled>${approvalStatus} / ${dispatchStatus}</button>`;
        }

        // 3. 배차 모달 템플릿 렌더링 (승인 상태일 때만)
        if(approvalStatus === 'APPROVED') {
            if (dispatch) {
                // [수정] 배차가 있으면 (수정 모드)
                modalContent.innerHTML = document.getElementById("dispatchModifyTemplate").innerHTML;
                modalContent.querySelector("#mod_currentVehicleInfo").value = dispatch.vehicle_id + ' (' + dispatch.driver_name + ')';
                modalContent.querySelector("#mod_start_point").value = dispatch.start_point;
                modalContent.querySelector("#mod_end_point").value = dispatch.end_point;
                const selectEl = modalContent.querySelector("#mod_vehicleIdSelect");
                populateVehicleSelect(selectEl, or_index, dispatch.vehicle_index);
            } else {
                // [등록] 배차가 없으면 (등록 모드)
                modalContent.innerHTML = document.getElementById("dispatchRegisterTemplate").innerHTML;
                modalContent.querySelector("#reg_end_point").value = endPointAddress;
                const selectEl = modalContent.querySelector("#reg_vehicleIdSelect");
                populateVehicleSelect(selectEl, or_index);
            }
        }
        bindAdminButtons();
    }

    /**
     * [API 수정] 배차 모달의 차량 <select> 목록을 채움 (API 비동기 호출)
     */
    async function populateVehicleSelect(selectElement, or_index, selectedVehicleId = null) {
        if (!selectElement) return;
        selectElement.innerHTML = '<option value="">차량 목록 로딩 중...</option>';

        try {
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            const response = await axios.get(API.ADMIN + "/dispatch/available/" + or_index);
            const vehicles = response.data;

            let optionsHtml = '<option value="">차량을 선택하세요</option>';

            // [수정] JS 템플릿 리터럴(백틱)을 사용 (JSP EL과 충돌 안 함)
            vehicles.forEach(v => {
                const selected = (selectedVehicleId && v.vehicle_index == selectedVehicleId) ? "selected" : "";
                optionsHtml += `<option value="${v.vehicle_index}" ${selected}>
                                    ${v.vehicle_id} (${v.driver_name} / ${v.vehicle_type})
                               </option>`;
            });
            selectElement.innerHTML = optionsHtml;
        } catch (error) {
            console.error("Failed to load available vehicles for " + or_index, error);
            selectElement.innerHTML = '<option value="">차량 로드 실패</option>';
        }
    }

    /**
     * [AXIOS] 사용자 버튼 이벤트 바인딩 (삭제 버튼)
     */
    function bindUserButtons() {
        const deleteBtn = document.getElementById("deleteOutboundBtn");
        if (deleteBtn) {
            deleteBtn.addEventListener("click", function() {
                if (!confirm("정말로 이 출고 요청을 삭제하시겠습니까?")) return;
                // [수정] 백틱(``) 대신 문자열 연결(+) 사용
                axios.delete(WRITE_API_BASE + "/request/" + currentOutboundId)
                    .then(response => {
                        alert("삭제되었습니다.");
                        // [수정] 백틱(``) 대신 큰따옴표("") 사용
                        location.href = "${contextPath}/outbound/requests"; // 목록으로 이동
                    })
                    .catch(error => alert("삭제 실패: " + (error.response?.data?.message || "서버 오류")));
            });
        }
    }

    /**
     * [AXIOS] 관리자 버튼 이벤트 바인딩 (동적 생성 후 호출)
     */
    function bindAdminButtons() {

        // 1. 출고 승인/반려
        const approveBtn = document.getElementById("approveBtn");
        const rejectBtn = document.getElementById("rejectBtn");
        const handleApproval = (event) => {
            const status = event.target.dataset.approvalStatus;
            const rejectDetail = document.getElementById("reject_detail").value;
            if (status === 'REJECTED' && !rejectDetail) {
                alert("반려 시 사유를 반드시 입력해야 합니다.");
                return;
            }
            if (!confirm(`정말로 이 요청을 '${status}' 하시겠습니까?`)) return;
            const data = {
                or_index: currentOutboundId,
                or_approval: status,
                reject_detail: rejectDetail
            };
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            axios.put(API.ADMIN + "/request/approval", data, { headers: { 'Content-Type': 'application/json' } })
                .then(response => {
                    alert("처리가 완료되었습니다.");
                    location.reload();
                })
                .catch(error => alert("처리 실패: " + (error.response?.data?.message || "서버 오류")));
        };
        if(approveBtn) approveBtn.addEventListener("click", handleApproval);
        if(rejectBtn) rejectBtn.addEventListener("click", handleApproval);

        // 2. 배차 등록
        const registerDispatchBtn = document.getElementById("registerDispatchBtn");
        if (registerDispatchBtn) {
            registerDispatchBtn.addEventListener("click", function() {
                const data = getFormData("dispatchRegisterForm");
                data.or_index = currentOutboundId;
                if (!data.vehicle_index) {
                    alert("차량을 선택하세요.");
                    return;
                }
                // [수정] 백틱(``) 대신 문자열 연결(+) 사용
                axios.post(API.ADMIN + "/dispatch", data, { headers: { 'Content-Type': 'application/json' } })
                    .then(response => {
                        alert("배차 등록되었습니다.");
                        location.reload();
                    })
                    .catch(error => alert("등록 실패: " + (error.response?.data?.message || "서버 오류")));
            });
        }

        // 3. 배차 수정
        const modifyDispatchBtn = document.getElementById("modifyDispatchBtn");
        if (modifyDispatchBtn) {
            modifyDispatchBtn.addEventListener("click", function() {
                const data = getFormData("dispatchModifyForm");
                // [수정] 백틱(``) 대신 문자열 연결(+) 사용
                axios.put(API.ADMIN + "/dispatch/" + currentDispatchId, data, { headers: { 'Content-Type': 'application/json' } })
                    .then(response => {
                        alert("배차 수정되었습니다.");
                        location.reload();
                    })
                    .catch(error => alert("수정 실패: " + (error.response?.data?.message || "서버 오류")));
            });
        }

        // 4. 배차 삭제
        const deleteDispatchBtn = document.getElementById("deleteDispatchBtn");
        if (deleteDispatchBtn) {
            deleteDispatchBtn.addEventListener("click", function() {
                if (!confirm("정말로 이 배차를 삭제하시겠습니까?")) return;
                // [수정] 백틱(``) 대신 문자열 연결(+) 사용
                axios.delete(API.ADMIN + "/dispatch/" + currentDispatchId)
                    .then(response => {
                        alert("배차 삭제되었습니다.");
                        location.reload();
                    })
                    .catch(error => alert("삭제 실패: " + (error.response?.data?.message || "서버 오류")));
            });
        }
    }
</script>
<%@ include file="../includes/end.jsp" %>