<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp"%>
</head>
<body>
	<div class="auth-wrapper">
		<div class="auth-content subscribe">
				<div class="col-sm-12">
					<div class="card">
						<div class="card-header">
                            <h5>이메일 변경</h5>
                        </div>

						<div class="card-block">
		                	<input type="hidden" id="userId" value="<c:out value='${info.userId}'/>" />

		                	<div class="input-group mb-4 valueDiv">
								<label for="email" class="col-sm-3 col-form-label">이메일&nbsp;<span style="color:red;">*</span></label>
								<input type="text" id="email" name="email" class="form-control col-sm-9 custoemf" maxlength="35" />
								<div class="input-group-append">
		                            <button class="btn btn-primary" type="button" onclick="fn_createCertiNum()">인증번호 발송</button>
		                        </div>
							</div>

							<div class="input-group mb-4 certiNumDiv" style="display:none;">
								<label for="certificationNumber" class="col-sm-3 col-form-label">인증번호&nbsp;<span style="color:red;">*</span></label>
								<input type="text" id="certificationNumber" name="certificationNumber" class="form-control col-sm-9 custonf" maxlength="6" />
							</div>

							<div class="mb-1 valueDiv" style="text-align: center;">
		                    	<button class="btn btn-dark" onclick="window.close()"><spring:message code='button.close' /></button>
		                    </div>

		                    <div class="mb-1 certiNumDiv" style="text-align: center; display:none;">
		                    	<button class="btn btn-primary" onclick="fn_checkCertiNum()">확인</button>
		                    	<button class="btn btn-dark" onclick="window.close()"><spring:message code='button.close' /></button>
		                    </div>
	                    </div>
                    </div>
				</div>

		</div>
	</div>

	<script>
		function fn_createCertiNum(){
			var email = $("#email").val();

			if(!checkValid.isCheckValueVaild(email)){
				swal('이메일을 입력하지 않았습니다.').then((ok)=>{
					if(ok){
						$("#email").focus();
					}
				});

				return;
			}

			if(!checkValid.isEmailValid(email)){
				swal('이메일이 유효하지 않습니다.').then((ok)=>{
					if(ok){
						$("#email").focus();
					}
				});

				return;
			}

			var userId = $("#userId").val();

			$.ajax({
				url: "/user/getCreateCertiEmailNum.do",
				data: {"userId":userId,"email":email},
				type: 'POST',
				dataType : 'json',
				success: function(data) {
					/* ■ 상태코드
					 * 700 : 정상
			    	 * 701 : param의 값 또는 각 항목의 값이 없음
			    	 * 702 : 이미 존재하는 이메일
			    	 */
					if(data.statusCode == 700){
						swal('인증번호가 발송 되었습니다.').then((ok)=>{
							if(ok){
								$(".certiNumDiv").css("display","");
								$(".valueDiv").css("display","none");
							}
						});
					}else if(data.statusCode == 702){
						swal('이미 존재하는 이메일 입니다.');
						return;
					}else{
						console.log(data.statusCode);
					}
				},
				error:function(request, status, error) {
					alert("status: " + request.status + ", error: " + error);
				}
			});
		}

		function fn_checkCertiNum(){
			var certificationNumber = $("#certificationNumber").val();

			if(!checkValid.isCheckValueVaild(certificationNumber)){
				swal('인증번호를 입력하지 않았습니다.').then((ok)=>{
					if(ok){
						$("#certificationNumber").focus();
					}
				});

				return;
			}

			var userId = $("#userId").val();

			$.ajax({
				url: "/user/getCheckCertiNum.do",
				data: {"userId":userId, "certificationNumber":certificationNumber},
				type: 'POST',
				dataType : 'json',
				success: function(data) {
					/* ■ 상태코드
					 * 700 : 정상
			    	 * 701 : 필수값없음
			    	 * 702 : 인증번호 불일치
			    	 */
					if(data.statusCode == 700){
						swal('확인 되었습니다.').then((ok)=>{
							if(ok){
								if(!checkValid.isCheckValueVaild($("#email",opener.document).val())){
									$("#email1",opener.document).val($("#email").val());
								}else{
									$("#email",opener.document).val($("#email").val());
								}

								window.close();
							}
						});
					}else if(data.statusCode == 702){
						swal('인증번호가 일치하지 않습니다.');
						return;
					}else{
						console.log(data.statusCode);
					}
				},
				error:function(request, status, error) {
					alert("status: " + request.status + ", error: " + error);
				}
			});
		}
	</script>
</body>
</html>