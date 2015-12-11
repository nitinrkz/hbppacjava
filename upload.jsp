<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>



<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.ObjectInputStream" %>
<%@ page import="java.io.ObjectOutputStream" %>
 
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.CipherInputStream" %>
<%@ page import="javax.crypto.CipherOutputStream" %>
<%@ page import="javax.crypto.KeyGenerator" %>
<%@ page import="javax.crypto.SecretKey" %>
 <%!
 
static class AESEncryptor {
 
 public static void encrypt(String fname) throws Exception{
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
  
 public static void decrypt(String fname) throws Exception{
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











//package com.sumatone.cloud.securecloud;//package com.javaingrab.security.encrypt;

/*import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

import javax.crypto.Cipher;
import javax.crypto.CipherInputStream;
import javax.crypto.CipherOutputStream;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;

import java.io.OutputStream;
import java.io.Serializable;
import java.util.*;


public class AESEncryptor {

    public ReturnObject encrypt(String fname) throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(128);  //using AES-256
        SecretKey key = keyGen.generateKey();  //generating key
        Cipher aesCipher = Cipher.getInstance("AES");  //getting cipher for AES
        aesCipher.init(Cipher.ENCRYPT_MODE, key);  //initializing cipher for encryption with key
          System.out.println("keyEc:"+key);
          System.out.println("keysize:"+key.toString());


        //creating file output stream to write to file
  /*try(FileOutputStream fos = new FileOutputStream(fname+".aes")){
   //creating object output stream to write objects to file
   ObjectOutputStream oos = new ObjectOutputStream(fos);
   oos.writeObject(key);  //saving key to file for use during decryption*/

        //creating file input stream to read contents for encryption
   /*     try {
            InputStream fis = new ByteArrayInputStream(fname.getBytes());
            //creating cipher output stream to write encrypted contents

            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

            CipherOutputStream cos = new CipherOutputStream(outputStream, aesCipher);
            int read;
            byte buf[] = new byte[4096];
            while ((read = fis.read(buf)) != -1)  //reading from file
                cos.write(buf, 0, read);  //encrypting and writing to file
            byte arrAfterEncrytion[] = outputStream.toByteArray();

            return new ReturnObject(arrAfterEncrytion, key.toString());

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

/*    public byte[] decrypt(String fname, final String dKey) throws Exception {
        SecretKey key = null;

        //creating file input stream to read from file

        key = new SecretKey() {
            @Override
            public String getAlgorithm() {
                return "AES";
            }

            @Override
            public String getFormat() {
                return "RAW";
            }

            @Override
            public byte[] getEncoded() {
              System.out.println("dedgetEnStr:"+dKey);
              byte[] en=dKey.getBytes();
              System.out.println("dedgetEn:"+en);
              try{
                String dec=new String(en,"UTF-8");
              System.out.println("dedgetEnAg:"+dec);
              }catch(Exception e){
                e.printStackTrace();
              }
              byte arr[]=Arrays.copyOf(en,128);
                return arr;
            }
        };  //reading key used for encryption

        System.out.println("DecKey:"+key.getEncoded());

      Cipher aesCipher = Cipher.getInstance("AES");  //getting cipher for AES
        aesCipher.init(Cipher.DECRYPT_MODE, key);  //initializing cipher for decryption with key
        //creating file output stream to write back original contents
        ByteArrayInputStream fis=new ByteArrayInputStream(fname.getBytes());
        ByteArrayOutputStream fos=new ByteArrayOutputStream();
        try (CipherInputStream cis = new CipherInputStream(fis, aesCipher)) {
            int read;
            byte buf[] = new byte[4096];
            while ((read = cis.read(buf)) != -1)  //reading from file
                fos.write(buf, 0, read);  //decrypting and writing to file
            
            return fos.toByteArray();
        }


    }

    public static void main(String[] args) throws Exception {
        AESEncryptor obj = new AESEncryptor();
        //long start = System.currentTimeMillis();
        ReturnObject object=obj.encrypt("Prince");
        System.out.println("Encrypted:"+object.getOutputBytes());
        System.out.println("Key:"+object.getKey().toString());*/
//obj.encrypt("CAT2-LAB");
        //long end = System.currentTimeMillis();
       // long diff = end - start;
       // System.out.println("Encryption Time is : " + diff);
        //long start1 = System.currentTimeMillis();
   //     byte [] dec=obj.decrypt(object.getOutputBytes().toString(), object.getKey().toString());
        //System.out.println(new String(dec,"UTF-8"));
//  obj.decrypt(".doc.aes.dec");
        //long end1 = System.currentTimeMillis();
        //long diff1 = end1 - start1;
        //System.out.println("Decryption Time is : " + diff1);
   /* }

    public class ReturnObject implements Serializable {

        private byte[] outputBytes;
        private String key;

        public ReturnObject(byte[] outputBytes, String key) {
            this.outputBytes = outputBytes;
            this.key = key;
        }

        public byte[] getOutputBytes() {
            return outputBytes;
        }

        public void setOutputBytes(byte[] outputBytes) {
            this.outputBytes = outputBytes;
        }

        public String getKey() {
            return key;
        }

        public void setKey(String key) {
            this.key = key;
        }
    }

}*/

%>


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

           try{ 
		AESEncryptor.encrypt(filePath+fileName);
            out.write("encrypted");
            AESEncryptor.decrypt(filePath+fileName+".aes");
            out.write("decrypted");
}catch(Exception e){
	e.printStackTrace();
}

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