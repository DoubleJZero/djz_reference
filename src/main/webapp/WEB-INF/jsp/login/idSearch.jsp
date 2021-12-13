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
				<div class="card-body text-center">
					<h5 class="mb-4">
						<spring:message code='login.idSearch' />
					</h5>

					<div class="input-group mb-3">
						<input type="text" id="userName" name="userName" class="form-control custokaef" placeholder="<spring:message code='search.name' />" maxlength="20" onkeypress="if(event.keyCode == 13){fn_idSearch();}" />
					</div>
					<div class="input-group mb-3">
						<input type="text" id="mobile" name="mobile" class="form-control" placeholder="<spring:message code='login.mobile' />(ex.010-1234-5678)" maxlength="13" onkeypress="if(event.keyCode == 13){fn_idSearch();}" onkeyup="checkValid.inputPhoneNumber(this)" />
					</div>

					<p class="mb-2 text-muted" id="viewSearchId" style="display:none;"><spring:message code='login.idSearchMsg1' />&nbsp;<span style="color: blue; font-weight: 600;" id="viewUserId"></span>&nbsp;<spring:message code='login.idSearchMsg2' /></p>
					<input type="hidden" id="searchUserId" name="searchUserId" maxlength="16" />
					<button class="btn btn-primary shadow-2 mb-4" onclick="fn_idSearch()" id="searchBtn"><spring:message code='button.lookup' /></button>
					<button class="btn btn-primary shadow-2 mb-4" onclick="fn_createFormSubmit('/login.do', 'post')" id="loginBtn"><spring:message code='login.moveLoign' /></button>
					<button class="btn btn-primary shadow-2 mb-4" onclick="fn_moveLogin()" id="moveBtn" style="display:none;"><spring:message code='login.moveLoign' /></button>
				</div>
			</div>
		</div>
	</div>

	<script>
		function fn_idSearch(){
			var userName = $("#userName").val();

			if(!checkValid.isCheckValueVaild(userName)){
				swal('<spring:message code="login.errMsg16" />').then((ok)=>{
					if(ok){
						$("#userName").focus();
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
					}
				});
				return;
			}

			$.ajax({
				type : "POST",
				url : "/getIdSearch.do",
				data : {"userName":userName, "mobile":mobile},
				dataType : 'json',
				success : function(res) {
					/* ■ 상태코드
					 * 700 : 정상
			    	 * 701 : 해당 아이디로 조회결과 없음
			    	 */
					if(res.statusCode == 700){
						$("#viewUserId").html(res.data.userId);
						$("#viewSearchId").css("display","");
						$("#moveBtn").css("display","");
						$("#searchBtn").css("display","none");
						$("#loginBtn").css("display","none");
						$("#searchUserId").val(res.data.userId);
						$("#userName").attr("disabled","disabled");
						$("#mobile").attr("disabled","disabled");
						$("#moveBtn").focus();
					}else if(res.statusCode == 701){
						swal('<spring:message code="login.errMsg19" />').then((ok)=>{
							if(ok){
								$("#viewSearchId").css("display","none");
								$("#moveBtn").css("display","none");
								$("#searchBtn").css("display","");
								$("#loginBtn").css("display","");
								$("#searchUserId").val("");
								$("#userName").focus();
							}
						});
					}
				},
				error : function(request, status, error) {
					alert("status: " + request.status + ", error: " + error);
				}
			});
		}

		function fn_moveLogin(){
			var searchUserId = $("#searchUserId").val();

			if(!fn_isCheckValueVaild(searchUserId)){
				swal('<spring:message code="login.errMsg12" />').then((ok)=>{
					if(ok){
						$("#viewSearchId").css("display","none");
						$("#moveBtn").css("display","none");
						$("#searchBtn").css("display","");
						$("#loginBtn").css("display","");
						$("#searchUserId").val("");
					}
				});
				return;
			}

			dynamicSubmit.createFormSubmit("/login.do", "post","","searchUserId",searchUserId,1);
		}
	</script>
</body>
</html>