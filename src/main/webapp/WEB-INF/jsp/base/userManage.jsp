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
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5>사용자관리</h5>

                                            <div class="card-header-right">
                                            	<div class="btn-group card-option">

													<input type="text" id="searchUserName" class="form-control custttscf" style="margin-right:5px; max-height:36px;" maxlength="30" />

													<c:if test='${!empty sessionScope.curAuthInfo and curAuthInfo.r eq "Y"}'>
														<button type="button" class="btn btn-primary btn-sm" onclick="fn_search()" style="min-width:60px;"><spring:message code='button.lookup' /></button>
													</c:if>
												</div>
											</div>
                                        </div>

                                        <div class="card-body">
											<div class="row">
												<div class="col-md-8" style="padding-top:15px;">
													<table id="GRID_1"></table>
													<div id="PAGINATION_1"></div>
												</div>

												<div class="col-md-4">
													<div style="text-align: right;" class="mb-3">
														<c:if test='${!empty sessionScope.curAuthInfo and curAuthInfo.roleD eq "Y"}'>
															<button type="button" class="btn btn-danger btn-sm" onclick="fn_delete()" style="margin-right: 0.5px;"><spring:message code='button.delete' /></button>
														</c:if>
														<button type="button" class="btn btn-dark btn-sm" onclick="fn_init()" style="margin-right: 0.5px;"><spring:message code='button.init' /></button>
														<c:if test='${!empty sessionScope.curAuthInfo and (curAuthInfo.roleC eq "Y" or curAuthInfo.roleU eq "Y")}'>
															<button type="button" class="btn btn-primary btn-sm" onclick="fn_save()" style="margin-right: 0.5px;"><spring:message code='button.save' /></button>
														</c:if>
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label"><spring:message code='login.userId' />&nbsp;<span style="color:red;">*</span></label>
														<input type="text" id="userId" class="form-control col-sm-8 custoenuhf" maxlength="16" />
														<input type="hidden" id="userIdDupCheckKey" name="userIdDupCheckKey" maxlength="11" />
														<input type="hidden" id="orgUserId" />
														<div class="input-group-append dupBtnDiv">
								                            <button class="btn btn-primary" type="button" onclick="fn_isDupCheck(1)"><spring:message code='member.dupCheck' /></button>
								                        </div>
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label"><spring:message code='login.password' />&nbsp;<span style="color:red;" class="updateSpan">*</span></label>
														<input type="password" id="userPw" class="form-control col-sm-8 custpf" maxlength="20" />
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label"><spring:message code='login.conPassword' />&nbsp;<span style="color:red;" class="updateSpan">*</span></label>
														<input type="password" id="conPw" class="form-control col-sm-8 custpf" maxlength="20" />
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label"><spring:message code='search.name' />&nbsp;<span style="color:red;" class="updateSpan">*</span></label>
														<input type="text" id="userName" class="form-control col-sm-8 custokaef" maxlength="30" />
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label"><spring:message code='member.zipcode' />&nbsp;<span style="color:red;" class="updateSpan">*</span></label>
														<input type="text" id="zipcode" name="zipcode" class="form-control col-sm-8 custonf" maxlength="6" readonly="readonly" />
														<div class="input-group-append">
								                            <button class="btn btn-primary" type="button" onclick="fn_getAddressPop('zipcode','address')" id="zipcodeBtn"><i class="fab fa-searchengin"></i></button>
								                        </div>
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label for="address" class="col-sm-4 col-form-label"><spring:message code='member.address' />&nbsp;<span style="color:red;">*</span></label>
														<input type="text" id="address" name="address" class="form-control col-sm-8" maxlength="120" readonly="readonly" />
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label for="addressDetail" class="col-sm-4 col-form-label"><spring:message code='member.addressDetail' />&nbsp;<span style="color:red;">*</span></label>
														<input type="text" id="addressDetail" name="addressDetail" class="form-control col-sm-8 custascf" maxlength="50" />
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label for="mobile" class="col-sm-4 col-form-label"><spring:message code='login.mobile' />&nbsp;<span style="color:red;">*</span></label>
														<input type="text" id="mobile" name="mobile" class="form-control col-sm-8" placeholder="###-####-####" maxlength="13" onkeyup="checkValid.inputPhoneNumber(this)" />
														<input type="hidden" id="mobileDupCheckKey" name="mobileDupCheckKey" maxlength="11" />
														<div class="input-group-append dupBtnDiv">
								                            <button class="btn btn-primary" type="button" onclick="fn_isDupCheck(2)"><spring:message code='member.dupCheck' /></button>
								                        </div>
								                        <div class="input-group-append certiDiv" style="display:none;">
								                            <button class="btn btn-primary" type="button" onclick="fn_certPopMobile()">변경</button>
								                        </div>
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label"></label>
								                        <div class="checkbox checkbox-primary checkbox-fill d-inline">
								                            <input type="checkbox" id="smsYn" name="smsYn" value="Y" />
								                            <label for="smsYn" class="cr"><spring:message code='member.smsYn' /></label>
								                        </div>
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label for="email" class="col-sm-4 col-form-label"><spring:message code='member.email' />&nbsp;<span style="color:red;">*</span></label>
														<input type="text" id="email" name="email" class="form-control col-sm-8 custoemf" placeholder="abc123@abcde.com" maxlength="35" />
														<input type="hidden" id="emailDupCheckKey" name="emailDupCheckKey" maxlength="11" />
														<div class="input-group-append dupBtnDiv">
								                            <button class="btn btn-primary" type="button" onclick="fn_isDupCheck(3)"><spring:message code='member.dupCheck' /></button>
								                        </div>
								                        <div class="input-group-append certiDiv" style="display:none;">
								                            <button class="btn btn-primary" type="button" onclick="fn_certPopMobile()">변경</button>
								                        </div>
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label"></label>
								                        <div class="checkbox checkbox-primary checkbox-fill d-inline">
								                            <input type="checkbox" id="emailYn" name="emailYn" value="Y" />
								                            <label for="emailYn" class="cr"><spring:message code='member.emailYn' /></label>
								                        </div>
													</div>
												</div>
											</div>
                                        </div>
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
function fn_initJqGrid(data){

	$("#GRID_1").jqGrid({
		datatype: "local",
	    height: 600,
		pager: $('#PAGINATION_1'),
	   	colNames:[
	   		"이메일 수신여부"
	   		,"모바일 수신여부"
	   		,"상세주소"
	   		,"아이디"
	   		,"사용자명"
	   		,"우편번호"
	   		,"주소"
	   		,"이메일"
	   		,"휴대폰번호"
	   	],
	   	colModel:[
	   		{name:'emailYn',index:'emailYn', hidden:true},
	   		{name:'smsYn',index:'smsYn', hidden:true},
	   		{name:'addressDetail',index:'addressDetail', hidden:true},
	   		{name:'userId',index:'userId', width:100},
	   		{name:'userName',index:'userName', width:100},
	   		{name:'zipcode',index:'zipcode', width:100},
	   		{name:'address',index:'address', width:300},
	   		{name:'email',index:'email', width:200},
	   		{name:'mobile',index:'mobile', width:120}
	   	],
	   	shrinkToFit:true,
	    viewrecords: true,
	    loadonce: false,
	   	rowNum:50,
	   	rowList:[50,100,500],
	   	rownumbers:true,
	    rownumWidth:30,
	    jsonReader:{repeatitems : false},
	   	multiselect: false,
	   	scrollrows:true,
	   	autowidth:true,
	   	onSelectRow :  function(id){
	   		var cols = $("#GRID_1").jqGrid('getRowData', id);

	   		$('#userId').prop("readonly", true);
			$('#mobile').prop("readonly", true);
			$('#email').prop("readonly", true);

			$('.dupBtnDiv').css("display","none");
	   		$('.certiDiv').css("display","");
			$('.updateSpan').css("display", "none");

			$('#orgUserId').val(cols.userId);
	   		$('#userId').val(cols.userId);
			$('#userName').val(cols.userName);
			$('#zipcode').val(cols.zipcode);
			$('#address').val(cols.address);
			$('#email').val(cols.email);
			$('#mobile').val(cols.mobile);
			$('#addressDetail').val(cols.addressDetail);

			if(cols.smsYn == "Y"){
				$('#smsYn').prop("checked", true);
			}else{
				$('#smsYn').prop("checked", false);
			}

			if(cols.emailYn == "Y"){
				$('#emailYn').prop("checked", true);
			}else{
				$('#emailYn').prop("checked", false);
			}
   		},
	    loadComplete: function(data) {
			if(data.rows.length == 0){
				$("#GRID_1").jqGrid('clearGridData');

				$("#GRID_1 > tbody").append("<tr><td align='center' colspan='7'><spring:message code='common.msg3' /></td></tr>");
			}
	   }
	});

	if(fn_isCheckNumValueVaild(data)){
		$("#GRID_1").jqGrid('clearGridData');
		$("#GRID_1").jqGrid('setGridParam',{data:data}).trigger("reloadGrid");
	}
}

function fn_search() {
	var searchUserName = $("#searchUserName").val();

	$.ajax({
		type : "POST",
		url : "/base/getUserList.do",
		data : {"searchUserName":searchUserName},
		dataType : 'json',
		success : function(res) {
			/* ■ 상태코드
			 * 700 : 정상
	    	 * 705 : 조회결과 없음
	    	 */
			if(res.statusCode == 700){
				fn_initJqGrid(res.data);
				fn_init();
			}else{
				console.log(res.statusCode);
				fn_initJqGrid([]);
				fn_init();
			}
		},
		error : function(request, status, error) {
			alert("status: " + request.status + ", error: " + error);
		}
	});
}

function fn_delete(){
	var userId = $('#orgUserId').val();

	if(!checkValid.isCheckValueVaild(userId)){
		fn_init();
		return;
	}

	swal({
		title: '<spring:message code="button.delete" />',
        text: '<spring:message code="common.msg2" />',
        icon: "warning",
        buttons: ['<spring:message code="button.cancel" />','<spring:message code="button.confirm" />'],
        dangerMode: true,
    })
    .then((willDelete) => {
        if (willDelete) {
        	$.ajax({
        		type : "POST",
        		url : "/base/getDeleteUser.do",
        		data : {"userId":userId},
        		dataType : 'json',
        		success : function(data) {
        			swal('<spring:message code="member.errMsg35" />');
        			/* ■ 상태코드
        			 * 700 : 정상
        	    	 * 701 : 비정상 접근 - param null
        	    	 * 702 : 필수값 없음
        	    	 */
        	    	 if(data.statusCode == 700){
        	    		 fn_search();
        	    	 }else{
        	    		 console.log(data.statusCode);
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

function fn_init(){
	$('#userId').prop("readonly", false);
	$('#mobile').prop("readonly", false);
	$('#email').prop("readonly", false);

	$('.dupBtnDiv').css("display","");
	$('.certiDiv').css("display","none");
	$('.updateSpan').css("display", "");

	$('#orgUserId').val('');
	$('#userId').val('');
	$('#userPw').val('');
	$('#conPw').val('');
	$('#userName').val('');
	$('#zipcode').val('');
	$('#address').val('');
	$('#email').val('');
	$('#mobile').val('');
	$('#addressDetail').val('');

	$('#smsYn').prop("checked", false);
	$('#emailYn').prop("checked", false);

	$("#GRID_1").jqGrid('resetSelection');
}

function fn_save(){
	var orgUserId = $('#orgUserId').val();

	if(!checkValid.isCheckValueVaild(orgUserId)){
		var userId = $("#userId").val();

		if(!checkValid.isCheckValueVaild(userId)){
			swal('<spring:message code="login.errMsg1" />').then((ok)=>{
				if(ok){
					$("#userId").focus();
				}
			});
			return;
		}

		/* ■ 아이디 길이 체크 */
		if(!fn_checkId(userId)){
			swal('<spring:message code="member.errMsg36" />').then((ok)=>{
				if(ok){
					$("#userId").focus();

				}
			});
			return;
		}

		var userIdDupCheckKey = $("#userIdDupCheckKey").val();

		if(!fn_isPrime(userIdDupCheckKey)){
			swal('<spring:message code="member.errMsg1" />').then((ok)=>{
				if(ok){
					$("#userId").focus();
				}
			});
			return;
		}

		var userPw = $("#userPw").val();

		if(!checkValid.isCheckValueVaild(userPw)){
			swal('<spring:message code="login.errMsg2" />').then((ok)=>{
				if(ok){
					$("#userPw").focus();
				}
			});
			return;
		}

		/* ■ 비밀번호 길이 체크 */
		if(!fn_checkPassword1(userPw)){
			swal('<spring:message code="login.errMsg20" />').then((ok)=>{
				if(ok){
					$("#userPw").focus();

				}
			});
			return;
		}

		/* ■ 비밀번호 복잡도 체크 */
		if(!fn_checkPassword2(userPw)){
			swal('<spring:message code="login.errMsg21" />').then((ok)=>{
				if(ok){
					$("#userPw").focus();
				}
			});
			return;
		}

		var conPw = $("#conPw").val();

		if(!checkValid.isCheckValueVaild(conPw)){
			swal('<spring:message code="login.errMsg11" />').then((ok)=>{
				if(ok){
					$("#conPw").focus();
				}
			});
			return;
		}

		if(userPw != conPw){
			swal('<spring:message code="member.errMsg2" />').then((ok)=>{
				if(ok){
					$("#conPw").focus();
				}
			});
			return;
		}

		var userName = $("#userName").val();

		if(!checkValid.isCheckValueVaild(userName)){
			swal('<spring:message code="login.errMsg16" />').then((ok)=>{
				if(ok){
					$("#userName").focus();
				}
			});
			return;
		}

		var zipcode = $("#zipcode").val();

		if(!checkValid.isCheckValueVaild(zipcode)){
			swal('<spring:message code="member.errMsg6" />').then((ok)=>{
				if(ok){
					$("#zipcode").focus();
				}
			});
			return;
		}

		var address = $("#address").val();

		if(!checkValid.isCheckValueVaild(address)){
			swal('<spring:message code="member.errMsg6" />').then((ok)=>{
				if(ok){
					$("#zipcode").focus();
				}
			});
			return;
		}

		var addressDetail = $("#addressDetail").val();

		if(!checkValid.isCheckValueVaild(addressDetail)){
			swal('<spring:message code="member.errMsg21" />').then((ok)=>{
				if(ok){
					$("#addressDetail").focus();
				}
			});
			return;
		}

		var mobile = $("#mobile").val();

		if(!checkValid.isCheckValueVaild(mobile)){
			swal('<spring:message code="login.errMsg17" />').then((ok)=>{
				if(ok){
					$("#mobile").focus();
				}
			});
			return;
		}

		if(!checkValid.isMobileValid(mobile)){
			swal('<spring:message code="login.errMsg18" />').then((ok)=>{
				if(ok){
					$("#mobile").focus();
					$("#mobileDupCheckKey").val(1);
				}
			});
			return;
		}

		var mobileDupCheckKey = $("#mobileDupCheckKey").val();

		if(!fn_isPrime(mobileDupCheckKey)){
			swal('<spring:message code="member.errMsg11" />').then((ok)=>{
				if(ok){
					$("#mobile").focus();
				}
			});
			return;
		}

		var email = $("#email").val();

		if(!checkValid.isCheckValueVaild(email)){
			swal('<spring:message code="member.errMsg8" />').then((ok)=>{
				if(ok){
					$("#email").focus();
				}
			});
			return;
		}

		if(!checkValid.isEmailValid(email)){
			swal('<spring:message code="member.errMsg9" />').then((ok)=>{
				if(ok){
					$("#emailDupCheckKey").val(1);
					$("#email").focus();
				}
			});
			return;
		}

		var emailDupCheckKey = $("#emailDupCheckKey").val();

		if(!fn_isPrime(emailDupCheckKey)){
			swal('<spring:message code="member.errMsg12" />').then((ok)=>{
				if(ok){
					$("#email").focus();
				}
			});
			return;
		}

		$.ajax({
			type : "POST",
			url : "/base/getInsertUser.do",
			data : {"userId":userId,"userIdDupCheckKey":userIdDupCheckKey,"userPw":userPw,"conPw":conPw,"userName":userName,"zipcode":zipcode,"address":address,"addressDetail":addressDetail,"mobile":mobile,"mobileDupCheckKey":mobileDupCheckKey,"email":email,"emailDupCheckKey":emailDupCheckKey},
			dataType : 'json',
			success : function(res) {
				/* ■ 상태코드
				 * 700 : 정상
		    	 * 701 : 비정상 접근 - param null
		    	 * 702 : 필수값 없음
		    	 */
				if(res.statusCode == 700){
					swal('<spring:message code="system.msg16" />');
					fn_init();

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
		var userId = $("#userId").val();
		var userPw = $("#userPw").val();
		var conPw = $("#conPw").val();

		if(checkValid.isCheckValueVaild(userPw)){
			/* ■ 비밀번호 길이 체크 */
			if(!fn_checkPassword1(userPw)){
				swal('<spring:message code="login.errMsg20" />').then((ok)=>{
					if(ok){
						$("#userPw").focus();

					}
				});
				return;
			}

			/* ■ 비밀번호 복잡도 체크 */
			if(!fn_checkPassword2(userPw)){
				swal('<spring:message code="login.errMsg21" />').then((ok)=>{
					if(ok){
						$("#userPw").focus();
					}
				});
				return;
			}

			conPw = $("#conPw").val();

			if(!checkValid.isCheckValueVaild(conPw)){
				swal('<spring:message code="login.errMsg11" />').then((ok)=>{
					if(ok){
						$("#conPw").focus();
					}
				});
				return;
			}

			if(userPw != conPw){
				swal('<spring:message code="member.errMsg2" />').then((ok)=>{
					if(ok){
						$("#conPw").focus();
					}
				});
				return;
			}
		}

		var userName = $("#userName").val();

		if(!checkValid.isCheckValueVaild(userName)){
			swal('<spring:message code="login.errMsg16" />').then((ok)=>{
				if(ok){
					$("#userName").focus();
				}
			});
			return;
		}

		var zipcode = $("#zipcode").val();

		if(!checkValid.isCheckValueVaild(zipcode)){
			swal('<spring:message code="member.errMsg6" />').then((ok)=>{
				if(ok){
					$("#zipcode").focus();
				}
			});
			return;
		}

		var address = $("#address").val();

		if(!checkValid.isCheckValueVaild(address)){
			swal('<spring:message code="member.errMsg6" />').then((ok)=>{
				if(ok){
					$("#zipcode").focus();
				}
			});
			return;
		}

		var addressDetail = $("#addressDetail").val();

		if(!checkValid.isCheckValueVaild(addressDetail)){
			swal('<spring:message code="member.errMsg21" />').then((ok)=>{
				if(ok){
					$("#addressDetail").focus();
				}
			});
			return;
		}

		var mobile = $("#mobile").val();
		var email = $("#email").val();


		var rowId = $("#GRID_1").jqGrid('getGridParam','selrow');
		var curPage = $("#GRID_1").jqGrid('getGridParam', 'page');

		$.ajax({
			type : "POST",
			url : "/base/getUpdateUser.do",
			data : {"userId":userId,"userPw":userPw,"conPw":conPw,"userName":userName,"zipcode":zipcode,"address":address,"addressDetail":addressDetail,"mobile":mobile,"email":email},
			dataType : 'json',
			success : function(res) {
				/* ■ 상태코드
				 * 700 : 정상
		    	 * 701 : 비정상 접근 - param null
		    	 * 702 : 필수값 없음
		    	 */
				if(res.statusCode == 700){
					var searchUserName = $("#searchUserName").val();

					$.ajax({
						type : "POST",
						url : "/base/getUserList.do",
						data : {"searchUserName":searchUserName},
						dataType : 'json',
						success : function(res) {
							swal('<spring:message code="system.msg17" />');

							/* ■ 상태코드
							 * 700 : 정상
					    	 * 705 : 조회결과 없음
					    	 */
							if(res.statusCode == 700){
								fn_initJqGrid(res.data);
								fn_init();
							}else{
								console.log(res.statusCode);
								fn_initJqGrid([]);
								fn_init();
							}
						},
						error : function(request, status, error) {
							alert("status: " + request.status + ", error: " + error);
						}
					});
	   	    	}else{
	   	    		console.log(res.statusCode);
	   	    	}
			},
			error : function(request, status, error) {
				alert("status: " + request.status + ", error: " + error);
			}
		});
	}
}

var certPopObj = null;

function fn_certPopMobile(){
	if(certPopObj != null){
		certPopObj.close();
	}

	certPopObj = fn_cPopup('/user/popUserMobileModify.do', 'userId', $("#userId1").val(), 1, 670, 220);
}

function fn_certPopEmail(){
	if(certPopObj != null){
		certPopObj.close();
	}

	certPopObj = fn_cPopup('/user/popUserEmailModify.do', 'userId', $("#userId1").val(), 1, 670, 220);
}

function fn_isDupCheck(code){
	var url = "";
	if(code == 1){
		var userId = $("#userId").val();

		if(!checkValid.isCheckValueVaild(userId)){
			swal('<spring:message code="login.errMsg1" />').then((ok)=>{
				if(ok){
					$("#userId").focus();
				}
			});
			return;
		}

		/* ■ 아이디 길이 체크 */
		if(!fn_checkId(userId)){
			swal('<spring:message code="member.errMsg36" />').then((ok)=>{
				if(ok){
					$("#userId").focus();

				}
			});
			return;
		}

		$.ajax({
			type : "POST",
			url : "/getIsIdDupCheck.do",
			data : {"userId":userId},
			dataType : 'json',
			success : function(res) {
				/* ■ 상태코드
				 * 700 : 정상
		    	 * 701 : param null
		    	 * 702 : userId null
		    	 * 703 : is duplicate
		    	 */
				if(res.statusCode == 700){
					swal('<spring:message code="member.errMsg13" />').then((ok)=>{
						if(ok){
							$("#userIdDupCheckKey").val(res.data.userIdDupCheckKey);
						}
					});
				}else if(res.statusCode == 701){
					swal('<spring:message code="login.errMsg12" />').then((ok)=>{
						if(ok){
							$("#userIdDupCheckKey").val(1);
						}
					});
				}else if(res.statusCode == 702){
					swal('<spring:message code="login.errMsg12" />').then((ok)=>{
						if(ok){
							$("#userIdDupCheckKey").val(1);
						}
					});
				}else if(res.statusCode == 703){
					swal('<spring:message code="member.errMsg14" />').then((ok)=>{
						if(ok){
							$("#userIdDupCheckKey").val(1);
						}
					});
				}
			},
			error : function(request, status, error) {
				alert("status: " + request.status + ", error: " + error);
			}
		});
	}else if(code == 2){
		var mobile = $("#mobile").val();

		if(!checkValid.isCheckValueVaild(mobile)){
			swal('<spring:message code="login.errMsg17" />').then((ok)=>{
				if(ok){
					$("#mobile").focus();
				}
			});
			return;
		}

		if(!checkValid.isMobileValid(mobile)){
			swal('<spring:message code="login.errMsg18" />').then((ok)=>{
				if(ok){
					$("#mobile").focus();
					$("#mobileDupCheckKey").val(1);
				}
			});
			return;
		}

		$.ajax({
			type : "POST",
			url : "/getIsMobileDupCheck.do",
			data : {"mobile":mobile},
			dataType : 'json',
			success : function(res) {
				/* ■ 상태코드
				 * 700 : 정상
		    	 * 701 : param is null
		    	 * 702 : mobile is null
		    	 * 703 : is duplicate
		    	 */
				if(res.statusCode == 700){
					swal('<spring:message code="member.errMsg15" />').then((ok)=>{
						if(ok){
							$("#mobileDupCheckKey").val(res.data.mobileDupCheckKey);
						}
					});
				}else if(res.statusCode == 701){
					swal('<spring:message code="login.errMsg12" />').then((ok)=>{
						if(ok){
							$("#mobileDupCheckKey").val(1);
						}
					});
				}else if(res.statusCode == 702){
					swal('<spring:message code="login.errMsg12" />').then((ok)=>{
						if(ok){
							$("#mobileDupCheckKey").val(1);
						}
					});
				}else if(res.statusCode == 703){
					swal('<spring:message code="member.errMsg16" />').then((ok)=>{
						if(ok){
							$("#mobileDupCheckKey").val(1);
						}
					});
				}
			},
			error : function(request, status, error) {
				alert("status: " + request.status + ", error: " + error);
			}
		});
	}else if(code == 3){
		var email = $("#email").val();

		if(!checkValid.isCheckValueVaild(email)){
			swal('<spring:message code="member.errMsg8" />').then((ok)=>{
				if(ok){
					$("#email").focus();
				}
			});
			return;
		}

		if(!checkValid.isEmailValid(email)){
			swal('<spring:message code="member.errMsg9" />').then((ok)=>{
				if(ok){
					$("#emailDupCheckKey").val(1);
					$("#email").focus();
				}
			});
			return;
		}

		$.ajax({
			type : "POST",
			url : "/getIsEmailDupCheck.do",
			data : {"email":email},
			dataType : 'json',
			success : function(res) {
				/* ■ 상태코드
				 * 700 : 정상
		    	 * 701 : param is null
		    	 * 702 : email is null
		    	 * 703 : is duplicate
		    	 */
				if(res.statusCode == 700){
					swal('<spring:message code="member.errMsg17" />').then((ok)=>{
						if(ok){
							$("#emailDupCheckKey").val(res.data.emailDupCheckKey);
						}
					});
				}else if(res.statusCode == 701){
					swal('<spring:message code="login.errMsg12" />').then((ok)=>{
						if(ok){
							$("#emailDupCheckKey").val(1);
						}
					});
				}else if(res.statusCode == 702){
					swal('<spring:message code="login.errMsg12" />').then((ok)=>{
						if(ok){
							$("#emailDupCheckKey").val(1);
						}
					});
				}else if(res.statusCode == 703){
					swal('<spring:message code="member.errMsg18" />').then((ok)=>{
						if(ok){
							$("#emailDupCheckKey").val(1);
						}
					});
				}
			},
			error : function(request, status, error) {
				alert("status: " + request.status + ", error: " + error);
			}
		});
	}
}

$(document).ready(function() {
	fn_search();
});
</script>
</body>
</html>