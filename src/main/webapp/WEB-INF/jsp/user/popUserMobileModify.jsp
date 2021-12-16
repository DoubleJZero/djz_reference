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
                            <h5>휴대폰번호 변경</h5>
                        </div>

						<div class="card-block">
		                	<input type="hidden" id="userId" value="<c:out value='${info.userId}'/>" />

		                	<div class="input-group mb-4 valueDiv">
								<label for="mobile" class="col-sm-3 col-form-label">휴대폰 번호&nbsp;<span style="color:red;">*</span></label>
								<input type="text" id="mobile" name="mobile" class="form-control col-sm-9" maxlength="13" onkeyup="checkValid.inputPhoneNumber(this)" />
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

			var userId = $("#userId").val();

			$.ajax({
				url: "/user/getCreateCertiMobileNum.do",
				data: {"userId":userId,"mobile":mobile},
				type: 'POST',
				dataType : 'json',
				success: function(data) {
					/* ■ 상태코드
					 * 700 : 정상
					 * 701 : param의 값 또는 각 항목의 값이 없음
					 * 702 : 이미 사용중인 휴대폰번호
					 */
					if(data.statusCode == 700){
						swal('인증번호가 발송 되었습니다.').then((ok)=>{
							if(ok){
								$(".certiNumDiv").css("display","");
								$(".valueDiv").css("display","none");
							}
						});
					}else if(data.statusCode == 702){
						swal('이미 존재하는 휴대폰 번호입니다.');
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
						swal('확인 되었습니다.',{closeOnClickOutside: false}).then((ok)=>{
							if(ok){
								if(!checkValid.isCheckValueVaild($("#mobile",opener.document).val())){
									$("#mobile1",opener.document).val($("#mobile").val());
								}else{
									$("#mobile",opener.document).val($("#mobile").val());
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