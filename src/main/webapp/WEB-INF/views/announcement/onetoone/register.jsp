<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>1:1 문의 등록 - WMS</title>
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
    <h2 class="mb-4"><i class="bi bi-chat-dots"></i> 1:1 문의 등록</h2>

    <div class="card">
        <div class="card-body">
            <form action="/announcement/onetoone/register" method="post">
                <div class="mb-3">
                    <label class="form-label">문의 유형 <span class="text-danger">*</span></label>
                    <select name="rType" class="form-select" required>
                        <option value="">선택하세요</option>
                        <option value="ORDER">주문 문의</option>
                        <option value="DELIVERY">배송 문의</option>
                        <option value="PRODUCT">상품 문의</option>
                        <option value="ETC">기타</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">제목 <span class="text-danger">*</span></label>
                    <input type="text" name="rTitle" class="form-control"
                           placeholder="제목을 입력하세요" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">내용 <span class="text-danger">*</span></label>
                    <textarea name="rContent" class="form-control" rows="10"
                              placeholder="문의 내용을 입력하세요" required></textarea>
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-send"></i> 등록
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
