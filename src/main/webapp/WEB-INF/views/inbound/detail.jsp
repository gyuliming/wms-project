<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>입고 상세 - WMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand" href="/"><i class="bi bi-building"></i> WMS 시스템</a>
    </div>
</nav>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-box-seam"></i> 입고 상세</h2>
        <button class="btn btn-secondary" onclick="location.href='/inbound/list'">
            <i class="bi bi-arrow-left"></i> 목록으로
        </button>
    </div>

    <div class="card mb-4">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">입고 요청 정보</h5>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label text-muted">입고번호</label>
                    <p class="fs-5 fw-bold">#${request.inboundIndex}</p>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label text-muted">승인상태</label>
                    <p>
                        <c:choose>
                            <c:when test="${request.approvalStatus == 'PENDING'}">
                                <span class="badge bg-warning">대기중</span>
                            </c:when>
                            <c:when test="${request.approvalStatus == 'APPROVED'}">
                                <span class="badge bg-success">승인됨</span>
                            </c:when>
                            <c:when test="${request.approvalStatus == 'REJECTED'}">
                                <span class="badge bg-danger">거부됨</span>
                            </c:when>
                            <c:when test="${request.approvalStatus == 'CANCELED'}">
                                <span class="badge bg-secondary">취소됨</span>
                            </c:when>
                        </c:choose>
                    </p>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label text-muted">요청수량</label>
                    <p>${request.inboundRequestQuantity}개</p>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label text-muted">요청일자</label>
                    <p>
                        <fmt:formatDate value="${request.inboundRequestDate}" pattern="yyyy-MM-dd HH:mm"/>
                    </p>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label text-muted">희망입고일</label>
                    <p>
                        <c:choose>
                            <c:when test="${not empty request.plannedReceiveDate}">
                                <fmt:formatDate value="${request.plannedReceiveDate}" pattern="yyyy-MM-dd"/>
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label text-muted">창고</label>
                    <p>창고 #${request.warehouseIndex}</p>
                </div>
                <c:if test="${request.approvalStatus == 'APPROVED' && not empty request.approveDate}">
                    <div class="col-md-6 mb-3">
                        <label class="form-label text-muted">승인일시</label>
                        <p>
                            <fmt:formatDate value="${request.approveDate}" pattern="yyyy-MM-dd HH:mm"/>
                        </p>
                    </div>
                </c:if>
            </div>
            <c:if test="${request.approvalStatus == 'CANCELED' && not empty request.cancelReason}">
                <hr>
                <label class="form-label text-muted">취소 사유</label>
                <p class="text-danger">${request.cancelReason}</p>
            </c:if>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">입고 상세 목록</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="table-light">
                    <tr>
                        <th>상세번호</th>
                        <th>QR코드</th>
                        <th>입고수량</th>
                        <th>입고일시</th>
                        <th>위치</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty request.details}">
                            <tr>
                                <td colspan="5" class="text-center py-4 text-muted">
                                    입고 상세 내역이 없습니다.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${request.details}" var="detail">
                                <tr>
                                    <td>#${detail.detailIndex}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty detail.qrCode}">
                                                <span class="badge bg-info">${detail.qrCode}</span>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty detail.receivedQuantity}">
                                                ${detail.receivedQuantity}개
                                            </c:when>
                                            <c:otherwise>0개</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty detail.completeDate}">
                                                <fmt:formatDate value="${detail.completeDate}" pattern="yyyy-MM-dd HH:mm"/>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty detail.location}">
                                                ${detail.location}
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="d-flex gap-2 mt-3">
        <c:if test="${request.approvalStatus == 'PENDING'}">
            <button class="btn btn-danger" onclick="cancelRequest()">
                <i class="bi bi-x-circle"></i> 요청 취소
            </button>
        </c:if>
        <button class="btn btn-secondary" onclick="location.href='/inbound/list'">
            <i class="bi bi-list"></i> 목록으로
        </button>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function cancelRequest() {
        const reason = prompt('취소 사유를 입력하세요:');
        if (reason && reason.trim() !== '') {
            if (confirm('정말 취소하시겠습니까?')) {
                const inboundIndex = ${request.inboundIndex};
                const apiUrl = `/api/inbound/request/${inboundIndex}/cancel?cancelReason=${encodeURIComponent(reason)}`;

                fetch(apiUrl, {
                    method: 'PUT',
                    headers: {
                        // Spring Security 등을 사용할 경우 CSRF 토큰을 여기에 추가해야 합니다.
                        'Content-Type': 'application/json'
                    }
                })
                    .then(response => response.json().then(data => ({ status: response.status, body: data })))
                    .then(({ status, body }) => {
                        if (status === 200 && body.success) {
                            alert(body.message);
                            window.location.reload(); // 성공 시 페이지 새로고침
                        } else if (status === 401) {
                            alert("로그인이 필요합니다.");
                            window.location.href = '/login'; // 로그인 페이지로 이동
                        } else if (status === 400 && body.message) {
                            alert("취소 실패: " + body.message);
                        } else {
                            alert("요청 취소 중 오류가 발생했습니다.");
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert("네트워크 오류가 발생했습니다.");
                    });
            }
        } else if (reason !== null) {
            alert('취소 사유를 반드시 입력해야 합니다.');
        }
    }
</script>
</body>
</html>