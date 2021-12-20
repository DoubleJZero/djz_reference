<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html>
<head>
    <%@ include file="/include/head.jsp" %>
</head>

<body>

    <!-- [Left] start -->
	<jsp:include page="/left.do" />
    <!-- [Left] end -->

    <!-- [Header] start -->
	<jsp:include page="/header.do" />
    <!-- [Header] end -->

    <!-- [ Main Content ] start -->
    <section class="pcoded-main-container">
        <div class="pcoded-wrapper">
            <div class="pcoded-content">
                <div class="pcoded-inner-content">
                    <div class="main-body">
                        <div class="page-wrapper">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5>메뉴권한관리</h5>

                                            <div class="card-header-right">
                                            	<div class="btn-group card-option">

												<select class="form-control" id="authId">
													<c:forEach var="item" items="${authList}" varStatus="status">
						                        		<option value="${item.authId}"><c:out value='${item.authId}'/></option>
                        	 						</c:forEach>
						                        </select>
												</div>
											</div>
                                        </div>

                                        <div class="card-body">
                                        	<div style="text-align: right;" class="mb-2">
                                        		<c:if test='${!empty sessionScope.curAuthInfo and curAuthInfo.roleU eq "Y"}'>
													<button type="button" class="btn btn-primary btn-sm" onclick="fn_save()" style="margin-right: 0.5px;"><spring:message code='button.save' /></button>
                                        		</c:if>
											</div>

											<div class="form-group" style="overflow:auto; height: 650px;margin-top:10px;">
												<table class="table table-bordered">
													<colgroup>
														<col style="width:65%">
														<col style="width:5%">
														<col style="width:5%">
														<col style="width:5%">
														<col style="width:5%">
														<col style="width:5%">
														<col style="width:5%">
														<col style="width:5%">
													</colgroup>
													<thead>
														<tr style="position:sticky;top: 0px;background-color: #fff !important;z-index: 1;">
															<th>메뉴명</th>
															<th><input type='checkbox' id='ck_useYn_all' onclick='checkValid.checkAll("ck_useYn_all", "useYn")' />&nbsp;사용여부</th>
															<th><input type='checkbox' id='ck_roleC_all' onclick='checkValid.checkAll("ck_roleC_all", "roleC")' />&nbsp;등록</th>
															<th><input type='checkbox' id='ck_roleR_all' onclick='checkValid.checkAll("ck_roleR_all", "roleR")' />&nbsp;조회</th>
															<th><input type='checkbox' id='ck_roleU_all' onclick='checkValid.checkAll("ck_roleU_all", "roleU")' />&nbsp;수정</th>
															<th><input type='checkbox' id='ck_roleD_all' onclick='checkValid.checkAll("ck_roleD_all", "roleD")' />&nbsp;삭제</th>
															<th><input type='checkbox' id='ck_roleE_all' onclick='checkValid.checkAll("ck_roleE_all", "roleE")' />&nbsp;엑셀</th>
															<th><input type='checkbox' id='ck_roleP_all' onclick='checkValid.checkAll("ck_roleP_all", "roleP")' />&nbsp;인쇄</th>
														</tr>
													</thead>
													<tbody id="clearArea"></tbody>
												</table>

											</div>
                                        </div>
                                    </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

<script>
function fn_search() {
	var authId = $("#authId").val();

	$.ajax({
		type : "POST",
		url : "/system/getAuthMenuList.do",
		data : {"authId":authId},
		dataType : 'json',
		success : function(res) {
			/* ■ 상태코드
			 * 700 : 정상
	    	 * 705 : 조회결과 없음
	    	 */
			var html = "";

			if(res.statusCode == '700'){
				$.each(res.data, function(idx, item){
					html += "<tr>";

					if(item.menuDepth == 1){
						html += "<td colspan='8' class='alert alert-primary-02' style='color:blue;'>" + item.menuName + "</td>"
					}else{
						html += "<td><input type='hidden' name='menuId' value='"+item.menuId+"' />" + item.menuName + "</td>";

						html += "<td><input type='checkbox' name='useYn'";
						if(item.useYn == "Y"){
							html += " checked='checked'";
						}
						html += " /></td>";

						html += "<td><input type='checkbox' name='roleC'";
						if(item.roleC == "Y"){
							html += " checked='checked'";
						}
						html += " /></td>";

						html += "<td><input type='checkbox' name='roleR'";
						if(item.roleR == "Y"){
							html += " checked='checked'";
						}
						html += " /></td>";

						html += "<td><input type='checkbox' name='roleU'";
						if(item.roleU == "Y"){
							html += " checked='checked'";
						}
						html += " /></td>";

						html += "<td><input type='checkbox' name='roleD'";
						if(item.roleD == "Y"){
							html += " checked='checked'";
						}
						html += " /></td>";

						html += "<td><input type='checkbox' name='roleE'";
						if(item.roleE == "Y"){
							html += " checked='checked'";
						}
						html += " /></td>";

						html += "<td><input type='checkbox' name='roleP'";
						if(item.roleP == "Y"){
							html += " checked='checked'";
						}
						html += " /></td>";
					}

					html += "</tr>";

					flag = false;
				});
			}else{
				console.log(res.statusCode);
				html = "<td colspan='8'><spring:message code='common.msg3' /></td>";
			}

			$("#clearArea").empty();
			$("#clearArea").html(html);
		},
		error : function(request, status, error) {
			alert("status: " + request.status + ", error: " + error);
		}
	});
}

function fn_save(){
	var authId = $("#authId").val();

	/* ■ 인자값으로 name 속성 값을 전달한다. */
	var menuId = getValue.getInputNameValue("menuId");

	/* ■ 인자값으로 checkbox name 속성 값을 전달한다. */
	var useYn = getValue.getCheckBoxValueYn("useYn");
	var roleC = getValue.getCheckBoxValueYn("roleC");
	var roleR = getValue.getCheckBoxValueYn("roleR");
	var roleU = getValue.getCheckBoxValueYn("roleU");
	var roleD = getValue.getCheckBoxValueYn("roleD");
	var roleE = getValue.getCheckBoxValueYn("roleE");
	var roleP = getValue.getCheckBoxValueYn("roleP");

	swal({
		title: '<spring:message code="button.save" />',
        text: '<spring:message code="common.msg6" />',
        icon: "warning",
        buttons: ['<spring:message code="button.cancel" />','<spring:message code="button.confirm" />'],
        dangerMode: true,
    })
    .then((willDelete) => {
        if (willDelete) {
        	$.ajax({
        		type : "POST",
        		url : "/system/getUpdateAuthMenu.do",
        		data : {"authId":authId, "menuId":menuId, "useYn":useYn, "roleC":roleC, "roleR":roleR, "roleU":roleU, "roleD":roleD, "roleE":roleE, "roleP":roleP},
        		dataType : 'json',
        		success : function(res) {
        			/* ■ 상태코드
        			 * 700 : 정상
        	    	 * 701 : 비정상 접근 - param null
        	    	 * 702 : 필수값 없음
        	    	 */
        			if(res.statusCode == 700){
        				swal('<spring:message code="common.msg9" />');
          	    		fn_search();
           	    	}else{
           	    		console.log(res.statusCode);
           	    	}
        		},
        		error : function(request, status, error) {
        			alert("status: " + request.status + ", error: " + error);
        		}
        	});
        }else{
        	return;
        }
    });
}

$(document).ready(function() {
	fn_search();

	$("#authId").change(function(){
		fn_search();
   	});
});
</script>
</body>
</html>