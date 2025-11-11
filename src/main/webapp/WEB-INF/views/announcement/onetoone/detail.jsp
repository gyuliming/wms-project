<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>문의 상세 - WMS</title>
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
    <button class="btn btn-secondary mb-3" onclick="location.href='/announcement/onetoone/mylist'">
        <i class="bi bi-arrow-left"></i> 목록
    </button>

    <!-- 문의 내용 -->
    <div class="card mb-3">
        <div class="card-header">
            <span class="badge bg-info">${request.rType}</span>
            <c:choose>
                <c:when test="${request.rStatus == 'ANSWERED'}">
                    <span class="badge bg-success">답변완료</span>
                </c:when>
                <c:otherwise>
                    <span class="badge bg-warning">대기중</span>
                </c:otherwise>
            </c:choose>
            <h5 class="mt-2">${request.rTitle}</h5>
            <small class="text-muted">
                <fmt:formatDate value="${request.rCreateAt}" pattern="yyyy-MM-dd HH:mm"/>
            </small>
        </div>
        <div class="card-body">
            <p style="white-space: pre-wrap;">${request.rContent}</p>
        </div>
    </div>

    <!-- 답변 -->
    <c:if test="${not empty request.rResponse}">
        <div class="card">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">관리자 답변</h5>
            </div>
            <div class="card-body">
                <p style="white-space: pre-wrap;">${request.rResponse}</p>
                <c:if test="${not empty request.rUpdateAt}">
                    <small class="text-muted">
                        답변일: <fmt:formatDate value="${request.rUpdateAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </small>
                </c:if>
            </div>
        </div>
    </c:if>

    <c:if test="${empty request.rResponse}">
        <div class="alert alert-info">
            <i class="bi bi-info-circle"></i> 관리자의 답변을 기다리고 있습니다.
        </div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
