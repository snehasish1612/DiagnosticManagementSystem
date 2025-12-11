<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.dms.dao.AnalystDAO" %>
<%@ page import="com.dms.model.Analyst" %>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    AnalystDAO dao = new AnalystDAO();
    List<Analyst> analysts = dao.getAllAnalysts();
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Manage Analysts</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="components/header.jspf" %>

<div class="container mt-4">
  <h3>Analysts</h3>
  <hr>

  <% String msg = request.getParameter("msg");
     if ("removed".equals(msg)) { %>
      <div class="alert alert-success">Analyst removed successfully.</div>
  <% } %>

  <table class="table table-bordered table-striped">
    <thead>
      <tr>
        <th>ID</th><th>Name</th><th>Email</th><th>Specialization</th><th>Phone</th><th>Actions</th>
      </tr>
    </thead>
    <tbody>
    <% for (Analyst a : analysts) { %>
      <tr>
        <td><%= a.getAnalystId() %></td>
        <td><%= a.getName() %></td>
        <td><%= a.getEmail() %></td>
        <td><%= a.getSpecialization() %></td>
        <td><%= a.getPhone() %></td>
        <td>
          <form action="AdminActionsServlet" method="post" style="display:inline;"
                onsubmit="return confirm('Remove this analyst?');">
            <input type="hidden" name="action" value="removeAnalyst">
            <input type="hidden" name="analystId" value="<%= a.getAnalystId() %>">
            <button class="btn btn-danger btn-sm">Remove</button>
          </form>
        </td>
      </tr>
    <% } %>
    </tbody>
  </table>
</div>

<%@ include file="components/back_button.jspf" %>
<%@ include file="components/footer.jspf" %>

</body>
</html>
