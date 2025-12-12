<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../includes/header.jsp" %>

<div class="row">
    <div class="col-md-8">
        <div class="card h-100">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h4 class="card-title mb-0">${warehouse.WName}</h4>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-striped">
                        <tbody>

                        <tr><th style="width:200px;">창고번호</th><td>${warehouse.WIndex}</td></tr>
                        <tr><th>창고코드</th><td>${warehouse.WCode}</td></tr>
                        <tr><th>창고 전체 크기</th><td>${warehouse.WSize}</td></tr>
                        <tr><th>남은 크기</th><td>${warehouse.remainingCapacity}</td></tr>
                        <tr><th>주소</th><td>${warehouse.WAddress}</td></tr>
                        <tr><th>우편번호</th><td>${warehouse.WZipcode}</td></tr>
                        <tr><th>등록일</th><td>${warehouse.WCreatedAt}</td></tr>
                        <tr><th>수정일</th><td>${warehouse.WUpdatedAt}</td></tr>

                        <tr>
                            <th>상태</th>
                            <td>
                                <c:choose>
                                    <c:when test="${warehouse.WStatus == 'NORMAL'}">정상</c:when>
                                    <c:when test="${warehouse.WStatus == 'INSPECTION'}">점검</c:when>
                                    <c:otherwise>${warehouse.WStatus}</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex justify-content-end gap-2 mt-3">
                    <c:if test="${sessionScope.loginAdminRole == 'ADMIN'}">
                        <button type="button" class="btn btn-primary px-3 py-2 fw-bold" data-bs-toggle="modal" data-bs-target="#addSectionModal">
                            구역 생성
                        </button>
                    </c:if>
                    <c:if test="${sessionScope.loginAdminRole != 'ADMIN'}">
                        <button type="button" class="btn btn-primary px-3 py-2 fw-bold"
                                onclick="alert('접근 권한이 없습니다.')">
                            구역 생성
                        </button>
                    </c:if>

                    <div class="modal fade" id="addSectionModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">새 구역 생성</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="addSectionForm">
                                        <div class="mb-3">
                                            <label class="form-label">구역명</label>
                                            <input type="text" class="form-control" name="sName" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">구역 종류</label>
                                            <select class="form-select" name="sType">
                                                <option value="상온">상온</option>
                                                <option value="저온">저온</option>

                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">적재 용량 (팔레트 수)</label>
                                            <input type="number" class="form-control" name="palletCount" required>
                                            <div class="form-text">1 팔레트 = 50 박스 기준으로 자동 변환됩니다.</div>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-primary" onclick="addSection()">등록</button>
                                    <button type="button" class="btn btn-outline-secondary px-3 py-2 fw-bold" data-bs-dismiss="modal">취소</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <c:if test="${sessionScope.loginAdminRole == 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/warehouse/${warehouse.WIndex}/update"
                           class="btn btn-primary px-3 py-2 fw-bold">
                            수정
                        </a>
                    </c:if>

                    <c:if test="${sessionScope.loginAdminRole != 'ADMIN'}">
                        <button type="button" class="btn btn-primary px-3 py-2 fw-bold"
                                onclick="alert('접근 권한이 없습니다.')">
                            수정
                        </button>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/warehouse/list"
                       class="btn btn-outline-secondary px-3 py-2 fw-bold">목록</a>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card h-100">
            <div class="card-header">
                <h4 class="mb-0">창고 위치</h4>
            </div>

            <div class="card-body d-flex align-items-stretch">
                <div id="map" style="width:100%; height:100%; border-radius:10px;"></div>
            </div>
        </div>
    </div>
</div>
<br>

<h3>구역 현황</h3>
<div class="row" id="sectionListArea">
    <c:forEach var="sec" items="${warehouse.sections}">
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span class="fw-bold">${sec.SName}</span>
                    <span class="badge bg-secondary">${sec.SType}</span>
                </div>
                <div class="card-body">
                    <div class="d-flex justify-content-between mb-2">
                        <small>사용률: <strong>${sec.usageRate}%</strong></small>
                    </div>

                    <div class="progress mb-3" style="height: 20px;">
                        <div class="progress-bar ${sec.statusColorClass}"
                             role="progressbar"
                             style="width: ${sec.usageRate}%;"
                             aria-valuenow="${sec.usageRate}" aria-valuemin="0" aria-valuemax="100">
                                ${sec.usageRate}%
                        </div>
                    </div>

                    <ul class="list-group list-group-flush small text-muted">
                        <li class="list-group-item d-flex justify-content-between px-0">
                            <span>내부 용량 (Box)</span>
                            <span>${sec.currentUsed} / ${sec.SCapacity}</span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between px-0">
                            <span>관리 코드</span>
                            <span>${sec.SCode}</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </c:forEach>

    <c:if test="${empty warehouse.sections}">
        <div class="col-12 text-center py-5 text-muted">
            <i class="fas fa-box-open fa-3x mb-3"></i>
            <p>등록된 구역이 없습니다. '구역 생성' 버튼을 눌러 공간을 설계해주세요.</p>
        </div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<!-- 지도 스크립트는 HTML 아래에 배치하는 것이 정석 -->
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=2879f57d00d7fd3009336abf35aad5e6&libraries=services"></script>

<script>
    var mapContainer = document.getElementById('map');
    var mapOption = {
        center: new kakao.maps.LatLng(37.5665, 126.9780),
        level: 4
    };

    var map = new kakao.maps.Map(mapContainer, mapOption);
    var geocoder = new kakao.maps.services.Geocoder();

    const address = "${fn:escapeXml(warehouse.WAddress)}";

    if (address) {
        geocoder.addressSearch(address, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {

                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                var marker = new kakao.maps.Marker({
                    map: map,
                    position: coords
                });

                var infowindow = new kakao.maps.InfoWindow({
                    content:
                        `<div style="padding:6px;font-size:12px;font-weight:bold;">
                            ${fn:escapeXml(warehouse.WName)}
                        </div>`
                });

                infowindow.open(map, marker);
                map.setCenter(coords);
            }
        });
    }
</script>

<script>
    function addSection() {
        const form = document.getElementById("addSectionForm");

        const data = {
            sName: form.sName.value,
            sType: form.sType.value,
            palletCount: parseInt(form.palletCount.value)
        };

        // 유효성 검사
        if (!data.sName || !data.palletCount) {
            alert("구역 명칭과 용량을 모두 입력해주세요.");
            return;
        }

        axios.post(`/api/warehouse/${warehouse.WIndex}/section`, data)
            .then(response => {
                // 성공 시 (HTTP 200)
                alert(response.data);
                location.reload();
            })
            .catch(error => {
                // 실패 시 (HTTP 400, 500 등)
                let errorMsg = "알 수 없는 오류 발생";

                if (error.response && error.response.data) {
                    errorMsg = error.response.data;
                } else if (error.message) {
                    errorMsg = error.message;
                }

                alert(errorMsg);
            });
    }
</script>

<%@ include file="../includes/footer.jsp" %>
