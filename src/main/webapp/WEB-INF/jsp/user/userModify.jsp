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

                            <div class="rows">
								<div class="col-sm-12">
									<div class="card">
										<div class="card-header">
				                            <h5><spring:message code="user.userModify" /></h5>
				                        </div>

										<div class="card-body text-center">
											<div class="alert alert-danger" role="alert">
												<p><spring:message code='member.noticeMsg3' /></p>
											</div>

						                    <div class="input-group mb-1" style="background: #fff">
												<label for="userId" class="col-sm-3 col-form-label"><spring:message code='login.userId' /></label>
												<input type="text" id="userId" name="userId" class="form-control col-sm-9 custokaef" maxlength="16" readonly="readonly" value="<c:out value='${info.userId}'/>" />
											</div>

											<div class="input-group mb-1" style="background: #fff">
												<label for="userPw" class="col-sm-3 col-form-label"><spring:message code='login.password' />&nbsp;<span style="color:red;">*</span></label>
												<input type="password" id="userPw" name="userPw" class="form-control col-sm-6 custpf" placeholder="<spring:message code='member.placeholderMsg2' />" maxlength="20" />
												<div class="checkbox checkbox-primary checkbox-fill d-inline">
						                            <input type="checkbox" id="pwModifyYn" name="pwModifyYn" value="Y" />
						                            <label for="pwModifyYn" class="cr"><spring:message code='user.pwModify' /></label>
						                        </div>
											</div>

											<div class="input-group mb-1" style="background: #fff">
												<label for="newPw" class="col-sm-3 col-form-label"><spring:message code='user.newPw' /></label>
												<input type="password" id="newPw" name="newPw" class="form-control col-sm-9 custpf" placeholder="<spring:message code='member.placeholderMsg2' />" maxlength="20" disabled="disabled" />
											</div>

											<div class="input-group mb-1" style="background: #fff">
												<label for="conPw" class="col-sm-3 col-form-label"><spring:message code='user.newConPw' /></label>
												<input type="password" id="conPw" name="conPw" class="form-control col-sm-9 custpf" placeholder="<spring:message code='member.placeholderMsg2' />" maxlength="20" disabled="disabled" />
											</div>

											<div class="input-group mb-1" style="background: #fff">
												<label for="userName" class="col-sm-3 col-form-label"><spring:message code='search.name' />&nbsp;<span style="color:red;">*</span></label>
												<input type="text" id="userName" name="userName" class="form-control col-sm-9 custokaef" placeholder="<spring:message code='member.placeholderMsg3' />" maxlength="30" value="<c:out value='${info.userName}'/>" />
											</div>

											<div class="input-group mb-1" style="background: #fff">
												<label for="zipcodeBtn" class="col-sm-3 col-form-label"><spring:message code='member.zipcode' />&nbsp;<span style="color:red;">*</span></label>
												<input type="text" id="zipcode" name="zipcode" class="form-control col-sm-9 custonf" maxlength="6" readonly="readonly" value="<c:out value='${info.zipcode}'/>" />
												<div class="input-group-append">
                            						<button class="btn btn-primary" type="button" onclick="fn_getAddressPop('zipcode','address')" id="zipcodeBtn"><i class="fab fa-searchengin"></i></button>
						                        </div>
											</div>

											<div class="input-group mb-1" style="background: #fff">
												<label for="address" class="col-sm-3 col-form-label"><spring:message code='member.address' />&nbsp;<span style="color:red;">*</span></label>
												<input type="text" id="address" name="address" class="form-control col-sm-9" maxlength="120" readonly="readonly" value="<c:out value='${info.address}'/>" />
											</div>

											<div class="input-group mb-1" style="background: #fff">
												<label for="addressDetail" class="col-sm-3 col-form-label"><spring:message code='member.addressDetail' />&nbsp;<span style="color:red;">*</span></label>
												<input type="text" id="addressDetail" name="addressDetail" class="form-control col-sm-9 custokaenf" placeholder="<spring:message code='member.placeholderMsg4' />" maxlength="50" value="<c:out value='${info.addressDetail}'/>" />
											</div>

											<div class="input-group mb-1" style="background: #fff">
												<label for="mobile" class="col-sm-3 col-form-label"><spring:message code='login.mobile' />&nbsp;<span style="color:red;">*</span></label>
												<input type="text" id="mobile" name="mobile" class="form-control col-sm-6" placeholder="###-####-####" maxlength="13" value="<c:out value='${info.mobile}'/>" readonly="readonly" />
												<div class="input-group-append">
						                            <button class="btn btn-primary" type="button" onclick="fn_certPopMobile()">변경</button>
						                        </div>
						                        <div class="checkbox checkbox-primary checkbox-fill d-inline">
						                            <input type="checkbox" id="smsYn" name="smsYn" <c:if test='${info.smsYn eq "Y"}'>checked</c:if> value="Y" />
						                            <label for="smsYn" class="cr"><spring:message code='member.smsYn' /></label>
						                        </div>
											</div>

											<div class="input-group mb-3" style="background: #fff">
												<label for="email" class="col-sm-3 col-form-label"><spring:message code='member.email' />&nbsp;<span style="color:red;">*</span></label>
												<input type="text" id="email" name="email" class="form-control col-sm-6 custoemf" placeholder="abc123@abcde.com" maxlength="35" value="<c:out value='${info.email}'/>" readonly="readonly" />
												<div class="input-group-append">
						                            <button class="btn btn-primary" type="button" onclick="fn_certPopEmail()">변경</button>
						                        </div>
						                        <div class="checkbox checkbox-primary checkbox-fill d-inline">
						                            <input type="checkbox" id="emailYn" name="emailYn" <c:if test='${info.emailYn eq "Y"}'>checked</c:if> value="Y" />
						                            <label for="emailYn" class="cr"><spring:message code='member.emailYn' /></label>
						                        </div>
											</div>

											<button class="btn btn-primary shadow-2" onclick="fn_getUserModify()" id="searchBtn"><spring:message code='button.modify' /></button>
					                    </div>
				                    </div>
								</div>

								<div class="col-sm-12">
									<div class="card">
										<div class="card-header">
				                            <h5><spring:message code="member.headertext2" /></h5>
				                        </div>

										<div class="card-body">
											<form id="resumeForm">
												<input type="hidden" name="userId" value="<c:out value='${info.userId}'/>" />

												<%-- [S] 첨부파일 공통 영역 --%>
												<div class="input-group input_file_box mb-2" id="input_file_box_target">
													<input type="text" class="upload_namefile form-control" value="<spring:message code="member.placeholderMsg5" />" readonly="readonly" onclick="fn_fileUploaderLabelClick()" />
													<div class="input-group-append">
							                            <button class="btn btn-primary" type="button" onclick="fn_fileUploaderLabelClick()"><spring:message code='member.fileSelect' /></button>
							                        </div>
													<label id="fileUploaderLabel" for="fileUploader" class="file_box_label"></label>
													<input name="file_1" id="fileUploader" type="file" />
												</div>

												<div class="inp_file_sec">
												    <div id="fileList" class="file_list_box"></div>
												</div>
												<%-- [E] 첨부파일 공통 영역 --%>
				                            </form>

				                            <%-- [S] 첨부파일 공통 영역 --%>
				                            <div id="displayFile"></div>
				                            <%-- [E] 첨부파일 공통 영역 --%>
										</div>

										<div class="mb-4" style="text-align: center;">
											<button class="btn btn-primary shadow-2" onclick="fn_getInsertIntr()"><spring:message code='member.intrReg' /></button>
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
function fn_getUserModify(){
	var userPw = $("#userPw").val();

	if(!fn_isCheckNumValueVaild(userPw) || userPw == ""){
		swal('<spring:message code="login.errMsg2" />').then((ok)=>{
			if(ok){
				$("#userPw").focus();
			}
		});
		return;
	}

	if($("input:checkbox[id='pwModifyYn']").is(":checked")){
		var newPw = $("#newPw").val();

		if(!fn_isCheckNumValueVaild(newPw) || newPw == ""){
			swal('<spring:message code="login.errMsg2" />').then((ok)=>{
				if(ok){
					$("#newPw").focus();
				}
			});
			return;
		}

		/* ■ 비밀번호 길이 체크 */
		if(!fn_checkPassword1(newPw)){
			swal('<spring:message code="login.errMsg20" />').then((ok)=>{
				if(ok){
					$("#newPw").focus();

				}
			});
			return;
		}

		/* ■ 비밀번호 복잡도 체크 */
		if(!fn_checkPassword2(newPw)){
			swal('<spring:message code="login.errMsg21" />').then((ok)=>{
				if(ok){
					$("#newPw").focus();
				}
			});
			return;
		}

		var conPw = $("#conPw").val();

		if(!fn_isCheckNumValueVaild(conPw) || conPw == ""){
			swal('<spring:message code="login.errMsg11" />').then((ok)=>{
				if(ok){
					$("#conPw").focus();
				}
			});
			return;
		}

		if(newPw != conPw){
			swal('<spring:message code="member.errMsg2" />').then((ok)=>{
				if(ok){
					$("#conPw").focus();
				}
			});
			return;
		}
	}

	var userName = $("#userName").val();

	if(!fn_isCheckValueVaild(userName)){
		swal('<spring:message code="login.errMsg16" />').then((ok)=>{
			if(ok){
				$("#userName").focus();
			}
		});
		return;
	}

	var zipcode = $("#zipcode").val();

	if(!fn_isCheckNumValueVaild(zipcode) || zipcode == ""){
		swal('<spring:message code="member.errMsg6" />').then((ok)=>{
			if(ok){
				$("#zipcode").focus();
			}
		});
		return;
	}

	var address = $("#address").val();

	if(!fn_isCheckNumValueVaild(address) || address == ""){
		swal('<spring:message code="member.errMsg6" />').then((ok)=>{
			if(ok){
				$("#zipcode").focus();
			}
		});
		return;
	}

	var addressDetail = $("#addressDetail").val();

	if(!fn_isCheckNumValueVaild(addressDetail) || addressDetail == ""){
		swal('<spring:message code="member.errMsg21" />').then((ok)=>{
			if(ok){
				$("#addressDetail").focus();
			}
		});
		return;
	}

	swal({
		title: '<spring:message code="button.modify" />',
        text: '<spring:message code="user.errMsg1" />',
        icon: "warning",
        buttons: ['<spring:message code="button.cancel" />','<spring:message code="button.confirm" />'],
        dangerMode: true,
    })
    .then((willDelete) => {
        if (willDelete) {
        	$.ajax({
        		type : "POST",
        		url : "/user/getUserModify.do",
        		data : fn_serialize(),
        		async: false,
        		dataType : 'json',
        		success : function(data) {
        	    	/* ■ 상태코드
        	 		 * 700 : 정상
        	     	 * 701 : params의 값이 없음. 비정상 접근
        	     	 * 702 : 필수항목 유효하지 않음.
        	     	 * 706 : 비밀번호 불일치
        	     	 * 707 : 기존비밀번호와 동일
        	     	 */
        			if(data.statusCode == 700){
        				swal('<spring:message code="member.errMsg29" />').then((ok)=>{
        					if(ok){
        						fn_createFormSubmit('/user/userModify.do', 'post');
        					}
        				});
        			}else if(data.statusCode == 706){
        				swal('<spring:message code="login.errMsg4" />');
        				return;
        			}else if(data.statusCode == 707){
        				swal('<spring:message code="login.errMsg8" />');
        				return;
        			}else {
        				console.log("status :: " + data.statusCode);
        				return;
        			}
        		},
        		error : function(request, status, error) {
        			alert("status: " + request.status + ", error: " + error);
        		}
        	});
        }
    });
}

function fn_getInsertIntr(){
	/* ■ 파일 최대 등록 갯수 */
	var maximum = 1;

	/* ■ 파일 최대 등록 갯수 초과 여부 */
	if(fn_isMaximumOverFileCnt(maximum,'input_file_box_target')){
		swal('<spring:message code="member.errMsg25" arguments="1" />');

		return;
	}

	/* ■ 업로드 파일 선택여부 */
	if(fn_isNotSelectedFile()){
		swal('<spring:message code="member.errMsg27" />').then((ok)=>{
			if(ok){
				$("#fileUploader").focus();
			}
		});

	    return;
	}

	var formData = new FormData($("#resumeForm")[0]);

	$.ajax({
		url: "/user/getInsertIntr.do",
		processData: false,
		contentType: false,
		data: formData,
		type: 'POST',
		dataType : 'json',
		success: function(res) {
	    	/* ■ 상태코드
	 		 * 700 : 정상
	     	 * 701 : params의 값이 없음. 비정상 접근
	     	 * 702 : userId 미확인
	     	 * 706 : 첨부파일 없음.
	     	 */
			if(res.statusCode == 700){
				swal('<spring:message code="member.errMsg26" />').then((ok)=>{
					if(ok){
						$("#fileList").empty();

						/* ■ 업로드 파일 조회 후 displayFile div에 표시(delete 기능 있음) */
						fn_updateFileInfoAjax('displayFile', res.data.atchflGrpId,'input_file_box_target');
					}
				});
			}else if(res.statusCode == 706){
				swal('<spring:message code="member.errMsg27" />').then((ok)=>{
					if(ok){
						$("#fileUploader").focus();
					}
				});
			}else{
				console.log("fn_getInsertIntr >> " + res.statusCode);
			}
		},
		error:function(request, status, error) {
			alert("status: " + request.status + ", error: " + error);
		}
	});
}

function fn_getIntr(){
	var userId = "<c:out value='${info.userId}'/>";

	$.ajax({
		type : "POST",
		url : "/user/getIntr.do",
		data : {"userId":userId},
		dataType : 'json',
		async: false,
		success : function(res) {
	    	/* ■ 상태코드
	 		 * 700 : 정상
	     	 * 701 : param null
	     	 * 702 : userId 미확인
	     	 * 705 : 데이터 없음
	     	 */
			if(res.statusCode == 700){
				if(fn_isCheckValueVaild(res.data.atchflGrpId)){
					fn_updateFileInfoAjax('displayFile', res.data.atchflGrpId,'input_file_box_target');
				}
			}else{
				console.log("status :: " + res.statusCode);
			}
		},
		error : function(request, status, error) {
			alert("status: " + request.status + ", error: " + error);
		}
	});
}

var certPopObj = null;

function fn_certPopMobile(){
	if(certPopObj != null){
		certPopObj.close();
	}

	certPopObj = fn_cPopup('/user/popUserMobileModify.do', 'userId', $("#userId").val(), 1, 670, 320);
}

function fn_certPopEmail(){
	if(certPopObj != null){
		certPopObj.close();
	}

	certPopObj = fn_cPopup('/user/popUserEmailModify.do', 'userId', $("#userId").val(), 1, 670, 320);
}

$(document).ready(function() {
	$('#pwModifyYn').click(function () {
		if($("input:checkbox[id='pwModifyYn']").is(":checked")){
			$('#newPw').attr("disabled", false);
			$('#conPw').attr("disabled", false);
		}else{
			$('#newPw').val('');
			$('#conPw').val('');
			$('#newPw').attr("disabled", true);
			$('#conPw').attr("disabled", true);
		}
    });

	fn_getIntr();
});

/* ■ 자기소개서 */
var multi_selector = new MultiSelector(document.getElementById('fileList'), 1);
multi_selector.addElement(document.getElementById('fileUploader'));
</script>
</body>
</html>