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
                                            <h5>그룹권한관리</h5>

                                            <div class="card-header-right">
                                            	<div class="btn-group card-option">

												<select class="form-control" id="groupId">
													<c:forEach var="item" items="${groupList}" varStatus="status">
						                        		<option value="${item.groupId}"><c:out value='${item.groupName}'/></option>
                        	 						</c:forEach>
						                        </select>
												</div>
											</div>
                                        </div>

                                        <div class="card-body">
											<div class="row">
												<div class="col-md-12">
													<div style="text-align: right;" class="mb-1">
														<c:if test='${!empty sessionScope.curAuthInfo and (curAuthInfo.roleC eq "Y" or curAuthInfo.roleU eq "Y")}'>
															<button type="button" class="btn btn-primary btn-sm" onclick="fn_searchAuth()" style="margin-right: 0.5px;">추가</button>
															<button type="button" class="btn btn-danger btn-sm" onclick="fn_delete()" style="margin-right: 0.5px;"><spring:message code='button.delete' /></button>
														</c:if>
													</div>

													<table id="GRID_1"></table>
													<div id="PAGINATION_1"></div>
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

    <%-- 권한검색 modal --%>
	<div class="modal fade" id="authModal" tabindex="-1" role="dialog" aria-labelledby="authModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="authModalLabel">권한</h5>
                    <button type="button" class="close" data-dismiss="modal" id="amclose"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    <table id="GRID_AUTH"></table>
                    <div id="PAGINATION_AUTH"></div>
                </div>
            </div>
        </div>
    </div>
    <%-- 권한검색 modal --%>

<script>
function fn_initJqGrid(data){

	$("#GRID_1").jqGrid({
		datatype: "local",
	    height: 600,
		pager: $('#PAGINATION_1'),
	   	colNames:[
	   		"삭제"
	   		,"권한아이디"
	   		,"권한설명"
	   	],
	   	colModel:[
	   		{name:'isDel',index:'isDel', width:60, editable:true, edittype:"checkbox", formatter:"checkbox", editoptions: {value:"Y:N"}, align: "center",formatoptions:{disabled:false},sortable:false},
	   		{name:'authId',index:'authId', width:200, align: "center"},
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
	   		//var cols = $("#GRID_1").jqGrid('getRowData', id);
   		},
	    loadComplete: function(data) {
			if(data.rows.length == 0){
				$("#GRID_1").jqGrid('clearGridData');

				$("#GRID_1 > tbody").append("<tr><td align='center' colspan='7'><spring:message code='common.msg3' /></td></tr>");
			}
	   }
	});

	if(fn_isCheckNumValueVaild(data)){
		$("#GRID_1").jqGrid('clearGridData');
		$("#GRID_1").jqGrid('setGridParam',{data:data}).trigger("reloadGrid");
	}
}

function fn_search() {
	var groupId = $('#groupId').val();

	if(!checkValid.isCheckValueVaild(groupId)){
		groupId = "";
	}

	$.ajax({
		type : "POST",
		url : "/system/getGroupAuthList.do",
		data : {"groupId" : groupId},
		dataType : 'json',
		success : function(res) {
			/* ■ 상태코드
			 * 700 : 정상
	    	 * 705 : 조회결과 없음
	    	 */
			if(res.statusCode == 700){
				fn_initJqGrid(res.data);
			}else{
				console.log(res.statusCode);
				fn_initJqGrid([]);
			}
		},
		error : function(request, status, error) {
			alert("status: " + request.status + ", error: " + error);
		}
	});
}

function fn_delete(){
	var gridData = jqGridRowsData('GRID_1');

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
        		url : "/system/getDeleteGroupAuth.do",
        		data : gridData,
        		dataType : 'json',
        		success : function(res) {
        			/* ■ 상태코드
        			 * 700 : 정상
        	    	 * 701 : 비정상 접근 - param null
        	    	 * 706 : 삭제할 데이터 없음
        	    	 */
        	    	if(res.statusCode == 700){
        	    		swal('삭제 되었습니다.');
        	    		fn_search();
        	    	}else if(res.statusCode == 706){
						swal('삭제할 항목이 없습니다.');
        	    	}else{
        	    		console.log(res.statusCode);
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

function fn_initJqGridAuth(data){
	$("#GRID_AUTH").jqGrid({
		datatype: "local",
	    height: 380,
		pager: $('#PAGINATION_AUTH'),
	   	colNames:[
	   		"권한아이디"
	   		,"권한설명"
	   	],
	   	colModel:[
	   		{name:'authId',index:'authId', width:150},
	   		{name:'authDesc',index:'authDesc', width:550}
	   	],
	   	shrinkToFit:true,
	    viewrecords: true,
	    loadonce: false,
	   	rowNum:10,
	   	rowList:[10,20,50],
	   	rownumbers:true,
	    rownumWidth:30,
	    jsonReader:{repeatitems : false},
	   	multiselect: false,
	   	scrollrows:true,
	   	autowidth:true,
	   	onSelectRow :  function(id){
	   		var cols = $("#GRID_AUTH").jqGrid('getRowData', id);

	   		var groupId = $("#groupId").val();
	   		var authId = cols.authId;

			$.ajax({
				type : "POST",
				url : "/system/getInsertGroupAuth.do",
				data : {"groupId" : groupId, "authId" : authId},
				async: false,
				dataType : 'json',
				success : function(res) {
					/* ■ 상태코드
					 * 700 : 정상
			    	 * 701 : 비정상 접근 - param null
			    	 * 702 : 필수값 없음
			    	 * 704 : 중복
			    	 */
					if(res.statusCode == 700){
						swal("등록 되었습니다.");
						fn_search();
						$('#amclose').click();
					}else if(res.statusCode == 704){
						swal('이미 존재합니다.');
						return;
					}else{
						console.log(res.statusCode);
					}
				},
				error : function(request, status, error) {
					alert("status: " + request.status + ", error: " + error);
				}
			});
   		},
	    loadComplete: function(data) {
			if(data.rows.length == 0){
				$("#GRID_AUTH").jqGrid('clearGridData');

				$("#GRID_AUTH > tbody").append("<tr><td align='center' colspan='8'><spring:message code='common.msg1' /></td></tr>");
			}
	   }
	});

	if(fn_isCheckNumValueVaild(data)){
		$("#GRID_AUTH").jqGrid('clearGridData');
		$("#GRID_AUTH").jqGrid('setGridParam',{data:data}).trigger("reloadGrid");
	}
}

function fn_searchAuth() {
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
				fn_initJqGridAuth(res.data);
			}else{
				console.log(res.statusCode);
				fn_initJqGridAuth([]);
			}
			$('#authModal').modal('toggle');
		},
		error : function(request, status, error) {
			alert("status: " + request.status + ", error: " + error);
		}
	});
}

$(document).ready(function() {
	fn_search();

	$("#groupId").change(function(){
		fn_search();
   	});
});
</script>
</body>
</html>