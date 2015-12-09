<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%! private final String UPLOAD_DIRECTORY = "/uploads"; %>

<%
		String level="-1";
		
		Enumeration<String> e=request.getParameterNames();
		while(e.hasMoreElements()){
			String s=e.nextElement();
			out.println(s);
		}
	
		if(request.getParameter("submit")!=null){
			
		if(request.getParameter("level")!=null){

      if(ServletFileUpload.isMultipartContent(request)){

            try {

                List<FileItem> multiparts = new ServletFileUpload(

                                         new DiskFileItemFactory()).parseRequest(request);

               

                for(FileItem item : multiparts){

                    if(!item.isFormField()){

                        String name = new File(item.getName()).getName();

                        item.write( new File(UPLOAD_DIRECTORY + File.separator + name));

                    }

                }

            

               //File uploaded successfully

               out.println("File Uploaded Successfully");

            } catch (Exception ex) {

            	out.println("File Upload Failed due to " + ex);

            }         

          

        }else{

        	out.println("Sorry this Servlet only handles file upload request");

        }
		}else{
			out.println("Level not defined");
				
		}
		}else{
			out.println("Parameter missing");
		}
   

%>