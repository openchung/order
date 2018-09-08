<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<head>
	<title>編輯餐點分類</title>
	<style>
		input.none {border:none}
		select.none {border:none}
	</style>
</head>

<body>
	<h2>編輯餐點分類</h2>

	<form action="/saveCategory" method = "post">
		<table border="1" cellspacing="0" cellpadding="5">
			<tr>
				<th>餐點分類ID</th>
				<th>餐點分類名稱</th>
			</tr>
			<tr>
				<td><input class = "none" type="text" name="cid" value = "${category.cid}" readonly = "readonly"/></td>
				<td><input class = "none" type="text" name="cname" value = "${category.cname}"/></td>
			</tr>
		</table>
		<br>
		<input type = "submit" value = "送出"/>
		&nbsp;
		<input type = "button" value = "取消" onclick="window.location.href='/showCategories'"/>
	</form>

</body>
</html>