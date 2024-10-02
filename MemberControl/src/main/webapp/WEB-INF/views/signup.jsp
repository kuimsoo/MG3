<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
</head>
<style>
td:nth-child(1) {
	text-align:right;
}
</style>
<body>
<form method=post action='/doSignup'>
<table>
<tr><td>아이디</td><td><input type=text name=userid></td></tr>
<tr><td>비밀번호</td><td><input type=password name=passwd></td></tr>
<tr><td>실명</td><td><input type=text name=realname></td></tr>
<tr><td>생년월일</td><td><input type="date" name=birthday></td></tr>
<tr><td>성별</td><td><input type=radio name=gender value='남성'>남성
					<input type=radio name=gender value="여성">여성</td>
</tr>
<tr><td>모바일</td><td><input type=text name=mobile></td></tr>
<tr>
	<td>관심분야</td><td>
		<input type=checkbox name=favorite value=Java>Java
		<input type=checkbox name=favorite value=Javascript>Javascript
		<input type=checkbox name=favorite value=Python>Python
		<input type=checkbox name=favorite value=MySQL>MySQL
		<input type=checkbox name=favorite value=Oracle>Oracle
		<input type=checkbox name=favorite value=React>React
		<input type=checkbox name=favorite value=Spring>Spring
		<input type=checkbox name=favorite value="Node.js">Node.js
		<input type=checkbox name=favorite value="Next.js">Next.js
	</td>
</tr>
<tr>
	<td colspan=2 style='text-align:center'>
		<input type=submit value='회원가입'>&nbsp;
		<input type=button value='비우기' id=btncan>
	</td>
</table>
</form>
</body>
<script src="https://code.jquery.com/jquery-latest.js"></script>
<script>
$(document)
.on('click','#btncan',function(){

	document.location.href="http://localhost:8081/signup";

});
</script>





</html>