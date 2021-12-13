<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<title>:: reference ::</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimal-ui">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="description" content="Datta Able Bootstrap admin template made using Bootstrap 4 and it has huge amount of ready made feature, UI components, pages which completely fulfills any dashboard needs."/>
<meta name="keywords" content="admin templates, bootstrap admin templates, bootstrap 4, dashboard, dashboard templets, sass admin templets, html admin templates, responsive, bootstrap admin templates free download,premium bootstrap admin templates, datta able, datta able bootstrap admin template">
<meta name="author" content="Codedthemes" />

<!-- Favicon icon -->
<link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico" type="image/x-icon">
<!-- fontawesome icon -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/fonts/fontawesome/css/fontawesome-all.min.css">
<!-- animation css -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/animation/css/animate.min.css">
<!-- notification css -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/notification/css/notification.min.css">

<!-- vendor css -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">


<!-- material datetimepicker css -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/material-datetimepicker/css/bootstrap-material-datetimepicker.css">
<!-- data tables css -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/data-tables/css/datatables.min.css">

<!-- footable css -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/footable/css/footable.bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/footable/css/footable.standalone.min.css">

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/jquery-ui-1.8.1.custom.css" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ui.jqgrid.css">

<!-- Required Js -->
<script src="${pageContext.request.contextPath}/assets/js/vendor.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/plugins/bootstrap/js/bootstrap.min.js"></script>

<!-- datetimepicker Js -->
<script src="${pageContext.request.contextPath}/assets/plugins/material-datetimepicker/js/moment-with-locales.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/plugins/material-datetimepicker/js/bootstrap-material-datetimepicker.js"></script>

<!-- sweet alert Js -->
<script src="${pageContext.request.contextPath}/assets/plugins/sweetalert/js/sweetalert.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/pages/ac-alert.js"></script>

<!-- amchart js -->
<script src="${pageContext.request.contextPath}/assets/plugins/amchart/js/amcharts.js"></script>
<script src="${pageContext.request.contextPath}/assets/plugins/amchart/js/gauge.js"></script>
<script src="${pageContext.request.contextPath}/assets/plugins/amchart/js/serial.js"></script>
<script src="${pageContext.request.contextPath}/assets/plugins/amchart/js/light.js"></script>
<script src="${pageContext.request.contextPath}/assets/plugins/amchart/js/pie.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/plugins/amchart/js/ammap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/plugins/amchart/js/usaLow.js"></script>
<script src="${pageContext.request.contextPath}/assets/plugins/amchart/js/radar.js"></script>
<script src="${pageContext.request.contextPath}/assets/plugins/amchart/js/worldLow.js"></script>
<!-- notification Js -->
<script src="${pageContext.request.contextPath}/assets/plugins/notification/js/bootstrap-growl.min.js"></script>

<!-- dashboard-custom js -->
<script src="${pageContext.request.contextPath}/assets/js/pages/dashboard-custom.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/jquery-ui-1.8.1.custom.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/i18n/grid.locale-kr.js"></script>
<script type="text/javascript">$.jgrid.no_legacy_api = true;</script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.jqGrid-4.7.0.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
$(document).keydown(function(event){
	if(event.ctrlKey==true && (event.which == '61' || event.which == '107' || event.which == '173' || event.which =='109' || event.which == '187' || event.which == '189')){
		event.preventDefault();
	}
});

window.addEventListener('wheel', function(event){
	if(event.ctrlKey == true){
		event.preventDefault();
	}
},{passive:false});
</script>