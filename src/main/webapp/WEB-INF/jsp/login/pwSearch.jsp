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
						비밀번호 초기화
					</h5>

					<div class="input-group mb-3 valueGrp">
						<input type="text" id="userId" name="userId" class="form-control nondata" placeholder="아이디" maxlength="16" onkeypress="if(event.keyCode == 13){fn_pwSearch();}" />
					</div>
					<div class="input-group mb-3 valueGrp">
						<input type="text" id="mobile" name="mobile" class="form-control" placeholder="<spring:message code='login.mobile' />(ex.010-1234-5678)" maxlength="13" onkeyup="checkValid.inputPhoneNumber(this)" onkeypress="if(event.keyCode == 13){fn_pwSearch();}" />
					</div>

					<div class="input-group mb-3 certiGrp" style="display:none;">
						<input type="text" id="certificationNumber" name="certificationNumber" class="form-control custonf" placeholder="인증번호" maxlength="6" />
					</div>

					<div class="input-group mb-3 passGrp" style="display:none;">
						<input type="password" id="userPw" name="userPw" class="form-control nondata" placeholder="변경할 비밀번호" maxlength="20" onkeypress="if(event.keyCode == 13){fn_pwSearch();}" />
					</div>
					<div class="input-group mb-3 passGrp" style="display:none;">
						<input type="password" id="conPw" name="conPw" class="form-control nondata" placeholder="비밀번호 확인" maxlength="20" onkeypress="if(event.keyCode == 13){fn_pwSearch();}" />
					</div>

					<button class="btn btn-primary shadow-2 mb-4 valueGrp" onclick="fn_pwSearch()">인증번호발송</button>
					<button class="btn btn-primary shadow-2 mb-4 certiGrp" onclick="fn_confirmCerti()" style="display:none;">인증번호확인</button>
					<button class="btn btn-primary shadow-2 mb-4 passGrp" id="pwcBtn" onclick="fn_pwChange()" style="display:none;">변경</button>
					<button class="btn btn-primary shadow-2 mb-4" onclick="fn_createFormSubmit('/login.do', 'post')" id="loginBtn"><spring:message code='login.moveLoign' /></button>
					<button class="btn btn-primary shadow-2 mb-4" onclick="fn_moveLogin()" id="moveBtn" style="display:none;"><spring:message code='login.moveLoign' /></button>
				</div>
			</div>
		</div>
	</div>

	<script>
		function fn_pwSearch(){
			var userId = $("#userId").val();

			if(!fn_isCheckValueVaild(userId)){
				swal('아이디를 입력하지 않았습니다.').then((ok)=>{
					if(ok){
						$("#userId").focus();
					}
				});
				return;
			}

			var mobile = $("#mobile").val();

			if(!checkValid.isCheckValueVaild(mobile)){
				swal('휴대폰번호를 입력하지 않았습니다.').then((ok)=>{
					if(ok){
						$("#mobile").focus();
					}
				});

				return;
			}

			if(!checkValid.isMobileValid(mobile)){
				swal('휴대폰번호가 유효하지 않습니다.').then((ok)=>{
					if(ok){
						$("#mobile").focus();
					}
				});

				return;
			}

			$.ajax({
				type : "POST",
				url : "/getPwSearch.do",
				data : {"userId":userId, "mobile":mobile},
				dataType : 'json',
				success : function(res) {
					/* ■ 상태코드
					 * 700 : 정상
					 * 701 : param의 값 또는 각 항목의 값이 없음
					 * 702 : 해당정보로 조회된 결과가 없습니다.
					 */
					if(res.statusCode == 700){
						swal('인증번호가 발송 되었습니다.').then((ok)=>{
							if(ok){
								$("#moveBtn").css("display","none");
								$("#loginBtn").css("display","");
								$(".valueGrp").css("display","none");
								$(".certiGrp").css("display","");
								$(".passGrp").css("display","none");
							}
						});
					}else if(res.statusCode == 702){
						swal('해당정보로 조회된 결과가 없습니다.').then((ok)=>{
							if(ok){
								$("#moveBtn").css("display","none");
								$("#loginBtn").css("display","");
								$(".valueGrp").css("display","");
								$(".certiGrp").css("display","none");
								$(".passGrp").css("display","none");
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

		function fn_confirmCerti(){
			var userId = $("#userId").val();

			var certificationNumber = $("#certificationNumber").val();

			if(!checkValid.isCheckValueVaild(certificationNumber)){
				swal('인증번호를 입력하지 않았습니다.').then((ok)=>{
					if(ok){
						$("#certificationNumber").focus();
					}
				});

				return;
			}

			$.ajax({
				type : "POST",
				url : "/getPwcCertiConfirm.do",
				data : {"userId":userId, "certificationNumber":certificationNumber},
				dataType : 'json',
				success : function(res) {
			    	 /* ■ 상태코드
			 		 * 700 : 정상
			 		 * 701 : param null
			 		 * 702 : 필수 항목의 값이 없음
			 		 * 706 : 인증번호 불일치
			 		 */
					if(res.statusCode == 700){
						swal('확인 되었습니다.').then((ok)=>{
							if(ok){
								$("#moveBtn").css("display","none");
								$("#loginBtn").css("display","");
								$(".valueGrp").css("display","none");
								$(".certiGrp").css("display","none");
								$(".passGrp").css("display","");
							}
						});
					}else if(res.statusCode == 706){
						swal('인증번호가 일치하지 않습니다.').then((ok)=>{
							if(ok){
								$("#moveBtn").css("display","none");
								$("#loginBtn").css("display","");
								$(".valueGrp").css("display","none");
								$(".certiGrp").css("display","");
								$(".passGrp").css("display","none");
							}
						});
					}else{
						console.log("fn_confirmCerti status >> " + res.statusCode);
					}
				},
				error : function(request, status, error) {
					alert("status: " + request.status + ", error: " + error);
				}
			});
		}

		function fn_pwChange(){
			var userId = $("#userId").val();

			var userPw = $("#userPw").val();

			if(!checkValid.isCheckValueVaild(userPw)){
				swal('비밀번호를 입력하지 않았습니다.').then((ok)=>{
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
				swal('비밀번호확인을 입력하지 않았습니다.').then((ok)=>{
					if(ok){
						$("#conPw").focus();
					}
				});

				return;
			}

			if(userPw != conPw){
				swal('비밀번호가 일치하지 않습니다.').then((ok)=>{
					if(ok){
						$("#conPw").focus();
					}
				});

				return;
			}

			$.ajax({
				type : "POST",
				url : "/getPwcInit.do",
				data : {"userId":userId, "userPw":userPw, "conPw":conPw},
				dataType : 'json',
				success : function(res) {
					/* ■ 상태코드
					 * 700 : 정상
			    	 * 701 : 기타 - 비정상적인 접근
			    	 */
					if(res.statusCode == 700){
						swal('변경 되었습니다.',{closeOnClickOutside: false}).then((ok)=>{
							if(ok){
								fn_moveLogin();
							}
						});
					}else{
						console.log("getPwcInitStatus >> " + res.statusCode);
						$("#moveBtn").css("display","none");
						$("#loginBtn").css("display","");
						$(".valueGrp").css("display","");
						$(".certiGrp").css("display","none");
						$(".passGrp").css("display","none");
					}
				},
				error : function(request, status, error) {
					alert("status: " + request.status + ", error: " + error);
				}
			});
		}

		function fn_moveLogin(){
			var searchUserId = $("#userId").val();

			if(!checkValid.isCheckValueVaild(searchUserId)){
				swal('잘못된 접근입니다.').then((ok)=>{
					if(ok){
						$("#moveBtn").css("display","none");
						$("#loginBtn").css("display","");
						$(".valueGrp").css("display","");
						$(".certiGrp").css("display","none");
						$(".passGrp").css("display","none");
					}
				});
				return;
			}

			fn_createFormSubmit("/login.do", "post","","searchUserId",searchUserId,1);
		}
	</script>
</body>
</html>