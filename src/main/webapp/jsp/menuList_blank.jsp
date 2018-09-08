<%@ page import="com.lesson.service.CategoryManager" %>
<%@ page import="com.lesson.model.Category" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	CategoryManager categoryManager = (CategoryManager)session.getAttribute("categoryManager");
	String currentCid = request.getParameter("cid");
	String currentUseCookie = request.getParameter("useCookie");

	//獲取當前站點所需要的cookie: ckUseCookie, ckCid
	Cookie[] cookies = request.getCookies();

	Cookie ckUseCookie = null;
	Cookie ckCid = null;
	for (int i = 0; cookies != null && i < cookies.length; i++) {
		if ("ckUseCookie".equals(cookies[i].getName())) {
			ckUseCookie = cookies[i];
			System.out.println("ckUseCookie 的值為" + ckUseCookie.getName() + " = " + ckUseCookie.getValue());
		} else if ("ckCid".equals(cookies[i].getName())) {
			ckCid = cookies[i];
			System.out.println("ckCid 的值是" + ckCid.getName() + " = " + ckCid.getValue());
		}
	}

	//如果ckUseCookie = on 並且當前的 currentCid 為空 則嘗試提交相應的請求
	if(ckUseCookie != null && ckUseCookie.getValue().equalsIgnoreCase("on") && currentCid == null){
%>
		<jsp:forward page="/showMenus">
			<jsp:param name="useCookie" value="<%=ckUseCookie.getValue()%>"></jsp:param>
			<jsp:param name="cid" value="<%=ckCid.getValue()%>"></jsp:param>
		</jsp:forward>
<%
	}
%>

<html>
<head>
	<title>Main Menu</title>
</head>

<body>
	<h2>Current Menu</h2>
	<form action = "/showMenus" method = "post">
		<b>查詢：</b>
		<select name="cid">
			<option value="all"
				<% if(currentCid == null){ out.println("selected"); }%>
			>全部</option>
			<%
				List<Category> categories = categoryManager.getAllCategories();
				for(Category category:categories){
			%>
					<option value="<%=category.getCid()%>"
						<%
							if(currentCid != null && currentCid.equalsIgnoreCase(new Integer(category.getCid()).toString())){
								out.println("selected");
							}
						%>
					>
						<%=category.getCname()%>
					</option>
			<%
				}
			%>
		</select>
		<input type = "submit", value = "送出查詢"/>
		&nbsp;|&nbsp;
		<input type = "button" value = "增加餐點"" onclick="window.location.href='/addMenu'">
		&nbsp;|&nbsp;
		<input type = "button" value = "管理分類" onclick="window.location.href='/showCategories'">
		&nbsp;|&nbsp;
		<input type = "checkbox" name = "useCookie"
		<%
			if(currentUseCookie != null && currentUseCookie.equalsIgnoreCase("on")){
		%>
				checked value="on"
		<%
			}
		%>
		/> 使用cookie
	</form>

	<table border="1" cellspacing="0" cellpadding="5">
		<tr>
			<th>點餐</th>
			<th>餐點編號</th>
			<th>餐點名稱</th>
			<th>餐點ID</th>
			<th>價錢</th>
			<th>相關操作</th>
		</tr>
		<c:forEach items="${menus}" var="menu">
			<tr>
				<td align="center"><input type="checkbox"/></td>
				<td align="center">${menu.mid}</td>
				<td>${menu.mname}</td>
				<td>
					<c:set var="cid" scope="request" value="${menu.cid}" />
					<%=categoryManager.getCategoryById(((Integer)request.getAttribute("cid")).intValue()).getCname()%>
				</td>
				<td align="center">${menu.price}</td>
				<td>
					<input type = "button" value = "删除" onclick="javascript:if(confirm('確認刪除${menu.mname}'))window.location.href='/delete/${menu.mid}'">
					<input type = "button" value = "更新" onclick="window.location.href='/editMenu/${menu.mid}'">
				</td>
			</tr>
		</c:forEach>
	</table>

</body>
</html>