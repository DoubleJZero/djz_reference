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
                                            <h5>그룹멤버관리</h5>

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
															<button type="button" class="btn btn-primary btn-sm" onclick="fn_userSerach()" style="margin-right: 0.5px;">추가</button>
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

    <%-- 사용자검색 modal --%>
	<div class="modal fade" id="userModal" tabindex="-1" role="dialog" aria-labelledby="userModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="userModalLabel">사용자</h5>
                    <button type="button" class="close" data-dismiss="modal" id="umclose"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                	<div class="input-group mb-1" style="background: #fff;">
                        <label class="col-form-label col-sm-3">사용자명</label>
                        <input type="text" class="form-control col-sm-9 custokaef" id="searchUserName" maxlength="20" onkeypress="if(event.keyCode == 13){fn_searchUser();}" />
                        <div class="input-group-append">
                            <button class="btn btn-primary" type="button" onclick="fn_searchUser()"><spring:message code='button.lookup' /></button>
                        </div>
                    </div>

                    <br />

                    <table id="GRID_USER"></table>
                    <div id="PAGINATION_USER"></div>
                </div>
            </div>
        </div>
    </div>
    <%-- 사용자검색 modal --%>

<script>
function fn_initJqGrid(data){

	$("#GRID_1").jqGrid({
		datatype: "local",
	    height: 600,
		pager: $('#PAGINATION_1'),
	   	colNames:[
	   		"삭제"
	   		,"사용자아이디"
	   		,"사용자명"
	   		,"우편번호"
	   		,"주소"
	   		,"이메일"
	   		,"휴대폰번호"
	   	],
	   	colModel:[
	   		{name:'isDel',index:'isDel', width:60, editable:true, edittype:"checkbox", formatter:"checkbox", editoptions: {value:"Y:N"}, align: "center",formatoptions:{disabled:false},sortable:false},
	   		{name:'userId',index:'userId', width:100},
	   		{name:'userName',index:'userName', width:80},
	   		{name:'zipcode',index:'zipcode', width:80},
	   		{name:'address',index:'address', width:300},
	   		{name:'email',index:'email', width:200},
	   		{name:'mobile',index:'mobile', width:120}
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
		url : "/system/getGroupMemberList.do",
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
        		url : "/system/getDeleteGroupMember.do",
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

function fn_initJqGridUser(data){
	$("#GRID_USER").jqGrid({
		datatype: "local",
	    height: 380,
		pager: $('#PAGINATION_USER'),
	   	colNames:[
	   		"사용자아이디"
	   		,"사용자명"
	   		,"우편번호"
	   		,"주소"
	   		,"이메일"
	   		,"휴대폰번호"
	   	],
	   	colModel:[
	   		{name:'userId',index:'userId', width:100},
	   		{name:'userName',index:'userName', width:80},
	   		{name:'zipcode',index:'zipcode', width:60},
	   		{name:'address',index:'address', width:220},
	   		{name:'email',index:'email', width:160},
	   		{name:'mobile',index:'mobile', width:110}
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
	   		var cols = $("#GRID_USER").jqGrid('getRowData', id);

	   		var groupId = $("#groupId").val();
	   		var userId = cols.userId;

			$.ajax({
				type : "POST",
				url : "/system/getInsertGroupMember.do",
				data : {"groupId" : groupId, "userId" : userId},
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
						$('#umclose').click();
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
				$("#GRID_USER").jqGrid('clearGridData');

				$("#GRID_USER > tbody").append("<tr><td align='center' colspan='8'><spring:message code='common.msg1' /></td></tr>");
			}
	   }
	});

	if(fn_isCheckNumValueVaild(data)){
		$("#GRID_USER").jqGrid('clearGridData');
		$("#GRID_USER").jqGrid('setGridParam',{data:data}).trigger("reloadGrid");
	}
}

function fn_userSerach(){
	$('#searchUserName').val('');
	fn_searchUser();
	$('#userModal').modal('toggle');
}

function fn_searchUser() {
	var searchUserName = $('#searchUserName').val();

	$.ajax({
		type : "POST",
		url : "/system/getUserSearchList.do",
		data : {"searchUserName":searchUserName},
		dataType : 'json',
		async: false,
		success : function(res) {
			/* ■ 상태코드
			 * 700 : 정상
	    	 * 705 : 조회결과 없음
	    	 */
			if(res.statusCode == 700){
				fn_initJqGridUser(res.data);
			}else if(res.statusCode == 705){
				fn_initJqGridUser([]);
			}else{
				console.log("status :: " + res.statusCode);
			}
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