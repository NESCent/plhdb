package org.nescent.plhdb.apps;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.ArrayList;


public class AutoSeqCascade {
	
	String dbURL;
	String user;
	String password;
	String basePath;
	
	public static void main(String [] agrs)
	{
		try
		{
			
			if(agrs.length!=4)
			{
				printUsage();
			}
			else
			{
				String base=agrs[0];
				String url=agrs[1];
				String user=agrs[2];
				String password=agrs[3];
				 
				AutoSeqCascade autoSeqCascade=new AutoSeqCascade();
				autoSeqCascade.setBasePath(base);
				autoSeqCascade.setDbURL(url);
				autoSeqCascade.setPassword(password);
				autoSeqCascade.setUser(user);
				autoSeqCascade.generateSeqCascade();
			}
		}
		catch(Exception e)
		{
			System.out.println("----------------------------------------------");
			e.printStackTrace();
			System.out.println("----------------------------------------------");
			printUsage();
		}
	}
	public static void printUsage()
	{
		String message="";
		message+=" Usage: java AutoSeqCascade basePath dbUrl dbUser dbPassword\n";
        message+="   basePath          the path to the folder where the hbm.xml files are stored.\n";
        message+="   dbUrl             the URL to the database.\n";
        message+="   dbUser            the user name to access the database.\n";
        message+="   dbPassword        the password to access the database.\n";
        System.out.println(message);
	}
	public String getBasePath() {
		return basePath;
	}

	public void setBasePath(String basePath) {
		this.basePath = basePath;
	}

	public String getDbURL() {
		return dbURL;
	}

	public void setDbURL(String dbURL) {
		this.dbURL = dbURL;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}

	public void generateSeqCascade()
	{
		java.sql.Connection conn=null;
		try{
		Class.forName("org.postgresql.Driver").newInstance();
				
		String connString=dbURL+"?user="+user+"&password="+password;
		
		
		conn = DriverManager.getConnection(connString);
		
		DatabaseMetaData meta = conn.getMetaData();
		String[] names = {"TABLE"}; 
		ResultSet tableNames = meta.getTables(null,"%", "%", names);
		
		
		while (tableNames.next()) { 
			String tbname=  tableNames.getString("TABLE_NAME");
			String objname="";
			String ss[]=tbname.split("_");
			for(int i=0;i<ss.length;i++)
			{
				if(!ss[i].trim().equals(""))
				{
					objname+=ss[i].substring(0,1).toUpperCase()+ss[i].substring(1);
				}
			}
			String file=basePath+objname+".hbm.xml";
			ArrayList lines=new ArrayList();
			try
			{
				BufferedReader r=new BufferedReader(new FileReader(new File(file)));
				String str=r.readLine();
				while(str!=null)
				{
					lines.add(str);
					str=r.readLine();
				}
				
				r.close();
				
				BufferedWriter w=new BufferedWriter(new FileWriter(new File(file)));
				
				for(int i=0;i<lines.size();i++)
				{
					str=(String)lines.get(i);
					if(str.indexOf("<hibernate-mapping>")!=-1)
					{
						str="<hibernate-mapping default-cascade=\"save-update\">";
					}
					else if(str.indexOf("<generator class=\"assigned\" />")!=-1)
					{
						str="<generator class=\"sequence\">\n";
						str+="<param name=\"sequence\">plhdb."+tbname+"_"+tbname+"_oid_seq"+"</param>\n";
						str+="</generator>";
					}
					w.write(str);
					w.newLine();
				}
				w.close();
			}catch(Exception e){
				System.out.println(e);
			}
		}
		}catch(Exception e){
			System.out.println(e);
		}finally{
			try{
				conn.close();
			}catch(Exception e){
				System.out.println(e);
			}
		}
		
		

			
	}
}
