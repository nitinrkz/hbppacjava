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

            AESEncryptor.encrypt(filePath+fileName);
            out.write("encrypted");
            }
         }
      }catch(Exception ex) {
         out.write(ex.toString());
		ex.printStackTrace();
      }
   }else{
      
      out.write("\nNo file uploaded"); 
   }

   }
%>

<% 

	public class AESEncryptor {
 
 public void encrypt(String fname) throws Exception{
  KeyGenerator keyGen = KeyGenerator.getInstance("AES");
  keyGen.init(128);  //using AES-256
  SecretKey key = keyGen.generateKey();  //generating key
  Cipher aesCipher = Cipher.getInstance("AES");  //getting cipher for AES
  aesCipher.init(Cipher.ENCRYPT_MODE, key);  //initializing cipher for encryption with key
   
  //creating file output stream to write to file
  
    FileOutputStream fos = new FileOutputStream(fname+".aes");
   //creating object output stream to write objects to file
   ObjectOutputStream oos = new ObjectOutputStream(fos);
   oos.writeObject(key);  //saving key to file for use during decryption
 
   //creating file input stream to read contents for encryption
   FileInputStream fis = new FileInputStream(fname);
    //creating cipher output stream to write encrypted contents
   CipherOutputStream cos = new CipherOutputStream(fos, aesCipher);
     int read;
     byte buf[] = new byte[4096];
     while((read = fis.read(buf)) != -1)  //reading from file
      cos.write(buf, 0, read);  //encrypting and writing to file
    
   
   
 }
  
 public void decrypt(String fname) throws Exception{
  SecretKey key =null;
     
  //creating file input stream to read from file
  FileInputStream fis = new FileInputStream(fname);
   //creating object input stream to read objects from file
   ObjectInputStream ois = new ObjectInputStream(fis);
   key = (SecretKey)ois.readObject();  //reading key used for encryption
    
   Cipher aesCipher = Cipher.getInstance("AES");  //getting cipher for AES
   aesCipher.init(Cipher.DECRYPT_MODE, key);  //initializing cipher for decryption with key
   //creating file output stream to write back original contents
   FileOutputStream fos = new FileOutputStream(fname+".dec");
    //creating cipher input stream to read encrypted contents
    CipherInputStream cis = new CipherInputStream(fis, aesCipher);
     int read;
     byte buf[] = new byte[4096];
     while((read = cis.read(buf)) != -1)  //reading from file
      fos.write(buf, 0, read);  //decrypting and writing to file
    
   
  
 }
  
 
 
}

%>