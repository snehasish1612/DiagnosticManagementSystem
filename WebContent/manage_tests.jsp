<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.dms.model.Test" %>
<%@ page import="com.dms.dao.TestDAO" %>

<%
    // only admin can access
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    // Usually TestServlet sets this attribute
    List<Test> tests = (List<Test>) request.getAttribute("tests");

    // If someone opens manage_tests.jsp directly, load from DAO
    if (tests == null) {
        TestDAO dao = new TestDAO();
        tests = dao.getAllTests();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Tests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="bg-light">
<%@ include file="components/header.jspf" %>

<div class="container mt-4">
    <h3 class="text-danger">Manage Tests</h3>
    <hr>

    <a href="test_form.jsp" class="btn btn-primary mb-3">+ Add New Test</a>

    <table class="table table-bordered table-striped">
        <thead>
        <tr>
            <th>ID</th>
            <th>Test Name</th>
            <th>Description</th>
            <th>Price (₹)</th>
            <th>Duration</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <% if (tests != null) {
               for (Test t : tests) { %>
            <tr>
                <td><%= t.getTestId() %></td>
                <td><%= t.getTestName() %></td>
                <td><%= t.getDescription() %></td>
                <td><%= t.getPrice() %></td>
                <td><%= t.getDuration() %></td>
                <td>
                    <!-- Edit -->
                    <a href="TestServlet?testId=<%= t.getTestId() %>" 
                       class="btn btn-sm btn-warning me-1">Edit</a>

                    <!-- Delete -->
                    <form action="TestServlet" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="delete"/>
                        <input type="hidden" name="testId" value="<%= t.getTestId() %>"/>
                        <button class="btn btn-sm btn-danger"
                                onclick="return confirm('Delete this test?');">
                            Delete
                        </button>
                    </form>
                </td>
            </tr>
        <%   }
           } %>
        </tbody>
    </table>
</div>

<%@ include file="components/back_button.jspf" %>
<%@ include file="components/footer.jspf" %>

</body>
</html>
