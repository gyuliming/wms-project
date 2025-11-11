<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세 - WMS</title>
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
        <h2><i class="bi bi-megaphone"></i> 공지사항</h2>
        <button class="btn btn-secondary" onclick="location.href='/announcement/notices/list'">
            <i class="bi bi-list"></i> 목록
        </button>
    </div>

    <div class="card">
        <div class="card-header bg-white">
            <div class="d-flex justify-content-between align-items-start">
                <div>
                    <c:if test="${notice.nPriority == 1}">
                        <span class="badge bg-danger">중요</span>
                    </c:if>
                    <h4 class="mt-2">${notice.nTitle}</h4>
                </div>
                <small class="text-muted">
                    <fmt:formatDate value="${notice.nCreateAt}" pattern="yyyy-MM-dd HH:mm"/>
                </small>
            </div>
        </div>
        <div class="card-body">
            <div style="min-height: 300px; white-space: pre-wrap;">${notice.nContent}</div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
