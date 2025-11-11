<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>내 문의 내역 - WMS</title>
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
        <h2><i class="bi bi-chat-dots"></i> 내 문의 내역</h2>
        <button class="btn btn-primary" onclick="location.href='/announcement/onetoone/register'">
            <i class="bi bi-plus-circle"></i> 문의하기
        </button>
    </div>

    <div class="card">
        <div class="card-body p-0">
            <div class="list-group list-group-flush">
                <c:choose>
                    <c:when test="${empty list}">
                        <div class="list-group-item text-center py-5 text-muted">
                            <i class="bi bi-inbox display-1"></i>
                            <p class="mt-3">문의 내역이 없습니다.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${list}" var="item">
                            <a href="/announcement/onetoone/detail/${item.requestIndex}"
                               class="list-group-item list-group-item-action">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <span class="badge bg-info">${item.rType}</span>
                                        <strong class="ms-2">${item.rTitle}</strong>
                                    </div>
                                    <c:choose>
                                        <c:when test="${item.rStatus == 'ANSWERED'}">
                                            <span class="badge bg-success">답변완료</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning">대기중</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <small class="text-muted">
                                    <fmt:formatDate value="${item.rCreateAt}" pattern="yyyy-MM-dd HH:mm"/>
                                </small>
                            </a>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
