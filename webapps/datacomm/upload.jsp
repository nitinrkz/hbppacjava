<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>

<%
   try{

   ServletContext context = pageContext.getServletContext();
   String filePath = context.getInitParameter("file-upload");
	System.out.println(context);
   }
catch(Exception ex) {
         System.out.println(ex);
      }


%>