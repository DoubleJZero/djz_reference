<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- [Left] start -->
<nav class="pcoded-navbar">
    <div class="navbar-wrapper">
        <div class="navbar-brand header-logo">
        	<a href="/main/main.do" class="b-brand">
                <div class="b-bg">
                    <i class="feather icon-trending-up"></i>
                </div>
                <span class="b-title">Reference</span>
            </a>
            <a class="mobile-menu" id="mobile-collapse" href="#!"><span></span></a>
        </div>
        <div class="navbar-content scroll-div">
            <ul class="nav pcoded-inner-navbar">
            	<c:set var="curMenuGroup" value="0" />
            	<c:forEach var="item" items="${menuList}" varStatus="status">
            		<c:if test='${status.index ne 0 and item.menuGroup ne curMenuGroup}'>
	            			</ul>
	            		</li>
            		</c:if>
            		<c:if test='${item.menuGroup eq curMenuGroup}'>
						<li class="<c:if test='${!empty sessionScope.curMenuSeq and sessionScope.curMenuSeq eq item.menuSeq}'>active</c:if>"><a href="javascript:void(0);" onclick="fn_createFormSubmit('${item.menuUrl}', 'post','','curMenuGroup,curMenuSeq,curMenuId','${item.menuGroup},${item.menuSeq},${item.menuId}',3)" class=""><c:out value='${item.menuName}'/></a></li>
						<c:if test='${status.last}'>
							</ul>
	            		</li>
						</c:if>
					</c:if>
					<c:if test='${item.menuGroup ne curMenuGroup}'>
						<c:set var="curMenuGroup" value="${item.menuGroup}" />
						<li class="nav-item pcoded-hasmenu <c:if test='${!empty sessionScope.curMenuGroup and sessionScope.curMenuGroup eq item.menuGroup}'>active pcoded-trigger</c:if>">
							<a href="#!" class="nav-link"><span class="pcoded-micon">

								<c:if test='${curMenuGroup eq 100}'>
									<i class="feather icon-edit"></i>
								</c:if>

								<c:if test='${curMenuGroup eq 200}'>
									<i class="feather icon-file-text"></i>
								</c:if>

								<c:if test='${curMenuGroup eq 300}'>
									<i class="feather icon-fast-forward"></i>
								</c:if>

								<c:if test='${curMenuGroup eq 500}'>
									<i class="feather icon-box"></i>
								</c:if>

								<c:if test='${curMenuGroup eq 600}'>
									<i class="feather icon-file-text"></i>
								</c:if>

								<c:if test='${curMenuGroup eq 700}'>
									<i class="feather icon-file-plus"></i>
								</c:if>

								<c:if test='${curMenuGroup eq 800}'>
									<i class="feather icon-user"></i>
								</c:if>

								<c:if test='${curMenuGroup eq 900}'>
									<i class="feather icon-server"></i>
								</c:if>

							</span><span class="pcoded-mtext"><c:out value='${item.menuName}'/></span></a>
							<ul class="pcoded-submenu">
					</c:if>
            	</c:forEach>
            </ul>
        </div>
    </div>
</nav>
<script src="/assets/js/pcoded.min.js"></script>
<script>
$(function(){
	fn_leftMenuInit();
});
</script>
<!-- [Left] end -->
