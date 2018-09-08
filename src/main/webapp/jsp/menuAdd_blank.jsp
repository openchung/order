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
	<title>增加餐點</title>
	<style>
		input.none {border:1}
		select.none {border:1}
	</style>
</head>

<body>
	<h2>增加餐點</h2>
	<form action="/saveMenu" method = "post">
		<table border="1" cellspacing="0" cellpadding="5">
			<tr>
				<th>餐點名稱</th>
				<th>餐點分類</th>
				<th>餐點單價</th>
			</tr>
			<tr>
				<td>
					<input type="text" name="mid" value="-1" hidden/>
					<input class = "none" type="text" name="mname"/>
				</td>
				<td>
					<select class = "none" name="cid">
						<%
							List<Category> categories = categoryManager.getAllCategories();
							for(Category category: categories){
						%>
								<option value = "<%=category.getCid()%>">
									<%=category.getCname()%>
								</option>
						<%
							}
						%>
					</select>
				</td>
				<td><input class = "none" type="text" name="price" /></td>
			</tr>
		</table>
		<br>
		<input type = "submit" value = "增加"/>
		&nbsp;
		<input type = "button" value = "取消" onclick="window.location.href='/showMenus'"/>
	</form>

</body>
</html>