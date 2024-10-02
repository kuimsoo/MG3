<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form method=post action="/doLogin">
아이디<input type=text name=userid ><br><br>
비번<input type=password name=passwd><br><br>
<input type=submit value="로그인">
<input type=button value="비우기" id=btncan>


</form>
</body>
<script src="https://code.jquery.com/jquery-latest.js"></script>
<script>
$(document)
.on('click','#btncan',function(){

	document.location.href="http://localhost:8081/";

});
</script>

</html>