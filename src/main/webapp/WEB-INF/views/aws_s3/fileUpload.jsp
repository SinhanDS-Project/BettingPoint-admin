<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파일 업로드</title>
</head>
<body>
	
	<h1>AWS S3 파일 업로드 테스트</h1><br>

	<!-- 단일 파일 업로드 폼 예시 -->
	<form action="/admin/uploadFormSingle" method="post" enctype="multipart/form-data">
	    <input type="file" name="file" />
	    <button type="submit">업로드</button>
	</form>
	
	<hr><br>
	
	<!-- 다중 파일 업로드 폼 예시 -->
	<form action="/admin/uploadFormMulti" method="post" enctype="multipart/form-data">
	    <input type="file" name="files" multiple />
	    <button type="submit">여러 파일 업로드</button>
	</form>
	
	<hr><br>
	<h2>아래는 같은 기능(파일 하나 업로드)을 ajax로 구현하였습니다.</h2>
	<input type="file" id="uploadFiles" name="files" multiple />
	<button type="button" onclick="uploadViaAjax()">파일 업로드(Ajax)</button>
	
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
	  function uploadViaAjax() {
	    var files = document.getElementById("uploadFiles").files;
	    var formData = new FormData();
	    // 선택된 모든 파일을 FormData에 추가
	    for (var i = 0; i < files.length; i++) {
	      formData.append('files', files[i]);
	    }
	    // 필요하면 다른 일반 폼 필드도 formData.append로 추가 가능
	    $.ajax({
	      type: 'POST',
	      url: '${cpath}/api/uploadAjax',
	      data: formData,
	      processData: false,  // 파일 데이터를 전송할 때 필수 설정
	      contentType: false,  // 콘텐츠 타입 자동 설정되도록 false로 지정
	      success: function(response) {
	        alert("업로드 성공: " + response);  // 서버가 반환한 결과 처리
	      },
	      error: function(xhr, status, error) {
	        alert("업로드 실패: " + error);
	      }
	    });
	  }
	</script>
	
</body>
</html>