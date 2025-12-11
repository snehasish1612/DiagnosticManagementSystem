<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Analyst Login</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Shared Style -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>

<body class="bg-light">

<!-- 🔹 Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-success">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="index.jsp">🧬 Diagnostic System</a>
    <a href="index.jsp" class="btn btn-light btn-sm">Back</a>
  </div>
</nav>

<!-- 🔹 Login Card -->
<div class="container mt-5" style="max-width: 450px;">
  
  <h2 class="text-center mb-4 text-success">Analyst Login</h2>

  <% 
    String error = (String) request.getAttribute("error");
    if (error != null) { 
  %>
      <div class="alert alert-danger text-center">
          <%= error %>
      </div>
  <% } %>

  <form action="AnalystServlet" method="post" class="p-4 bg-white rounded shadow form-card">
      <input type="hidden" name="action" value="login">

      <div class="mb-3">
        <label class="form-label fw-semibold">📧 Email</label>
        <input type="email" class="form-control" name="email" placeholder="example@mail.com" required>
      </div>

      <div class="mb-3">
        <label class="form-label fw-semibold">🔑 Password</label>
        <input type="password" class="form-control" name="password" placeholder="Enter password" required>
      </div>

      <button type="submit" class="btn btn-success w-100">Login</button>
  </form>

  <div class="text-center mt-3">
    <span>New Analyst?</span>
    <a href="analyst_register.jsp">Register here</a>
  </div>
</div>

<%@ include file="components/footer.jspf" %>
</body>
</html>
