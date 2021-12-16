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
                            <h5>메뉴아이디 중복검사</h5>
                        </div>

						<div class="card-block">
		                	<input type="hidden" id="userId" value="<c:out value='${info.userId}'/>" />

		                	<div class="input-group mb-4 valueDiv">
								<label class="col-sm-3 col-form-label"><spring:message code='system.msg6' />&nbsp;<span style="color:red;">*</span></label>
								<input type="text" id="menuId" class="form-control col-sm-9 custoenf" maxlength="7" />
								<div class="input-group-append">
		                            <button class="btn btn-primary" type="button" onclick="fn_isMenuIdValid()"><spring:message code='member.dupCheck' /></button>
		                        </div>
							</div>

							<div class="mb-1" style="text-align: center;">
		                    	<button class="btn btn-dark" onclick="window.close()"><spring:message code='button.close' /></button>
		                    	<button id="useBtn" class="btn btn-primary" onclick="fn_use()" style="display:none;"><spring:message code='system.msg19' /></button>
		                    </div>
	                    </div>
                    </div>
				</div>

		</div>
	</div>

	<script>
		function fn_isMenuIdValid(){
			var menuId = $("#menuId").val();

			if(!checkValid.isCheckValueVaild(menuId)){
				swal("<spring:message code='system.msg13' />").then((ok)=>{
					if(ok){
						$("#menuId").focus();
					}
				});

				return;
			}

			$.ajax({
				url: "/system/getIsValidMenuId.do",
				data: {"menuId":menuId},
				type: 'POST',
				dataType : 'json',
				success: function(data) {
					/* ■ 상태코드
					 * 700 : 정상
			    	 * 701 : 비정상 접근 - param null
			    	 * 706 : 해당 메뉴ID 이미 사용중
			    	 */
					if(data.statusCode == 700){
						swal("<spring:message code='system.msg20' />", {closeOnClickOutside: false}).then((ok)=>{
							if(ok){
								$("#useBtn").css("display","");
								$("#menuId").attr("readonly",true);
							}
						});
					}else if(data.statusCode == 706){
						swal("<spring:message code='system.msg21' />");
						$("#useBtn").css("display","none");
						$("#menuId").attr("readonly",false);
					}else{
						console.log(data.statusCode);
					}
				},
				error:function(request, status, error) {
					alert("status: " + request.status + ", error: " + error);
				}
			});
		}

		function fn_use(){
			$("#menuId",opener.document).val($("#menuId").val());
			window.close();
		}
	</script>
</body>
</html>