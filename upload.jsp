<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>

<%
   File file ;
   int maxFileSize = 5000 * 1024;
   int maxMemSize = 5000 * 1024;
   ServletContext context = pageContext.getServletContext();
   String filePath = "D:\\uploads\\";
   out.write("start");
   // Verify the content type
   String contentType = request.getContentType();
   if ((contentType.indexOf("multipart/form-data") >= 0)) {
   		out.write("content type");
      DiskFileItemFactory factory = new DiskFileItemFactory();
      // maximum size that will be stored in memory
      factory.setSizeThreshold(maxMemSize);
      // Location to save data that is larger than maxMemSize.
      factory.setRepository(new File("D:\\temp\\"));

      // Create a new file upload handler
      ServletFileUpload upload = new ServletFileUpload(factory);
      out.write("\nservlet file upload");
      // maximum file size to be uploaded.
      upload.setSizeMax( maxFileSize );
      try{ 
         // Parse the request to get file items.
         List fileItems = upload.parseRequest(request);
         out.write("\nparse request");
         // Process the uploaded file items
         Iterator i = fileItems.iterator();

         
         while ( i.hasNext () ) 
         {
         	out.write("\niterator next");
            FileItem fi = (FileItem)i.next();
            if ( !fi.isFormField () )	
            {
            out.write("\nis not form field");
            // Get the uploaded file parameters
            String fieldName = fi.getFieldName();
            String fileName = fi.getName();
            boolean isInMemory = fi.isInMemory();
            long sizeInBytes = fi.getSize();
            // Write the file
out.write("<br />"+fileName+"<br />");
            File fos=new File(filePath+fileName);
		fos.createNewFile();
out.write("\noutput");
            fi.write( fos ) ;
            out.write("\nSuccessfully uploaded");
            }
         }
      }catch(Exception ex) {
         out.write(ex.toString());
		ex.printStackTrace();
      }
   }else{
      
      out.write("\nNo file uploaded"); 
   }
%>