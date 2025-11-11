<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시판 상세 - WMS</title>
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
    <button class="btn btn-secondary mb-3" onclick="location.href='/announcement/board/list'">
        <i class="bi bi-list"></i> 목록
    </button>

    <!-- 게시글 내용 -->
    <div class="card mb-4">
        <div class="card-header bg-white">
            <h4>${board.bTitle}</h4>
            <div class="d-flex justify-content-between align-items-center mt-2">
                <div>
                    <span class="text-muted">작성자: 사용자 #${board.userIndex}</span>
                    <span class="text-muted ms-3">
                            작성일: <fmt:formatDate value="${board.bCreateAt}" pattern="yyyy-MM-dd HH:mm"/>
                        </span>
                </div>
                <span class="text-muted">조회: ${board.bViews != null ? board.bViews : 0}</span>
            </div>
        </div>
        <div class="card-body">
            <p style="white-space: pre-wrap; min-height: 200px;">${board.bContent}</p>
        </div>
    </div>

    <!-- 댓글 목록 -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">
                댓글 (<c:out value="${not empty board.comments ? board.comments.size() : 0}"/>)
            </h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${empty board.comments}">
                    <p class="text-muted text-center py-3">등록된 댓글이 없습니다.</p>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${board.comments}" var="comment" varStatus="status">
                        <div class="mb-3 ${!status.last ? 'pb-3 border-bottom' : ''}">
                            <div class="d-flex justify-content-between">
                                <strong>
                                    <c:choose>
                                        <c:when test="${not empty comment.adminIndex}">
                                            관리자
                                        </c:when>
                                        <c:otherwise>
                                            사용자 #${comment.userIndex}
                                        </c:otherwise>
                                    </c:choose>
                                </strong>
                                <small class="text-muted">
                                    <fmt:formatDate value="${comment.cCreateAt}" pattern="yyyy-MM-dd HH:mm"/>
                                </small>
                            </div>
                            <p class="mt-2 mb-0">${comment.cContent}</p>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="card-footer">
            <form action="/announcement/board/comment" method="post">
                <input type="hidden" name="boardIndex" value="${board.boardIndex}">
                <div class="input-group">
                    <input type="text" name="cContent" class="form-control"
                           placeholder="댓글을 입력하세요..." required>
                    <button class="btn btn-primary" type="submit">
                        <i class="bi bi-send"></i> 등록
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
