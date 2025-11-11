<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. JSTL Context Path 추가 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:import url="/WEB-INF/views/includes/header.jsp"/>

<div class="main-panel">
    <div class="container">
        <%-- 2. page-inner 시작 (기존 코드 유지) --%>
        <div class="page-inner">

            <%-- 3. 출고 목록 스타일의 page-header (Breadcrumbs) 추가 --%>
            <div class="page-header">

                <h3 class="fw-bold mb-3">입고 관리</h3>
                <ul class="breadcrumbs mb-3">
                    <li class="nav-home"><a href="${contextPath}/"><i class="icon-home"></i></a></li>
                    <li class="separator"><i class="icon-arrow-right"></i></li>
                    <%-- 경로를 /inbound/list로 설정 --%>
                    <li class="nav-item"><a href="${contextPath}/inbound/list">입고 리스트</a></li>
                </ul>
            </div>

            <%-- 4. 전체 내용을 row/col로 감싸기 --%>
            <div class="row">
                <div class="col-md-12">

                    <div class="card mb-4">
                        <div class="card-body">
                            <%-- form action을 현재 URL에 대한 상대 경로 'list'로 유지 (개선) --%>
                            <form action="<c:url value="list"/>" method="get">
                                <div class="row g-3 align-items-center">
                                    <div class="col-md-3">
                                        <label for="status-select" class="form-label visually-hidden">상태</label>
                                        <select name="status" id="status-select" class="form-control">
                                            <option value="">전체 상태</option>
                                            <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>대기중</option>
                                            <option value="APPROVED" ${param.status == 'APPROVED' ? 'selected' : ''}>승인됨</option>
                                            <option value="REJECTED" ${param.status == 'REJECTED' ? 'selected' : ''}>거부됨</option>
                                            <option value="CANCELED" ${param.status == 'CANCELED' ? 'selected' : ''}>취소됨</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="keyword-input" class="form-label visually-hidden">검색</label>
                                        <input type="text" name="keyword" id="keyword-input" class="form-control"
                                               placeholder="입고번호 또는 요청자 검색..." value="${param.keyword}">
                                    </div>
                                    <div class="col-md-3">
                                        <button type="submit" class="btn btn-info w-100">
                                            <i class="fa fa-search"></i> 검색
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <%-- 제목을 '입고 리스트'로 통일 --%>
                            <div class="d-flex align-items-center">
                                <h4 class="card-title">입고 리스트</h4>
                                <%-- '입고 요청 등록' 버튼은 삭제된 상태 유지 --%>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover mt-3">
                                    <thead class="thead-light">
                                    <tr>
                                        <th>입고번호</th>
                                        <th>요청자ID</th>
                                        <th>요청수량</th>
                                        <th>요청일</th>
                                        <th>희망일</th>
                                        <th>상태</th>
                                        <th>창고</th>
                                        <th>액션</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:choose>
                                        <c:when test="${empty list}">
                                            <tr>
                                                <td colspan="8" class="text-center py-5 text-muted">
                                                    <i class="fas fa-inbox display-1"></i>
                                                    <p class="mt-3">입고 요청 내역이 없습니다.</p>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${list}" var="item">
                                                <tr style="cursor:pointer" onclick="location.href='<c:url value="/inbound/detail/${item.inboundIndex}"/>'">
                                                    <td><strong>#${item.inboundIndex}</strong></td>
                                                    <td>${item.requestUserId}</td>
                                                    <td>${item.inboundRequestQuantity}개</td>
                                                    <td>
                                                        <fmt:formatDate value="${item.inboundRequestDate}" pattern="yyyy-MM-dd"/>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty item.plannedReceiveDate}">
                                                                <fmt:formatDate value="${item.plannedReceiveDate}" pattern="yyyy-MM-dd"/>
                                                            </c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${item.approvalStatus == 'PENDING'}">
                                                                <span class="badge bg-warning">대기중</span>
                                                            </c:when>
                                                            <c:when test="${item.approvalStatus == 'APPROVED'}">
                                                                <span class="badge bg-success">승인됨</span>
                                                            </c:when>
                                                            <c:when test="${item.approvalStatus == 'REJECTED'}">
                                                                <span class="badge bg-danger">거부됨</span>
                                                            </c:when>
                                                            <c:when test="${item.approvalStatus == 'CANCELED'}">
                                                                <span class="badge bg-secondary">취소됨</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${item.approvalStatus}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>창고 #${item.warehouseIndex}</td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-info"
                                                                onclick="event.stopPropagation();
                                                                        location.href='<c:url value="/inbound/detail/${item.inboundIndex}"/>'">
                                                            <i class="fa fa-eye"></i> 상세
                                                        </button>
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
                </div>
            </div> <%-- /.row --%>

        </div>
    </div>


</div>
<c:import url="/WEB-INF/views/includes/footer.jsp"/>
<c:import url="/WEB-INF/views/includes/end.jsp"/>