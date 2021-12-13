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
						<spring:message code='login.password' />
					</h5>
					<div class="input-group mb-3">
						<input type="password" id="userPw" name="userPw" class="form-control custpf" placeholder="<spring:message code='login.curPassword' />" maxlength="20" onkeypress="if(event.keyCode == 13){fn_changePw();}" />
					</div>
					<div class="input-group mb-3">
						<input type="password" id="newPw" name="newPw" class="form-control custpf" placeholder="<spring:message code='login.newPassword' />" maxlength="20" onkeypress="if(event.keyCode == 13){fn_changePw();}" />
					</div>
					<div class="input-group mb-4">
						<input type="password" id="conPw" name="conPw" class="form-control custpf" placeholder="<spring:message code='login.conPassword' />" maxlength="20" onkeypress="if(event.keyCode == 13){fn_changePw();}" />
					</div>
					<button class="btn btn-primary shadow-2 mb-4" onclick="fn_changePw()"><spring:message code='login.chaPassword' /></button>
					<button class="btn btn-primary shadow-2 mb-4" onclick="fn_createFormSubmit('/login.do', 'post')" id="loginBtn"><spring:message code='login.moveLoign' /></button>
					<button class="btn btn-primary shadow-2 mb-4" onclick="fn_moveLogin()" id="moveBtn" style="display:none;"><spring:message code='login.moveLoign' /></button>
				</div>
			</div>
		</div>
	</div>

	<script>
		function fn_changePw(){
			var userId = "<c:out value='${userId}'/>";
			var userPw = $("#userPw").val();

			if(!checkValid.isCheckValueVaild(userPw)){
				swal('<spring:message code="login.errMsg2" />').then((ok)=>{
					if(ok){
						$("#userPw").focus();
					}
				});
				return;
			}

			var newPw = $("#newPw").val();

			if(!checkValid.isCheckValueVaild(newPw)){
				swal('<spring:message code="login.errMsg10" />').then((ok)=>{
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

			if(!checkValid.isCheckValueVaild(conPw)){
				swal('<spring:message code="login.errMsg10" />').then((ok)=>{
					if(ok){
						$("#conPw").focus();
					}
				});
				return;
			}

			$.ajax({
				type : "POST",
				url : "/getChangePassword.do",
				data : {"userId":userId, "userPw":userPw, "newPw":newPw, "conPw":conPw},
				dataType : 'json',
				success : function(data) {
			    	 /* ■ 상태코드
			 		 * 700 : 정상
			     	 * 705 : 해당 아이디로 조회결과 없음
			     	 * 706 : 비밀번호 불일치
			     	 * 707 : 기존비밀번호랑 동일
			     	 * 708 : 새로운 비밀번호랑 비밀번호 확인이랑 불일치
			     	 */
					if(data.statusCode == 700){
						swal('<spring:message code="login.errMsg13" />\n<spring:message code="login.errMsg14" />',{closeOnClickOutside: false}).then((ok)=>{
							if(ok){
								dynamicSubmit.createFormSubmit("/login.do", "post");
							}
						});
					}else if(data.statusCode == 705){
						swal('<spring:message code="login.errMsg3" />');
					}else if(data.statusCode == 706){
						swal('<spring:message code="login.errMsg4" />').then((ok)=>{
							if(ok){
								$("#userPw").focus();
							}
						});
					}else if(data.statusCode == 707){
						swal('<spring:message code="login.errMsg8" />').then((ok)=>{
							if(ok){
								$("#newPw").focus();
							}
						});
					}else if(data.statusCode == 708){
						swal('<spring:message code="login.errMsg9" />').then((ok)=>{
							if(ok){
								$("#conPw").focus();
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
			dynamicSubmit.createFormSubmit("/login.do", "post","","searchUserId","",1);
		}
	</script>
</body>
</html>