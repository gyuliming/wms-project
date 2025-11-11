<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>공지사항 - WMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand" href="/"><i class="bi bi-building"></i> WMS 시스템</a>
        <div class="navbar-nav ms-auto">
            <a class="nav-link" href="/inbound/list">입고관리</a>
            <a class="nav-link active" href="/announcement/notices/list">공지사항</a>
            <a class="nav-link" href="/announcement/board/list">게시판</a>
        </div>
    </div>
</nav>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-megaphone"></i> 공지사항</h2>
    </div>

    <!-- 검색 -->
    <div class="card mb-4">
        <div class="card-body">
            <form action="/announcement/notices/list" method="get">
                <div class="row g-3">
                    <div class="col-md-9">
                        <input type="text" name="keyword" class="form-control"
                               placeholder="제목 또는 내용 검색..." value="${param.keyword}">
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-search"></i> 검색
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- 공지사항 목록 -->
    <div class="card">
        <div class="card-body p-0">
            <div class="list-group list-group-flush">
                <c:choose>
                    <c:when test="${empty list}">
                        <div class="list-group-item text-center py-5 text-muted">
                            <i class="bi bi-inbox display-1"></i>
                            <p class="mt-3">등록된 공지사항이 없습니다.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${list}" var="notice">
                            <a href="/announcement/notices/detail/${notice.noticeIndex}"
                               class="list-group-item list-group-item-action">
                                <div class="d-flex w-100 justify-content-between align-items-center">
                                    <div>
                                        <c:if test="${notice.nPriority == 1}">
                                            <span class="badge bg-danger me-2">중요</span>
                                        </c:if>
                                        <strong class="fs-5">${notice.nTitle}</strong>
                                    </div>
                                    <small class="text-muted">
                                        <fmt:formatDate value="${notice.nCreateAt}" pattern="yyyy-MM-dd"/>
                                    </small>
                                </div>
                                <p class="mb-1 mt-2 text-muted text-truncate" style="max-width: 100%;">
                                        ${notice.nContent}
                                </p>
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
