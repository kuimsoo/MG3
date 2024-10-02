<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>새글작성</title>
</head>
<style>
table { margin:auto; border-collapse:collapsed;}
td:nth-child(1) {
	text-align:right;
}
td {
	border:1px solid black;
}
</style>
<body>
<table>
<tr><td>제목</td><td><input type=text name=title value="${board.title}" readonly></td></tr>
<tr><td>작성자</td><td><input type=text name=writer value="${board.writer}" readonly></td></tr>
<tr><td>게시글</td><td><textarea name=content rows=20 cols=50 readonly>${board.content}</textarea></td></tr>
<tr><td>작성시각</td><td>${board.created}</td></tr>
<tr><td>수정시각</td><td>${board.updated}</td></tr>
<tr><td colspan=2 style='text-align:center'>
<a href="/">목록으로 돌아가기</a>&nbsp;&nbsp;&nbsp;
<c:if test="${sessionScope.userid == board.writer}">
<a href="/update?id=${board.id}">수정</a>&nbsp;&nbsp;&nbsp;
<a href="/delete?id=${board.id}">삭제</a>
</c:if>
</td></tr>
</table>
<table >
<tr><td style=border:none><input type=hidden name=userid  value="${sessionScope.userid}" id=userid></td></tr>
<tr><td style=border:none;text-align:left;>댓글작성</td></tr>
<tr><td style="border:none; text-align:left;"><input type=text id=replyid></td></tr>
<tr><td><textarea name=reply rows=8 cols="60" id=reply></textarea></td></tr>
<tr><td style=border:none>
<input type=button value="등록" id="btnAdd">
<input type="button" value="취소" id="btnCan">

</td></tr>
</table>
<table id="tblreply">
<tr><th style="display:none"></th><th>작성자</th><th>내용</th><th>작성시간</th>
<c:forEach items="${arReply}" var="reply">
    <tr>
            <td style="display:none">${reply.id}</td>
            <td>${reply.userid}</td>
            <td>${reply.content}</td>
            <td>${reply.created}</td>
            <td style=border:none>
                <c:if test="${sessionScope.userid == reply.userid}">
                    <button id="btnUpdate">수정</button>
                    <button id="btnDelete">삭제</button>
                </c:if>
            </td>
        </tr>
</c:forEach>
<tbody>
</tbody>
</table>
</body>
<script src="https://code.jquery.com/jquery-latest.js"></script>
<script>
$(document)
.ready(function(){
	

})

.on('click','#btnAdd',function(){

	if($('#userid').val()==''){
		alert("로그인을 먼저해주세요");
		
	return false;
	}
	if($('#reply').val()==''){
		alert("내용을 입력해주세요");
		
		return false;
	
	}
	
	let id="${board.id}";
	let reply=$('#reply').val();
	let writer=$('#userid').val();
	console.log("id="+id);
	
		$.ajax({
			url:'/insertreply',type:'post',data:{id:id,reply:reply,writer:writer},dataType:'text',
			success:function(data) {
			console.log(data);
			if(data=='ok') {
				$('#reply').val('');
				location.reload();
			}
		}
	})

})

.on('click','#btnokok',function(){

	 let row = $(this).closest('tr').prev('tr'); 
	    let replyValue = row.find('textarea#replyreply').val(); // Get the value from textarea

	    row.add(row.next('.reply-reply-form')).remove(); // Remove the textarea and buttons
	
	    let par_id = $(this).closest('tr').find('input[id^="ididid"]').val();
	    let replyreply = replyValue;
	    let writer = $('#userid').val(); 
	
			$.ajax({
					url:'/replyreply',type:'post',data:{par_id:par_id,replyreply:replyreply,writer:writer},dataType:'text',
					success:function(data){
					console.log(data);
					if(data=='ok'){
						$('#replyreply').val('');
						
					}
				
	}
})
})


.on('click','#btnCan',function(){
	alert('등록을 취소할까요?');
	
	location.reload();
	return false;

})
.on('click', '#tblreply tbody tr', function () {
    let id = $(this).find('td:eq(0)').text();
    let reply = $(this).find('td:eq(2)').text();
    let userid = $(this).find('td:eq(1)').text();

    $('#replyid').val(id);

    if ($('#reply').val() === '') {
        if (userid !== $('#userid').val()) {
            $('#reply').val(reply).prop('readonly', true);
        } else {
            $('#reply').val(reply);
        }
    }

    if ($('#userid').val() !== '') {
        let row = $(this).closest('tr');

        // Check if the reply-reply-form class rows already exist
        if (row.nextAll('.reply-reply-form').length === 0) {
            let existingIdidid = $('#idid').val(); // Save the existing value

            let newRow = `
                <tr class="reply-reply-form">
                    <td colspan="3"><textarea rows="10" cols="60" id="replyreply"></textarea></td>
                </tr>
                <tr class="reply-reply-form">
                    <td style="border:none;">
                        <input type="button" value="대댓글등록" id="btnokok" style="text-align:right;">
                        <input type="button" value="취소" id="btncancan" style="text-align:right;">
                        <input type="text"  id="useridid"  style="text-align:right;" readonly>
                    </td>
                    <td style="border:none;">
                        <input type="text" id="ididid_${id}" value="${existingIdidid}">
                    </td>
                </tr>`;

            row.after(newRow);
        }
    }

    // Make sure to handle cases where #ididid might not exist or might be empty

	    if (userid !== '') {
        $('#useridid').val(userid);
   	 	}
    if (!$(`#ididid_${id}`).val()) {
        $(`#ididid_${id}`).val(id);
    }
    
		 
  	let par_id = id;	
  	console.log("par_id=="+par_id);

  	
	$.ajax({
			url:'/comment',type:'post',data:{par_id:par_id},dataType:'json',
			success:function(data){
			console.log(data);
					for(let x of data) {
					
				 let str='<tr><td style="border:none;">대댓글</td><td>'+x['userid']+'</td><td>'+x['content']+'</td><td>'+x['created']+'</td><td style="display:none">'+x['id']+'</td></tr>';
				 $('#tblreply tbody').after(str);
							
					}
				}
			
			
		})
 
	})
.on('click','#btnDelete',function(){
			
	if(!confirm('정말로 삭제할까요')) return false;
	
	//let replyid=$('#replyid').val();	
	//$(this).closest('tr').find('#replyid').val();
	
	$(this).closest('tr').remove();
	//console.log("replyid1"+replyid1);
	
	let rep = $(this).closest('tr').find('td:eq(0)').text();


	
		$.ajax({
				url:'/deletereply',type:'post',data:{rep:rep},dataType:'text',
				success:function(data){
					console.log(data);
					if(data=='ok'){
						$('#reply').val('');
						 location.reload();
						
							
					}
					
				}
})
		
})
.on('click', '#btnUpdate', function() {
                let row = $(this).closest('tr');
              
                let currentContent = row.find('td').eq(2).text();
                     
            let newRow = '<tr class="edit-row"><td colspan="3"><textarea rows="10" cols="60" id="updatecontent">' + currentContent + '</textarea></td></tr>'
            + '<tr><td style="border:none;"><input type="button" value="등록" id="btnok" style="text-align:right;"></td><td style="border:none;"><input type=text id="idid"></td></tr>';
               
                row.after(newRow);
                
                
                //$('#reply').val($('#updatecontent').val());
            	let id=row.find('td').eq(0).text();  
				$('#replyid').val(id);
				console.log('id22222='+id);
				$('#idid').val($('#replyid').val());
   
})
.on('click','#btnok',function(){
	let par_id="${board.id}";//작성자아이디
	let reply=$('#updatecontent').val();
	let writer=$('#userid').val(); //댓글작성자아이디
	
	let id=$('#idid').val();
	
	if(reply=='') {
		
	alert('내용을 입력해주세요');
		
	}
	
	if(!confirm('등록하시겠습니까?')){
	
		return false;
	}
	
	
	console.log("replyid111"+id);
	console.log("reply111="+reply);
	console.log("writer111="+writer);
	console.log("par_id1111"+par_id);
	
				$.ajax({
					url:'/updatereply',type:'post',data:{par_id:par_id,reply:reply,writer:writer,id:id},dataType:'text',
					success:function(data){
						console.log(data);
						if(data=='ok'){
							$('#reply').val($('#updatecontent').val());
							location.reload();
							
							
						}
					}
				})
})

.on('click', '#btncancan', function () {
    if (confirm("대댓글 작성을 취소할까요?")) {
        location.reload();
        return false;
    }
})

</script>
</html>