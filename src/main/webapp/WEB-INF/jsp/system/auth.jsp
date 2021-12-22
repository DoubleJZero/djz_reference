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
                                            <h5>권한관리</h5>
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
														<label class="col-sm-4 col-form-label">권한아이디&nbsp;<span style="color:red;">*</span></label>
														<input type="text" id="authId" class="form-control col-sm-8" readonly="readonly" maxlength="20" />
														<input type="hidden" id="orgAuthId" />
														<div class="input-group-append">
								                            <button class="btn btn-primary" type="button" onclick="fn_popIsDupCheck()"><spring:message code='member.dupCheck' /></button>
								                        </div>
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label">권한설명&nbsp;<span style="color:red;">*</span></label>
														<textarea id="authDesc" class="form-control col-sm-8 custttscf" rows="4" maxlength="80" style="resize: none;"></textarea>
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
	   		"권한아이디"
	   		,"권한설명"
	   	],
	   	colModel:[
	   		{name:'authId',index:'authId', width:200},
	   		{name:'authDesc',index:'authDesc', width:800}
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

	   		$('#authId').val(cols.authId);
			$('#authDesc').val(cols.authDesc);
			$('#orgAuthId').val(cols.authId);
   		},
	    loadComplete: function(data) {
			if(data.rows.length == 0){
				$("#GRID_1").jqGrid('clearGridData');

				$("#GRID_1 > tbody").append("<tr><td align='center' colspan='3'><spring:message code='common.msg3' /></td></tr>");
			}
	   }
	});

	if(fn_isCheckNumValueVaild(data)){
		$("#GRID_1").jqGrid('clearGridData');
		$("#GRID_1").jqGrid('setGridParam',{data:data}).trigger("reloadGrid");
	}
}

function fn_search() {

	$.ajax({
		type : "POST",
		url : "/system/getAuthList.do",
		data : {},
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
	var authId = $('#orgAuthId').val();

	if(!checkValid.isCheckValueVaild(authId)){
		authId = $('#authId').val();
	}

	if(!checkValid.isCheckValueVaild(authId)){
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
        		url : "/system/getDeleteAuth.do",
        		data : {"authId":authId},
        		dataType : 'json',
        		success : function(data) {
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
	$('#authId').val('');
	$('#authDesc').val('');
	$('#orgAuthId').val('');

	$("#GRID_1").jqGrid('resetSelection');
}

function fn_save(){
	var authId = $('#authId').val();
	var authDesc = $('#authDesc').val();
	var orgAuthId = $('#orgAuthId').val();

	if(!checkValid.isCheckValueVaild(authId)){
		swal('권한아이디를 입력하지 않았습니다.');

		return;
	}

	if(!checkValid.isCheckValueVaild(authDesc)){
		swal('권한설명을 입력하지 않았습니다.');

		return;
	}

	if(!checkValid.isCheckValueVaild(orgAuthId)){
		$.ajax({
			type : "POST",
			url : "/system/getInsertAuth.do",
			data : {"authId":authId, "authDesc":authDesc},
			dataType : 'json',
			success : function(res) {
				/* ■ 상태코드
				 * 700 : 정상
		    	 * 701 : 비정상 접근 - param null
		    	 * 702 : 필수값 없음
		    	 */
				if(res.statusCode == 700){
					swal('<spring:message code="system.msg16" />');

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
		var rowId = $("#GRID_1").jqGrid('getGridParam','selrow');
		var curPage = $("#GRID_1").jqGrid('getGridParam', 'page');

		$.ajax({
			type : "POST",
			url : "/system/getUpdateAuth.do",
			data : {"authId":authId, "authDesc":authDesc, "orgAuthId":orgAuthId},
			dataType : 'json',
			success : function(res) {
				/* ■ 상태코드
				 * 700 : 정상
		    	 * 701 : 비정상 접근 - param null
		    	 * 702 : 필수값 없음
		    	 */
				if(res.statusCode == 700){
					var searchMenuName = $('#searchMenuName').val();

					if(!checkValid.isCheckValueVaild(searchMenuName)){
						searchMenuName = "";
					}

					searchMenuName = searchMenuName.replace(/\s/gi, "");

					$.ajax({
						type : "POST",
						url : "/system/getAuthList.do",
						data : {},
						dataType : 'json',
						success : function(subRes) {
							swal('<spring:message code="system.msg17" />');

							if(subRes.statusCode == 700){
								fn_initJqGrid(subRes.data);
								fn_init();
							}else{
								console.log(subRes.statusCode);
								fn_initJqGrid([]);
								fn_init();
							}

							$("#GRID_1").jqGrid('setGridParam',{page:curPage}).trigger('reloadGrid');
		   	    			setTimeout(function(){$("#GRID_1").jqGrid('setSelection', rowId, false);}, 500);
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

var popObj = null;

function fn_popIsDupCheck(){
	if(popObj != null){
		popObj.close();
	}

	popObj = fn_cPopup('/system/popValidAuthId.do','','','', 670, 320);
}

$(document).ready(function() {
	fn_search();
});
</script>
</body>
</html>