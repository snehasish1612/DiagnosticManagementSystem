<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dms.model.Test" %>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    // When editing, TestServlet forwards with attribute "test"
    Test t = (Test) request.getAttribute("test");
    boolean editing = (t != null);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= editing ? "Edit Test" : "Add Test" %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="bg-light">
<%@ include file="components/header.jspf" %>


<div class="container mt-4">
    <h3 class="text-danger"><%= editing ? "Edit Test" : "Add New Test" %></h3>
    <hr>

    <form action="TestServlet" method="post" class="p-4 bg-white rounded shadow">
        <input type="hidden" name="action" value="<%= editing ? "update" : "add" %>"/>

        <% if (editing) { %>
            <input type="hidden" name="testId" value="<%= t.getTestId() %>"/>
        <% } %>

        <div class="mb-3">
            <label class="form-label">Test Name</label>
            <input type="text" name="testName" class="form-control"
                   value="<%= editing ? t.getTestName() : "" %>" required/>
        </div>

        <div class="mb-3">
            <label class="form-label">Description</label>
            <textarea name="description" class="form-control" rows="3"><%= editing ? t.getDescription() : "" %></textarea>
        </div>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Price (₹)</label>
                <input type="number" step="0.01" name="price" class="form-control"
                       value="<%= editing ? t.getPrice() : "" %>" required/>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">Duration</label>
                <input type="text" name="duration" class="form-control"
                       value="<%= editing ? t.getDuration() : "" %>" placeholder="e.g. 30 mins" />
            </div>
        </div>

        <button type="submit" class="btn btn-danger w-100">
            <%= editing ? "Update Test" : "Add Test" %>
        </button>
    </form>
</div>

<%@ include file="components/back_button.jspf" %>
<%@ include file="components/footer.jspf" %>

</body>
</html>
