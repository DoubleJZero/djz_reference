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
                                            <h5>코드관리</h5>

                                            <div class="card-header-right">
                                            	<div class="btn-group card-option">
													<select class="form-control" id="searchCodeGroup">
														<option value=""><spring:message code='common.msg13' /></option>
														<c:forEach var="item" items="${codeGroupList}" varStatus="status">
							                        		<option value="${item.codeGroup}"><c:out value='${item.codeGroup}'/></option>
	                        	 						</c:forEach>
							                        </select>
												</div>
											</div>
                                        </div>

                                        <div class="card-body">
											<div class="row">
												<div class="col-md-8" style="padding-top:15px;">
													<table id="GRID_1"></table>
													<div id="PAGINATION_1"></div>
												</div>

												<div class="col-md-4">
													<div style="text-align: right;" class="mb-3">
														<button type="button" class="btn btn-dark btn-sm" onclick="fn_init()" style="margin-right: 0.5px;"><spring:message code='button.init' /></button>
														<c:if test='${!empty sessionScope.curAuthInfo and (curAuthInfo.roleC eq "Y" or curAuthInfo.roleU eq "Y")}'>
															<button type="button" class="btn btn-primary btn-sm" onclick="fn_save()" style="margin-right: 0.5px;"><spring:message code='button.save' /></button>
														</c:if>
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<input type="hidden" id="codeSeq" />
														<label class="col-sm-4 col-form-label">코드그룹&nbsp;<span style="color:red;">*</span></label>
														<input type="text" id="codeGroup" class="form-control col-sm-8 custoenuf" maxlength="30" />
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label">코드아이디&nbsp;<span style="color:red;">*</span></label>
														<input type="text" id="codeId" class="form-control col-sm-8 custoenuf" maxlength="10" />
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label">코드데이터&nbsp;<span style="color:red;">*</span></label>
														<input type="text" id="codeData" class="form-control col-sm-8 custttscf" maxlength="66" />
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label">정렬순서&nbsp;<span style="color:red;">*</span></label>
														<input type="text" id="codeOrder" class="form-control col-sm-8 custonf" maxlength="2" />
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label">기타1&nbsp;</label>
														<input type="text" id="codeEtc1" class="form-control col-sm-8 custttscf" maxlength="66" />
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label">기타2&nbsp;</label>
														<input type="text" id="codeEtc2" class="form-control col-sm-8 custttscf" maxlength="66" />
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label">기타3&nbsp;</label>
														<input type="text" id="codeEtc3" class="form-control col-sm-8 custttscf" maxlength="66" />
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
	   		"코드seq"
	   		,"기타1"
	   		,"기타2"
	   		,"기타3"
	   		,"코드그룹"
	   		,"코드아이디"
	   		,"코드데이터"
	   		,"정렬순서"
	   	],
	   	colModel:[
	   		{name:'codeSeq',index:'codeSeq', hidden:true},
	   		{name:'codeEtc1',index:'codeEtc1', hidden:true},
	   		{name:'codeEtc2',index:'codeEtc2', hidden:true},
	   		{name:'codeEtc3',index:'codeEtc3', hidden:true},
	   		{name:'codeGroup',index:'codeGroup', width:120},
	   		{name:'codeId',index:'codeId', width:120},
	   		{name:'codeData',index:'codeData', width:500},
	   		{name:'codeOrder',index:'codeOrder', width:80}
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

	   		$('#codeGroup').prop("readonly", true);
	   		$('#codeId').prop("readonly", true);

	   		$('#codeSeq').val(cols.codeSeq);
	   		$('#codeGroup').val(cols.codeGroup);
	   		$('#codeId').val(cols.codeId);
	   		$('#codeData').val(cols.codeData);
	   		$('#codeOrder').val(cols.codeOrder);
	   		$('#codeEtc1').val(cols.codeEtc1);
	   		$('#codeEtc2').val(cols.codeEtc2);
	   		$('#codeEtc3').val(cols.codeEtc3);
   		},
	    loadComplete: function(data) {
			if(data.rows.length == 0){
				$("#GRID_1").jqGrid('clearGridData');

				$("#GRID_1 > tbody").append("<tr><td align='center' colspan='5'><spring:message code='common.msg3' /></td></tr>");
			}
	   }
	});

	if(fn_isCheckNumValueVaild(data)){
		$("#GRID_1").jqGrid('clearGridData');
		$("#GRID_1").jqGrid('setGridParam',{data:data}).trigger("reloadGrid");
	}
}

function fn_search() {
	var searchCodeGroup = $("#searchCodeGroup").val();

	$.ajax({
		type : "POST",
		url : "/system/getCodeList.do",
		data : {"searchCodeGroup":searchCodeGroup},
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

function fn_init(){
	$('#codeGroup').prop("readonly", false);
	$('#codeId').prop("readonly", false);

	$('#codeSeq').val('');
	$('#codeGroup').val('');
	$('#codeId').val('');
	$('#codeData').val('');
	$('#codeOrder').val('');
	$('#codeEtc1').val('');
	$('#codeEtc2').val('');
	$('#codeEtc3').val('');

	$("#GRID_1").jqGrid('resetSelection');
}

function fn_save(){
	var codeSeq = $('#codeSeq').val();
	var codeGroup = $('#codeGroup').val();
	var codeId = $('#codeId').val();
	var codeData = $('#codeData').val();
	var codeOrder = $('#codeOrder').val();

	var codeEtc1 = $('#codeEtc1').val();
	if(!checkValid.isCheckValueVaild(codeEtc1)){
		codeEtc1 = "";
	}

	var codeEtc2 = $('#codeEtc2').val();
	if(!checkValid.isCheckValueVaild(codeEtc2)){
		codeEtc2 = "";
	}

	var codeEtc3 = $('#codeEtc3').val();
	if(!checkValid.isCheckValueVaild(codeEtc3)){
		codeEtc3 = "";
	}

	if(!checkValid.isCheckValueVaild(codeSeq)){
		if(!checkValid.isCheckValueVaild(codeGroup)){
			swal('코드그룹을 입력하지 않았습니다.');

			return;
		}

		if(!checkValid.isCheckValueVaild(codeId)){
			swal('코드아이디를 입력하지 않았습니다.');

			return;
		}

		if(!checkValid.isCheckValueVaild(codeData)){
			swal('코드데이터를 입력하지 않았습니다.');

			return;
		}

		if(!checkValid.isCheckValueVaild(codeOrder)){
			swal('정렬순서를 입력하지 않았습니다.');

			return;
		}

		$.ajax({
			type : "POST",
			url : "/system/getInsertCode.do",
			data : {"codeGroup":codeGroup, "codeId":codeId, "codeData":codeData, "codeOrder":codeOrder, "codeEtc1":codeEtc1, "codeEtc2":codeEtc2, "codeEtc3":codeEtc3},
			dataType : 'json',
			success : function(res) {
				/* ■ 상태코드
				 * 700 : 정상
		    	 * 701 : 비정상 접근 - param null
		    	 * 702 : 필수값 없음
		    	 * 704 : 해당코드그룹에 코드아이디 중복
		    	 */
				if(res.statusCode == 700){
					swal('<spring:message code="system.msg16" />');

   	    			fn_search();
	   	    	}else if(res.statusCode == 704){
	   	    		swal("해당 코드그룹에 코드아이디가 이미 존재합니다.");
	   	    	}else{
	   	    		console.log(res.statusCode);
	   	    	}
			},
			error : function(request, status, error) {
				alert("status: " + request.status + ", error: " + error);
			}
		});
	}else{
		if(!checkValid.isCheckValueVaild(codeGroup)){
			swal('코드데이터를 입력하지 않았습니다.');

			return;
		}

		if(!checkValid.isCheckValueVaild(codeGroup)){
			swal('정렬순서를 입력하지 않았습니다.');

			return;
		}

		var rowId = $("#GRID_1").jqGrid('getGridParam','selrow');
		var curPage = $("#GRID_1").jqGrid('getGridParam', 'page');

		$.ajax({
			type : "POST",
			url : "/system/getUpdateCode.do",
			data : {"codeSeq":codeSeq, "codeData":codeData, "codeOrder":codeOrder, "codeEtc1":codeEtc1, "codeEtc2":codeEtc2, "codeEtc3":codeEtc3},
			dataType : 'json',
			success : function(res) {
				/* ■ 상태코드
				 * 700 : 정상
		    	 * 701 : 비정상 접근 - param null
		    	 * 702 : 필수값 없음
		    	 */
				if(res.statusCode == 700){
					var searchCodeGroup = $("#searchCodeGroup").val();

					$.ajax({
						type : "POST",
						url : "/system/getCodeList.do",
						data : {"searchCodeGroup":searchCodeGroup},
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

	$("#searchCodeGroup").change(function(){
		fn_search();
   	});
});
</script>
</body>
</html>