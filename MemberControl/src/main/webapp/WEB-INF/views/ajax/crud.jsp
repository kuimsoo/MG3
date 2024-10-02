
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<style>
table {margin:auto; border-collapse: collapse;}
th:nth-child(1){
	text-align:right;
}
td{
	border:1px solid black;
}
th{
color:white; background-color:black;
}
</style>
<body>
<input type="hidden" id="id">
<table>
<tr><td>제목</td><td><input type="text" id="title"></td></tr>
<tr><td>내용</td><td><input type="text" id="content"></td></tr>
<tr><td colspan="2" style="text-align:center;">
	<input type="button" value="등록" id="btnAdd">
	<input type="button" value="비우기" id="btnClear">
	<input type="button" value="삭제" id="btnDelete">
</td></tr>
</table>
<button id="btnLoad">데이터가져오기</button><br><br>
<table id="tblBoard">
<thead>
<tr><th>번호</th><th>제목</th><th>작성자</th><th>작성시간</th></tr>
</thead>
<tbody></tbody>
</table>
</body>
<script src="https://code.jquery.com/jquery-latest.js"></script>
<script>
$(document)
.ready(function(){
	$('#btnLoad').trigger('click');
})
.on('click','#btnLoad',function(){
	$.post('/list',{},function(data){
	console.log(data);
	$('#tblBoard tbody').empty();
	for(let x of data){
	let str='<tr><td>'+x['id']+'</td><td>'+x['title']+'</td><td>'+
	x['author']+'</td><td>'+x['created']+'</td></tr>';
	$('#tblBoard tbody').append(str);
		}
	},'json');
})
.on('click','#btnClear',function(){
	$('#title,#content').val('');

})

.on('click','#btnAdd',function(){
	let title=$('#title').val();
	let content=$('#content').val();
	if(title==''||content=='') return false;
	$.ajax({url:'/addCrud',type:'post',data:{title:title,content:content},dataType:'text',
	success:function(data){
	console.log(data);
	if(data=='ok'){
		$('#btnLoad,#btnClear').trigger('click');
		}
	}
	})
	return false;
})
.on('click','#tblBoard tbody tr',function(){
	let id=$(this).find('td:eq(0)').text();
	let title=$(this).find('td:eq(1)').text();
	let content=$(this).find('td:eq(2)').text();
	
	$('#id').val(id);
	$('#title').val(title);
	$('#content').val(content);

})
.on('click','#btnDelete',function(){
	if(!confirm('정말로 지울까요')) return false;
	
	let id=$('#id').val();
	$.ajax({
	url:'/deleteBoard',type:'post',data:{id:id},dataType:'text',
	success:function(data){
		console.log(data);
		if(data=='ok'){
			$('#btnLoad,#btnClear').trigger('click');
		}
	}
		
})
})
</script>
</html>
