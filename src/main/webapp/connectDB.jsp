<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page language="java" import="java.text.*, java.sql.*" %>
<%
//따로 include로 관리해도 될듯
	String serverIP = "localhost";
	String strSID = "orcl";
	String portNum = "1521";
	String user = "knuroom";
	String pass = "comp322";
	String url = "jdbc:oracle:thin:@"+serverIP+":"+portNum+":"+strSID;
		
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
		
	//Driver Setting
	try {
		Class.forName("oracle.jdbc.driver.OracleDriver");
	}catch(ClassNotFoundException e) {
		System.err.println("error = " + e.getMessage());
		System.exit(1);
	}
			
	//Connection Create
	try {
		conn = DriverManager.getConnection(url, user, pass);
		stmt = conn.createStatement();
	}catch(SQLException ex) {
		ex.printStackTrace();
		System.err.println("Cannot get a connection: " + ex.getLocalizedMessage());
		System.err.println("Cannot get a connection: " + ex.getMessage());
		System.exit(1);
	}
%>