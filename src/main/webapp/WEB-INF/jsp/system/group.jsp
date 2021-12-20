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
                                            <h5>그룹관리</h5>
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
														<input type="hidden" id="groupId" />
														<label class="col-sm-4 col-form-label">그룹명&nbsp;<span style="color:red;">*</span></label>
														<input type="text" id="groupName" class="form-control col-sm-8 custttscf" maxlength="20" />
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
	   		"그룹아이디"
	   		,"그룹명"
	   	],
	   	colModel:[
	   		{name:'groupId',index:'groupId', hidden:true},
	   		{name:'groupName',index:'groupName', width:1000}
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

	   		$('#groupId').val(cols.groupId);
			$('#groupName').val(cols.groupName);
   		},
	    loadComplete: function(data) {
			if(data.rows.length == 0){
				$("#GRID_1").jqGrid('clearGridData');

				$("#GRID_1 > tbody").append("<tr><td align='center' colspan='2'><spring:message code='common.msg3' /></td></tr>");
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
		url : "/system/getGroupList.do",
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
	var groupId = $('#groupId').val();

	if(!checkValid.isCheckValueVaild(groupId)){
		fn_init();
		return;
	}

	swal({
		title: '<spring:message code="common.msg1" />',
        text: '<spring:message code="common.msg2" />',
        icon: "warning",
        buttons: ['<spring:message code="button.cancel" />','<spring:message code="button.confirm" />'],
        dangerMode: true,
    })
    .then((willDelete) => {
        if (willDelete) {
        	$.ajax({
        		type : "POST",
        		url : "/system/getDeleteGroup.do",
        		data : {"groupId":groupId},
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
	$('#groupId').val('');
	$('#groupName').val('');

	$("#GRID_1").jqGrid('resetSelection');
}

function fn_save(){
	var groupId = $('#groupId').val();
	var groupName = $('#groupName').val();

	if(!checkValid.isCheckValueVaild(groupName)){
		swal('그룹명을 입력하지 않았습니다.');

		return;
	}

	if(!checkValid.isCheckValueVaild(groupId)){
		$.ajax({
			type : "POST",
			url : "/system/getInsertGroup.do",
			data : {"groupName":groupName},
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
			url : "/system/getUpdateGroup.do",
			data : {"groupId":groupId, "groupName":groupName},
			dataType : 'json',
			success : function(res) {
				/* ■ 상태코드
				 * 700 : 정상
		    	 * 701 : 비정상 접근 - param null
		    	 * 702 : 필수값 없음
		    	 */
				if(res.statusCode == 700){

					$.ajax({
						type : "POST",
						url : "/system/getGroupList.do",
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

$(document).ready(function() {
	fn_search();
});
</script>
</body>
</html>