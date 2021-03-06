<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- [Header] start -->
<header class="navbar pcoded-header navbar-expand-lg navbar-light headerpos-fixed" style="background: #f4f7fa;">
    <div class="m-header">
        <a class="mobile-menu" id="mobile-collapse1" href="#!"><span></span></a>
        <a href="/main/main.do" class="b-brand">
           <div class="b-bg">
               <i class="feather icon-trending-up"></i>
           </div>
           <span class="b-title" style="color:black;">Reference</span>
       </a>
    </div>
    <a class="mobile-menu" id="mobile-header" href="#!">
        <i class="feather icon-more-horizontal"></i>
    </a>
    <div class="collapse navbar-collapse">
        <ul class="navbar-nav ml-auto">
            <li><spring:message code="header.msg1" /> : <span id="timer"></span></li>
            <li><a href="javascript:fn_changeLang('ko');">ko</a>|<a href="javascript:fn_changeLang('en');">en</a></li>
            <li>
                <div class="dropdown drp-user">
                    <a href="#" class="dropdown-toggle2" data-toggle="dropdown">
                        <i class="icon feather icon-settings"></i>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right profile-notification">
                        <div class="pro-head">
                            <span><c:out value='${sessionScope.loginInfo.userName}'/></span>
                            <a href="javascript:void(0)" onclick="fn_actionLogout()" class="dud-logout" title="Logout">
                                <i class="feather icon-log-out"></i>
                            </a>
                        </div>
                        <ul class="pro-body">
                            <li><a href="javascript:void(0)" onclick="fn_createFormSubmit('/user/userModify.do', 'post')" class="dropdown-item"><i class="feather icon-user"></i> <spring:message code="header.userInfoModify" /></a></li>
                        </ul>
                    </div>
                </div>
            </li>
        </ul>
    </div>
    <div class="noErrorMsgDiv" style="display:none;"></div>
</header>
<!-- [Header] end -->
<script>

Lpad=function(str, len) {
	str = str + "";
	while(str.length < len) {
		str = "0"+str;
	}

	return str;
};

// ?????????????????? ????????? ?????? ????????? ???????????? ??????????????? ??????????????????????????? ????????????, ?????????
var iMinute = 60;

// ?????????????????? ?????? ???????????? ????????? ???????????? ???????????? ??????, ?????????
var noticeSecond = 10;

var iSecond = iMinute * 60 ;
var timerchecker = null;

initTimer=function() {
	rMinute = parseInt(iSecond / 60);
	rSecond = iSecond % 60;
	if(iSecond > 0) {
		// ?????????????????? ?????????????????? ?????????+?????? ?????? ???????????? ??????
		if (document.getElementById("timer") != null){
			$("#timer").html(Lpad(rMinute, 2)+"???"+Lpad(rSecond, 2)+"???");
		}

	    iSecond--;
	 	timerchecker = setTimeout("initTimer()", 1000); // 1??? ???????????? ??????
	} else {
	 	clearTimeout(timerchecker);
	 	fn_actionLogout();
	}
}
window.onload = initTimer;// ?????? ????????? ????????????
document.onclick = reset;
document.onkeypress = reset;

function reset(){
	iSecond = iMinute * 60 ;
	clearTimeout(timerchecker);
	initTimer();
}

function fn_actionLogout(){
	fn_createFormSubmit("/actionLogout.do", "post");
}

function fn_changeGroupId(groupId){
	var curGroupCode = "<c:out value='${curGroupCode}'/>";

	/* ??? ????????? ????????? ????????? ????????? ?????? ??????. */
	if(curGroupCode == groupId){
		return;
	}

	fn_createFormSubmit("/changeGroupId.do", "post","","groupId",groupId,1);
}

function fn_changeWB(){
	fn_createFormSubmit("/fn_changeWB.do", "post","","","",1);
}
</script>