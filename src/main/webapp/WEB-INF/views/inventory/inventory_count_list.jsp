<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../includes/header.jsp" %>

<div class="row">
  <div class="col-md-12">
    <div class="card">

      <!-- 헤더 + 검색 폼 -->
      <div class="card-header d-flex align-items-center justify-content-between">
        <h4 class="card-title mb-0">재고 실사 목록</h4>

        <!-- 화면 전용 폼 (fetch로 호출) -->
        <form id="searchForm" class="d-flex gap-2" onsubmit="return false;">
          <input type="number" class="form-control" name="invenIndex" placeholder="재고번호(inven_index)" style="width:200px"/>
          <input type="date" class="form-control" name="fromDate"  style="width:170px"/>
          <input type="date" class="form-control" name="toDate"    style="width:170px"/>

          <!-- 페이지 크기 -->
          <select class="form-select" name="amount" style="width:120px">
            <option value="10">10개</option>
            <option value="20" selected>20개</option>
            <option value="50">50개</option>
            <option value="100">100개</option>
          </select>

          <button type="button" id="btnSearch" class="btn btn-primary">조회</button>
          <button type="button" id="btnReset" class="btn btn-outline-secondary">초기화</button>

          <!-- 신규 등록 버튼 -->
          <button type="button" id="btnOpenCreate" class="btn btn-success">실사 등록</button>
        </form>
      </div>

      <!-- 본문: 테이블 -->
      <div class="card-body">
        <div class="table-responsive">
          <table class="display table table-striped table-hover">
            <thead>
            <tr>
              <th>실사번호</th>
              <th>재고번호</th>
              <th>장부수량</th>
              <th>실사수량</th>
              <th>차이(variance)</th>
              <th>실사일자</th>
              <th style="width:130px;">액션</th>
            </tr>
            </thead>
            <tbody id="tbodyCounts">
            <tr><td colspan="7" class="text-center text-muted">조회 결과가 없습니다.</td></tr>
            </tbody>
          </table>
        </div>

        <!-- 페이지네이션 -->
        <nav class="mt-3">
          <ul id="pagination" class="pagination justify-content-center"></ul>
        </nav>
      </div>
    </div>
  </div>
</div>

<!-- 등록/수정 모달 -->
<div class="modal fade" id="countModal" tabindex="-1" aria-labelledby="countModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form id="countForm" class="modal-content" onsubmit="return false;">
      <div class="modal-header">
        <h5 class="modal-title" id="countModalLabel">재고 실사</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="countIndex"/>
        <div class="mb-3">
          <label class="form-label" for="invenIndexInput">재고번호(inven_index)</label>
          <input id="invenIndexInput" type="number" class="form-control" required />
        </div>
        <div class="mb-3">
          <label class="form-label" for="invenQtyInput">장부수량(inven_quantity)</label>
          <input id="invenQtyInput" type="number" class="form-control" min="0" required />
        </div>
        <div class="mb-3">
          <label class="form-label" for="actualQtyInput">실사수량(actual_quantity)</label>
          <input id="actualQtyInput" type="number" class="form-control" min="0" required />
        </div>
        <div class="mb-0">
          <label class="form-label" for="updateAtInput">실사일자(count_updateAt)</label>
          <input id="updateAtInput" type="date" class="form-control" required />
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
        <button type="submit" id="btnSave" class="btn btn-primary">저장</button>
      </div>
    </form>
  </div>
</div>

<script>
  (function () {
    // 1) DOM 준비 후 실행
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', init);
    } else {
      init();
    }

    function init() {
      try {
        const ctxMetaH = document.querySelector('meta[name="_csrf_header"]');
        const ctxMetaT = document.querySelector('meta[name="_csrf"]');
        const CSRF = { h: ctxMetaH && ctxMetaH.content, t: ctxMetaT && ctxMetaT.content };

        // 2) 컨텍스트 경로 (EL 사용은 여기까지만)
        var ctx = '${pageContext.request.contextPath}';

        // 3) 테이블/버튼 등 요소 안전 접근
        var table = document.getElementById('inventoryCountTable'); // 예: <table id="inventoryCountTable">
        if (!table) {
          console.warn('inventoryCountTable not found. Skip JS.');
          return; // 요소 없으면 조용히 종료
        }

        // 4) JSON 호출은 반드시 format=json + Accept 헤더
        var params = new URLSearchParams(window.location.search);
        var pageNum = params.get('pageNum') || '${cri.pageNum}';
        var amount  = params.get('amount')  || '${cri.amount}';

        fetch(ctx + '/inventory/inventory_count_list?format=json'
                + '&pageNum=' + encodeURIComponent(pageNum)
                + '&amount='  + encodeURIComponent(amount),
                {
                  method: 'GET',
                  headers: { 'Accept': 'application/json' }, // 중요!
                  credentials: 'same-origin'
                })
                .then(function (res) {
                  if (!res.ok) throw new Error('HTTP ' + res.status);
                  return res.json();
                })
                .then(function (data) {
                  // data = { list: [...], page: {...} }
                  renderRows(table, data.list || []);
                  // 필요 시 페이지네이션도 여기서 그림
                })
                .catch(function (err) {
                  console.error('load error:', err);
                });

        // 5) 렌더 함수는 DOM 조작만
        function renderRows(tbl, rows) {
          var tbody = tbl.tBodies[0] || tbl.createTBody();
          tbody.innerHTML = '';
          rows.forEach(function (r) {
            var tr = document.createElement('tr');
            tr.innerHTML =
                    '<td>' + (r.countIndex || '')      + '</td>' +
                    '<td>' + (r.invenIndex || '')      + '</td>' +
                    '<td>' + (r.invenQuantity || '')   + '</td>' +
                    '<td>' + (r.actualQuantity || '')  + '</td>' +
                    '<td>' + (r.updateAt || '')        + '</td>';
            tbody.appendChild(tr);
          });
        }

        // 6) CSRF 필요한 POST/PUT/DELETE 예시 (널일 수 있어서 조건부)
        function csrfHeaders(base) {
          if (CSRF.h && CSRF.t) {
            base[CSRF.h] = CSRF.t;
          }
          return base;
        }

        // 예: 삭제 버튼 위임 (버튼 없으면 자동 skip)
        document.addEventListener('click', function (e) {
          var btn = e.target.closest('.btn-delete-count');
          if (!btn) return;
          var id = btn.getAttribute('data-id');
          if (!id) return;

          if (!confirm('삭제할까요?')) return;

          fetch(ctx + '/inventory/inventory_count_list/' + encodeURIComponent(id), {
            method: 'DELETE',
            headers: csrfHeaders({}),
            credentials: 'same-origin'
          })
                  .then(function (res) {
                    if (!res.ok) throw new Error('삭제 실패 ' + res.status);
                    // UI 갱신
                    btn.closest('tr') && btn.closest('tr').remove();
                  })
                  .catch(function (err) {
                    alert(err.message || '삭제 중 오류');
                  });
        });

      } catch (e) {
        console.error('init error:', e);
      }
    }
  })();
</script>



<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/end.jsp" %>
