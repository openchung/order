<%@ page import="com.lesson.service.CategoryManager" %>
<%@ page import="com.lesson.model.Category" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	CategoryManager categoryManager = (CategoryManager)session.getAttribute("categoryManager");
%>

<html>
<head>
	<title>編輯餐點明細</title>
	<style>
		input.none {border:none}
		select.none {border:none}
	</style>
</head>

<body>
	<h2>編輯餐點明細</h2>

	<form action="/saveMenu" method = "post">
		<table border="1" cellspacing="0" cellpadding="5">
			<tr>
				<th>餐點ID</th>
				<th>餐點名稱</th>
				<th>餐點分類</th>
				<th>餐點單價</th>
			</tr>
			<tr>
				<td><input class = "none" type="text" name="mid" value = "${menu.mid}" readonly = "readonly"/></td>
				<td><input class = "none" type="text" name="mname" value = "${menu.mname}"/></td>
				<td>
					<c:set var="ccid" scope="request" value="${menu.cid}" /> <!--cid-->
					<select class = "none" name="cid">
						<%
							List<Category> categories = categoryManager.getAllCategories();
							int ccid = ((Integer)request.getAttribute("ccid")).intValue();
							for(Category category: categories){
						%>
								<option value = "<%=category.getCid()%>"
								<%
									if(category.getCid() == ccid){
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
				</td>
				<td><input class = "none" type="text" name="price" value = "${menu.price}"/></td>
			</tr>
		</table>
		<br>
		<input type = "submit" value = "送出"/>
		&nbsp;
		<input type = "button" value = "取消" onclick="window.location.href='/showMenus'"/>
	</form>

</body>
</html>