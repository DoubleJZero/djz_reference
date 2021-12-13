<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp"%>
</head>
<body>
	<div class="auth-wrapper">
		<div class="auth-content subscribe">
			<div class="auth-bg">
				<span class="r"></span> <span class="r s"></span> <span class="r s"></span>
				<span class="r"></span>
			</div>
			<div class="card">
				<div class="card-body text-center">
					<h5 class="mb-4">
						<spring:message code='login.join' />
					</h5>

					<div class="alert alert-danger" role="alert">
						<p><spring:message code='member.noticeMsg3' /></p>
					</div>

					<div class="input-group mb-1">
						<label for="userId" class="col-sm-3 col-form-label"><spring:message code='login.userId' />&nbsp;<span style="color:red;">*</span></label>
						<input type="text" id="userId" name="userId" class="form-control col-sm-9 custoenuhf" placeholder="<spring:message code='member.placeholderMsg1' />" maxlength="16" onkeypress="if(event.keyCode == 13){fn_joinMembership();}" />
						<input type="hidden" id="userIdDupCheckKey" name="userIdDupCheckKey" maxlength="11" />
						<input type="hidden" id="insertFlag" value="N" />
						<div class="input-group-append">
                            <button class="btn btn-primary" type="button" onclick="fn_isDupCheck(1)"><i class="fab fa-searchengin"></i><spring:message code='member.dupCheck' /></button>
                        </div>
					</div>

					<div class="input-group mb-1">
						<label for="userPw" class="col-sm-3 col-form-label"><spring:message code='login.password' />&nbsp;<span style="color:red;">*</span></label>
						<input type="password" id="userPw" name="userPw" class="form-control col-sm-9 custpf" placeholder="<spring:message code='member.placeholderMsg2' />" maxlength="20" onkeypress="if(event.keyCode == 13){fn_joinMembership();}" />
					</div>

					<div class="input-group mb-1">
						<label for="conPw" class="col-sm-3 col-form-label"><spring:message code='login.conPassword' />&nbsp;<span style="color:red;">*</span></label>
						<input type="password" id="conPw" name="conPw" class="form-control col-sm-9 custpf" placeholder="<spring:message code='member.placeholderMsg2' />" maxlength="20" onkeypress="if(event.keyCode == 13){fn_joinMembership();}" />
					</div>

					<div class="input-group mb-1">
						<label for="userName" class="col-sm-3 col-form-label"><spring:message code='search.name' />&nbsp;<span style="color:red;">*</span></label>
						<input type="text" id="userName" name="userName" class="form-control col-sm-9 custokaef" placeholder="<spring:message code='member.placeholderMsg3' />" maxlength="30" onkeypress="if(event.keyCode == 13){fn_joinMembership();}" />
					</div>

					<div class="input-group mb-1">
						<label for="zipcodeBtn" class="col-sm-3 col-form-label"><spring:message code='member.zipcode' />&nbsp;<span style="color:red;">*</span></label>
						<input type="text" id="zipcode" name="zipcode" class="form-control col-sm-9 custonf" maxlength="6" readonly="readonly" />
						<div class="input-group-append">
                            <button class="btn btn-primary" type="button" onclick="fn_getAddressPop('zipcode','address')" id="zipcodeBtn"><i class="fab fa-searchengin"></i></button>
                        </div>
					</div>

					<div class="input-group mb-1">
						<label for="address" class="col-sm-3 col-form-label"><spring:message code='member.address' />&nbsp;<span style="color:red;">*</span></label>
						<input type="text" id="address" name="address" class="form-control col-sm-9" maxlength="120" readonly="readonly" />
					</div>

					<div class="input-group mb-1">
						<label for="addressDetail" class="col-sm-3 col-form-label"><spring:message code='member.addressDetail' />&nbsp;<span style="color:red;">*</span></label>
						<input type="text" id="addressDetail" name="addressDetail" class="form-control col-sm-9 custascf" maxlength="50" onkeypress="if(event.keyCode == 13){fn_joinMembership();}" />
					</div>

					<div class="input-group mb-1">
						<label for="mobile" class="col-sm-3 col-form-label"><spring:message code='login.mobile' />&nbsp;<span style="color:red;">*</span></label>
						<input type="text" id="mobile" name="mobile" class="form-control col-sm-6" placeholder="###-####-####" maxlength="13" onkeypress="if(event.keyCode == 13){fn_joinMembership();}" onkeyup="checkValid.inputPhoneNumber(this)" />
						<input type="hidden" id="mobileDupCheckKey" name="mobileDupCheckKey" maxlength="11" />
						<div class="input-group-append">
                            <button class="btn btn-primary" type="button" onclick="fn_isDupCheck(2)"><i class="fab fa-searchengin"></i><spring:message code='member.dupCheck' /></button>
                        </div>
                        <div class="checkbox checkbox-primary checkbox-fill d-inline">
                            <input type="checkbox" id="smsYn" name="smsYn" value="Y" />
                            <label for="smsYn" class="cr"><spring:message code='member.smsYn' /></label>
                        </div>
					</div>

					<div class="input-group mb-4">
						<label for="email" class="col-sm-3 col-form-label"><spring:message code='member.email' />&nbsp;<span style="color:red;">*</span></label>
						<input type="text" id="email" name="email" class="form-control col-sm-6 custoemf" placeholder="abc123@abcde.com" maxlength="35" onkeypress="if(event.keyCode == 13){fn_joinMembership();}" />
						<input type="hidden" id="emailDupCheckKey" name="emailDupCheckKey" maxlength="11" />
						<div class="input-group-append">
                            <button class="btn btn-primary" type="button" onclick="fn_isDupCheck(3)"><i class="fab fa-searchengin"></i><spring:message code='member.dupCheck' /></button>
                        </div>
                        <div class="checkbox checkbox-primary checkbox-fill d-inline">
                            <input type="checkbox" id="emailYn" name="emailYn" value="Y" />
                            <label for="emailYn" class="cr"><spring:message code='member.emailYn' /></label>
                        </div>
					</div>

					<button class="btn btn-primary shadow-2" onclick="fn_joinMembership()" id="searchBtn"><spring:message code='button.create' /></button>
					<button class="btn btn-primary shadow-2" onclick="dynamicSubmit.createFormSubmit('/login.do', 'post')"><spring:message code='login.moveLoign' /></button>
				</div>
			</div>
		</div>
	</div>
	<script>
		function fn_joinMembership(){
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

			swal({
				title: '<spring:message code="login.join" />',
		        text: '<spring:message code="member.msg3" />',
		        icon: "warning",
		        buttons: ['<spring:message code="button.cancel" />','<spring:message code="button.confirm" />'],
		        dangerMode: true,
		    })
		    .then((willDelete) => {
		        if (willDelete) {
		        	$.ajax({
						type : "POST",
						url : "/getJoinMembership.do",
						data : fn_serialize(),
						dataType : 'json',
						success : function(res) {
							/* ■ 상태코드
							 * 700 : 정상
					    	 * 701 : params의 값이 없음. 비정상 접근
					    	 * 702 : 필수항목 유효하지 않음.
					    	 * 706 : 중복체크 key값이 유효하지 않음.
					    	 */
							if(res.statusCode == 700){
								swal('회원가입 되었습니다.',{closeOnClickOutside: false}).then((ok)=>{
									if(ok){
										dynamicSubmit.createFormSubmit('/login.do', 'post');
									}
								});
							}else if(res.statusCode == 706){
								swal('<spring:message code="member.errMsg23" />');
								return;
							}else{
								console.log("joinMembership :: " + res.statusCode);
								return;
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

	</script>
</body>
</html>