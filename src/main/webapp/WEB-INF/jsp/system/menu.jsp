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
                                            <h5><spring:message code="system.msg1" /></h5>

                                            <div class="card-header-right">
                                            	<div class="btn-group card-option">

													<input type="text" id="searchMenuName" class="form-control custttscf" placeholder="<spring:message code="system.msg2" />" style="margin-right:5px; max-height:36px;" maxlength="30" />

													<%-- <c:if test='${!empty sessionScope.curAuthInfo and curAuthInfo.r eq "Y"}'> --%>
														<button type="button" class="btn btn-primary btn-sm" onclick="fn_search()" style="min-width:60px;"><spring:message code='button.lookup' /></button>
													<%-- </c:if> --%>
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
														<%-- <c:if test='${!empty sessionScope.curAuthInfo and curAuthInfo.d eq "Y"}'> --%>
															<button type="button" class="btn btn-danger btn-sm" onclick="fn_delete()" style="margin-right: 0.5px;"><spring:message code='button.delete' /></button>
														<%-- </c:if> --%>
														<button type="button" class="btn btn-dark btn-sm" onclick="fn_init()" style="margin-right: 0.5px;"><spring:message code='button.init' /></button>
														<%-- <c:if test='${!empty sessionScope.curAuthInfo and (curAuthInfo.c eq "Y" or curAuthInfo.u eq "Y")}'> --%>
															<button type="button" class="btn btn-primary btn-sm" onclick="fn_save()" style="margin-right: 0.5px;"><spring:message code='button.save' /></button>
														<%-- </c:if> --%>
														<%-- <c:if test='${!empty sessionScope.curAuthInfo and curAuthInfo.e eq "Y"}'> --%>
															<button type="button" class="btn btn-success btn-sm" onclick="dynamicSubmit.createFormSubmit('/system/getMenuExcel.do', 'post')" style="margin-right: 0.5px;"><spring:message code='button.excel' /></button>
														<%-- </c:if> --%>
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<input type="hidden" id="menuSeq" />
														<label class="col-form-label col-sm-4"><spring:message code='system.msg3' />&nbsp;<span style="color:red;">*</span></label>
														<input type="text" id="menuGroup" class="form-control col-sm-8 custonf" maxlength="4" />
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-form-label col-sm-4"><spring:message code='system.msg4' /></label>
														<input type="text" id="parentMenuGroup" class="form-control col-sm-8 custonf" maxlength="3" />
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-form-label col-sm-4"><spring:message code='system.msg5' /></label>
								                        <select class="form-control col-sm-8" id="menuDepth">
								                        	<option value="1">상위메뉴</option>
                          	 								<option value="2">하위메뉴</option>
								                        </select>
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label"><spring:message code='system.msg6' />&nbsp;<span style="color:red;">*</span></label>
														<input type="text" id="menuId" class="form-control col-sm-8" readonly="readonly" maxlength="7" />
														<div class="input-group-append">
								                            <button class="btn btn-primary" type="button" onclick="fn_popIsDupCheck()"><spring:message code='member.dupCheck' /></button>
								                        </div>
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label"><spring:message code='system.msg2' />&nbsp;<span style="color:red;">*</span></label>
														<input type="text" id="menuName" class="form-control col-sm-8 custttscf" maxlength="30" />
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label"><spring:message code='system.msg7' />&nbsp;<span style="color:red;">*</span></label>
														<textarea id="menuDescription" class="form-control col-sm-8 custttscf" rows="4" maxlength="80" style="resize: none;"></textarea>
													</div>

													<div class="input-group mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label"><spring:message code='system.msg8' /></label>
								                        <select class="form-control col-sm-8" id="useYn">
								                        	<option value="Y">사용</option>
                          	 								<option value="N">미사용</option>
								                        </select>
													</div>

													<div class="input-group input-group02 mb-1" style="background: #fff">
														<label class="col-sm-4 col-form-label"><spring:message code='system.msg9' /></label>
														<input type="text" id="menuUrl" class="form-control col-sm-8 custoenspf" maxlength="66" />
													</div>

													<div class="input-group input-group02 mb-4" style="background: #fff">
														<label class="col-form-label col-sm-4"><spring:message code='system.msg10' /></label>
														<input type="text" id="menuOrder" class="form-control col-sm-8 custonf" maxlength="3" />
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
	   		"menuSeq"
	   		,"useYn"
	   		,"menuUrl"
	   		,"menuOrder"
	   		,"<spring:message code='system.msg3' />"
	   		,"<spring:message code='system.msg4' />"
	   		,"<spring:message code='system.msg5' />"
	   		,"<spring:message code='system.msg6' />"
	   		,"<spring:message code='system.msg2' />"
	   		,"<spring:message code='system.msg7' />"
	   	],
	   	colModel:[
	        {name:'menuSeq',index:'menuSeq', hidden:true},
	   		{name:'useYn',index:'useYn', hidden:true},
	   		{name:'menuUrl',index:'menuUrl', hidden:true},
	   		{name:'menuOrder',index:'menuOrder', hidden:true},
	   		{name:'menuGroup',index:'menuGroup', width:120, align: "center"},
	   		{name:'parentMenuGroup',index:'parentMenuGroup', width:120, align: "center"},
	   		{name:'menuDepth',index:'menuDepth', width:80, align: "center"},
	   		{name:'menuId',index:'menuId', width:90, align: "center"},
	   		{name:'menuName',index:'menuName', width:200},
	   		{name:'menuDescription',index:'menuDescription', width:400}
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

	   		$('#menuSeq').val(cols.menuSeq);
			$('#menuGroup').val(cols.menuGroup);
			$('#parentMenuGroup').val(cols.parentMenuGroup);
			$("#menuDepth").val(cols.menuDepth).prop("selected", true);
			$('#menuId').val(cols.menuId);
			$('#menuName').val(cols.menuName);
			$('#menuDescription').val(cols.menuDescription);
			$("#useYn").val(cols.useYn).prop("selected", true);
			$('#menuUrl').val(cols.menuUrl);
			$('#menuOrder').val(cols.menuOrder);
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
	var searchMenuName = $('#searchMenuName').val();

	if(!checkValid.isCheckValueVaild(searchMenuName)){
		searchMenuName = "";
	}

	searchMenuName = searchMenuName.replace(/\s/gi, "");

	$.ajax({
		type : "POST",
		url : "/system/getMenuList.do",
		data : {"searchMenuName" : searchMenuName},
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
	var menuSeq = $('#menuSeq').val();

	if(!checkValid.isCheckValueVaild(menuSeq)){
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
        		url : "/system/getDeleteMenu.do",
        		data : {"menuSeq":menuSeq},
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
	$('#menuSeq').val('');
	$('#menuGroup').val('');
	$('#parentMenuGroup').val('');
	$("#menuDepth option:eq(0)").prop("selected", true);
	$('#menuId').val('');
	$('#menuName').val('');
	$('#menuDescription').val('');
	$("#useYn option:eq(0)").prop("selected", true);
	$('#menuUrl').val('');
	$('#menuOrder').val('');

	$("#GRID_1").jqGrid('resetSelection');
}

function fn_save(){
	var menuGroup = $('#menuGroup').val();
	var menuId = $('#menuId').val();
	var menuName = $('#menuName').val();
	var menuDescription = $('#menuDescription').val();


	if(!checkValid.isCheckValueVaild(menuGroup)){
		swal('<spring:message code="system.msg12" />');

		return;
	}

	if(!checkValid.isCheckValueVaild(menuId)){
		swal('<spring:message code="system.msg13" />');

		return;
	}

	if(!checkValid.isCheckValueVaild(menuName)){
		swal('<spring:message code="system.msg14" />');

		return;
	}

	if(!checkValid.isCheckValueVaild(menuDescription)){
		swal('<spring:message code="system.msg15" />');

		return;
	}

	var menuSeq = $('#menuSeq').val();
	if(!checkValid.isCheckValueVaild(menuSeq)) {
		menuSeq = "";
	}

	var parentMenuGroup = $('#parentMenuGroup').val();
	if(!checkValid.isCheckValueVaild(parentMenuGroup)){
		parentMenuGroup = "";
	}

	var menuDepth = $('#menuDepth').val();

	var useYn = $('#useYn').val();

	var menuUrl = $('#menuUrl').val();
	if(!checkValid.isCheckValueVaild(menuUrl)){
		menuUrl = "";
	}

	var menuOrder = $('#menuOrder').val();
	if(!checkValid.isCheckValueVaild(menuOrder)){
		menuOrder = "";
	}

	if(menuSeq == ""){
		$.ajax({
			type : "POST",
			url : "/system/getInsertMenu.do",
			data : {"menuGroup":menuGroup, "parentMenuGroup":parentMenuGroup, "menuDepth":menuDepth, "menuId":menuId, "menuName":menuName, "menuDescription":menuDescription, "useYn":useYn, "menuUrl":menuUrl, "menuOrder":menuOrder},
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
			url : "/system/getUpdateMenu.do",
			data : {"menuSeq":menuSeq, "menuGroup":menuGroup, "parentMenuGroup":parentMenuGroup, "menuDepth":menuDepth, "menuId":menuId, "menuName":menuName, "menuDescription":menuDescription, "useYn":useYn, "menuUrl":menuUrl, "menuOrder":menuOrder},
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
						url : "/system/getMenuList.do",
						data : {"searchMenuName" : searchMenuName},
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

	popObj = fn_cPopup('/system/popValidMenuId.do','','','', 670, 320);
}

$(document).ready(function() {
	fn_search();
});
</script>
</body>
</html>