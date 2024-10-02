<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
#container {
    display: flex;
  	flex-direction: column; /* 자식 요소들을 수직으로 배치 */ 
    justify-content: center; 
    padding: 20px;
    width: 1000px; 
    margin: 0 auto;   
  
}
.cart_step {
    list-style-type: none;
    padding: 0;
    margin: 0;
    display: flex;
    align-items: center;
    justify-content: space-between;
   
}
.cart_step li {
    display: flex;
    align-items: center;
    position: relative;
}
.cart_step div{
    display: block;
    font-size: 16px;
    color: #666;
    margin-bottom: 5px;
    margin-right: 10px; /* STEP과 화살표 사이의 마진 */
}

.cart_step li strong {
    display: block;
    font-size: 16px;
    font-weight: bold;
}

.cart_step .step.active strong,.cart_step .step.step2 {
    color: red; /* 활성 단계의 색상 */
}
/* 화살표 스타일 */
.cart_step .step:not(:last-child)::after {
        content: '>';
        display: inline-block;
        margin: 0 10px; /* 화살표의 좌우 간격 */
        font-size: 20px;
        color: #666;
}

.cart-item {
    display: flex;
     align-items: center; /* 세로 중앙 정렬 */
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 10px;
    margin-bottom: 10px;
    
}

.item-image {
    max-width: 100px;
    margin-right: 20px;
}
   .cart-item {
        display: flex;
        align-items: center; /* 수직 정렬 */
        padding: 10px; /* 선택적: 여백 */
        margin-bottom: 10px; /* 선택적: 항목 간 간격 */
    }
    .cart-item img {
        max-width: 100px; /* 이미지 크기 조정, 필요에 따라 수정 */
        margin-right: 20px; /* 이미지와 텍스트 간의 간격 */
    }
    .item-details  {
        display: flex;
        flex: 1;
        justify-content: space-between;
    }
    
    .item-details div{
        margin-right: 20px;
    }
    
    .item-name, .discount, .price, .qty, .total {
        width: 100px; /* Adjust as needed */
    }
  .header {
    display: grid;
    grid-template-columns: 100px 1fr 1fr 1fr 100px 100px 100px 100px;
    gap: 10px;
    font-weight: bold;
    margin-bottom: 10px;
}

.separator {
 width: 100%; 
 height: 2px;
 margin: 0;
}
.separator {
   
    background-color: black; 
    margin-bottom:20px;
}
.foottable {
    width: 100%; /* 테이블이 부모 요소의 너비를 100% 차지 */
    border-collapse: collapse; /* 테두리가 겹치지 않도록 설정 */
    margin: 0 auto; /* 테이블을 중앙에 정렬 */
}

.foottable thead {
    display: block;
}

.foottable tbody {
    display: block;
    overflow-x: auto; /* 가로 스크롤을 허용 */
}

.foottable thead th {
    background-color: #f4f4f4; /* 헤더 배경색 */
}

.foottable tbody tr {
    display: flex;
    justify-content: space-between;
}

.foottable tbody td {
    width: 33%; /* 각 셀의 너비 설정 */
}
.foottable th, .foottable td {
    text-align: center;
    padding: 10px;
  
    box-sizing: border-box; /* padding과 border를 너비에 포함 */
}

/* thead의 th 스타일 */
.foottable thead {
    width: 100%; /* 전체 테이블 너비에 맞게 설정 */
}

/* 각 열의 너비 비율 설정 */
.width-40 {
    width: 10%; /* 모든 .width-40 요소에 동일한 너비 설정 */
}

.width-20 {
    width: 20%;
}
/* tbody의 td 스타일 (기본적으로 thead와 동일하게 유지) */
.foottable tbody td {
    box-sizing: border-box; /* padding과 border를 너비에 포함 */
}
.cartprice{
	text-decoration: line-through;
    color:grey; 

}
.cart-table {
    width: 100%; /* 테이블을 부모 요소의 너비에 맞게 설정 */
    border-collapse: collapse; /* 테이블 셀 간의 경계를 겹치지 않게 설정 */
}
.cart-table td {
    text-align: left;
   	margin-right:50px;
  
}
</style>
</head>
<body>
<div id="container">
 	<div class="cart_step">
       <div class="step step1 "><span>STEP 01</span>&nbsp;<strong>장바구니</strong></div>
       <div class="step step2 active"><span>STEP 02</span>&nbsp;<strong>결제하기</strong></div>
       <div class="step step3"><span>STEP 03</span>&nbsp;<strong>결제완료</strong></div>
   </div>
    <div class="cart_details">
        <table class="cart-table">
            <thead>
                <tr class="header">
                    <th>상품이미지</th>
                    <th>상품이름</th>       
                    <th>판매금액</th>        
                    <th>수량</th>
                    <th>구매금액</th>
                    <th>선택</th>
                </tr>
            </thead>
            <tbody>
              <c:forEach items="${items}" var="item">
                   <tr class="cart-item">                    
                        <td>
                            <input type="hidden" class="item_id" value="${item.item_id}">
                            <input type="hidden" id="gg">             
                            <img src="${item.image_path}" id="imagepath" alt="${item.item_id}">
                        </td>  
                        <td class="item-details">
                            <div class="item_name">
                                <span>${item.name}</span><br>
                                <span>${item.composition}</span>
                            </div>
                        </td>      
                        <td>
                            <div class="discount">
                                <span class="discount_price">${item.discount_price}원</span>
                             	<c:choose>
								    <c:when test="${not empty item.cart_price and item.cart_price ne cart.discount_price}">
								        <span class="cartprice">${item.cart_price}원</span>
								    </c:when>
								</c:choose>
                            </div>
                        </td>
                        <td class="qty">${item.qty}개</td>
                         <td class="total">${item.total}원</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <div class="separator"></div>
        <table class="foottable"> 
      	<thead class="footthead">
        		<tr>
			        <th class="width-40">총 상품 금액</th>
	                <th class="width-20">할인금액</th>
	                <th class="width-40">총 결제 예정금액</th>
        		</tr>
	    	</thead>
        	 <tbody>
		        <tr>
		     		<td class="totalprice">${totalPrice}원</td>
		     		<td class="minus">-</td>
		            <td class="totaldiscount">${totalDiscount}원</td>
		         	<td class="equal">=</td>
		            <td class="finalprice">${finalPrice}원</td>		            
		        </tr>
	    	</tbody>
	    	 <tfoot>
			    <tr class="separator"></tr>		  
			 </tfoot>
        </table>
    </div> 
</div>

</body>

<script src="https://code.jquery.com/jquery-latest.js"></script>
<script>
$(document).ready(function() {
    function formatNumber(number) {
        return number.toLocaleString();
    }

    $('.discount_price, .cartprice, .total, .totalprice, .totaldiscount, .finalprice').each(function() {
        let $this = $(this);
        // Extract text, remove '원', and format
        let text = $this.text().replace('원', '').replace(/,/g, ''); // Remove '원' and any existing commas
        let price = parseInt(text, 10); // Convert to integer

        if (!isNaN(price)) {
            $this.text(formatNumber(price) + '원');
        }
    });
});

 










</script>
</html>