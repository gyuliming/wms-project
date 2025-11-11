<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 작성 - WMS</title>
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
    <h2 class="mb-4"><i class="bi bi-pencil"></i> 게시글 작성</h2>

    <div class="card">
        <div class="card-body">
            <form action="/announcement/board/register" method="post">
                <div class="mb-3">
                    <label class="form-label">문의 유형 <span class="text-danger">*</span></label>
                    <select name="bType" class="form-select" required>
                        <option value="">선택하세요</option>
                        <option value="DELIVERY">배송 문의</option>
                        <option value="PRODUCT">상품 문의</option>
                        <option value="STOCK">재고 문의</option>
                        <option value="ETC">기타</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">제목 <span class="text-danger">*</span></label>
                    <input type="text" name="bTitle" class="form-control"
                           placeholder="제목을 입력하세요" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">내용 <span class="text-danger">*</span></label>
                    <textarea name="bContent" class="form-control" rows="15"
                              placeholder="내용을 입력하세요" required></textarea>
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check"></i> 등록
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="location.href='/announcement/board/list'">
                        취소
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
