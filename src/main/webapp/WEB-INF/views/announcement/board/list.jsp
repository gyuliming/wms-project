<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시판 - WMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand" href="/"><i class="bi bi-building"></i> WMS 시스템</a>
        <div class="navbar-nav ms-auto">
            <a class="nav-link" href="/inbound/list">입고관리</a>
            <a class="nav-link" href="/announcement/notices/list">공지사항</a>
            <a class="nav-link active" href="/announcement/board/list">게시판</a>
        </div>
    </div>
</nav>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-clipboard"></i> 게시판</h2>
        <button class="btn btn-primary" onclick="location.href='/announcement/board/register'">
            <i class="bi bi-pencil"></i> 글쓰기
        </button>
    </div>

    <!-- 검색 -->
    <div class="card mb-4">
        <div class="card-body">
            <form action="/announcement/board/list" method="get">
                <div class="row g-3">
                    <div class="col-md-3">
                        <select name="type" class="form-select">
                            <option value="">전체 유형</option>
                            <option value="DELIVERY" ${param.type == 'DELIVERY' ? 'selected' : ''}>배송</option>
                            <option value="PRODUCT" ${param.type == 'PRODUCT' ? 'selected' : ''}>상품</option>
                            <option value="STOCK" ${param.type == 'STOCK' ? 'selected' : ''}>재고</option>
                            <option value="ETC" ${param.type == 'ETC' ? 'selected' : ''}>기타</option>
                        </select>
                    </div>
                    <div class="col-md-6">
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

    <div class="card">
        <div class="card-body">
            <table class="table table-hover">
                <thead class="table-light">
                <tr>
                    <th width="80">번호</th>
                    <th>제목</th>
                    <th width="120">작성자</th>
                    <th width="120">작성일</th>
                    <th width="80">조회</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr>
                            <td colspan="5" class="text-center py-5 text-muted">
                                <i class="bi bi-inbox display-1"></i>
                                <p class="mt-3">등록된 게시글이 없습니다.</p>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${list}" var="board" varStatus="status">
                            <tr style="cursor: pointer;" onclick="location.href='/announcement/board/detail/${board.boardIndex}'">
                                <td>${board.boardIndex}</td>
                                <td>
                                    <strong>${board.bTitle}</strong>
                                    <c:if test="${not empty board.comments && board.comments.size() > 0}">
                                        <span class="badge bg-primary">${board.comments.size()}</span>
                                    </c:if>
                                </td>
                                <td>사용자 #${board.userIndex}</td>
                                <td>
                                    <fmt:formatDate value="${board.bCreateAt}" pattern="yyyy-MM-dd"/>
                                </td>
                                <td>${board.bViews != null ? board.bViews : 0}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
