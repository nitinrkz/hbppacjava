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
<%@ page import="java.io.BufferedOutputStream" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.math.BigInteger" %>
<%@ page import="java.security.KeyFactory" %>
<%@ page import="java.security.KeyPair" %>
<%@ page import="java.security.KeyPairGenerator" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="java.security.PrivateKey" %>
<%@ page import="java.security.PublicKey" %>
<%@ page import="java.security.spec.InvalidKeySpecException" %>
<%@ page import="java.security.spec.RSAPrivateKeySpec" %>
<%@ page import="java.security.spec.RSAPublicKeySpec" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.util.Date" %>


 <%!


static class RSAEncryptionDescription {
 
 public static ArrayList<String> encrypt(String data,JspWriter out) {
    
  try {
    out.write("\nrsaencrypt started");
   //System.out.println("-------GENRATE PUBLIC and PRIVATE KEY-------------");
   KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
   keyPairGenerator.initialize(2048); //1024 used for normal securities
   KeyPair keyPair = keyPairGenerator.generateKeyPair();
   PublicKey publicKey = keyPair.getPublic();
   PrivateKey privateKey = keyPair.getPrivate();
   //System.out.println("Public Key - " + publicKey);
   //System.out.println("Private Key - " + privateKey);

   //Pullingout parameters which makes up Key
   //System.out.println("\n------- PULLING OUT PARAMETERS WHICH MAKES KEYPAIR----------\n");
   KeyFactory keyFactory = KeyFactory.getInstance("RSA");
   RSAPublicKeySpec rsaPubKeySpec = keyFactory.getKeySpec(publicKey, RSAPublicKeySpec.class);
   RSAPrivateKeySpec rsaPrivKeySpec = keyFactory.getKeySpec(privateKey, RSAPrivateKeySpec.class);

    out.write("\nrsaencrypt keys got");
   //System.out.println("PubKey Modulus : " + rsaPubKeySpec.getModulus());
   //System.out.println("PubKey Exponent : " + rsaPubKeySpec.getPublicExponent());
   //System.out.println("PrivKey Modulus : " + rsaPrivKeySpec.getModulus());
   //System.out.println("PrivKey Exponent : " + rsaPrivKeySpec.getPrivateExponent());
   
   //Share public key with other so they can encrypt data and decrypt thoses using private key(Don't share with Other)
   //System.out.println("\n--------SAVING PUBLIC KEY AND PRIVATE KEY TO FILES-------\n");
   //RSAEncryptionDescription rsaObj = new RSAEncryptionDescription();
   //rsaObj.saveKeys(PUBLIC_KEY_FILE, rsaPubKeySpec.getModulus(), rsaPubKeySpec.getPublicExponent());
   //rsaObj.saveKeys(PRIVATE_KEY_FILE, rsaPrivKeySpec.getModulus(), rsaPrivKeySpec.getPrivateExponent());

   //Encrypt Data using Public Key
   byte[] encryptedData = encryptData(data,rsaPubKeySpec,rsaPrivKeySpec);
   String encryptedDataString=Base64.getEncoder().encodeToString(encryptedData);
   String privKeyString=RSAEncryptionDescription.toString(rsaPrivKeySpec);
    ArrayList<String> keyList=new ArrayList<String>();
    keyList.add(encryptedDataString);
    keyList.add(privKeyString);
    return keyList;
   //Descypt Data using Private Key
   //rsaObj.decryptData(encryptedData);
   
  } catch (NoSuchAlgorithmException e) {
    try{
    out.write(e.getMessage());
  }catch(Exception e){  }
   e.printStackTrace();
  }catch (Exception e) {
   e.printStackTrace();
    try{
    out.write(e.getMessage());
  }catch(Exception e){  }
  }
  return null;

 }
 
 /**
  * Save Files
  * @param fileName
  * @param mod
  * @param exp
  * @throws IOException
  */
 private void saveKeys(String fileName,BigInteger mod,BigInteger exp) throws IOException{
  FileOutputStream fos = null;
  ObjectOutputStream oos = null;
  
  try {
   System.out.println("Generating "+fileName + "...");
   fos = new FileOutputStream(fileName);
   oos = new ObjectOutputStream(new BufferedOutputStream(fos));
   
   oos.writeObject(mod);
   oos.writeObject(exp); 
   
   System.out.println(fileName + " generated successfully");
  } catch (Exception e) {
   e.printStackTrace();
  }
  finally{
   if(oos != null){
    oos.close();
    
    if(fos != null){
     fos.close();
    }
   }
  }  
 }
 
 
 private static byte[] encryptData(String data, RSAPublicKeySpec rsaPubKey,RSAPrivateKeySpec rsaPrivKey) throws IOException {
  //System.out.println("\n----------------ENCRYPTION STARTED------------");
  
  //System.out.println("Data Before Encryption :" + data);
  byte[] dataToEncrypt = data.getBytes();
  byte[] encryptedData = null;
  try {
   //PublicKey pubKey = readPublicKeyFromFile(PUBLIC_KEY_FILE);
   Cipher cipher = Cipher.getInstance("RSA");
   cipher.init(Cipher.ENCRYPT_MODE, readPublicKeyFromFile(rsaPubKey));
//long start = System.currentTimeMillis();   
encryptedData = cipher.doFinal(dataToEncrypt);
//long end = System.currentTimeMillis();
//long elapsed = end - start;
//System.out.println("Encryption time"+elapsed);   
//System.out.println("Encryted Data: " + encryptedData);
   
  } catch (Exception e) {
   e.printStackTrace();
  } 
  
  //System.out.println("----------------ENCRYPTION COMPLETED------------");  
  return encryptedData;
 }

  /*
 private static void decryptData(byte[] data) throws IOException {
  //System.out.println("\n----------------DECRYPTION STARTED------------");
  byte[] descryptedData = null;
  
  try {
   PrivateKey privateKey = readPrivateKeyFromFile(PRIVATE_KEY_FILE);
   Cipher cipher = Cipher.getInstance("RSA");
   cipher.init(Cipher.DECRYPT_MODE, privateKey);
//long start1 = System.currentTimeMillis();
   descryptedData = cipher.doFinal(data);
//long end1 = System.currentTimeMillis();
//long elapsed1 = end1 - start1;
//System.out.println("Decryption time"+elapsed1);
  // System.out.println("Decrypted Data: " + new String(descryptedData));
   
  } catch (Exception e) {
   e.printStackTrace();
  } 
  
 // System.out.println("----------------DECRYPTION COMPLETED------------");  
 }*/
 
 /**
  * read Public Key From File
  * @param fileName
  * @return PublicKey
  * @throws IOException
  */
 public static PublicKey readPublicKeyFromFile(RSAPublicKeySpec fileName) throws IOException{
  //FileInputStream fis = null;
  //ObjectInputStream ois = null;
  try {
   //fis = new FileInputStream(new File(fileName));
   //ois = new ObjectInputStream(fis);
   
   //BigInteger modulus = (BigInteger) ois.readObject();
      //BigInteger exponent = (BigInteger) ois.readObject();
   
      //Get Public Key
      //RSAPublicKeySpec rsaPublicKeySpec = new RSAPublicKeySpec(modulus, exponent);
      KeyFactory fact = KeyFactory.getInstance("RSA");
      PublicKey publicKey = fact.generatePublic(fileName);
            
      return publicKey;
      
  } catch (Exception e) {
   e.printStackTrace();
  }
  finally{
   //if(ois != null){
    //ois.close();
    //if(fis != null){
     //fis.close();
    //}
   //}
  }
  return null;
 }
 
 /**
  * read Public Key From File
  * @param fileName
  * @return
  * @throws IOException
  */
 public static PrivateKey readPrivateKeyFromFile(String fileName) throws IOException{
  FileInputStream fis = null;
  ObjectInputStream ois = null;
  try {
   fis = new FileInputStream(new File(fileName));
   ois = new ObjectInputStream(fis);
   
   BigInteger modulus = (BigInteger) ois.readObject();
      BigInteger exponent = (BigInteger) ois.readObject();
   
      //Get Private Key
      RSAPrivateKeySpec rsaPrivateKeySpec = new RSAPrivateKeySpec(modulus, exponent);
      KeyFactory fact = KeyFactory.getInstance("RSA");
      PrivateKey privateKey = fact.generatePrivate(rsaPrivateKeySpec);
            
      return privateKey;
      
  } catch (Exception e) {
   e.printStackTrace();
  }
  finally{
   if(ois != null){
    ois.close();
    if(fis != null){
     fis.close();
    }
   }
  }
  return null;
 }

 private static Object fromString( String s ) throws IOException ,
                                                       ClassNotFoundException {
        byte [] data = Base64.getDecoder().decode( s );
        ObjectInputStream ois = new ObjectInputStream( 
                                        new java.io.ByteArrayInputStream(  data ) );
        Object o  = ois.readObject();
        ois.close();
        return o;
   }

    /** Write the object to a Base64 string. */
    private static String toString( Object o ) throws IOException {
        java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream();
        ObjectOutputStream oos = new ObjectOutputStream( baos );
        oos.writeObject( o );
        oos.close();
        return Base64.getEncoder().encodeToString(baos.toByteArray()); 
    }
  
}

 %>

 <%!
 
static class AESEncryptor {
 
 public static String encrypt(String fname) throws Exception{
  KeyGenerator keyGen = KeyGenerator.getInstance("AES");
  keyGen.init(128);  //using AES-256
  SecretKey key = keyGen.generateKey();  //generating key
  Cipher aesCipher = Cipher.getInstance("AES");  //getting cipher for AES
  aesCipher.init(Cipher.ENCRYPT_MODE, key);  //initializing cipher for encryption with key
   
  //creating file output stream to write to file
  
    FileOutputStream fos = new FileOutputStream(fname+".aes");
   //creating object output stream to write objects to file
   //ObjectOutputStream oos = new ObjectOutputStream(fos);
   //oos.writeObject(key);  //saving key to file for use during decryption
    String encodedKey=toString(key);
    //encryptKeyUsingRSA(encodedKey);
   //creating file input stream to read contents for encryption
   FileInputStream fis = new FileInputStream(fname);
    //creating cipher output stream to write encrypted contents
   CipherOutputStream cos = new CipherOutputStream(fos, aesCipher);
     int read;
     byte buf[] = new byte[4096];
     while((read = fis.read(buf)) != -1)  //reading from file
      cos.write(buf, 0, read);  //encrypting and writing to file
    return encodedKey;
   
   
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

 private static Object fromString( String s ) throws IOException ,
                                                       ClassNotFoundException {
        byte [] data = Base64.getDecoder().decode( s );
        ObjectInputStream ois = new ObjectInputStream( 
                                        new java.io.ByteArrayInputStream(  data ) );
        Object o  = ois.readObject();
        ois.close();
        return o;
   }

    /** Write the object to a Base64 string. */
    private static String toString( Object o ) throws IOException {
        java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream();
        ObjectOutputStream oos = new ObjectOutputStream( baos );
        oos.writeObject( o );
        oos.close();
        return Base64.getEncoder().encodeToString(baos.toByteArray()); 
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

<%!

static class MySQLAccess {

  public static void storeInDatabase(String fileName,int level,String esk,String pk) throws Exception {
    try {


  Connection connect = null;
  Statement statement = null;
  PreparedStatement preparedStatement = null;
  ResultSet resultSet = null;
      // This will load the MySQL driver, each DB has its own driver
      Class.forName("com.mysql.jdbc.Driver");
      // Setup the connection with the DB
      connect = DriverManager
          .getConnection("jdbc:mysql://ap-cdbr-azure-southeast-a.cloudapp.net/datacomm","b8fdb7a0f430b6","3770357f");

      // Statements allow to issue SQL queries to the database
      statement = connect.createStatement();
      // Result set get the result of the SQL query
      resultSet = statement
          .executeQuery("SELECT * FROM cloudfiles where filename='"+fileName+"';");
      //writeResultSet(resultSet);
      if(resultSet.first()){
      // PreparedStatements can use variables and are more efficient
      preparedStatement = connect
          .prepareStatement("UPDATE cloudfiles set level=?,esk=?,sk=? where filename=?;");
      // "myuser, webpage, datum, summery, COMMENTS from feedback.comments");
      // Parameters start with 1
      preparedStatement.setInt(1, level);
      preparedStatement.setString(2, esk);
      preparedStatement.setString(3, pk);
      preparedStatement.setString(4, fileName);
      int status=preparedStatement.executeUpdate();
      if(status==0){
        throw new Exception("SQL Update Failed");
      }
    }else{

      preparedStatement = connect
          .prepareStatement("INSERT INTO cloudfiles values(?,?,?,?);");
      preparedStatement.setString(1, fileName);
      preparedStatement.setInt(2, level);
      preparedStatement.setString(3, esk);
      preparedStatement.setString(4, pk);
      int status = preparedStatement.executeUpdate();
      if(status==0){
        throw new Exception("SQL Insertion Failed");
      }
    }

    if (resultSet != null) {
        resultSet.close();
      }

      if (statement != null) {
        statement.close();
      }

      if (connect != null) {
        connect.close();
      }
      //writeResultSet(resultSet);
      // Remove again the insert comment
        
      
    } catch (Exception e) {
      throw e;
    } finally {
    }

  }

  /*private void writeMetaData(ResultSet resultSet) throws SQLException {
    //   Now get some metadata from the database
    // Result set get the result of the SQL query
    
    System.out.println("The columns in the table are: ");
    
    System.out.println("Table: " + resultSet.getMetaData().getTableName(1));
    for  (int i = 1; i<= resultSet.getMetaData().getColumnCount(); i++){
      System.out.println("Column " +i  + " "+ resultSet.getMetaData().getColumnName(i));
    }
  }*/

  /*private void writeResultSet(ResultSet resultSet) throws SQLException {
    // ResultSet is initially before the first data set
    while (resultSet.next()) {
      // It is possible to get the columns via name
      // also possible to get the columns via the column number
      // which starts at 1
      // e.g. resultSet.getSTring(2);
      String user = resultSet.getString("myuser");
      String website = resultSet.getString("webpage");
      String summery = resultSet.getString("summery");
      Date date = resultSet.getDate("datum");
      String comment = resultSet.getString("comments");
      System.out.println("User: " + user);
      System.out.println("Website: " + website);
      System.out.println("Summery: " + summery);
      System.out.println("Date: " + date);
      System.out.println("Comment: " + comment);
    }
  }*/

  // You need to close the resultSet
  
} 

%>


<%
   File file ;
   int maxFileSize = 5000 * 1024;
   int maxMemSize = 5000 * 1024;
   String level;
   int lev=-1;
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
      level=request.getParameter("level");
      lev=Integer.parseInt(level);
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
		String key=AESEncryptor.encrypt(filePath+fileName);
            out.write("encrypted");
            out.write("\nLevel:"+level);
            out.write("\naeskey:"+key);
            ArrayList<String> rsaKeys=RSAEncryptionDescription.encrypt(key,out);
            if(rsaKeys==null){
            out.write("rsanull");
          }
            MySQLAccess.storeInDatabase(fileName,lev,rsaKeys.get(0),rsaKeys.get(1));
            //AESEncryptor.decrypt(filePath+fileName+".aes");
            //out.write("decrypted");

}catch(Exception e){
	e.printStackTrace();
  //out.write(e.toString());
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