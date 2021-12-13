<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp"%>
</head>
<body>
	<div class="auth-wrapper">
		<div class="auth-content">
			<div class="auth-bg">
				<span class="r"></span> <span class="r s"></span> <span class="r s"></span>
				<span class="r"></span>
			</div>
			<div class="card">
				<div class="card-header">
					<div class="card-header-right">
						<a href="javascript:fn_changeLang('ko');">ko</a>|
						<a href="javascript:fn_changeLang('en');">en</a>
					</div>
				</div>

				<div class="card-body text-center">
					<div class="mb-4">
						<i class="feather icon-unlock auth-icon"></i>
					</div>
					<h3 class="mb-4">
						<spring:message code='login.login' />
					</h3>
					<div class="input-group mb-3">
						<input type="text" id="userId" class="form-control custoenuhf" placeholder="<spring:message code='login.userId' />" value="<c:out value='${searchUserId}'/>" maxlength="16" onkeypress="if(event.keyCode == 13){fn_actionLogin();}" />
					</div>

					<div class="input-group mb-4">
						<input type="password" id="userPw" class="form-control custpf" placeholder="<spring:message code='login.password' />" maxlength="20" onkeypress="if(event.keyCode == 13){fn_actionLogin();}" />
					</div>

					<button class="btn btn-primary shadow-2 mb-4" onclick="fn_actionLogin()" id="loginBtn"><spring:message code='login.login' /></button>

					<p class="mb-2 text-muted">
						<a href="javascript:void(0);" onclick="fn_join()"><spring:message code='login.join' /></a>
						&nbsp;&nbsp;|&nbsp;&nbsp;
						<a href="javascript:void(0);" onclick="fn_idSearch()"><spring:message code='login.idSearch' /></a>
						&nbsp;&nbsp;|&nbsp;&nbsp;
						<a href="javascript:void(0);" onclick="fn_pwSearch()"><spring:message code='login.pwSearch' /></a>
					</p>
				</div>
			</div>
		</div>
	</div>
</body>
<script>
	function fn_actionLogin(){
		var userId = $("#userId").val();
		var userPw = $("#userPw").val();

		if(!checkValid.isCheckValueVaild(userId)){
			swal('<spring:message code="login.errMsg1" />').then((ok)=>{
				if(ok){
					$("#userId").focus();
				}
			});

			return;
		}

		if(!checkValid.isCheckValueVaild(userPw)){
			swal('<spring:message code="login.errMsg2" />').then((ok)=>{
				if(ok){
					$("#userPw").focus();
				}
			});

			return;
		}

		userId = userId.replace(/\s/gi, "");

		$.ajax({
			type : "POST",
			url : "/loginValidation.do",
			data : {"userId":userId, "userPw":userPw},
			dataType : 'json',
			success : function(data) {
				/* ■ 상태코드
				 * 700 : 정상
		    	 * 705 : 해당 아이디로 조회결과 없음
		    	 * 706 : 비밀번호 불일치
		    	 * 707 : 비밀번호 변경 후 12개월 경과
		    	 */
				if(data.statusCode == 700){
					$.ajax({
						type : "POST",
						url : "/dupLoginCheck.do",
						data : {"userId":userId, "userPw":userPw},
						dataType : 'text',
						success : function(data2) {
							if(data2.status == "Y") {
								/* ■ confirm
								 * 타이틀이 필요없을 경우 삭제
								 */
								swal({
									title: '<spring:message code="login.connecting" />',
					                text: '<spring:message code="login.dupMsg1" />\n\r<spring:message code="login.dupMsg2" />',
					                icon: "warning",
					                buttons: ['<spring:message code="button.cancel" />','<spring:message code="button.confirm" />'],
					                dangerMode: true,
					            })
					            .then((willDelete) => {
					                if (willDelete) {
					                	dynamicSubmit.createFormSubmit("/actionLogin.do", "post", "", "userId,userPw", userId+","+userPw, 2);
					                }
					            });
							}else{
								dynamicSubmit.createFormSubmit("/actionLogin.do", "post", "", "userId,userPw", userId+","+userPw, 2);
							}
						},
						error : function(request, status, error) {
							alert("status: " + request.status + ", error: " + error);
						}
					});
				}else if(data.statusCode == 705){
					swal('<spring:message code="login.errMsg3" />').then((ok)=>{
						if(ok){
							$("#userId").focus();
						}
					});
				}else if(data.statusCode == 706){
					swal('<spring:message code="login.errMsg4" />').then((ok)=>{
						if(ok){
							$("#userPw").focus();
						}
					});
				}else if(data.statusCode == 707){
					swal('<spring:message code="login.errMsg7" />').then((ok)=>{
						if(ok){
							dynamicSubmit.createFormSubmit("/pwdChange.do", "post","","userId",userId,1);
						}
					});
				}
			},
			error : function(request, status, error) {
				alert("status: " + request.status + ", error: " + error);
			}
		});
	}

	function fn_join(){
		dynamicSubmit.createFormSubmit("/agreement.do", "post");
	}

	function fn_idSearch(){
		dynamicSubmit.createFormSubmit("/idSearch.do", "post");
	}

	function fn_pwSearch(){
		dynamicSubmit.createFormSubmit("/pwSearch.do", "post");
	}

	'<c:if test="${!empty statusCode and statusCode eq 888}">'
	$(function(){
		swal('<spring:message code="login.errMsg12" />').then((ok)=>{
			if(ok){
				$("#userId").focus();
			}
		});
	});
	'</c:if>'

	'<c:if test="${!empty statusCode and statusCode eq 889}">'
	$(function(){
		swal('<spring:message code="login.errMsg22" />').then((ok)=>{
			if(ok){
				$("#userId").focus();
			}
		});
	});
	'</c:if>'

	'<c:if test="${!empty searchUserId}">'
	$(function(){
		$("#userPw").focus();
	});
	'</c:if>'
</script>
</html>
